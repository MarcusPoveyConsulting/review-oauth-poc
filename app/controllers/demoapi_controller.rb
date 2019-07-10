class DemoapiController < ApplicationController

    def bearer_token
        pattern = /^Bearer /
        header  = request.headers['Authorization']
        header.gsub(pattern, '') if header && header.match(pattern)
    end

    # Demo example
    def user


        params.permit(:access_token);
        access_token = params[:access_token]
        if access_token.nil?
            access_token = bearer_token
        end

        # Validate auth token
        tokens = Oauthtoken.where(access_token: access_token)
        if !tokens.exists?
            raise "Token invalid"
        end

        token = tokens.take

        # Todo validate expiry

        # If ok, then return demo user
        user = token.user_id

        if user == 1
            userdetails = {
                :user_id => 1,
                :username => 'demouser',
                :name => 'Demo User'
            } 

            puts userdetails
            render json: userdetails.to_json
        end
        

    end

end
