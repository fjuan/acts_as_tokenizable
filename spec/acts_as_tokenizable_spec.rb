require 'spec_helper'
require 'support_helper'

describe ActiveRecord do
  describe 'classes with acts_as_tokenizable' do
    it 'does include to_token and tokenize methods' do
      expect(Friend.instance_methods)
        .to include(:tokenize, :tokenize!, :to_token)
    end

    it 'updates the token field after creating an object' do
      friend = Friend.new name: 'John', email: 'john@example.com'
      expect(friend.token).to be_nil
      friend.save
      expect(friend.token).to eq('john')
    end

    it 'allows different token field name' do
      malmo = City.create name: 'Malmö'
      expect(malmo.tokenized_name).to eq('malmo')
    end

    it 'raises an error if `to_token` method is not defined' do
      expect { Enemy.to_token }.to raise_error(NoMethodError)
    end
  end

  describe 'classes without acts_as_tokenizable' do
    it 'does not include to_token and tokenize methods' do
      expect(Pet.instance_methods)
        .to_not include(:tokenize, :tokenize!, :to_token)
    end
  end
end
