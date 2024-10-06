class HomeController < ApplicationController
  def welcome
    @exoplanets = Exoplanet.all
  end
end
