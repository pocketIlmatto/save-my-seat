require 'uri'
namespace :api_sources do
  
  desc "Foursquare"
  task :foursquare => :environment do
    location = Geocoder.search("1 Dr Carlton B Goodlett Place, San Francisco, CA 94102").first
    api_r = HTTParty.get("https://api.foursquare.com/v2/venues/search?"\
      "client_id=#{ENV['FOURSQUARE_KEY']}&client_secret=#{ENV['FOURSQUARE_SECRET']}"\
      "&v=20141211&ll=#{location.latitude},#{location.longitude}"\
      "&limit=10"\
      "&query=#{URI::encode('coffee')}")
    
    s = Source.find_by(name: "Foursquare")

    api_r["response"]["venues"].each do |venue|
      
      #if the api link doesn't exist, find or create a new place and create the link
      api_link = ApiLink.find_or_initialize_by(api_key: venue['id'], source_id: s.id)
      if api_link.new_record?
        p = Place.find_or_initialize_by(name: venue['name'], 
                                        latitude: venue['location']['lat'], 
                                        longitude: venue['location']['lng'])
        if p.new_record?
          p.capacity = 45
          p.save
        end
        api_link.place = p
        puts "#{api_link.errors.full_messages}" unless api_link.save

      end
      p = ApiLink.find_by(api_key: venue['id'], source_id: s.id).place
      #Now create the statistic
      unless p.nil?
        last_stat = p.latest_statistic_by_source(s.id)
        if last_stat.nil? or last_stat.created_at > 15.minutes.ago
          measurement = transform_measurement(venue['hereNow']['count'], p.capacity, 4)
          statistic = p.place_statistics.build(measurement: measurement, source_id: s.id)
          statistic.save
          puts "Statistic created for #{p.name} #{s.name}"
        end
      end
      
    end
  end

  desc "Test measurement mapping"
  task :test_measurement_mapping => :environment do
    puts "0 " + "#{transform_measurement(24, 100, 0)}"
    puts "1 " + "#{transform_measurement(49, 100, 4)}"
    puts "2 " + "#{transform_measurement(74, 100, 4)}"
    puts "3 " + "#{transform_measurement(99, 100, 4)}"
  end

  def transform_measurement(measure, capacity, num_buckets)
    if num_buckets > 0
      bucket = capacity/num_buckets
      for i in 1..num_buckets
        if measure <= i*bucket
          break
        end
      end
      i-1
    else
      0
    end
  end


end
