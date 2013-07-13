class FinesController < ApplicationController
  # GET /fines
  # GET /fines.json
  def index
    @fines = Fine.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fines }
    end
  end

  # GET /fines/1
  # GET /fines/1.json
  def show
    @fine = Fine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fine }
    end
  end
end
