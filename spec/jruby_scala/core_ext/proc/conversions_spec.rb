require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
include JrubyScala::CoreExt::Proc

describe "JrubyScala::CoreExt::Proc::Conversion" do
  describe "to_function" do
    it "should return an instance of FunctionN of the proper arity" do
      l2 = lambda {|x, y|}
      l3 = lambda {|x, y, z|}

      f2 = l2.to_function
      f2.should be_an_instance_of(Function2)

      f3 = l3.to_function
      f3.should be_an_instance_of(Function3)
    end
  end
end
