module IconLookup
  extend ActiveSupport::Concern

  included do

    def icon_image
      icon_map = {
        "clear-day": "Sun.png",
        "clear-night": "Moon.png",
        "rain": "Cloud-Rain.png",
        "snow": "Snowflake.png",
        "sleet": "Cloud-Snow.png",
        "wind": "Wind.png",
        "fog": "Cloud-Fog-Alt.png",
        "cloudy": "Cloud.png",
        "partly-cloudy-day": "Cloud-Sun.png",
        "partly-cloudy-night": "Cloud-Moon.png"
      }
      icon_map[icon.to_sym]
    end
  end

end
