class Admin::UsersController < ApplicationController

	load_and_authorize_resource :user

	def index
		@users = User.all()
		respond_to do |format|
			format.html
		end
	end

	def show
		respond_to do |format|
			format.html # show.html.erb
		end
	end

	def new
		respond_to do |format|
			format.html # new.html.erb
		end
	end

	def edit
		@user = User.find(params[:id])
	end

	def create
		respond_to do |format|
			if @user.save
				format.html { redirect_to admin_user_path(@user), notice: 'User was successfully created.' }
			else
				format.html { render action: "new" }
			end
		end
	end

	def update
		respond_to do |format|

		end
	end

	def destroy
		flash[:notice] = "#{@user.name} has been deleted."
		@user.destroy

		respond_to do |format|
			format.html { redirect_to admin_users_path }
		end
	end

end
