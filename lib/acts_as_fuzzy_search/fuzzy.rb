module ActsAsFuzzySearch
  module Fuzzy

    extend ActiveSupport::Concern
 
    included do
    end
 
    module ClassMethods
      
      DEFAULT_ALGORITHM = :white_similarity
      MATCH_SCORE = 0.8 # used by jarow-winkler and white-similarity
      MIN_LEVENSHTEIN_DISTANCE = 3 # number of changes to get the strings to match
      
      DATE_FORMAT = "%B %d %Y"
      SCOPE = "all"
      
      
      
      attr_accessor :config
      
      def acts_as_fuzzy_search(options = {})
        @config = { :date_format => DATE_FORMAT,
                    :scope => "all",
                    :scope_args => nil, # Should be an array of arguments to pass
                    :search_algorithm => DEFAULT_ALGORITHM,
                    :jarow_score => MATCH_SCORE,
                    :white_similarity_score => MATCH_SCORE,
                    :min_levenshtein_distance => MIN_LEVENSHTEIN_DISTANCE,
                    :debug => false }

        @config.merge!(options)
      end
        
      def find_by_fuzzy_search(search_term, options = {})
        
        @config.merge!(options)

        search_term = search_term.strip.chomp
        records = []

        if config[:scope_args] and config[:scope_args].is_a? Array
          scoped_records = send(config[:scope], *config[:scope_args])
        elsif config[:scope_args]
          scoped_records = send(config[:scope], config[:scope_args])
        else
          scoped_records = send(config[:scope])
        end
        scoped_records.each do |record|

          attrs = record.attributes.values

          # convert dates to ones humans will likely search on
          attrs.collect! {|a| ([Date,Time,DateTime].include? a.class) ? a.strftime(config[:date_format]) : a }

          # 'create' an html page
          markup = Nokogiri::HTML(attrs.join(" "))

          # strip all the tags and whitespace
          no_tags = markup.text.gsub(/\s+|\n/, ' ')
  
          # Match each word in the document against each search term
          no_tags.split(" ").each do |word|        
             search_term.split(" ").each do |term|
               records << record if matches?(term, word)
             end
           end
        end
        return records.uniq
      end
      
      private
      
      def matches?(word1, word2)
        # mostly for the regex - the other matches are probably smart enough
        word1 = word1.downcase
        word2 = word2.downcase
        
        case config[:search_algorithm]
        when :jarow_winkler
          # Drop for now cause we're using 1.8
          raise "Jarow-Winkler not supported" #return FuzzyStringMatch::JaroWinkler.create(:native).getDistance(word1, word2) >= config[:jarow_score]
        when :white_similarity
          return Text::WhiteSimilarity.new.similarity(word1,word2) >= config[:white_similarity_score]
        when :levenshtein_distance
          return Text::Levenshtein.distance(word1,word2) <= config[:min_levenshtein_distance]
        else
          return word1.match(word2).present? # simple regex match
        end

      end

      
    end
  end
end
 
ActiveRecord::Base.send :include, ActsAsFuzzySearch::Fuzzy