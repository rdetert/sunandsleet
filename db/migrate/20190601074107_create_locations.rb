class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
    	t.string :city
    	t.string :state
    	t.string :zipcode
    	t.string :timezone
    	t.string :canonical_timezone
    	t.string :daylight_savings
    	
    	t.float :longitude, index: true
    	t.float :latitude, index: true
    end
  end
end
