require 'spec_helper'

describe Status::Github::Statuses do
  before do
    stub_const("Status::Jenkins", stub)
  end

  subject { Status::Github::Statuses }
  it "has a payload target URL of the ci server URL and the branch name" do
    Status.stub(:ci_url => "http://jenkins-ci.org", :branch => "feature_branch")
    subject.new.send(:target_url).should == "http://jenkins-ci.org/job/feature_branch"
  end

  it "has a payload description of the ci state and qa status" do
    Status::Jenkins.stub(:state => "success")
    subject.new.send(:description).should == "Build status: success, QA pending"
  end

  it "has a payload pending state when ci is passing but qa hasn't passed" do
    Status::Jenkins.stub(:pass? => true, :state => "pending")
    subject.new.send(:state).should == "pending"
  end

  it "has a payload success state when ci is passing and qa has passed" do
    Status::Jenkins.stub(:pass? => true, :state => "success")
    subject.new("pass").send(:state).should == "success"
  end

  it "has a payload error state when ci has an error" do
    Status::Jenkins.stub(:pass? => false, :state => "nothing")
    subject.new("pass").send(:state).should == "error"
  end

  it "goes to the correct status api" do
    Status.stub(:owner => "owner", :repo => "status", :sha => "99efgd", :token => "123")
    subject.new.send(:status_api).should == "/repos/owner/status/statuses/99efgd?access_token=123"
  end
end