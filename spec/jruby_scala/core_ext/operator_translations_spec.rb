require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "JrubyScala::CoreExt::OperatorTranslations" do
  before(:all) do
    @h = scala.collection.immutable.HashMap.new
    @h = @h.update(0, 5)
  end

  it "should translate #[] to #apply" do
    @h.should_receive(:apply).with(0)
    @h[0]
  end

  it "should translate operators into a corresponding method call" do
    @h = @h.update(1, 67)
    @h[1].should == 67
    @h = @h - 1
    lambda {@h[1]}.should raise_error(java.util.NoSuchElementException)
  end

  describe "when an object extends a Scala FunctionN" do
    it "should translate #call to #apply" do
      @h.should_receive(:apply).with(0)
      @h.call(0)
    end

    describe "arity method" do
      it "should return the arity of the extended FunctionN trait" do
        @h.should be_a_java_kind_of(scala.Function1)
        @h.arity.should == 1
      end
    end

    describe "binding method" do
      it "should expose the private binding method" do
        lambda {@h.binding}.should_not raise_error(NoMethodError)
      end
    end

    describe "to_proc method" do
      it "should return the object itself" do
        @h.to_proc.should == @h
      end
    end
  end
end
