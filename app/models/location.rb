class Location < ApplicationRecord

  has_one :forecast, dependent: :destroy


  def has_dst?; daylight_savings; end

  def self.parse_city(city)
  	return nil if city.blank?
    city = city.strip
    city = city.squeeze(" ")
    city = city.gsub(/-/, " ")
    city = city.gsub(/\./, "")
    city = city.sub(/^st\s(.+)/i, 'Saint \1')    # convert St to Saint
    city = city.sub(/^ste\s(.+)/i, 'Sainte \1')  # convert Ste to Sainte
    city = city.sub(/^mt\s(.+)/i, 'Mount \1')    # convert Mt to Mount
    city = city.sub(/^ft\s(.+)/i, 'Fort \1')     # convert Ft to Fort
    city
  end

  def self.parse_zipcode(zipcode)
  	return nil if zipcode.blank?
    zipcode.strip.gsub /[^0-9]/, ''
  end

  def self.string_lookup(location_string)
  	return nil if location_string.blank?
    zipcode = location_string.tr('^[0-9]', '')
    city, state = location_string.tr('[0-9]', '').split(',')
    lookup(city, state, zipcode)
  end

  def self.lookup(city, state, zipcode)
  	zipcode = Location.parse_zipcode(zipcode)
    location = Location.where(:zipcode => zipcode).first
    if location.blank?
	  	city = Location.parse_city(city).try(:upcase)
	  	state = state.upcase.strip unless state.blank?
      location = Location.where("UPPER(city) = ? AND state = ?", city, state).first
    end
    location
  end


  def coords
  	[latitude, longitude]
  end

  def to_s
    "#{city}, #{state}"
  end


  # for testing
  def self.sac
    where(city: 'Sacramento', state: 'CA').first
  end

  def self.ny
    where(city: 'New York', state: 'NY').first
  end

end
