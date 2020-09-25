class UsersController < ApplicationController

    skip_before_action :authorized, only: [:create, :login]

    def index 
        @users = User.all 
        render json: @users
    end

    def profile 
        render json: @user
    end

    def profile_by_username 
        @user = User.find_by(username: params[:username])
        render json: @user
    end

    def create 
        @user = User.create(
            username: params[:username],
            password: params[:password]
        )

        render json: @user
    end

    def login  
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            @token = JWT.encode({user_id: @user.id}, Rails.application.secrets.secret_key_base[0])
            render json: {user: @user, token: @token}
        else
            render json: {message: "Invalid credentials!"}
        end
    end
end
