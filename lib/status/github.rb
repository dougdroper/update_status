# coding: utf-8

module Status
  class Github
    def initialize(qa_status="pending")
      @qa_status = qa_status
      @pull_request = Status::PullRequest.new
      @statuses = Status::Statuses.new(qa_status)
    end

    def update
      @pull_request.create if @pull_request.not_found?
      @statuses.request
    end
  end
end