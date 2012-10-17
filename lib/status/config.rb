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
      validate_presence_of :username
      validate_presence_of :password
      validate_presence_of :token
    end

    def validate_presence_of(sym)
      unless attrs.include?(sym.to_s)
        puts "You have not entered a #{sym}"
        attribute = gets
        self.attrs = ({sym => attribute.chomp})
      end
    end

    def bootstrap
      @attrs = {
        :owner => "notonthehighstreet",
        :repo => "notonthehighstreet",
        :ci => "http://ci.noths.com/job/"
      }
      save
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