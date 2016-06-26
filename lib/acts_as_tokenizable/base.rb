require 'active_record'
require 'acts_as_tokenizable/acts_as_tokenizable'

module ActiveRecord
  class Base
    def self.acts_as_tokenizable(field_name = :token)
      include ActsAsTokenizable
      self.token_field_name = field_name
      before_save :tokenize
    end
  end
end
