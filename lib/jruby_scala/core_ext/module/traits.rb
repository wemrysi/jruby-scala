require 'set'

module JrubyScala
  module CoreExt
    module Module
      # Enables the inclusion of Scala traits into Ruby modules.
      #
      # TODO: Currently, JRuby throws an exception when attempting to load
      # many of the top-level traits: List, Iterator, Equiv, Ordered, etc.
      # Oddly enough, scala.FunctionN works fine. We need to investigate
      # why this happens.
      #
      module Traits
        def self.included(base)
          base.module_eval do
            alias_method :include_without_trait_support, :include
            alias_method :include, :include_with_trait_support
          end
        end

        # Mixes the given modules into the current module, including Scala
        # Traits.
        def include_with_trait_support(*modules)
          modules.each do |m|
            if m.respond_to?(:java_class) and m.java_class.interface?
              loader = m.java_class.class_loader
              unless loader.nil?
                mixin_methods_from_trait(loader.load_class(m.java_class.to_s), loader)
              end
            end

            if defined?(@@trait_methods)
              define_method(:scala_reflective_trait_methods) {@@trait_methods}
            end

            include_without_trait_support(m)
          end
        end

        # Mixes the methods from a Scala trait into the module.
        #
        # @param trait_class The trait to mixin
        # @param [java.lang.ClassLoader] loader The Java ClassLoader for the trait
        # @param [Set] done The set of traits that have already been mixed in,
        #   for memoization purposes
        def mixin_methods_from_trait(trait_class, loader, done = Set.new)
          return if done.include?(trait_class)
          done << trait_class

          begin
            klass = loader.load_class("#{trait_class.name}$class")
          rescue java.lang.ClassNotFoundException
            # Unable to load the <TraitName>$class, probably because this is
            # a standard Java interface, not a Scala trait, so just return.
            return
          end

          # TODO: Should this happen before attempting to load the special
          # <TraitName>$class?
          trait_class.interfaces.each do |iface| 
            mixin_methods_from_trait(iface, loader, done)
          end

          klass.declared_methods.each do |meth|
            mods = meth.modifiers
            
            if java.lang.reflect.Modifier.static?(mods) and java.lang.reflect.Modifier.public?(mods)
              @@trait_methods ||= []

              unless meth.name.include?('$')
                module_eval <<-CODE
                  def #{meth.name}(*args, &block)
                    args.insert(0, self)
                    args << block unless block.nil?
                    args.map! {|a| defined?(a.java_object) ? a.java_object : a}
                    scala_reflective_trait_methods[#{@@trait_methods.size}].invoke(nil, args.to_java)
                  end
                CODE

                @@trait_methods << meth
              else
                # Method name contains special characters, so use a fallback
                # implementation with define_method.
                #
                # Caveat: This impl can't deal with methods with function
                # arguments (blocks)
                define_method(meth.name) do |*args|
                  args.insert(0, self)
                  meth.invoke(nil, args.to_java)
                end
              end
            end
          end
        end
      end
    end
  end
end
