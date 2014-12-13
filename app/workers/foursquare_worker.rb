class FoursquareWorker
  include Sidekiq::Worker

  def perform(latitude, longitude)
    puts "Doing it #{latitude}, #{longitude}"
  end

end