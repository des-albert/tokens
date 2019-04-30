class TokensController < ApplicationController
  before_action :set_token, only: [:show, :edit, :update]
  def select
    @user = session[:user]
  end
#
  def activity
    selection = params[:selection][:activity]
    @activity = Subject.find_by_activity(selection).activity
    session[:activity] = @activity
    redirect_to new_token_path
  end
#
  def new
    @activity = session[:activity]
    @user = session[:user]
    @token = Token.new
    @token.build_package
  end
#
  def create
    if (params[:commit] == "Exit")
      redirect_to tokens_path
      return
    end
    @token = Token.new(token_params)
    @token.creator = session[:user]

    if (params[:commit] == "Draft")
      @token.state = State.find_by_name('draft')
    else (params[:commit] == "Send")
    @token.state = State.find_by_name('sent')
    end

    if @token.save
      redirect_to @token, notice: 'Token was successfully created.'
    else
      render :new
    end
  end
#
  def show
    @user = session[:user]
  end

  def index
    @user = session[:user]
    user_id = session[:user_id]
    @tokens = Token.where('(recipient_id = ? or creator = ?) and state_id <> ?', user_id, @user, ARCHIVED)
  end

  def edit
    @user = session[:user]
  end
#
  def update
    if (params[:commit] == "Exit")
      redirect_to tokens_path
      return
    end

    if @token.update(token_params)
      redirect_to @token, notice: 'Token was successfully updated.'
    else
      render :edit
    end
  end
#
  def reset
    config = ActiveRecord::Base.connection.adapter_name.downcase.to_sym
    table = %w[packages tokens states recipients subjects]
    case config
    when :sqlite
      ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
      ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='#{table}'")

    when :postgresql
      table.each do |table|
        ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
        ActiveRecord::Base.connection.execute("ALTER SEQUENCE #{table}_id_seq RESTART WITH 1")
      end
    end
  end

  private

  def set_token
    @token = Token.find(params[:id])
  end

  def token_params
    params.require(:token).permit(:id, :state_id, :recipient_id,
                                  package_attributes: [:id, :subject, :request, :response])
  end
end
