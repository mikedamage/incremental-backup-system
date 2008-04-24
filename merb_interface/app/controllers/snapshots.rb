class Snapshots < Application
  # provides :xml, :yaml, :js

  def index
    @snapshots = Snapshot.find(:all)
    display @snapshots
  end

  def show
    @snapshot = Snapshot.find_by_id(params[:id])
    raise NotFound unless @snapshot
    display @snapshot
  end

  def new
    only_provides :html
    @snapshot = Snapshot.new(params[:snapshot])
    render
  end

  def create
    @snapshot = Snapshot.new(params[:snapshot])
    if @snapshot.save
      redirect url(:snapshot, @snapshot)
    else
      render :new
    end
  end

  def edit
    only_provides :html
    @snapshot = Snapshot.find_by_id(params[:id])
    raise NotFound unless @snapshot
    render
  end

  def update
    @snapshot = Snapshot.find_by_id(params[:id])
    raise NotFound unless @snapshot
    if @snapshot.update_attributes(params[:snapshot])
      redirect url(:snapshot, @snapshot)
    else
      raise BadRequest
    end
  end

  def destroy
    @snapshot = Snapshot.find_by_id(params[:id])
    raise NotFound unless @snapshot
    if @snapshot.destroy
      redirect url(:snapshots)
    else
      raise BadRequest
    end
  end

end
