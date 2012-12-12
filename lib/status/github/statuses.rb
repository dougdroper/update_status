# coding: utf-8

module Status
  module Github
    class Statuses
      def initialize(qa_status, branch)
        @qa_status = qa_status
        @branch = branch
        @jenkins = Jenkins.new(branch)
      end

      def request
        Request.new.post(status_api, payload)
      end

      private

      def status_api
        "/repos/#{Status.owner}/#{Status.repo}/statuses/" + sha + "?access_token=" + Status.token
      end

      def description
        "Build status: #{@jenkins.state}, QA #{@qa_status}"
      end

      def payload
        {:state => state, :description => description, :target_url => target_url}
      end

      def target_url
        "#{Status.ci_url}/job/#{@branch}"
      end

      def state
        return "success" if @jenkins.pass? && @qa_status == "pass"
        return "pending" if @jenkins.pass? && @qa_status != "pass"
        git_state
      end

      def git_state
        states.include?(@jenkins.state) ? states[states.index(@jenkins.state)] : "error"
      end

      def states
        %w(error failure)
      end

      def sha
        `git log #{@branch} -1 --pretty=format:'%H'`
      end
    end
  end
end