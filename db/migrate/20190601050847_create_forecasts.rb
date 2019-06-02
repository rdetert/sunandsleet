class CreateForecasts < ActiveRecord::Migration[5.2]
  def change
    create_table :forecasts do |t|
      t.references :location

    	t.datetime :date
    	t.string   :search

    	t.float :current_temp
    	t.float :high_temp
    	t.float :low_temp

      t.string :icon

      t.timestamps
    end
  end
end
