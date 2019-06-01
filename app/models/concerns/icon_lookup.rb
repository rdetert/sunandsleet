module IconLookup
  extend ActiveSupport::Concern

  included do

    def icon_image
      icon_map = {
        "clear-day": "Sun.svg",
        "clear-night": "Moon.svg",
        "rain": "Cloud-Rain.svg",
        "snow": "Snowflake.svg",
        "sleet": "Cloud-Snow.svg",
        "wind": "Wind.svg",
        "fog": "Cloud-Fog-Alt.svg",
        "cloudy": "Cloud.svg",
        "partly-cloudy-day": "Cloud-Sun.svg",
        "partly-cloudy-night": "Cloud-Moon.svg"
      }
      file = icon_map[icon.to_sym]
      "/climacons-master/SVG/#{file}" unless file.blank?
    end
  end

end
