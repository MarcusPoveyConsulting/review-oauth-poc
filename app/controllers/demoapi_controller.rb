class DemoapiController < ApplicationController

    # Demo example
    def user


        params.permit(:access_token);


        # Validate auth token
        tokens = Oauthtoken.where(access_token: params[:access_token]).first
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

            render json: userdetails.to_json
        end
        

    end

end
