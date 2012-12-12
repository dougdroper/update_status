# coding: utf-8
require File.dirname(__FILE__) + '/github/pull_request'
require File.dirname(__FILE__) + '/github/statuses'

module Status
  class Base
    attr_reader :qa_status

    def initialize(options)
      @qa_status = options[:state] || "pending"
      @branch = options[:branch] || branch
      @statuses = Status::Github::Statuses.new(@qa_status, @branch)
    end

    def branch
      `git rev-parse --abbrev-ref HEAD`.chomp
    end

    def update
      puts "Updating..."
      pull = Status::Github::PullRequest.new(@branch)
      pull.create_pull_request unless pull.pull_request_found?
      @statuses.request
      puts "Done."
    end
  end
end