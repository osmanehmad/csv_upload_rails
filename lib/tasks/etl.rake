# encoding: UTF-8
require 'csv'

namespace :etl do
  desc 'loading active projects'
    task :active => :environment do
      Active.new.collection.drop
      csv_data = CSV.read Rails.root.join("lib","tasks","c.csv")
      headers = csv_data.shift.map {|i| i.to_s }
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
      data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
      data.each do |doc|
        p doc
        doc["field_name_removed"] = 0
        active = Active.new(doc)
        active.save
      end
    end
    task :locations => :environment do
      Location.collection.drop

      # a sample csv file includes some vile text in every csv file, have to make that go away before etl
      f = open(Rails.root.join('lib','tasks','locations.csv').to_s)
      data = f.read()
      data.chomp! "\r\n\r\nTEXT REMOVED\r\n"
      csv_data = CSV.parse data
      # end csv repair

      headers = csv_data.shift.map {|i| i.to_s }
      headers =  headers + [FIELDS_REMOVED]
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
      data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
      data.each do |doc|
        # adding custom fields
        # removed
        # removed
        # removed
        doc.merge!({"removed" => ""+"#lat:long"})
        doc.merge!({"remooved" => ""})
        doc.merge!({"removed" => "No"})
        doc.merge!({"removed" => "#"})
        potential = Location.new(doc)
        potential.save
      end
    end
     task :locations_seed => :environment do
      # this task is for randomly seeding data for testing
      Location.collection.drop

      # a samle csv file exports some vile text in every csv file, have to make that go away before etl
      f = open(Rails.root.join('lib','tasks','locations.csv').to_s)
      data = f.read()
      data.chomp! "\r\n\r\nTEXT REMOVED\r\n"
      csv_data = CSV.parse data
      # end csv repair

      headers = csv_data.shift.map {|i| i.to_s }
      headers =  headers + ["Driver","Owned", "Manager"]
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
      data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
      data.each do |doc|
        # adding custom fields, Driver and Owned
        # removed
        # removed
        # removed
        doc.merge!({"removed" => MODEL::REMOVED.sample.to_s + "#lat:long"})
        doc.merge!({"removed" => MODEL::REMOVED.sample})
        doc.merge!({"removed" => "No"})
        doc.merge!({"removed" => "#"})
        potential = Location.new(doc)
        potential.save
      end
    end
    task :clean => :environment do
      Active.new.collection.drop
      Location.new.collection.drop
    end
    task :pull_from_rentjuice => :environment do
      REMOVED.seed
    end

end


