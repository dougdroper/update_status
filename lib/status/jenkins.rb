# coding: utf-8

module Status
  class Jenkins
    attr_reader :target_url

    def target_url
      "#{Status.ci_url}/job/#{@branch}"
    end

    def initialize(branch, sha=nil)
      @branch = branch.gsub(/\//, "_")
      @sha = sha
    end

    def state
      return "success" if pass?
      @status
    end

    def pass?
      @status ||= get_ci_status
      return false unless @status == "success"
      true
    end

    def get_ci_status
      response = Request.new(:ci).get(path)
      return "pending" if response == "not found"
      return "pending" if response["building"] == true
      return "failure" unless response["result"].downcase == "success"
       "success"
    end

    def path
      "/job/#{@branch}/#{find_build_for(@sha)}/api/json"
    end

    def find_build_for(sha)
      return "lastBuild"
    end
  end
end


