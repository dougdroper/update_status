require 'spec_helper'

describe Status::Jenkins do
  class Test
    include Status::Jenkins
  end

  subject {Test.new}

  before do
    Status.stub(:config => stub(:attrs => {}))
    Status.stub(:branch => "")

    stub(Status::Request)
  end

  context "#state" do
    it "is Green when ci result is success" do
      Status::Request.stub(:new => stub(:get => {"building" => false, "result" => "success"}))
      subject.state.should == "Green"
    end

    it "is Building when ci result is building" do
      Status::Request.stub(:new => stub(:get => {"building" => true, "result" => "success"}))
      subject.state.should == "building"
    end

    it "is Building when ci result is not found" do
      Status::Request.stub(:new => stub(:get => "not found"))
      subject.state.should == "building"
    end
  end
end