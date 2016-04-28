class MapDisplayController < ApplicationController
  def map
    shelfmark = params[:shelfmark]
    @library = params[:library]
    @floor = params[:floor]
    @title = params[:title]
    @author = params[:author]

    unless @floor
      @floor = 1
    end

    unless @library
      @library = "main"
    end

    if shelfmark and @library and @floor
        @qr = RQRCode::QRCode.new(request.original_url)
        shelfmarkNumber = shelfmarkToOrder(shelfmark)
        @elements = Element.where("range_up >= :shelfmark AND range_down <= :shelfmark AND library = :library AND floor = :floor", {shelfmark: shelfmarkNumber, library: @library, floor: @floor})
    end
  end
end
