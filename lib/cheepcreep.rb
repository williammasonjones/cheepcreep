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

  # List a user's gists
  def get_gists(screen_name)
    result = self.class.get("/users/#{screen_name}/gists", :headers => @headers)
    puts "#{result.headers['x-ratelimit-remaining']} requests left!"
    JSON.parse(result.body)
    result.each do |gist_hash|
      gist_hash['files'].each do |filename, file_hash|
        puts filename
      end
    end
  end

  # Create a new gist
  # def create_gists(user= 'williammasonjones', options={}, info= {:description => "the description of this gist", :public = true, :files => {:file1.txt, {:content => "String file contents"}}})
  #   options = {:body => info.to_json}
  #   result = self.class.post("/gists", options, :headers => @headers)
  #end

  # Edit a user's gist
  # def edit_gists(id)
  #   options = {:body => info.to_json}
  #   result = self.class.patch("/gists/#{id}")
  #end

  # Star a gist
  def star_gists(id)
    result = self.class.put("/gists/#{id}/star", :headers => @headers)
    puts "#{result.headers['x-ratelimit-remaining']} requests left!"
  end

  # Unstar a gist
  def unstar_gists(id)
    result = self.class.delete("/gists/#{id}/star", :headers => @headers)
    puts "#{result.headers['x-ratelimit-remaining']} requests left!"
  end

  # Delete a user's gist
  def delete_gists(id)
    result = self.class.delete("/gists/#{id}", :headers => @headers)
    puts "#{result.headers['x-ratelimit-remaining']} requests left!"
  end
end

# Add a user to the db
def add_user_to_db(screen_name)
  user = github.get_user(screen_name)
  Cheepcreep::GithubUser.create(:login => json['login'],
                                :name => json['name'],
                                :blog => json['blog'],
                                :followers => json['followers'],
                                :following => json['following'],
                                :public_repos => json['public_repos'])

end

# Query the database to print a list of the top users sorted by their follower count
# This was Brit's class example. Review w/ Britt for clarification!
def sorted_top_users
  add_github_user('redline6561')
  followers = github.get_followers('redline6561',1,100)
  followers.map { |x| x['login'] }.sample(20).each do |username|
    add_github_user(username)
  end

  Cheepcreep::GithubUser.order(:followers => :desc).each do |u|
    puts "User: #{u.login}, Name: #{u.name}, Followers: #{u.followers}"
  end
end

github = Github.new

binding.pry
