# coding: utf-8

module Status
  module Jenkins
    extend self

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
      "/job/#{Status.branch}/lastBuild/api/json"
    end
  end
end


