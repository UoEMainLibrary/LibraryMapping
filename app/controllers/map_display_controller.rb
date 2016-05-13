class MapDisplayController < ApplicationController
  def map
    browser = Browser.new(request.user_agent)
    @extension = ".png"

    if (browser.chrome? or browser.firefox? or browser.safari?) and !browser.platform.ios? and !browser.platform.android?
      @extension = ".svg"
    end

    @shelfmark = params[:shelfmark]
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

    if @shelfmark and @library and @floor
        unless browser.platform.ios? or browser.platform.android? or browser.platform.windows_phone?
          @qr = RQRCode::QRCode.new(request.original_url)
        end

        if @shelfmark.match(/^(Smith Coll.|Watt Coll.|Serj. Coll.|C.A.S.)/)
          identifier = "cwss_main"
          @elements = Element.where("identifier = :identifier AND library = :library AND floor = :floor", {identifier: identifier, library: @library, floor: @floor})
        elsif identifier == "eas_main"
          @elements = Element.where("identifier = :identifier AND library = :library AND floor = :floor", {identifier: identifier, library: @library, floor: @floor})
        else
          shelfmarkNumber = shelfmarkToOrder(@shelfmark, identifier)
          @elements = Element.where("range_end >= :shelfmark AND range_start <= :shelfmark AND library = :library AND floor = :floor AND identifier = :identifier", {shelfmark: shelfmarkNumber, library: @library, floor: @floor, identifier: identifier})
        end
    end
  end

  def save_statistics
    found = params[:found]
    if found
      UsageStatistic.create(found: found)
    end

    head :ok
  end
end
