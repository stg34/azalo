require 'rubygems'
require 'net/https'
require 'rubygems'
require 'rest_client'
require 'pp'
require 'json'
require 'time'
require "#{File.join(File.dirname(__FILE__),'howlingmine/config')}"
require "#{File.join(File.dirname(__FILE__),'howlingmine/client')}"
require "#{File.join(File.dirname(__FILE__),'howlingmine/issue')}"

module HowlingMine
  VERSION = '0.1.5'
end
