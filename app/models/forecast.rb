class Forecast < ApplicationRecord
	include IconLookup

	attr_accessor :api_data

	belongs_to :location
	has_many :extended_forecasts, dependent: :destroy

	before_save :process_weather_data

	validates :search, presence: true


	def to_param
		location.zipcode
	end

	def self.process(search)
		location = get_location(search)
		Forecast.new location: location, search: search
	end

	def self.api_lookup(location)
		lat, lon = location.coords
		ForecastIO.forecast(lat, lon)
	end
	def api_lookup
		self.api_data = Forecast.api_lookup(location)
	end


	def self.get_location(search)
		Location.string_lookup(search)
	end
	def get_location
		self.location = Forecast.get_location(search)
	end



	protected

		def process_weather_data
			api_lookup

			location.forecasts.destroy_all

			currently = api_data.currently
			self.date = Time.at(currently.time)
			self.current_temp = currently.temperature

			daily = api_data.daily.data

			daily.each do |day|
				time = Time.at(day.time)
				if time.to_date == Date.today
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
