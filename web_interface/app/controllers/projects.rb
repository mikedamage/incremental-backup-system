class Projects < Application
  # provides :xml, :yaml, :js

  def index
    @projects = Project.find(:all)
    display @projects
  end

  def show
    @project = Project.find_by_id(params[:id])
    raise NotFound unless @project
    display @project
  end

  def new
    only_provides :html
    @project = Project.new(params[:project])
    render
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      redirect url(:project, @project)
    else
      render :new
    end
  end

  def edit
    only_provides :html
    @project = Project.find_by_id(params[:id])
    raise NotFound unless @project
    render
  end

  def update
    @project = Project.find_by_id(params[:id])
    raise NotFound unless @project
    if @project.update_attributes(params[:project])
      redirect url(:project, @project)
    else
      raise BadRequest
    end
  end

  def destroy
    @project = Project.find_by_id(params[:id])
    raise NotFound unless @project
    if @project.destroy
      redirect url(:projects)
    else
      raise BadRequest
    end
  end

end
