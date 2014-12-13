require 'uri'
namespace :api_sources do
  
  desc "Foursquare"
  task :foursquare => :environment do
    location = Geocoder.search("1 Dr Carlton B Goodlett Place, San Francisco, CA 94102").first
    # client = Foursquare2::Client.new(client_id: "#{ENV['FOURSQUARE_KEY']}", 
    #                                 client_secret: "#{ENV['FOURSQUARE_SECRET']}",
    #                                 api_version: '20141210')
    # response = client.search_venues(ll: "#{location.latitude}, #{location.longitude}", query: "Coffee", limit: 2)
    api_r = HTTParty.get("https://api.foursquare.com/v2/venues/search?"\
      "client_id=#{ENV['FOURSQUARE_KEY']}&client_secret=#{ENV['FOURSQUARE_SECRET']}"\
      "&v=20141211&ll=#{location.latitude},#{location.longitude}"\
      "&limit=10"\
      "&query=#{URI::encode('coffee')}")
    
    s = Source.find_by(name: "Foursquare")

    api_r["response"]["venues"].each do |venue|
      unless ApiLink.exists?(api_key: venue['id'], source_id: s.id)
        p = Place.new(name: venue['name'], 
            latitude: venue['location']['lat'], 
            longitude: venue['location']['lng'])
        p.save
        p.api_links.create(source_id: s.id, api_key: venue['id'])

        #TODO add validation checks

      end
      #TODO - later, insert data to the statistics
    end
  end



end
