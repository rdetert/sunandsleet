class Forecast < ApplicationRecord
	include IconLookup

	attr_accessor :api_data

	belongs_to :location
	has_many :extended_forecasts, dependent: :destroy

	after_initialize :set_location, if: :new_record?
	before_save :process_weather_data

	validates :search, presence: true


	def to_param
		location.zipcode
	end

	def self.api_lookup(location)
		lat, lon = location.coords
		ForecastIO.forecast(lat, lon)
	end
	def api_lookup
		self.api_data = Forecast.api_lookup(location)
	end


	def self.set_location(search)
		Location.string_lookup(search)
	end
	def set_location
		self.location = Forecast.set_location(search)
	end

	def already_exists?
		load_existing.present?
	end

	def load_existing
		Location.find(location.id).forecast if location.present?
	end

	protected

		def process_weather_data
			api_lookup

			# delete the old forecast and reload new one
			Location.find(location.id).forecast.try(:destroy)

			currently = api_data.currently
			self.date = Time.at(currently.time)
			self.current_temp = currently.temperature

			daily = api_data.daily.data

			daily.each do |day|
				time = Time.at(day.time)
				if time.to_date == Time.now.to_date
					self.high_temp = day.temperatureHigh
					self.low_temp  = day.temperatureLow
					self.icon 		 = day.icon
				else
					ef = ExtendedForecast.new date: time, icon: day.icon, high_temp: day.temperatureHigh, low_temp: day.temperatureLow
					self.extended_forecasts << ef
				end
			end
		end

end
