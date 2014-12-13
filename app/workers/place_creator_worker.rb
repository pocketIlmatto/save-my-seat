class PlaceCreatorWorker
  include Sidekiq::Worker

  def perform(latitude, longitude)
    # create_places_foursquare(latitude, longitude, 'coffee', 20)
  end
end