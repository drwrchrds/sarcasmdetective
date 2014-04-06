class TwitterSession
  ACCESS_TOKEN = "access_token.yml"

  def self.get(path, query_values)
    url = self.path_to_url(path, query_values)
    JSON.parse(self.access_token.get(url).body)
  end

  def self.post(path, req_params)
    url = self.path_to_url(path, req_params)
    JSON.parse(self.access_token.post(url).body)
  end

  def self.access_token
    @access_token ||= (File.exist?(ACCESS_TOKEN) ?
      File.open(ACCESS_TOKEN) { |f| YAML.load(f) } :
      self.request_access_token)
  end

  def self.request_access_token
    consumer = OAuth::Consumer.new(
      ENV["CONSUMER_KEY"], ENV["CONSUMER_SECRET"], :site => "https://twitter.com")

    request_token = consumer.get_request_token
    authorize_url = request_token.authorize_url

    puts "Go to this URL: #{authorize_url}"
    Launchy.open(authorize_url)

    puts "Login, and type your verification code in"
    oauth_verifier = gets.chomp
    access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier
    )

    puts access_token
      .get("http://api.twitter.com/1.1/statuses/user_timeline.json")
      .body

    File.open(ACCESS_TOKEN, "w") { |f| YAML.dump(access_token, f) }

    access_token
  end

  def self.path_to_url(path, query_values = nil)
   Addressable::URI.new(
         :scheme => "https",
         :host => "api.twitter.com",
         :path => "/1.1/#{path}.json",
         :query_values => query_values
       ).to_s
  end
end