require "cheepcreep/version"
require "cheepcreep/init_db"
require "httparty"
require "pry"

module Cheepcreep
  # CamelCase names on model need to match snake case names on table
  class GithubUser < ActiveRecord::Base
    validates :login, :uniqueness => true, :presence => true
  end
end

class Github
  include HTTParty
  base_uri 'https://api.github.com'
  basic_auth ENV['GITHUB_USER'], ENV['GITHUB_PASS']

  # Can't get it to work unless I use user-agent???
  def initialize
    @headers = {"User-Agent" => "cookies"}
  end

  # Add a method to return data for a particular github user
  def get_user(screen_name)
    result = self.class.get("/users/#{screen_name}", :headers => @headers)
    puts "#{result.headers['x-ratelimit-remaining']} requests left!"
    JSON.parse(result.body)

  end

  # Add a method that takes a username & returns list of their followers
  def get_followers(screen_name, page=1, per_page=20)
    result = self.class.get("/users/#{screen_name}/followers", :headers => @headers)
    puts "#{result.headers['x-ratelimit-remaining']} requests left!"
    JSON.parse(result.body)
  end

  # Extra practice using get_gists method from class
  # I was getting a "Request forbidden by admin rules" error until added user-agent header
  def get_gists(screen_name)
    #self.class.get("/users/#{screen_name}/gists", :headers => {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"})
    self.class.get("/users/#{screen_name}/gists", :headers => @headers)
    # json = JSON.parse(result.body)
  end
end


binding.pry

# github = Github.new
# resp = github.get_followers('redline6561')
# followers = JSON.parse(resp.body)
# Cheepcreep::GithubUser
