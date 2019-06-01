class CreateExtendedForecasts < ActiveRecord::Migration[5.2]
  def change
    create_table :extended_forecasts do |t|
    	t.references :forecast

      t.datetime :date
      t.string :icon
      
    	t.float :high_temp
    	t.float :low_temp

      t.timestamps
    end
  end
end
