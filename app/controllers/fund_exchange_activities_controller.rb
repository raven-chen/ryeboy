class FundExchangeActivitiesController < ApplicationController
  # GET /fund_exchange_activities
  # GET /fund_exchange_activities.json
  def index
    @fund_exchange_activities = FundExchangeActivity.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fund_exchange_activities }
    end
  end

  # GET /fund_exchange_activities/1
  # GET /fund_exchange_activities/1.json
  def show
    @fund_exchange_activity = FundExchangeActivity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fund_exchange_activity }
    end
  end
end
