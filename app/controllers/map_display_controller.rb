class MapDisplayController < ApplicationController
  def map
    @a = shelfmarkToOrder(params[:shelfmark])
  end
end
