class HomepageItemsController < ApplicationController
  load_and_authorize_resource

  def index
    @options = process_query_params %w{name category}

    @items = HomepageItem.all
    @items = @items.where(category: @options[:category]) if @options[:category]
    @items = @items.where("name LIKE ?", "%#{@options[:name]}%") if @options[:name]
    @items = @items.order("sequence ASC")
    @items = @items.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @items }
    end
  end

  def new
    @item = HomepageItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @item }
    end
  end

  def create
    @item = HomepageItem.new(params[:homepage_item])

    respond_to do |format|
      if @item.save
        format.html { redirect_to homepage_items_path, notice: I18n.t("notices.create_%{obj}_successfully", :obj => @item.name) }
        format.json { render json: @item, status: :created, location: @item }
      else
        format.html { render action: "new" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def update
    @item = current_user.items.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:homepage_item])
        format.html { redirect_to homepage_items_path, notice: I18n.t("notices.update_%{obj}_successfully", :obj => @item.name) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @item = current_user.items.find(params[:id])
    @item.destroy

    flash[:notice] = I18n.t("notices.delete_%{obj}_successfully", :obj => @item.name)

    respond_to do |format|
      format.html { redirect_to homepage_items_path }
      format.json { head :no_content }
    end
  end
end
