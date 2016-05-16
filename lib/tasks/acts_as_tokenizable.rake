namespace :tokens do
  desc 'Generates the token for objects without tokens.'
  task generate: :environment do
    tokenize_models
  end

  desc 'Re-builds the token for all objects.'
  task regenerate: :environment do
    tokenize_models(true)
  end
end

def array_of_active_record_models
  Rails.application.eager_load!
  ActiveRecord::Base.descendants.select { |m| m.respond_to? :tokenized_by }
end

def tokenize_records(records)
  total_count = records.size

  count = 0

  records.each do |record|
    record.tokenize!
    count += 1
    print "\r#{count}/#{total_count}"
    # launch garbage collection each 1000 registers
    GC.start if count % 1000 == 0
  end
  puts ''
end

def tokenize_models(regenerate = false)
  start = Time.current
  puts 'Start token generation'
  puts '++++++++++++++++++++++++++++++++'

  array_of_active_record_models.each do |model|
    puts "Generating new tokens for #{model.name.pluralize}"
    field_name = model.token_field_name
    sql_conds = "#{field_name} IS NULL OR #{field_name} = ''" unless regenerate

    records_without_token = model.all(conditions: sql_conds)
    if !records_without_token.empty?
      tokenize_records(records_without_token)
    else
      puts 'There are no records without token'
      puts '++++++++++++++++++++++++++++++++'
    end
  end
  puts "Elapsed time #{(Time.current - start).seconds} seconds"
end
