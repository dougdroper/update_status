# coding: utf-8

module Status
  class PullRequest
    def not_found?
      response = get_pull_request
      MultiJson.decode(response).select {|pull| pull["head"]["sha"] == Status.sha}.empty?
    end

    def get_pull_request
      %x[curl -s #{get_url}]
    end

    def create
      puts "no pull request found create one? (y/n)"
      answer = gets
      if answer.chomp.downcase == "y"
        new_pull_request
      else
        abort("No pull request found")
      end
    end

    def new_pull_request
      response = %x[curl -s -d #{MultiJson.encode(payload)} #{create_url}]
      response = MultiJson.decode(response)
      raise response["message"].inspect unless response["status"] == "success"
    end

    def payload
      puts "enter a description"
      body = gets
      {:title => Status.title, :body => body, :base => "master", :head => Status.sha }.to_json
    end

    def get_url
      "https://api.github.com/repos/#{Status.owner}/#{Status.repo}/pulls?access_token=#{Status.token}"
    end

    def create_url
      "https://api.github.com/repos/#{Status.owner}/#{Status.repo}/pulls?access_token=#{Status.token}"
    end
  end
end