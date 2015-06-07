class Location < ActiveRecord::Base
  geocoded_by :mylocation
  after_validation :geocoded        # auto-getch coordinates

  def my_location
    "#{address}, #{city}, GA"
  end
end
