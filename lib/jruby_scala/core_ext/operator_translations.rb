module JrubyScala
  module CoreExt
    # Provides translations between the standard set of Ruby operators and their
    # Scala counterparts allowing the natural use of Ruby operators on Scala
    # objects.
    #
    # Currently, translates the ruby-style array/hash access operator #[] and
    # handles Proc methods on objects that extend scala.FunctionN.  Other
    # operators may be added as necessary.
    #
    # @example Ruby-style hash access
    #   h = scala.collection.immutable.HashMap.new
    #   h = h.update(0, 4)
    #   puts h[0]   --> 4
    #
    module OperatorTranslations
      # A mapping of ruby operators to their respective method invocations in
      # Scala
      OPERATORS = {
        "=" => "$eq",
        ">" => "$greater",
        "<" => "$less",
        "+" => "$plus",
        "-" => "$minus",
        "*" => "$times",
        "/" => "div",
        "!" => "$bang",
        "@" => "$at",
        "#" => "$hash",
        "%" => "$percent",
        "^" => "$up",
        "&" => "$amp",
        "~" => "$tilde",
        "?" => "$qmark",
        "|" => "$bar",
        "\\" => "$bslash"}

      def self.included(base)
        alias_method :method_missing_without_scala_operator_translations, :method_missing
        alias_method :method_missing, :method_missing_with_scala_operator_translations
      end

      def method_missing_with_scala_operator_translations(sym, *args)
        if sym == :[] or (sym == :call and type_of_scala_function?(self))
          apply(*args)
        elsif sym == :arity and (ar = type_of_scala_function?(self))
          ar
        elsif sym == :binding and type_of_scala_function?(self)
          binding
        elsif sym == :to_proc and type_of_scala_function?(self)
          self
        else
          method_missing_without_scala_operator_translations(sym, *args)
=begin
          str = sym.to_s
          str = $&[1] + '_=' if str =~ /^(.*[^\]=])=$/
          OPERATORS.each {|from, to| str.gsub!(from, to)}
        
          if respond_to?(str)
            send(str.to_sym, *args)
          else
            method_missing_without_scala_operator_translations(sym, *args)
          end
=end
        end
      end

    private

      # Predicate returning whether the given object extends one of the Scala
      # FunctionN traits.
      #
      # @param [Object] An object to interrogate
      #
      # @return [Fixnum or FalseClass] The arity if the object is a function or
      #   false if not
      #
      def type_of_scala_function?(obj)
        if obj.java_kind_of? scala.Function0
          0
        elsif obj.java_kind_of? scala.Function1
          1
        elsif obj.java_kind_of? scala.Function2
          2
        elsif obj.java_kind_of? scala.Function3
          3
        elsif obj.java_kind_of? scala.Function4
          4
        elsif obj.java_kind_of? scala.Function5
          5
        elsif obj.java_kind_of? scala.Function6
          6
        elsif obj.java_kind_of? scala.Function7
          7
        elsif obj.java_kind_of? scala.Function8
          8
        elsif obj.java_kind_of? scala.Function9
          9
        elsif obj.java_kind_of? scala.Function10
          10
        elsif obj.java_kind_of? scala.Function11
          11
        elsif obj.java_kind_of? scala.Function12
          12
        elsif obj.java_kind_of? scala.Function13
          13
        elsif obj.java_kind_of? scala.Function14
          14
        elsif obj.java_kind_of? scala.Function15
          15
        elsif obj.java_kind_of? scala.Function16
          16
        elsif obj.java_kind_of? scala.Function17
          17
        elsif obj.java_kind_of? scala.Function18
          18
        elsif obj.java_kind_of? scala.Function19
          19
        elsif obj.java_kind_of? scala.Function20
          20
        elsif obj.java_kind_of? scala.Function21
          21
        elsif obj.java_kind_of? scala.Function22
          22
        else
          false
        end
      end
    end
  end
end
