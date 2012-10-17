# coding: utf-8

module Status
  class Statuses
    STATES = %w(error failure pending success)
    def initialize(qa_status="pending")
      @qa_status = qa_status
    end

    def request
      response = %x[curl -s -d '#{payload}' #{status_api}]
    end

    private

    def status_api
      "https://api.github.com/repos/#{Status.owner}/#{Status.repo}/statuses/" + Status.sha + "?access_token=" + Status.token
    end

    def description
      "Build status: #{Jenkins.state}, QA #{@qa_status}"
    end

    def payload
      {:state => state, :description => description}.to_json
    end

    def state
      (Jenkins.pass? && @qa_status == "pass") ? states[3] : states[2]
    end

    def states
      STATES
    end
  end
end