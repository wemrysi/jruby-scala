require 'jruby_scala/core_ext/proc/conversions'

class Proc #:nodoc:
  include JrubyScala::CoreExt::Proc::Conversions
end
