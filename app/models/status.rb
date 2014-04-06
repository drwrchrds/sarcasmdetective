# == Schema Information
#
# Table name: statuses
#
#  id                :integer          not null, primary key
#  body              :string(255)      not null
#  twitter_status_id :string(255)      not null
#  twitter_user_id   :string(255)      not null
#  created_at        :datetime
#  updated_at        :datetime
#

require 'open-uri'

class Status < ActiveRecord::Base
  validates_uniqueness_of :twitter_status_id
  validates_presence_of :twitter_user_id, :twitter_status_id, :body

  belongs_to(:user,
    primary_key: :twitter_user_id,
    foreign_key: :twitter_user_id,
    class_name: "User")

  def self.fetch_by_twitter_user_id!(twitter_user_id)
    old_ids = Status.where(:twitter_user_id == twitter_user_id)
      .pluck(:twitter_status_id)

    statuses = TwitterSession.get("statuses/user_timeline",
      {:user_id => twitter_user_id, :count  => 100}).map do |status|
      Status.parse_json(status)
    end

    statuses.each do |status|
      status.save! unless old_ids.include?(status.twitter_status_id)
    end
  end
  
  def self.fetch_by_hashtag!(hashtag)
    old_ids = Status.where(:hashtag == hashtag)
      .pluck(:twitter_status_id)

    statuses = TwitterSession.get("search/tweets",
      {:hashtag => hashtag}).map do |status| # how to put hashtag into a search url?
      Status.parse_json(status)
    end

    statuses.each do |status|
      status.save! unless old_ids.include?(status.twitter_status_id)
    end
  end

  def self.get_by_twitter_user_id(twitter_user_id)
    if internet_connection?
      self.fetch_by_twitter_user_id!(twitter_user_id)
    else
      Status.where(:twitter_user_id == twitter_user_id)
    end
  end

  def self.parse_json(status)
    params = { :twitter_user_id => status["user"]["id_str"],
      :twitter_status_id => status["id_str"],
      :body => status["text"] }

    Status.new(params)
  end

  def self.post(body)
    TwitterSession.post("statuses/update", { :status => body })
  end
  
  def sentiments
    Thought.sentiments(self.body)
  end
  
  def sarcasm_level
    Thought.sarcasm(self.body)
  end

  def self.internet_connection?
    begin
      true if open("http://www.google.com?")
    rescue
      false
    end
  end
end
