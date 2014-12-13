class PlacesController < ApplicationController
  before_action :set_place, only: [:show]
  before_action :set_location, only: [:index]

  def index
    
    PlaceCreatorWorker.perform_async(@result.latitude, @result.longitude)
    
    @places = Place.all.sort_by {|x| PlaceStatistic.measurements.key(x.latest_measurement)}

    respond_to do |format|
      format.html
      format.json {render json: @places}
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json {render json: @place}
    end
  end

  private
  def set_place
    @place = Place.find(params[:id])
  end

  def places_param
    params.require(:place).permit(:name, :id, :lat, :lon, :address)
  end

  def set_location
    @result = request.location
    @result = Geocoder.search("2130 Post Street Apt 503, San Francisco, CA 94102").first if @result.latitude == ""
  end

end