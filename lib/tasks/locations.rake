require 'csv'

namespace :locations do

  desc "Seed Locations into the database using Zipinfo data"
  task :seed => :environment do
    puts "Deleting all locations"
    Location.delete_all
    puts "Seeding locations... (this will take a while)"
    location_count = 0

    csv_text = File.read("#{Rails.root}/db/raw/zipinfo_zipcodes_with_headers_id_col.csv")
    csv = CSV.parse(csv_text, :headers => true)

    csv.each do |row|
      # "id","City","ST","ZIP","A/C","FIPS","County","T/Z","DST?","Lat","Long","Type"
      id = row[0]
      city = row[1]
      st = row[2]
      zip = row[3]
      timezone = row[7]
      dst = (row[8] == "Y")
      lat = row[9].to_f #* 10**6
      lon = row[10].to_f #* 10**6

      case timezone
      when "EST+1"
        @canonical_timezone = "Atlantic Time (Canada)"
        timezone = "AST"
      when "EST"
        @canonical_timezone = "Eastern Time (US & Canada)"
      when "CST"
        @canonical_timezone = "Central Time (US & Canada)"
      when "MST"
        @canonical_timezone = "Mountain Time (US & Canada)"
      when "PST"
        @canonical_timezone = "Pacific Time (US & Canada)"
      when "PST-1"
        @canonical_timezone = "Alaska"
        timezone = "AKST"
      when "PST-2"
        @canonical_timezone = "Hawaii"
        timezone = "HST"
      when "PST-3"
        @canonical_timezone = "International Date Line West"
      when "PST-4"
        @canonical_timezone = "Nuku'alofa"
      else
        @canonical_timezone = timezone
      end


      location = Location.create(city: city, 
        state: st, 
        zipcode: zip, 
        timezone: timezone, 
        canonical_timezone: @canonical_timezone, 
        daylight_savings: dst, 
        longitude: lon,
        latitude: lat)
      
      location_count += 1
      puts "#{location_count} Locations (#{location_count * 100 / csv.length}% complete)" if location_count % 500 == 0

    end

    puts "#{location_count} locations seeded."
  end

end
