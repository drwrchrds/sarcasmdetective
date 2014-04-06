# encoding: UTF-8

class Thought
  INDICATORS = ['totally', 'literally', "yolo", '#yolo', 'plz', 'okz', 'okay', 'lol', '-_-', ':P', ';)', "can't", 'wow', 'much']
  POSITIVES = ['best', 'yes', 'good', 'great', 'OK', 'ok', 'okay', 'awesome', 'super', 'happy', 'cool', 'stoked']
  NEGATIVES = ['bad', ':/', 'no', 'terrible', 'awful', 'stupid', 'stop', 'dont', 'quit', "don't", 'not', 'no', 'hate', 'ugh', 'ughh', 'ughhh', 'ughhhhh', 'never', 'bs']
  SWEARS = ['wtf', 'asshole', 'fuck', 'shit', 'shits', 'wth', 'damn', 'damnit', 'goddammit', 'christ', 'fucking', 'fucker']
  CONTROVERSIAL = ['racist', 'racism', 'sexist', 'sex', 'sexism', 'meth', 'drugs', 'lsd', 'pussy', 'vagina', 'cocaine', 'crack-cocaine', 'masturbate']
  STARTERS = ['oh,', 'ohh', 'ohhh', 'ohhhh', 'stay', 'thanks', 'thank', 'apparently', 'clearly']
  POS_PHRASES = ['thank you']
  PUNCTUATION = %(.,:;'")
  
  attr_accessor :parsed_string

  def self.sarcasm(string)
    has_quotes = 0
    has_qmarks = 0
    has_bangs = string.split('').count('!')
    has_asterisks = 0
    has_hashtags = 0
    sarcasm_level = 0
    @parsed_string = string.split(' ')
    sarcasm_level += 1 if STARTERS.include? @parsed_string[0].downcase
    
    @parsed_string.each_with_index do |word, idx|
      next if word == '-'
      sarcasm_level += 1 if INDICATORS.include?(word.downcase)
      sarcasm_level += 1 if word == word.upcase && word[0] != '#' && !word.match(/\d/) && word.length > 2
      sarcasm_level += 1 if word.include?('..') || word.include?('...') && 
            !word.include?('http')
      has_quotes += 1 if word[0] == '"' || word[-1] == '"'
      has_qmarks += 1 if word[-1] == '?' || word[-2] == '?'
      has_asterisks += 1 if word[0] == '*' || word [-1] == '*'
      sarcasm_level += 1 if word[0] == '#' && word.length > 16
      has_hashtags += 1 if word[0] == '#'
    end
    sarcasm_level += (has_quotes + has_qmarks + has_bangs + has_asterisks)/ 2
    sarcasm_level += has_hashtags / 3
    return sarcasm_level
  end
  
  def self.sentiments(string) # if good and bad are expressed on about the same level 
    sentiments = []
    POS_PHRASES.each do |phrase|
      sentiments << "☺" if string.match(phrase)
    end
    
    @parsed_string = string.split(' ')
    @parsed_string.each do |word|
      down = word.downcase.delete(PUNCTUATION)
      puts down
      sentiments << "☺" if POSITIVES.include?(down)
      sentiments << "☹" if NEGATIVES.include?(down)
      sentiments << ">｡<" if SWEARS.include?(down)
      sentiments << "ಠ_ಠ" if CONTROVERSIAL.include?(down)
    end
    sentiments = ['malfunction: Jaden'] if @parsed_string.all? { |word| word.capitalize == word }
    sentiments
  end
  
  def parsed_string
    @parsed_string ||= string.split(' ')
  end
  
end