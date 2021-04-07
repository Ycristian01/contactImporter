class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end
 
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to @user
      flash[:notice] = "User was successfully created"      
    else
      render 'new'     
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user
      flash[:notice] = "User was successfully updated." 
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url
    flash[:notice] = "User was successfully destroyed." 
  end

end

private

    def set_user
      @user = User.find_by(username: params[:email])
    end

    def user_params
      params.require(:user).permit(:email)
    end
