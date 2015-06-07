module LocationsHelper
  # Parse the API data to store it in an array f hashes - each bus is a has.
  def fetch_api_data source
    http = Net::HTTP.get_response(URI.parse(source))
    data = http.body
    JSON.parse(data)
end

# Compare latitude/longitude of the user and all the buses to see if they are
  # within 0.01 degree

  def is_nearby(lat_user, long_user, lat_bus, long_bus)
    (long_user - long_bus).abs <= 0.01 && (lat_user - lat_bus).abs <= 0.01
  end
end

