class SubjectsController < ApplicationController
  before_action :set_subject, only: [:show, :edit, :update, :destroy]
  def index
    @user = session[:user]
    @subjects = Subject.order('name ASC').all
  end
#
  def show
    @user = session[:user]
  end
#
  def new
    @user = session[:user]
    @subject = Subject.new
  end
#
  def create
    if (params[:commit] == "Exit")
      redirect_to subjects_path
      return
    end
    @subject = Subject.new(subject_params)
    if @subject.save
      redirect_to @subject, notice: 'Subject was successfully created.'
    else
      render :new
    end
  end
#
  def edit
    @user = session[:user]
  end

  def update
    if (params[:commit] == "Exit")
      redirect_to subjects_path
      return
    end

    if @subject.update(subject_params)
      redirect_to @subject, notice: 'Subject was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @subject.destroy
      redirect_to subjects_path, notice: 'Subject was successfully destroyed.'
    else
      render :edit
    end
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end

  def subject_params
    params.require(:subject).permit(:id, :name, :activity, :_destroy)
  end
end
