class UsersController < ApplicationController
  def create
    @result = User.import(params[:user][:file])
    binding.pry
    redirect_to root_path
  end
end
