# coding: utf-8

module Status
  module Jenkins
    extend self

    def state
      return "Green" if pass?
      "building"
    end

    def pass?
      @status ||= get_ci_status
      return false if @status == "building" || @status == "not found"
      true
    end

    def get_ci_status
      response = Request.new(:ci).get(path)
      return response if response == "not found"
      response["building"] == true ? "building" : response["result"]
    end

    def path
      "/job/#{Status.branch}/lastBuild/api/json"
    end
  end
end