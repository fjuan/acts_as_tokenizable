require 'spec_helper'
require 'support_helper'

describe ActiveRecord do
  it 'does stuff' do
    friend = Friend.create name: 'John', email: 'john@example.com'
    expect(friend.token).to eq('john')
  end
end
