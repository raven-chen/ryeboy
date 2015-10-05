class DocumentsController < ApplicationController
  skip_before_filter :authenticate_user!

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

  def show
    @document = Document.find(params[:id])
    @comment = Comment.new(commentable: @document)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end
end
