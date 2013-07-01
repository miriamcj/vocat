class RegistrationsController < Devise::RegistrationsController



  def create
    super
    @user.organization = Organization.find(params[:organization][:id])
    @user.role = params[:resource][:role]
    @user.save
  end
end