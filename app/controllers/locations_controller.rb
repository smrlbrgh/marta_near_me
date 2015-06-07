class LocationsController < ApplicationController
  include LocationsHelper # use name of module from that file
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.all
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    # MARTA API URL
    source = 'http://developer.itsmarta.com/BRDRestService/BRDRestService.svc/GetAllBus'

    #Use a helper method to parse the data into an array of hashes for all
    #buses in system
    @buses = fetch_api_data(source)

    # Loop through all buses in system to find those that are close by and put
    # them in the nearby buses array.
    @nearby_buses = []
    # Check that geocoder found a valid address (this coordinate is default center of Atlanta)
    # TODO: check against array of geocodes for all cities when fake address entered.
    if @location.latitude == 33.7489954 && @location.longitude == -84.3879824
        @oops = true
    else
    # Loop through all buses to find those that are nearby
      @buses.each do |bus|
        if is_nearby(@location.latitude, @location.longitude,
          bus['LATITUDE'].to_f, bus['LONGITUDE'].to_f)
           @nearby_buses.push(bus)
        end
      end
    end

    @bus_count = @nearby_buses.length
    # TODO: if no buses, return with notice and redirect to new
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:address, :city, :latitude, :longitude)
    end
end
