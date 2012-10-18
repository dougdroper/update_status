require 'spec_helper'

describe Status::Jenkins do
  class Test
    include Status::Jenkins
  end

  before do
    Status.stub(:config => stub(:attrs => {}))
    @klass = Test.new
  end

  context "#state" do
    it "should be Green" do
      @klass.stub(:system => "{\"building\": false, \"result\": \"success\"}")
      @klass.state.should == "Green"
    end

    it "should be building" do
      @klass.stub(:system => "{\"building\": true, \"result\": \"success\"}")
      @klass.state.should == "building"
    end
  end
end