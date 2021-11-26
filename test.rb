require 'googleauth'
require 'googleauth/stores/file_token_store'

scopes =  ['https://www.googleapis.com/auth/business.manage',
           'https://www.googleapis.com/auth/plus.business.manage']

OOB_URI = 'http://localhost:3000/users/auth/google_oauth2/callback'
client_id = Google::Auth::ClientId.from_file('./config/client_secret.json')

token_store = Google::Auth::Stores::FileTokenStore.new(:file => './tokens.yaml')
authorizer = Google::Auth::UserAuthorizer.new(client_id, scopes, token_store)
credentials = authorizer.get_credentials(user_id)
if credentials.nil?
  url = authorizer.get_authorization_url(base_url: OOB_URI )
  puts "Open #{url} in your browser and enter the resulting code:"
  code = gets
  credentials = authorizer.get_and_store_credentials_from_code(
    user_id: user_id, code: code, base_url: OOB_URI)
end