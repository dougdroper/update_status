# coding: utf-8
require File.dirname(__FILE__) + '/github/pull_request'
require File.dirname(__FILE__) + '/github/statuses'

module Status
  class Base
    attr_reader :qa_status

    def initialize(qa_status="pending")
      @qa_status = qa_status
      @statuses = Status::Github::Statuses.new(qa_status)
    end

    def update
      puts "Updating..."
      pull = Status::Github::PullRequest.new
      pull.create_pull_request unless pull.pull_request_found?
      @statuses.request
      puts "Done."
    end
  end
end