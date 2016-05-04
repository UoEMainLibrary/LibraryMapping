class MapDisplayController < ApplicationController
  def map
    browser = Browser.new(request.user_agent)
    @extension = ".png"

    if (browser.chrome? or browser.firefox? or browser.safari?) and !browser.platform.ios? and !browser.platform.android?
      @extension = ".svg"
    end

    shelfmark = params[:shelfmark]
    identifier = params[:identifier]
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

    unless identifier
      identifier = "lc_hub"
    end

    if shelfmark and @library and @floor
        unless browser.platform.ios? or browser.platform.android? or browser.platform.windows_phone?
          @qr = RQRCode::QRCode.new(request.original_url)
        end
        shelfmarkNumber = shelfmarkToOrder(shelfmark, identifier)
        @elements = Element.where("range_end >= :shelfmark AND range_start <= :shelfmark AND library = :library AND floor = :floor AND identifier = :identifier", {shelfmark: shelfmarkNumber, library: @library, floor: @floor, identifier: identifier})
    end
  end
end
