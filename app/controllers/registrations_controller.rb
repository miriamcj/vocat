class RegistrationsController < Devise::RegistrationsController

  respond_to :json, :html

  def create
    super
    @user.organization = Organization.find(params[:organization][:id])
    @user.role = params[:resource][:role]
    @user.save
  end

  def update_settings
    # From corresponding devise controller method
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    settings = resource_params[:settings]
    resource.update_settings(settings)
    result = resource.save
    if result
      respond_with resource, :location => after_update_path_for(resource)
    end
  end

end
