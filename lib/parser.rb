class Thought
  INDICATORS = ['TOTALLY', 'LITERALLY', 'NOT']
  POSITIVES = ['good', 'great', 'OK', 'ok', 'okay', 'awesome', 'super']
  NEGATIVES = ['bad', 'terrible', 'awful', 'stupid', 'stop', 'quit', "don't"]
  
  attr_accessor :parsed_string
  
  def initialize(string)
    @string = string
    
  end
  
  def self.is_sarcastic?(string)
    is_sarcastic = false
    @parsed_string = string.split(' ')
    @parsed_string.each do |word|
      is_sarcastic = true if INDICATORS.include?(word)
      is_sarcastic = true if word.include?('..') || word.include?('...') && !word.include?('http://')
    end
    return is_sarcastic
  end
  
  def self.sentiments(string)
    sentiments = []
    @parsed_string.each do |word|
      sentiments << "good" if POSITIVES.include?(word)
      sentiments << "bad" if NEGATIVES.include?(word)
    end
    sentiments
  end
  
  def parsed_string
    @parsed_string ||= string.split(' ')
  end
  
end