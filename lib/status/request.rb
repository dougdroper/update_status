
module Status
  class Request
    attr_reader :conn
    def initialize(type="github")
      url = type == "github" ? "https://api.github.com" : Status.ci_url
      @conn = Faraday.new(:url => url) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end
    end

    def get(url)
      @response = @conn.get(url)
      body
    end

    def post(url, data)
      respose = @conn.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.body = data
      end
    end

    def status
      @response.code
    end

    def body
      @response.body
    end
  end
end