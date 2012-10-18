# coding: utf-8

module Status
  module Jenkins
    extend self

    def state
      return "Green" if pass?
      "building"
    end

    def ci_url
      #http://ci.noths.com/job/master/lastBuild/api/json
      "#{Status.ci_url}#{Status.branch}/lastBuild/api/json"
    end

    def pass?
      @status ||= get_ci_status
      return false if @status == "building" || @status == "not found"
      true
    end

    def get_ci_status
      response = `curl -s --user #{username}:#{password} #{ci_url}`
      return "not found" if response.match(/Error/)
      response = MultiJson.decode(response)

      if response["building"] == true
        "building"
      else
        response["result"]
      end
    end

    def username
      Status.config.attrs["username"]
    end

    def password
      Status.config.attrs["password"]
    end
  end
end