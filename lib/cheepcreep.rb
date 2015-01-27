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
  end

  # def get_followers(screen_name)
  #   self.class.get("/users/followers")
  # end

  # def get_user(screen_name)
  #   self.class.get()
  # end

  def get_gists(screen_name)
    self.class.get("/users/#{screen_name}/gists", :headers => {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17"})
    # json = JSON.parse(result.body)
  end
end


binding.pry

# github = Github.new
# resp = github.get_followers('redline6561')
# followers = JSON.parse(resp.body)
# Cheepcreep::GithubUser
