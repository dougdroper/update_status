# coding: utf-8

module Status
  class Config
    FILE = "#{ENV['HOME']}/.status.conf"

    attr_reader :attrs

    def initialize
      bootstrap unless File.exist?(file)
      load_config
      validate
    end

    def file
      FILE
    end

    def validate
      validate_presence_of :owner
      validate_presence_of :repo
      validate_presence_of :token
      validate_presence_of :ci_url, "ci"
      validate_presence_of :username, "ci"
      validate_presence_of :password, "ci"
    end

    def validate_presence_of(sym, type="github")
      unless attrs.include?(sym.to_s)
        puts "You have not entered a #{sym} for #{type}"
        attribute = gets
        self.attrs = ({sym => attribute.chomp})
      end
    end

    def bootstrap
      @attrs = {
        # eg:
        # :owner => "dougdroper",
        # :repo => "status",
        # :ci_url => "http://jenkins-ci.org/"
      }
      save
      abort("Config setup: Run status")
    end

    def attrs=(attribute={})
      @attrs.merge!(attribute)
      save
    end

    def load_config
      @attrs = MultiJson.decode(File.new(file, 'r').read)
    end

    def save
      json = MultiJson.encode(attrs)
      File.open(file, 'w') {|f| f.write(json) }
    end
  end
end