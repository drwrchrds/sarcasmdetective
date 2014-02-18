class Status < ActiveRecord::Base
  validates_uniqueness_of :twitter_status_id
  validates_presence_of :twitter_user_id, :twitter_status_id, :body

  def self.fetch_by_twitter_user_id!(twitter_user_id)
    statuses = TwitterSession.get("statuses/user_timeline", {:user_id => twitter_user_id}).map do |status|
      Status.parse_json(status)
    end


  end

  def self.parse_json(status)
    params = { :twitter_user_id => status["user"]["id_str"],
      :twitter_status_id => status["id_str"],
      :body => status["text"] }

    Status.new(params)
  end

  def self.save_maybe


  end

  def self.post(body)
    TwitterSession.post("statuses/update", { :status => body })
  end
end
