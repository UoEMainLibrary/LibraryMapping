class MapDisplayController < ApplicationController
  def map
    shelfmark = params[:shelfmark]
    @library = params[:library]
    @floor = params[:floor]

    if shelfmark and @library and @floor
        shelfmarkNumber = shelfmarkToOrder(shelfmark)
        @elements = Element.where("range_up >= :shelfmark AND range_down <= :shelfmark AND library = :library AND floor = :floor", {shelfmark: shelfmarkNumber, library: @library, floor: @floor})
    end
  end
end
