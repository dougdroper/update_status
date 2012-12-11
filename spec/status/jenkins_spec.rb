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
    it "is success when ci result is success" do
      Status::Request.stub(:new => stub(:get => {"building" => false, "result" => "success"}))
      subject.state.should == "success"
    end

    it "is Building when ci result is building" do
      Status::Request.stub(:new => stub(:get => {"building" => true, "result" => "success"}))
      subject.state.should == "pending"
    end

    it "is Building when ci result is in any other state" do
      Status::Request.stub(:new => stub(:get => {"building" => true, "result" => "failed"}))
      subject.state.should == "pending"
    end

    it "is Building when ci result is not found" do
      Status::Request.stub(:new => stub(:get => "not found"))
      subject.state.should == "pending"
    end
  end
end