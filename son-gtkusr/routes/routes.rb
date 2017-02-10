##
## Copyright (c) 2015 SONATA-NFV
## ALL RIGHTS RESERVED.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## Neither the name of the SONATA-NFV
## nor the names of its contributors may be used to endorse or promote
## products derived from this software without specific prior written
## permission.
##
## This work has been performed in the framework of the SONATA project,
## funded by the European Commission under Grant number 671517 through
## the Horizon 2020 and 5G-PPP programmes. The authors would like to
## acknowledge the contributions of their colleagues of the SONATA
## partner consortium (www.sonata-nfv.eu).

require 'json'
require 'sinatra'
require_relative '../helpers/init'


# Adapter class
class Adapter < Sinatra::Application

  # @method get_root
  # @overload get '/'
  # Get all available interfaces
  # -> Get all interfaces
  get '/' do
    headers 'Content-Type' => 'text/plain; charset=utf8'
    halt 200, interfaces_list.to_json
  end

  # @method get_log
  # @overload get '/adapter/log'
  # Returns contents of log file
  # Management method to get log file of adapter remotely
  get '/log' do
    headers 'Content-Type' => 'text/plain; charset=utf8'
    # filename = 'log/development.log'
    filename = 'log/production.log'

    # For testing purposes only
    begin
      txt = open(filename)

    rescue => err
      logger.error "Error reading log file: #{err}"
      return 500, "Error reading log file: #{err}"
    end

    halt 200, txt.read.to_s
  end
end

# Keycloak class
class Keycloak < Sinatra::Application
  post '/register' do
    registration
  end

  post '/login' do
    username = params[:username]
    password = params[:password]

    credentials = {"type" => "password", "value" => password.to_s}
    login(username, credentials)
  end

  post '/auth' do
    # TODO: implement authentication API
  end

  post '/authorize' do
    authorize
  end

  post '/userinfo' do
    # TODO: implement userinfo API
  end

  post '/logout' do
    logout
  end
end
=begin
class SecuredAPI < Sinatra::Application
  # This is a sample of a secured API

  get '/services' do
    # content_type :json
    # {message: "Hello, User!"}.to_json

    # scopes, user = request.env.values_at :scopes, :user
    # username = user['username'].to_sym

    # if scopes.include?('view_services') && @accounts.has_key?(username)
    # content_type :json
    # { services: @accounts[username]}.to_json
    # else
    # halt 403

    process_request request, 'view_services' do |req, username|
      content_type :json
      {services: @accounts[username]}.to_json
    end
  end

  post '/services' do
    # code
    scopes, user = request.env.values_at :scopes, :user
    username = user['username'].to_sym

    if scopes.include?('add_services') && @accounts.has_key?(username)
      service = request[:service]
      @accounts[username] << {'Service' => service}

      content_type :json
      {services: @accounts[username]}.to_json
    else
      halt 403
    end
  end

  delete '/services' do
    # code
    scopes, user = request.env.values_at :scopes, :user
    username = user['username'].to_sym

    if scopes.include?('remove_services') && @accounts.has_key?(username)
      service = request[:service]

      @accounts[username].delete_if { |h| h['Service'] == service }

      content_type :json
      {services: @accounts[username]}.to_json
    else
      halt 403
    end
  end
end
=end
