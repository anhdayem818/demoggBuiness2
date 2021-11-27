# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# [START docs_quickstart]
require "google/apis/docs_v1"
require "googleauth"
require "googleauth/stores/file_token_store"
require "fileutils"

OOB_URI = "http://localhost:3000/users/auth/google_oauth2/callback".freeze
APPLICATION_NAME = "Google Docs API Ruby Quickstart".freeze
CREDENTIALS_PATH = "./config/client_secret.json".freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = "token.yaml".freeze
SCOPE = ["https://www.googleapis.com/auth/plus.business.manage", "https://www.googleapis.com/auth/business.manage"]
##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file CREDENTIALS_PATH
  token_store = Google::Auth::Stores::FileTokenStore.new file: TOKEN_PATH
  authorizer = Google::Auth::UserAuthorizer.new client_id, SCOPE, token_store, OOB_URI
  user_id = "default"
  credentials = authorizer.get_credentials user_id
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

# Initialize the API
service = Google::Apis::DocsV1::DocsService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize

# Prints the title of the sample doc:
# https://docs.google.com/document/d/195j9eDD3ccgjQRttHhJPymLJUCOUjs-jmwTrekvdjFE/edit
# document_id = "1JNqWU9RyljWTo-Ln1zovTk9N6TGU-7wk4IMOl3b0AoQ"
# document = service.get_document document_id
# puts "The title of the document is: #{document.title}."
# [END docs_quickstart]