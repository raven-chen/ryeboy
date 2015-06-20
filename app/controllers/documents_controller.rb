class DocumentsController < ApplicationController
  def index
    @documents = params[:category].present? ? Document.where(category: params[:category]) : Document.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])
    @comment = Comment.new(commentable: @document)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end
end
