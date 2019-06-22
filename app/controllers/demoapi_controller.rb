class DemoapiController < ApplicationController

    # Demo example
    def user


        params.permit(:access_token);
        access_token = params[:access_token]

        
        # Validate auth token


        # If ok, then return demo user

    end

end
