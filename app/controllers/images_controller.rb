class ImagesController < ApplicationController
  def create
    image = Image.new(params[:image])

    respond_to do |format|
      format.json {
        if image.save
          render json: {"imageUrl" => image.attachment.url}.to_json
        else
          render json: {"error" => "#{image.errors} 出现错误,请确认上传的是图片且小于2MB."}.to_json, status: :unprocessable_entity
        end
      }
    end
  end
end
