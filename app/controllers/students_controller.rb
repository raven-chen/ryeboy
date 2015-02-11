class StudentsController < ApplicationController
  def index
    @options = {}
    @options = %w{name}.inject({}.with_indifferent_access) { |m, key|
      params.delete(key) if params[key].blank? # Strip out blank string

      m[key] = params[key]

      m
    }

    if @options[:name]
      @students = Student.where("name LIKE ?", "%#{@options[:name]}%")
    else
      @students = Student.limit(30)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @students }
    end
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(params[:student])

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Fine was successfully created.' }
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @student = Student.find(params[:id])

    respond_to do |format|
      if @student.update_attributes(params[:student])
        format.html { redirect_to students_path, notice: '学员已更新' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def edit
    @student = Student.find(params[:id])
  end

  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student }
    end
  end
end
