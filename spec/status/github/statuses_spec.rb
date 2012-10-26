require 'spec_helper'

describe Status::Github::Statuses do
  before do
    stub_const("Jenkins", stub)
  end

  subject { Status::Github::Statuses }
  it "has a payload target URL of the ci server URL and the branch name" do
    Status.stub(:ci_url => "http://jenkins-ci.org", :branch => "feature_branch")
    subject.new.send(:target_url).should == "http://jenkins-ci.org/job/feature_branch"
  end

  it "has a payload description of the ci state and qa status" do
    Jenkins.stub(:state => "Green")
    subject.new.send(:description).should == "Build status: Green, QA pending"
  end

  it "has a payload pending state when ci is passing but qa hasn't passed" do
    Jenkins.stub(:pass? => true)
    subject.new.send(:state).should == "pending"
  end

  it "has a payload success state when ci is passing and qa has passed" do
    Jenkins.stub(:pass? => true)
    subject.new("pass").send(:state).should == "success"
  end

  it "goes to the correct status api" do
    Status.stub(:owner => "owner", :repo => "status", :sha => "99efgd", :token => "123")
    subject.new.send(:status_api).should == "/repos/owner/status/statuses/99efgd?access_token=123"
  end
end