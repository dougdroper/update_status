# coding: utf-8

module Status
  module Github
    class Statuses
      def initialize(qa_status="pending")
        @qa_status = qa_status
      end

      def request
        Request.new.post(status_api, payload)
      end

      private

      def status_api
        "/repos/#{Status.owner}/#{Status.repo}/statuses/" + Status.sha + "?access_token=" + Status.token
      end

      def description
        "Build status: #{Jenkins.state}, QA #{@qa_status}"
      end

      def payload
        {:state => state, :description => description, :target_url => target_url}
      end

      def target_url
        "#{Status.ci_url}/job/#{Status.branch}"
      end

      def state
        (Jenkins.pass? && @qa_status == "pass") ? states[3] : states[2]
      end

      def states
        %w(error failure pending success)
      end
    end
  end
end