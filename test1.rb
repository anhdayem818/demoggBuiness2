require "google/apis/docs_v1"
require 'google/apis/mybusinessbusinessinformation_v1'
require 'google/apis/mybusinessaccountmanagement_v1'

require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

OOB_URI = "http://localhost:3000/users/auth/google_oauth2/callback".freeze
APPLICATION_NAME = "Google Docs API Ruby Quickstart".freeze
CREDENTIALS_PATH = "./config/client_secret.json".freeze

TOKEN_PATH = "token.yaml".freeze
SCOPE = ["https://www.googleapis.com/auth/plus.business.manage", "https://www.googleapis.com/auth/business.manage"]

def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store, OOB_URI
  user_id = "default"
  credentials = authorizer.get_credentials user_id
  p credentials
  if credentials.nil?
    url = authorizer.get_authorization_url()
    puts "Open the following URL in the browser and enter the " \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code
    )
  end
  credentials
end


# Initialize the  Account API
account_service = Google::Apis::MybusinessaccountmanagementV1::MyBusinessAccountManagementService.new
account_service.client_options.application_name = APPLICATION_NAME
account_service.authorization = authorize

# create Account admin












# Initialize the  Business API
service = Google::Apis::MybusinessbusinessinformationV1::MyBusinessBusinessInformationService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

# New location Object 
location = Google::Apis::MybusinessbusinessinformationV1::Location.new.tap do |l|
  l.name = "Demo Location Webmely"
  l.store_code = "en"
  l.title = "Cong Ty Webmely"
  l.phone_numbers = Google::Apis::MybusinessbusinessinformationV1::PhoneNumbers.new(primaryPhone: "+844519098")
  l.profile = Google::Apis::MybusinessbusinessinformationV1::Profile.new(description: "This is my profiles.")
end

uuid = SecureRandom.uuid

service.create_account_location(user_id, location, uuid )
# Initialize the API
# service = Google::Apis::DocsV1::DocsService.new
# service.client_options.application_name = APPLICATION_NAME
# service.authorization = authorize

# Prints the title of the sample doc:
# https://docs.google.com/document/d/195j9eDD3ccgjQRttHhJPymLJUCOUjs-jmwTrekvdjFE/edit
# document_id = "1JNqWU9RyljWTo-Ln1zovTk9N6TGU-7wk4IMOl3b0AoQ"
# document = service.get_document document_id
# puts "The title of the document is: #{document.title}."
# [END docs_quickstart]