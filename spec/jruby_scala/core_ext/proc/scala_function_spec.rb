require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
include JrubyScala::CoreExt::Proc

describe "JrubyScala::CoreExt::Proc::ScalaFunction" do
  describe "apply" do
    it "should apply the delegate object to the passed arguments" do
      d1 = lambda {|x| x * 3}
      d2 = lambda {|x| "#{x} red balloons"}

      arg = 4

      sf1 = ScalaFunction.new(d1)
      sf1.apply(arg).should == 12

      sf2 = ScalaFunction.new(d2)
      sf2.apply(arg).should == "4 red balloons"
    end
  end

  it "should define a FunctionN class for N = 0..SCALA_MAX_ARITY" do
    proc_ext = JrubyScala::CoreExt::Proc
    module Scala
      include_package('scala')
    end

    (0..SCALA_MAX_ARITY).each do |arity|
      klass = proc_ext.const_get("Function#{arity}")
      f = klass.new(lambda {})
      f.should be_a_kind_of(ScalaFunction)
      f.should be_a_kind_of(Scala.const_get("Function#{arity}"))
    end
  end

  describe "FunctionN" do
    it "should be usable as a Scala Function" do
      sum = Function2.new(lambda {|i, tuple| i + tuple._2})
      hm = scala.collection.immutable.HashMap.new
      hm = hm.update('a', 1)
      hm = hm.update('b', 2)
      hm = hm.update('c', 3)
      hm.fold_left(0, sum).should == 6
    end
  end
end
