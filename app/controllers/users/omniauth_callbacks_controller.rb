class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    generic_callback( 'google_oauth2' )
  end

  def generic_callback( provider )
    @identity = Identity.find_for_oauth auth

    @user = @identity.user || current_user
    if @user.nil?
      password = Devise.friendly_token[0,20]
      @user = User.create( email: @identity.email || "", password: password, password_confirmation: password )
      @identity.update_attribute( :user_id, @user.id )
    end

    if @user.email.blank? && @identity.email
      @user.update_attribute( :email, @identity.email)
    end

    if @user.persisted?
      @identity.update_attribute( :user_id, @user.id )
      # This is because we've created the user manually, and Device expects a
      
      @user = User.find @user.id
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      # session["devise.#{provider}_data"] = auth
      redirect_to new_user_registration_url
    end
  end
  

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end

end
