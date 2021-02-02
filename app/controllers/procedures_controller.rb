class ProceduresController < ApplicationController
  before_filter :admin_login_required
  
  def new
    @procedure = Procedure.new
    @procedure.company_id = @current_user.company_id
    
    @breadcrumb = Hash.new
    @breadcrumb['procedures'] = 1
    @breadcrumb['newprocedure'] = 1
  end
  
  def create
    @procedure = Procedure.new(procedure_params)
    if @procedure.save
      flash[:success] = 'Procedure created succesfully.'
      redirect_to editprocedure_path(id: @procedure.id)
    else
      flash[:danger] = view_context.get_error_string(@procedure,'Procedure creation failed.')
      render 'new'
    end
  end
  
  def list
    company_id = @current_user.company.id
    render :json=> ActiveSupport::JSON.encode(Procedure.datatable(company_id,params,view_context)) 
  end
  
  def edit
    @procedure = Procedure.where(id: params[:id]).first
    if @procedure.company.id != @current_user.company.id
      flash[:danger] = 'You cannot edit this procedure.'
      redirect_to dashboard_path and return false
    end
    
    @breadcrumb = Hash.new
    @breadcrumb['procedures'] = 1
    @breadcrumb['editprocedure_id'] = params[:id]
  end
  
  def save
    @procedure = Procedure.where(id: params[:procedure][:id]).first
    if @procedure.company.id != @current_user.company.id
      flash[:danger] = 'You cannot edit this procedure.'
      redirect_to dashboard_path and return false
    end
    
    if @procedure.update_attributes(procedure_params)
      flash[:success] = 'The procedure has been updated.'
      redirect_to editprocedure_path(id: @procedure.id)
    else
      flash[:danger] = view_context.get_error_string(@procedure,'Procedure could not be updated.')
      render 'edit'
    end
  end
  
  def arrange
    id = params[:id].to_i
    direction = params[:direction].to_i
    stage = Stage.includes(:procedure).where(:id => id).first
    if stage
      puts 'stage found'
      if stage.procedure.company.id != @current_user.company.id
        flash[:danger] = 'You cannot edit this procedure.'
        redirect_to dashboard_path and return false
      end
      stage.move(direction)
      redirect_to editprocedure_path(id: stage.procedure.id)
    else
      redirect_to dashboard_path
    end
  end
  
  def insert
    job = Job.where(token:params[:t]).first
    procedure = Procedure.where(id:params[:procedure_id].to_i).first
    if procedure.add_to_job(job)
      flash[:success] = 'Procedure added successfully.'
    else
      flash[:danger] = 'Procedure could not be added.'
    end
    redirect_to definequestions_path(id:job.id)
  end
end
