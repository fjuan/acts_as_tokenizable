$LOAD_PATH << File.dirname(__FILE__)

require 'active_record'
require 'acts_as_tokenizable/acts_as_tokenizable'
require 'acts_as_tokenizable/string_utils'

module ActsAsTokenizable
  if defined?(Rails::Railtie)
    class Railtie < Rails::Railtie
      initializer 'acts_as_tokenizable.insert_into_active_record' do
        ActiveSupport.on_load :active_record do
          ActiveRecord::Base.send(:include, ActsAsTokenizable)
        end
      end
    end
  elsif defined?(ActiveRecord)
    ActiveRecord::Base.send(:include, ActsAsTokenizable)
  end
end
