class RepliesController < ApplicationController
  load_and_authorize_resource

  def edit
    @reply = Reply.find(params[:id])
  end

  def create
    @reply = Reply.new(params[:reply])
    @reply.author = current_user

    respond_to do |format|
      if @reply.save
        @reply.topic.touch

        format.html { redirect_to topic_path(@reply.topic), notice: I18n.t("notices.create_%{obj}_successfully", :obj => "回复") }
        format.json { render json: @reply, status: :created, location: @reply }
      else
        format.html { render action: "new" }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @reply = Reply.find(params[:id])

    respond_to do |format|
      if @reply.update_attributes(params[:reply])
        format.html { redirect_to topic_path(@reply.topic), notice: I18n.t("notices.update_%{obj}_successfully", :obj => "回复") }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @reply = current_user.replies.find(params[:id])
    @reply.destroy

    flash[:notice] = I18n.t("notices.delete_%{obj}_successfully", :obj => "回复")

    respond_to do |format|
      format.html { redirect_to topic_path(@reply.topic) }
      format.json { head :no_content }
    end
  end
end
