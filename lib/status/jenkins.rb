# coding: utf-8

module Status
  module Jenkins
    extend self

    def username
      $JENKINS_USERNAME || Status.config.attrs["username"]
    end

    def password
      $JENKINS_PASSWORD || Status.config.attrs["password"]
    end

    def state
      return "Green" if pass?
      "building"
    end

    def ci_url
      Status.config.attrs["ci"] + Status.branch + "/lastBuild/api/json"
    end

    def pass?
      @status ||= get_ci_status
      return false if @status == "building" || @status == "not found"
      true
    end

    def get_ci_status
      response = %x[curl -s --user #{username}:#{password} #{ci_url}]
      return "not found" if response.match(/Error/)
      response = MultiJson.decode(response)

      if response["building"] == true
        "building"
      else
        response["result"]
      end
    end
  end
end