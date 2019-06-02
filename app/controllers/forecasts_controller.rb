class ForecastsController < ApplicationController
  before_action :set_forecast, only: [:show]

  def show
    @cached = fragment_exist?(@forecast.cache_key_with_version)
  end

  def create
    @forecast = Forecast.new(forecast_params)

    respond_to do |format|
      if load_or_create_forecast
        format.html { redirect_to @forecast }
      else
        format.html { redirect_to rocklin_path, alert: "Couldn't find #{@forecast.search}. Make sure to include the state if entering a city." }
      end
    end
  end


  private

    def load_or_create_forecast
      # debugger
      if @forecast.already_exists?
        @forecast = @forecast.load_existing
        if fragment_exist?(@forecast.cache_key_with_version)
          @success = true
        else
          @forecast.touch
          @success = @forecast.save
        end
      else
        @success = @forecast.save
      end
      @success
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_forecast
      @forecast = Location.where(zipcode: params[:zipcode]).first.try(:forecast)
      if @forecast.blank?
        @forecast = Forecast.new(search: params[:zipcode])
      end
      load_or_create_forecast
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def forecast_params
      params.fetch(:forecast, {}).permit(:search)
    end
end
