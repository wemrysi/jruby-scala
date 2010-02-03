require File.expand_path(File.dirname(__FILE__) + '/../../../spec_helper')
include JrubyScala::CoreExt::Module

describe "JrubyScala::CoreExt::Module::Traits" do
  describe "when included into a module" do
    it "should still allow normal Java interfaces to be mixed-in" do
      class Car
        include java.lang.Comparable

        attr_reader :speed

        def initialize(speed)
          @speed = speed
        end

        def compare_to(other)
          speed <=> other.speed
        end
      end

      pinto = Car.new(45)
      porsche = Car.new(180)
      veyron = Car.new(240)

      cars = java.util.TreeSet.new
      cars.add(porsche)
      cars.add(pinto)
      cars.add(veyron)

      cars.first.should == pinto
      cars.lower(veyron).should == porsche
    end

    describe "when a Scala trait is included" do
      before(:all) do
        class MySet
          include scala.collection.Set

          def initialize(*elements)
            @elements = elements
          end

          def contains(elem)
            @elements.include?(elem)
          end

          def size
            @elements.size
          end
        end

        @s1 = MySet.new(1, 2, 3, 4, 5, 6, 7, 8)
      end

      it "should mix-in defined methods on Scala traits" do
        @s1.should respond_to(:isEmpty)
        @s1.isEmpty.should be_false
        MySet.new.isEmpty.should be_true
      end

      it "should mix-in defined methods on super traits" do
        @s1.should respond_to(:compose)
        f = lambda {|x| x + 3}.to_function
        g = @s1.compose(f)
        g.apply(3).should be_true
        g.apply(7).should be_false
      end
    end
  end
end
