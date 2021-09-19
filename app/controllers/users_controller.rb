class UsersController < ApplicationController
  def create
    respond_to do |format|
      if @import = User.import(params[:user][:file])
        format.js { render :show }
      else
        format.js { }
      end
    end
  end
end
