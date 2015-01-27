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
    @auth = {:username => ENV['GITHUB_USER'], :password => ENV['GITHUB_PASS']}
    @headers = {"User-Agent" => "cookies"}
  end

  # Add a method that takes a username & returns list of their followers
  def get_followers(screen_name)
    self.class.get("/users/#{screen_name}/followers", :headers => @headers)
    # json = JSON.parse()
  end

  # Add a method to return data for a particular github user
  # def get_user(screen_name)
  #   self.class.get()
  # end

  # Extra practice using class get_gists method
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
