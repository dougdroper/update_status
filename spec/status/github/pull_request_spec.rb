require 'spec_helper'

describe Status::Github::PullRequest do
  class Test
    include Status::Github::PullRequest
  end

  before do
    Status.stub(:config => stub(:attrs => {}))
    @klass = Test.new
  end

  context "#pull_request_found?" do
    before do
      @klass.stub(:system => '[{"head": {"sha": "992ccc53"}}]')
    end

    it "is not found if a pull request does not exists" do
      Status.stub(:sha => "some sha")
      @klass.pull_request_found?.should be_false
    end

    it "is found if a pull request does exists" do
      Status.stub(:sha => "992ccc53")
      @klass.pull_request_found?.should be_true
    end
  end

  context "#create_pull_request" do
    before do
      @klass.stub(:puts)
      @klass.stub(:gets => "y\n")
    end

    it "creates a pull request" do
      @klass.stub(:system => "{\"status\":\"success\"}" )
      @klass.create_pull_request.should == "success"
    end

    it "returns error msg when pull request creation fails" do
      @klass.stub(:system => "{\"message\":\"server error\"}" )
      @klass.create_pull_request.should == "server error"
    end

    it "aborts pull request creation" do
      @klass.stub(:gets => "n")
      @klass.stub(:system => "{\"message\":\"server error\"}" )
      @klass.should_receive(:abort)
      @klass.create_pull_request
    end
  end
end