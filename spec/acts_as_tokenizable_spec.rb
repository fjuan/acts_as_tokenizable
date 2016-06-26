require 'spec_helper'
require 'support_helper'

describe ActiveRecord do
  describe 'classes with acts_as_tokenizable' do
    it 'respond to `tokenized_by`' do
      expect(Friend.methods).to include(:tokenized_by)
    end

    it 'raises an error if `to_token` method is not defined' do
      expect { Enemy.to_token }.to raise_error(NoMethodError)
    end

    describe 'instances' do
      it 'include to_token and tokenize methods' do
        expect(Friend.instance_methods)
          .to include(:tokenize, :tokenize!, :to_token)
      end

      it 'update the token field after creating an object' do
        friend = Friend.new name: 'John', email: 'john@example.com', age: 30
        expect(friend.token).to be_nil
        friend.save
        expect(friend.token).to eq('john 30')
      end

      it 'allow different token field name' do
        malmo = City.create name: 'Malmö'
        expect(malmo.tokenized_name).to eq('malmo')
      end
    end

    describe 'scope tokenized_by' do
      before do
        Friend.delete_all

        Friend.create name: 'Tomás', age: 31
        Friend.create name: 'Rafa', age: 25
        Friend.create name: 'Matthias', age: 35
        Friend.create name: 'Mamá', age: 30
      end

      it 'finds records with tokenized string' do
        expect(Friend.tokenized_by('as').count).to eq(2)
      end

      it 'finds records with tokenized with number' do
        expect(Friend.tokenized_by('3').count).to eq(3)
      end

      it 'finds records with duplicated characters' do
        expect(Friend.tokenized_by('mathias').count).to eq(1)
        expect(Friend.tokenized_by('matthias').count).to eq(1)
      end

      it 'excludes records with negative token' do
        expect(Friend.tokenized_by('-To').count).to eq(3)
      end

      it 'combines tokens' do
        expect(Friend.tokenized_by('-To 5').count).to eq(2)
      end
    end
  end

  describe 'classes without acts_as_tokenizable' do
    it 'does not include to_token and tokenize methods' do
      expect(Pet.instance_methods)
        .to_not include(:tokenize, :tokenize!, :to_token)
    end
  end
end
