class OauthappController < ApplicationController
    def new
    end

    def create
        render plain: params[:oauthapp].inspect
    end
end
