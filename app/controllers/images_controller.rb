class ImagesController < ApplicationController
  def create
    image = Image.create(params[:image])

    respond_to do |format|
      format.json { render json: {"imageUrl" => image.attachment.url}.to_json }
    end
  end
end
