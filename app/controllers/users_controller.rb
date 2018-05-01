class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :correct_user, only: %i(edit update)
  before_action :verify_admin?, only: :destroy
  before_action :load_user, only: %i(show edit update destroy)

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "static_pages.home.h1"
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page]).order(:created_at)
  end

  def index
    @users = User.paginate(page: params[:page]).order(:created_at)
  end

  def new
    @user = User.new
  end

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = t ".prupdate"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user && @user.destroy
      flash[:success] = t ".userdel"
      redirect_to users_url
    else
      flash[:failed] = t ".failed"
      redirect_to :help
    end
  end

  private

    def logged_in_user
      return if logged_in?
      store_location
      flash[:danger] = t ".plslogin"
      redirect_to login_url
    end

    def verify_admin?
      redirect_to root_url unless current_user.admin?
    end

    def load_user
      @user = User.find_by id: params[:id]
      return if @user
      flash[:danger] = t "static_pages.help.usernotfound"
      redirect_to :help
    end

    def user_params
      params.require(:user).permit :name, :email, :password,
        :password_confirmation
    end
end
