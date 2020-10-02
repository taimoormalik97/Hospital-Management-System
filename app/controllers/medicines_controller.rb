class MedicinesController < ApplicationController
  
  include ActionController::MimeResponds
  load_and_authorize_resource find_by: :sequence_num, through: :current_hospital
  
  before_action :index_page_breadcrumb, only: [:index, :new, :show, :edit]
  before_action :show_page_breadcrumb, only: [:show]

  def index
    @medicines = @medicines.paginate(page: params[:page], per_page: PAGINATION_SIZE )
    respond_to do |format|
      format.html
    end
  end

  def new
    add_breadcrumb t('medicine.breadcrumb.new'), new_medicine_path
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end
  
  def search_pred
    @medicines = current_hospital.medicines.search(params[:q])
    respond_to do |format| 
      format.json { render json: @medicines }
    end
  end

  def create
    if @medicine.save 
      flash[:notice] = t('medicine.add.success')
      redirect_to medicine_path(@medicine)
    else   
      flash[:error] = [t('medicine.add.failure')] 
      if @medicine.errors.full_messages.present?
        flash[:error] += @medicine.errors.full_messages
      end
      redirect_to(request.env['HTTP_REFERER'])    
    end   
  end

  def edit
    add_breadcrumb t('medicine.breadcrumb.edit'), edit_medicine_path
    respond_to do |format|
      format.html
    end
  end

  def update  
    if @medicine.update_attributes(medicine_params)   
      flash[:notice] = t('medicine.update.success')   
      redirect_to @medicine
    else   
      flash[:error] = [t('medicine.update.failure')]
      if @medicine.errors.full_messages.present?
        flash[:error] += @medicine.errors.full_messages
      end
      redirect_to(request.env['HTTP_REFERER'])        
    end   
  end

  def destroy
    if @medicine.destroy   
      flash[:notice] = t('medicine.delete.success')     
      redirect_to medicines_path   
    else   
      flash[:error] = [t('medicine.delete.failure')]
      if @medicine.errors.full_messages.present?
        flash[:error] += @medicine.errors.full_messages
      end
      redirect_to(request.env['HTTP_REFERER'])  
    end   
  end

  def medicine_params 
    params.require(:medicine).permit(:name, :price, :quantity, :search)   
  end 

  def root_page_breadcrumb
    add_breadcrumb current_hospital.name, hospital_index_path
  end

  def index_page_breadcrumb
    add_breadcrumb t('medicine.breadcrumb.index'), medicines_path
  end

  def show_page_breadcrumb
    add_breadcrumb t('medicine.breadcrumb.show'), medicine_path
  end
 

end
