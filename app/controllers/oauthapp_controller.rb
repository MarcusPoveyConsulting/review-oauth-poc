require 'digest/sha1'

class OauthappController < ApplicationController
    def new
    end

    def create
        # Generate key
        params[:oauthapp][:userid] = 1 # Userid: TODO Get this from session
        params[:oauthapp][:pubkey] = Digest::SHA1.hexdigest rand().to_s
        params[:oauthapp][:secret] = Digest::SHA1.hexdigest rand().to_s
        
        # TODO: Check we've not duplicated key 

        #render plain: params[:oauthapp].inspect
        @Oauthapp = Oauthapp.new(oauthapp_params)

        @Oauthapp.save
        redirect_to @Oauthapp

    end

    def show
        @oauthapp = Oauthapp.find(params[:id])
    end

    private 
        def oauthapp_params
            params.require(:oauthapp).permit(:title, :pubkey, :secret)
        end
end
