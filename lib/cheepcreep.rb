require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"

module Cheepcreep
end

class Github
  include HTTParty
  base_uri 'https://api.github.com'

  def initialize
    # ENV["FOO"] is like echo $FOO
    #@auth = {:username => ENV['GITHUB_USER'], :password => ENV['GITHUB_PASS']}
  end
end


class CheepcreepApp
end

binding.pry

creeper = CheepcreepApp.new
creeper.creep
