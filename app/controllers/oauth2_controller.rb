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



        # If not logged in, then do a login
            #TODO
            user_id = 1


        @Oauthcode = Oauthcode.new({
            :key => client_id,
            :code => code,
            :scope => scope,
            :user_id => user_id,
            :redirect_uri => redirect_uri,
            :expires => expires
        })




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
                :scope => scope,
                :state => state
            }
            redirect_to redirect_uri + "?" + query.to_query
        end

    end

    def access_token
        params.permit(:state)
        params.permit(:scope)
        params.permit(:response_type)
        params.permit(:client_id)
        params.permit(:redirect_uri)
        params.permit(:grant_type)
        params.permit(:refresh_token);

        state = params[:state]
        scope = params[:scope]
        response_type = params[:response_type]
        client_id = params[:client_id]
        redirect_uri = params[:redirect_uri]
        grant_type = params[:grant_type]
        refresh_token = params[:refresh_token]

        case grant_type
        when 'refresh_token'

            token = Oauthtoken.where(refresh_token: params[:refresh_token]).first
            if !token?
                raise "Token invalid"
            end

            if token.state != state
                raise "Invalid state given"
            end

            access_token = Digest::SHA1.hexdigest rand().to_s
            refresh_token = Digest::SHA1.hexdigest rand().to_s

            newtoken = Oauthtoken.new({
                :key => client_id,
                :access_token => access_token,
                :refresh_token => refresh_token,
                :scope => scope,
                :state => state,
                :token_type => 'grant',
                :user_id => token.user_id,
                :expires =>  Time.now + 2419200
            })

            newtoken.save

            render json: newtoken.to_json

        when 'authorization_code'

            code = Oauthcode.where(code: code, key: client_id)

            if code.state?
                if code.state != state
                    raise "Invalid state given"
                end
            end

            if code.redirect_uri?
                if code.redirect_uri != redirect_uri
                    raise "Sorry redirect url is not the same as the one given!"
                end
            end

            access_token = Digest::SHA1.hexdigest rand().to_s
            refresh_token = Digest::SHA1.hexdigest rand().to_s

            newtoken = Oauthtoken.new({
                :key => client_id,
                :access_token => access_token,
                :refresh_token => refresh_token,
                :scope => scope,
                :state => state,
                :token_type => 'grant',
                :user_id => code.user_id,
                :expires =>  Time.now + 2419200
            })
            # TODO Bind USER

            newtoken.save

            render json: newtoken.to_json

        else
            raise 'Unrecognised grant type'
        end
    end

    def connect
        # POST on connect

        # TODO: Ensure user logged in


        # Allow certain parameters
        params.permit(:fwd)
        params.permit(:client_id)



        # TODO: Save client and scope to user


        # Forward
        redirect_to params['fwd']

    end

    def connectform
        # Get form

        params.permit(:scope)
        params.permit(:fwd)
        params.permit(:client_id)

        
        @scope = params[:scope]
        @fwd = params[:fwd]
        @client_id = params[:client_id]

        

        @client = Oauthapp.where(pubkey: params[:client_id]).first
       
    end
end
# TODO do authentication - get token, check it's valid (not expired, invalid key), extract owner