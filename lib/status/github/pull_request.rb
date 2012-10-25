# coding: utf-8

module Status
  module Github
    class PullRequest
      def pull_request_found?
        !get_pull_request.select {|pull| pull["head"]["ref"] == Status.branch}.empty?
      end

      def create_pull_request
        puts "no pull request found create one? (y/n)"
        answer = gets
        answer.chomp.downcase == "y" ? new_pull_request : abort("exit")
      end

      def new_pull_request
        response = post_pull_request
        puts response == "not found" ? response : response["url"]
      end

      def payload
        puts "enter a description"
        body = gets

        {:title => Status.title, :body => body, :base => "master", :head => Status.branch }
      end

      def get_pull_request
        Status::Request.new.get(pull_request_api)
      end

      def post_pull_request
        Status::Request.new.post(pull_request_api, payload)
      end

      def pull_request_api
        "/repos/#{Status.owner}/#{Status.repo}/pulls?access_token=#{Status.token}"
      end
    end
  end
end