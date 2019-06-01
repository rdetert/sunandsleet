class ExtendedForecast < ApplicationRecord
	include IconLookup

	belongs_to :forecast

	default_scope { order(date: :asc) }

end
