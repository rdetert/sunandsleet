class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:show]

  def show
  end

  def create
    # @location = Forecast.get_location(params[:search])

    @forecast = Forecast.new(forecast_params)


    respond_to do |format|
      if @forecast.save
        format.html { redirect_to @forecast, notice: 'Forecast was successfully created.' }
      else
        format.html { render 'main#index' }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_forecast
      @forecast = Forecast.find(params[:zipcode])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forecast_params
      params.fetch(:forecast, {}).permit(:search)
    end
end
