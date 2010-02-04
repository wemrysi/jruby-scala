require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "JrubyScala" do
  before(:all) do
    @hmap = Java::ScalaCollectionImmutable::HashMap
  end

  it "should provide a top-level java-like namespace for scala elements" do
    scala.collection.immutable.HashMap.should == @hmap
  end
end
