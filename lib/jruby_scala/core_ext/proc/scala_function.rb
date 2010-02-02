module JrubyScala
  module CoreExt
    module Proc
      class ScalaFunction
        def initialize(delegate)
          @delegate = delegate
        end
        
        def apply(*args)
          @delegate.call(*args)
        end
      end

      SCALA_MAX_AIRITY = 22

      for n in 0..SCALA_MAX_AIRITY
        eval <<-CLASS
          class Function#{n} < ScalaFunction
            include scala.Function#{n}
          end
        CLASS
      end
    end
  end
end
