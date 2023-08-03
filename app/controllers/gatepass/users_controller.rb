#
#
# Refactor the code to make it less repetitive
#

module Gatepass
  class UsersController < ApplicationController
    before_action :set_user, only: %i[ show edit update destroy ]

    # GET /users
    def index
      @users = User.all

      @current_user = session[:user]
      if @current_user['rolename'] != 'admin'
        @users = @users.where(:id => @current_user[:id])
      end
    end

    # GET /users/1
    def show

      @current_user = session[:user]
      if @current_user['rolename'] != 'admin' and @user[:id] != @current_user[:id]
        redirect_to  users_url, notice: "You must be an admin to view users"
      end
    end

    # GET /users/new
    def new
      @user = User.new

      @current_user = session[:user]
      if @current_user['rolename'] != 'admin'
        redirect_to  users_url, notice: "You must be an admin to create a new user"
      end
    end

    # GET /users/1/edit
    def edit

      @current_user = session[:user]
      if @current_user['rolename'] != 'admin'
        redirect_to  users_url, notice: "You must be an admin to edit a user"
      end
    end

    # POST /users
    def create
      @user = User.new(user_params)

      @current_user = session[:user]
      if @current_user['rolename'] != 'admin'
        redirect_to  users_url, notice: "You must be an admin to create a new user"
      end

      if @user.save
        redirect_to @user, notice: "User was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /users/1
    def update

      @current_user = session[:user]
      if @current_user['rolename'] != 'admin'
        redirect_to  users_url, notice: "You must be an admin to update a new user"
      end

      if @user.update(user_params)
        redirect_to @user, notice: "User was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy

      @current_user = session[:user]
      if @current_user['rolename'] != 'admin'
        redirect_to  users_url, notice: "You must be an admin to delete a new user"
      end

      @user.destroy
      redirect_to users_url, notice: "User was successfully destroyed.", status: :see_other
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def user_params
        params.require(:user).permit(:username, :auth_type, :password_digest, :rolename, :username_mapping)
      end
  end
end
