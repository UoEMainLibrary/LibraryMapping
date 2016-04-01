class MapDisplayController < ApplicationController
  def map

    @shelfmark = shelfmarkToOrder(params[:shelfmark])
    @elements = Element.where("range_up >= :shelfmark AND range_down <= :shelfmark", {shelfmark: @shelfmark})

  end
end
