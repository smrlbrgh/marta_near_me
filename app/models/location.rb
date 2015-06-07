class Location < ActiveRecord::Base
  geocoded_by :my_location     # can also be an IP address
  after_validation :geocode        # auto-getch coordinates

  CITIES = ["Atlanta", "Alpharetta", "Avondale Estates", "Chamblee", "Clarkston",
    "College Park", "Decatur", "Doraville", "Dunwoody", "East Point",
    "Fairburn", "Forest Park", "Hapeville", "Lithonia", "Morrow", "Palmetto",
    "Riverdale", "Rosewell", "Sandy Springs", "Stone Mountain", "Union City"]


  def my_location
    "#{address}, #{city}, GA"
  end
end
