require 'java'

# Toplevel namespace for the core Scala classes.
#
# @example Access scala elements like you would in Java
#   scala.collection.immutable.HashMap
#
def scala
  Java::Scala
end

require 'jruby_scala/core_ext'
