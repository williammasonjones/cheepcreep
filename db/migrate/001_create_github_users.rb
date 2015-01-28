class CreateGithubUsers < ActiveRecord::Migration # This class name must match the name of the file
  def self.up
    # The db table must match the model name except be plural and use underscores 
    create_table :github_users do |t|
      t.string :login, uniqueness: true
      t.string :name
      t.string :blog
      t.integer :followers
      t.integer :following
      t.integer :public_repos
    end
  end

  def self.down
    drop_table :github_users
  end
end
