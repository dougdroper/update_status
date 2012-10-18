# coding: utf-8

module Status
  module Github
    module PullRequest
      def pull_request_found?
        !MultiJson.decode(get_pull_request).select {|pull| pull["head"]["sha"] == Status.sha}.empty?
      end

      def create_pull_request
        puts "no pull request found create one? (y/n)"
        answer = gets
        answer.chomp.downcase == "y" ? new_pull_request : abort("exit")
      end

      private

      def new_pull_request
        response = MultiJson.decode(post_pull_request)
        response["status"] == "success" ? "success" : response["message"]
      end

      def payload
        puts "enter a description"
        body = gets
        {:title => Status.title, :body => body, :base => "master", :head => Status.sha }.to_json
      end

      def get_pull_request
        system("curl -s #{pull_request_api}")
      end

      def post_pull_request
        system("curl -s -d #{MultiJson.encode(payload)} #{pull_request_api}")
      end

      def pull_request_api
        "https://api.github.com/repos/#{Status.owner}/#{Status.repo}/pulls?access_token=#{Status.token}"
      end
    end
  end
end
