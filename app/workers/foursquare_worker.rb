class FoursquareWorker
  include Sidekiq::Worker

  def perform(latitude, longitude, category, create_place = false)
    
  end

end