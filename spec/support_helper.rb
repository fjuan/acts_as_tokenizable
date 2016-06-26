class Pet < ActiveRecord::Base
end

class Enemy < ActiveRecord::Base
  acts_as_tokenizable :token
end

class Friend < ActiveRecord::Base
  acts_as_tokenizable :token

  def to_token
    string_to_token = [name, age].join(' ')
    ActsAsTokenizable::StringUtils.words_to_token(string_to_token)
  end
end

class City < ActiveRecord::Base
  acts_as_tokenizable :tokenized_name

  def to_token
    ActsAsTokenizable::StringUtils.words_to_token(name)
  end
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Base.logger
ActiveRecord::Schema.define do
  self.verbose = false
end

ActiveRecord::Schema.define(version: 1) do
  create_table :pets do |t|
    t.column :name, :string
    t.column :owner, :string
  end
end

ActiveRecord::Schema.define(version: 2) do
  create_table :friends do |t|
    t.column :name, :string
    t.column :email, :string
    t.column :age, :integer
    t.column :token, :text
  end
end

ActiveRecord::Schema.define(version: 3) do
  create_table :cities do |t|
    t.column :name, :string
    t.column :tokenized_name, :text
  end
end
