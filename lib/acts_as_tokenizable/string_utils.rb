require 'babosa' # make sure that babosa is loaded

module ActsAsTokenizable
  module StringUtils
    # returns true if numeric, false, otherwise
    def self.numeric?(str)
      true if Float(str)
    rescue
      false
    end

    # returns an array of strings containing the words on this string. Removes
    # spaces, strange chars, etc
    def self.words(str)
      str.gsub(/[^\w|-]/, ' ').split
    end

    # removes certain words from a string.
    # As a side-effect, all word-separators are converted to the separator char
    def self.remove_words(str, words_array, separator = ' ')
      (words(str) - words_array).join separator
    end

    # replaces certain words on a string.
    # As a side-effect, all word-separators are converted to the separator char
    def self.replace_words(str, replacements, separator = ' ')
      replaced_words = words(str)
      replacements.each do |candidates, replacement|
        candidates.each do |candidate|
          replaced_words = replaced_words.collect do |w|
            w == candidate ? replacement : w
          end
        end
      end
      replaced_words.join separator
    end

    # returns an array that contains, in order:
    #   * the numeric parts, converted to numbers
    #   * the non-numeric parts, as text
    # this is useful for sorting alphanumerically. For example:
    # ["A1", "A12", "A2"].sort_by{|x| x.alphanumerics} => ["A1", "A2", "A12"]
    #
    # inspired by : http://blog.labnotes.org/2007/12/13/rounded-corners-173-beautiful-code/
    def self.alphanumerics(str)
      str.split(/(\d+)/).map { |v| v =~ /\d/ ? v.to_i : v }
    end

    # convert into something that can be used as an indexation key
    def self.to_token(str, max_length = 255)
      # to_slug and normalize are provided by the 'babosa' gem
      # remove all non-alphanumeric but hyphen (-)
      str = str.to_slug.normalize.strip.downcase.gsub(/[^\w|-]/, '')
      # remove duplicates, except on pure numbers
      str = str.squeeze unless numeric?(str)
      str[0..(max_length - 1)]
    end

    # tokenizes each word individually and joins the word with the separator
    def self.words_to_token(str, max_length = 255, separator = ' ')
      words(str)
        .collect { |w| to_token(w) }
        .uniq
        .join(separator)
        .slice(0, max_length)
    end
  end
end
