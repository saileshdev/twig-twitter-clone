class UsersController < ApplicationController

  def new 
    if current_user
      redirect_to buddies_path
    else 
      @user = User.new
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thank you for signing up for Ribbit!"
    else
      render 'new'
    end
  end

  def index
    @users = User.all
    @ribbit = Ribbit.new
  end

  def buddies
    if current_user
      @ribbit = Ribbit.new
      buddies_ids = current_user.followeds.map(&:id).push(current_user.id)
      @ribbits = Ribbit.find_all_by_user_id buddies_ids
    else
      redirect_to root_url
    end
  end

  def show
    @user = User.find(params[:id])
    @ribbit = Ribbit.new
    @relationship = Relationship.where(
      follower_id: current_user.id,
      followed_id: @user.id
    ).first_or_initialize if current_user
  end

  def edit
    @user = User.find(params[:id])

    redirect_to @user unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: "Profile updated!"
    else
      render 'edit'
    end
  end

end
