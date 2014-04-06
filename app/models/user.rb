class User < ActiveRecord::Base
  has_many(:statuses,
  primary_key: :twitter_user_id,
  foreign_key: :twitter_user_id,
  class_name: "Status")

  def self.fetch_by_twitter_handle!(twitter_handle)
    user_info = TwitterSession.get("users/lookup", {:screen_name => twitter_handle}).first

    user = User.parse_twitter_user(user_info)
    user.save!
    user
  end

  def self.get_by_twitter_handle(twitter_handle)
    User.where(:twitter_handle => twitter_handle).first ||
      self.fetch_by_twitter_handle!(twitter_handle)
  end

  def self.parse_twitter_user(user_info)
    if user_info.include?('errors')
      raise "Invalid Screen Name"
    else 
      params = {
        :twitter_handle => user_info["screen_name"],
        :twitter_user_id => user_info["id_str"] }
      User.new(params)
    end
  end

  def fetch_statuses!
    Status.fetch_by_twitter_user_id!(self.twitter_user_id)
  end
end
