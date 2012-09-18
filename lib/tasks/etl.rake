# encoding: UTF-8
require 'csv'

namespace :etl do
  desc 'loading active constructions'
    task :active => :environment do
      Active.new.collection.drop
      csv_data = CSV.read Rails.root.join("lib","tasks","c.csv")
      headers = csv_data.shift.map {|i| i.to_s }
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
      data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
      data.each do |doc|
        p doc
        doc["Rehab_Cost"] = 0
        active = Active.new(doc)
        active.save
      end
    end
    task :locations => :environment do
      Location.collection.drop

      # foreclosure radar exports some vile text in every csv file, have to make that go away before etl
      f = open(Rails.root.join('lib','tasks','locations.csv').to_s)
      data = f.read()
      data.chomp! "\r\n\r\nThe information contained in this report is subject to the license restrictions and all other terms contained in ForeclosureRadar.com's User Agreement.\r\n"
      csv_data = CSV.parse data
      # end csv repair

      headers = csv_data.shift.map {|i| i.to_s }
      headers =  headers + ["Driver","Owned", "Manager"]
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
      data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
      data.each do |doc|
        # adding custom fields, Driver, Manager and Owned
        # Driver stores name of the driver assigned, default value is "" (empty string)
        # manager stores name of the Property Manager assigned, default value is "" (empty string)
        # Owned stores if Haven owns the house yet or not, default value is "No" (which means no, haven doesnt own it yet)
        doc.merge!({"Driver" => ""+"#lat:long"})
        doc.merge!({"Manager" => ""})
        doc.merge!({"Owned" => "No"})
        doc.merge!({"Order" => "#"})
        p doc
        potential = Location.new(doc)
        potential.save
      end
    end
     task :locations_seed => :environment do
      Location.collection.drop

      # foreclosure radar exports some vile text in every csv file, have to make that go away before etl
      f = open(Rails.root.join('lib','tasks','locations.csv').to_s)
      data = f.read()
      data.chomp! "\r\n\r\nThe information contained in this report is subject to the license restrictions and all other terms contained in ForeclosureRadar.com's User Agreement.\r\n"
      csv_data = CSV.parse data
      # end csv repair

      headers = csv_data.shift.map {|i| i.to_s }
      headers =  headers + ["Driver","Owned", "Manager"]
      string_data = csv_data.map {|row| row.map {|cell| cell.to_s } }
      data = string_data.map {|row| Hash[*headers.zip(row).flatten] }
      data.each do |doc|
        # adding custom fields, Driver and Owned
        # Driver stores name of the driver assigned, default value is "" (empty string)
        # Owned stores if Haven owns the house yet or not, default value is "No" (which means no, haven doesnt own it yet)
        doc.merge!({"Driver" => Location::DRIVERS.sample.to_s + "#lat:long"})
        doc.merge!({"Manager" => Location::MANAGERS.sample})
        doc.merge!({"Owned" => "No"})
        doc.merge!({"Order" => "#"})
        p doc
        potential = Location.new(doc)
        potential.save
      end
    end
    task :clean => :environment do
      Active.new.collection.drop
      Location.new.collection.drop
    end
    task :pull_from_rentjuice => :environment do
      Home.seed
    end

end


