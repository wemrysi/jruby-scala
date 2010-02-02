require 'jruby_scala/core_ext/proc/scala_function'

module JrubyScala
  module CoreExt
    module Proc
      module Conversions
        # Converts a Proc object into a Scala function of the same arity
        #
        # @return [JrubyScala::CoreExt::Proc::Function] A Scala-compatible proc
        def to_function
          eval "Function#{arity}.new(self)"
        end

        alias_method :java_object,  :to_function
        alias_method :scala_object, :to_function
      end
    end
  end
end
