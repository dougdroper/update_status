require 'spec_helper'

describe Status::Jenkins do

  subject {Status::Jenkins.new("")}

  before do
    Status.stub(:config => stub(:attrs => {}))

    stub(Status::Request)
  end

  context "#state" do
    it "changes slashes to underscores" do
      Status::Jenkins.new("dr/feature").path.should == "/job/dr_feature/lastBuild/api/json"
    end

    it "is success when ci result is success" do
      Status::Request.stub(:new => stub(:get => {"building" => false, "result" => "success"}))
      subject.instance_variable_set("@build_url", true)
      subject.state.should == "success"
    end

    it "is pending when ci result is building" do
      Status::Request.stub(:new => stub(:get => {"building" => true, "result" => "success"}))
      subject.instance_variable_set("@build_url", true)
      subject.state.should == "pending"
    end

    it "is pending when ci result is in any other state" do
      Status::Request.stub(:new => stub(:get => {"building" => true, "result" => "failed"}))
      subject.instance_variable_set("@build_url", true)
      subject.state.should == "pending"
    end

    it "is pending when ci result is not found" do
      Status::Request.stub(:new => stub(:get => "not found"))
      subject.state.should == "pending"
    end

    it "is failure when ci result is failure" do
      Status::Request.stub(:new => stub(:get => {"building" => false, "result" => "failure"}))
      subject.instance_variable_set("@build_url", true)
      subject.state.should == "failure"
    end
  end
end