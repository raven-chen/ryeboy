class TopicsController < ApplicationController
  load_and_authorize_resource except: [:index, :show]
  skip_before_filter :authenticate_user!, only: [:index, :show]

  def index
    @options = process_query_params %w{title category}

    @topics = Topic.includes(:comments).all
    @topics = @topics.where(category: @options[:category]) if @options[:category]
    @topics = @topics.where("title LIKE ?", "%#{@options[:title]}%") if @options[:title]
    @topics = @topics.order("updated_at DESC")
    @topics = @topics.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @topics }
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @comments = @topic.comments.page(params[:page])
    @comment = Comment.new(commentable: @topic)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @topic }
    end
  end

  def new
    @topic = Topic.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @topic }
    end
  end

  def edit
    @topic = current_user.topics.find(params[:id])
  end

  def create
    @topic = Topic.new(params[:topic])
    @topic.author = current_user

    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: I18n.t("notices.create_%{obj}_successfully", :obj => @topic.title) }
        format.json { render json: @topic, status: :created, location: @topic }
      else
        format.html { render action: "new" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @topic = current_user.topics.find(params[:id])

    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        format.html { redirect_to @topic, notice: I18n.t("notices.update_%{obj}_successfully", :obj => @topic.title) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @topic = current_user.topics.find(params[:id])
    @topic.destroy

    flash[:notice] = I18n.t("notices.delete_%{obj}_successfully", :obj => @topic.title)

    respond_to do |format|
      format.html { redirect_to topics_url }
      format.json { head :no_content }
    end
  end
end
