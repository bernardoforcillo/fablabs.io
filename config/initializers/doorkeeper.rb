Doorkeeper.configure do
  # Change the ORM that doorkeeper will use.
  # Currently supported options are :active_record, :mongoid2, :mongoid3, :mongo_mapper
  orm :active_record



  base_controller 'ApplicationController'


  # This block will be called to check whether the resource owner is authenticated or not.
  resource_owner_authenticator do
    # raise "Please configure doorkeeper resource_owner_authenticator block located in #{__FILE__}"
    # Put your resource owner authentication logic here.
    # Example implementation:
    User.find_by_id(session[:user_id]) || redirect_to(signin_url(goto: request.fullpath))
  end

  # If you didn't skip applications controller from Doorkeeper routes in your application routes.rb
  # file then you need to declare this block in order to restrict access to the web interface for
  # adding oauth authorized applications. In other case it will return 403 Forbidden response
  # every time somebody will try to access the admin web interface.
  #
  admin_authenticator do
    if current_user
      head :forbidden unless current_user.passed_spam_period?
    else
      redirect_to signin_url goto: request.fullpath 
    end
  end

  # Authorization Code expiration time (default 10 minutes).
  authorization_code_expires_in 10.minutes

  # Access token expiration time (default 2 hours).
  # If you want to disable expiration, set this to nil.
  access_token_expires_in #2.hours

  reuse_access_token

  # Issue access tokens with refresh token (disabled by default)
  # use_refresh_token

  # Provide support for an owner to be assigned to each registered application (disabled by default)
  # Optional parameter :confirmation => true (default false) if you want to enforce ownership of
  # a registered application
  # Note: you must also run the rails g doorkeeper:application_owner generator to provide the necessary support
  enable_application_owner :confirmation => true

  # Define access token scopes for your provider
  # For more information go to https://github.com/applicake/doorkeeper/wiki/Using-Scopes
  default_scopes  :public
  # optional_scopes :write, :update

  # Change the way client credentials are retrieved from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:client_id` and `:client_secret` params from the `params` object.
  # Check out the wiki for more information on customization
  # client_credentials :from_basic, :from_params

  # Change the way access token is authenticated from the request object.
  # By default it retrieves first from the `HTTP_AUTHORIZATION` header, then
  # falls back to the `:access_token` or `:bearer_token` params from the `params` object.
  # Check out the wiki for more information on customization
  # access_token_methods :from_bearer_authorization, :from_access_token_param, :from_bearer_param

  # # Change the test redirect uri for client apps
  # # When clients register with the following redirect uri, they won't be redirected to any server and the authorization code will be displayed within the provider
  # # The value can be any string. Use nil to disable this feature. When disabled, clients must provide a valid URL
  # # (Similar behaviour: https://developers.google.com/accounts/docs/OAuth2InstalledApp#choosingredirecturi)
  # #
  #test_redirect_uri nil#'urn:ietf:wg:oauth:2.0:oob'

  force_ssl_in_redirect_uri false


  # # Under some circumstances you might want to have applications auto-approved,
  # # so that the user skips the authorization step.
  # # For example if dealing with trusted a application.
  skip_authorization do |resource_owner, client|
    false
    # client.superapp? or resource_owner.admin?
  end
end
