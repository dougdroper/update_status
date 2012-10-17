# coding: utf-8

begin
  require 'rubygems'
rescue LoadError
end

require 'fileutils'
require 'multi_json'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'status/github'
require 'status/jenkins'
require 'status/config'

require 'status/github/statuses'
require 'status/github/pull_request'

module Status
  extend self

  def config
    @config ||= Status::Config.new
  end

  def sha
    %x[git log -1 --pretty=format:'%H']
  end

  def title
     %x[git log -1 --pretty=format:'%b']
  end

  def branch
    %x[git rev-parse --abbrev-ref HEAD].chomp!
  end

  def token
    Status.config.attrs["token"]
  end

  def repo
    Status.config.attrs["repo"]
  end

  def owner
    Status.config.attrs["owner"]
  end

end
