class HomeController < ApplicationController
  def index
    @users = User.new
  end
end
