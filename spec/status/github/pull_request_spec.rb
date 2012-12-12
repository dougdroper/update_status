require 'spec_helper'

describe Status::Github::PullRequest do
  subject { Status::Github::PullRequest.new("") }

  before do
    Status.stub(:config => stub(:parsed => {}))
  end

  context "#pull_request_found?" do
    before do
      Status::Request.stub(:new => stub(:get => [{"head" => {"ref" => "branch_name"}}]))
    end

    it "is not found if a pull request does not exists" do
      Status.stub(:branch => "new_branch")
      Status::Github::PullRequest.new("new_branch").pull_request_found?.should be_false
    end

    it "is found if a pull request does exists" do
      Status.stub(:branch => "branch_name")
      Status::Github::PullRequest.new("branch_name").pull_request_found?.should be_true
    end
  end

  context "#create_pull_request" do
    before do
      subject.stub(:puts)
      subject.stub(:gets => "y\n")
    end

    it "creates a pull request" do
      Status::Request.stub(:new => stub(:post => "{\"status\":\"success\"}"))
      subject.stub(:puts => "url")
      subject.create_pull_request.should == "url"
    end

    it "returns error msg when pull request creation fails" do
      Status::Request.stub(:new => stub(:post => "{\"message\":\"server error\"}"))
      subject.stub(:puts => "not found")
      subject.create_pull_request.should == "not found"
    end

    it "aborts pull request creation" do
      subject.stub(:gets => "n")
      subject.should_receive(:abort)
      subject.create_pull_request
    end
  end
end