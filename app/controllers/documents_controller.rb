class DocumentsController < ApplicationController
  load_and_authorize_resource

  def index
    @options = process_query_params %w{name category}

    @documents = Document.scoped
    @documents = @documents.where("name LIKE ?", "%#{@options[:name]}%") if @options[:name]
    @documents = @documents.where(category: @options[:category]) if @options[:category]

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
