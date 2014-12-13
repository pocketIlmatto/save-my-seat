require 'uri'
namespace :api_sources do
  
  desc "Foursquare - venue search"
  task :foursquare_venue_search => :environment do
    location = Geocoder.search("3321 16th Street, San Francisco, CA 94114").first
    
    api_r = api_call_venue_search(location.latitude, location.longitude, 'cafe', 10)

    s = Source.find_by(name: "Foursquare")

    api_r["response"]["venues"].each do |venue|
      handle_venue(s.id, venue['id'], venue['location']['lat'], venue['location']['lng'], venue['name'], venue['hereNow']['count'])
    end
  end

  desc "Foursquare - venue update"
  task :foursquare_venue_update => :environment do
    s = Source.find_by(name: "Foursquare")
    api_links = ApiLink.where(source_id: s.id)
    unless api_links.nil?
      api_links.each do |api_link|
        api_r = api_call_venue(api_link.api_key)
        venue = api_r['response']['venue']
        unless venue.nil?
          handle_venue(s.id, venue['id'], venue['location']['lat'], venue['location']['lng'], venue['name'], venue['hereNow']['count'])
        end
      end
    end
  end

  desc "Test create_statistic?"
  task :try_create_statistic => :environment do
    p = Place.find(4)
    s = Source.find_by(name: "Yelp")
    if create_statistic?(p.id, s.id)
      puts "true"
    else
      puts "false"
    end
  end

  def handle_venue(source_id, venue_id, lat, lon, name, measurement)
    find_or_create_place(source_id, venue_id, lat, lon, name)
    p = ApiLink.find_by(api_key: venue_id, source_id: source_id).place
    create_statistic(p.id, source_id, measurement, "integer") if create_statistic?(p.id, source_id)
  end

  def find_or_create_place(source_id, venue_id, lat, lon, name)
    api_link = ApiLink.find_or_initialize_by(api_key: venue_id, source_id: source_id)
    if api_link.new_record?
      p = Place.find_or_initialize_by(name: name, 
                                      latitude: lat, 
                                      longitude: lon)
      if p.new_record?
        p.capacity = 45
        p.save
      end
      api_link.place = p
      puts "#{api_link.errors.full_messages}" unless api_link.save
    end
  end

  def assign_categories(place_id, categories)
    #TODO need to go through and assign categories to existing data
    # unless categories.nil?
    #   categories.each.do |category|
    #     # cat = Category.find_or_create_by(name: categories['name'])
    #   end
    # end
  end

  def create_statistic?(place_id, source_id)
    p = Place.find(place_id)
    unless p.nil?  
      last_stat = p.latest_statistic_by_source(source_id)
      #TODO the interval should come from a configuration somewhere
      last_stat.nil? or (!last_stat.nil? and last_stat.created_at < 15.minutes.ago)
    end
  end

  def create_statistic(place_id, source_id, measure, raw_data_type)
    p = Place.find(place_id)
    measurement = transform_measurement(measure, p.capacity, 4)
    statistic = p.place_statistics.build(measurement: measurement, source_id: source_id, raw_data: measure, raw_data_type: raw_data_type)
    statistic.save
    puts "Statistic created for #{p.name}"
  end


  def api_call_venue_search(latitude, longitude, category, limit)
    HTTParty.get("https://api.foursquare.com/v2/venues/search?"\
      "client_id=#{ENV['FOURSQUARE_KEY']}&client_secret=#{ENV['FOURSQUARE_SECRET']}"\
      "&v=20141211&ll=#{latitude},#{longitude}"\
      "&limit=#{limit}"\
      "&query=#{URI::encode(category)}")
  end

  def api_call_venue(venue_id)
    HTTParty.get("https://api.foursquare.com/v2/venues/#{venue_id}?"\
      "client_id=#{ENV['FOURSQUARE_KEY']}&client_secret=#{ENV['FOURSQUARE_SECRET']}&v=20141211")
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
