module ActsAsTokenizable
  def self.included(base)
    base.class_eval { extend ClassMethods }
  end

  module ClassMethods
    attr_accessor :token_field_name

    def acts_as_tokenizable(field_name = :token)
      include InstanceMethods
      include TokenizedBy

      before_save :tokenize

      self.token_field_name = field_name
    end

    # search_token parameter is used by tokenized_by. This function allows for
    # preparation before tokenized_by function is invoked. Usually this means
    # removing stop words, replacing words.
    # By default it tokenizes each word and removes duplicates.
    def prepare_search_token(search_token)
      StringUtils.words_to_token(search_token)
    end
  end

  module InstanceMethods
    # default to_token method. needs to have a "name" property on the object.
    # override for more complex token generation
    def to_token
      raise(
        NoMethodError,
        'You must define to_token in your model. Example: self.name.to_token()'
      )
    end

    # makes self.<token_field_name>=self.to_token
    def tokenize
      send("#{self.class.token_field_name}=", to_token)
    end

    def tokenize!
      update_column(self.class.token_field_name, to_token)
    end
  end

  module TokenizedBy
    extend ActiveSupport::Concern

    included do
      scope :tokenized_by, lambda { |search_token|
        search_strings = []
        search_values = []
        StringUtils.words(search_token).each do |w|
          if w[0, 1] == '-'
            search_strings.push("#{table_name}.#{token_field_name} NOT LIKE ?")
          else
            search_strings.push("#{table_name}.#{token_field_name} LIKE ?")
          end
          tokenized_word = StringUtils.to_token(w)
          search_values.push("%#{tokenized_word}%")
        end
        where([search_strings.join(' AND '), *search_values])
      }
    end
  end
end
