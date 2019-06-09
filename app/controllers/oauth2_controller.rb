require 'date'
require 'time'
require 'digest/sha1'
require 'uri'
require 'cgi'

class Oauth2Controller < ApplicationController

    def authorise
        params.permit(:state)
        params.permit(:scope)
        params.permit(:response_type)
        params.permit(:client_id)
        params.permit(:redirect_uri)

        state = params[:state]
        scope = params[:scope]
        response_type = params[:response_type]
        client_id = params[:client_id]
        redirect_uri = params[:redirect_uri]
        expires = Time.now + (60 * 10)
        code = Digest::SHA1.hexdigest rand().to_s

        @Oauthcode = Oauthcode.new({
            :key => client_id,
            :code => code,
            :scope => scope,
            :redirect_uri => redirect_uri,
            :expires => expires
        })


        # If not logged in, then do a login
            #TODO




        # See if we've seen this code before, error if so
        if Oauthcode.where(code: code).exists?
            raise 'Code has already been seen'
        end

        # Save
        @Oauthcode.save

        # Forward or echo
        if redirect_uri.nil?
            # Don't redirect, just echo
            render json: @Oauthcode.to_json 
        else
            # Now we need to forward
            query = {
                :code => code,
                :scope => scope
            }
            redirect_to redirect_uri + "?" + query.to_query
        end

    end

    def access_token
    end

    def connect
    end

    def connectform
        params.permit(:scope)
        params.permit(:fwd)
        params.permit(:client_id)

        
        @scope = params[:scope]
        @fwd = params[:fwd]
        @client_id = params[:client_id]

        

        @client = Oauthapp.where(pubkey: params[:client_id]).first
       
    end
end
