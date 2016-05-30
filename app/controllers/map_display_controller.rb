class MapDisplayController < ApplicationController
  def map

    # Select Leaflet image based on browser
    browser = Browser.new(request.user_agent)
    @extension = ".png"

    if (browser.chrome? or browser.firefox? or browser.safari?) and !browser.platform.ios? and !browser.platform.android?
      @extension = ".svg"
    end

    # Read URL params
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

    # If URL is passing paramenters
    if @shelfmark and @library and @floor
        @is_searching = true
        
        unless browser.platform.ios? or browser.platform.android? or browser.platform.windows_phone?
          @qr = RQRCode::QRCode.new(request.original_url)
        end

        # Matches all the shelves in the EAS Collection
        if identifier == "eas_main"
          @elements = Element.where("identifier = :identifier AND library = :library AND floor = :floor", {identifier: identifier, library: @library, floor: @floor})

        # Matches all the file in special collections (C.A.S., Watt, Smith, Serjeant)
        elsif @shelfmark.match(/^(Smith Coll.|Watt Coll.|Serj. Coll.|C.A.S.)/)
          identifier = "cwss_main"
          @elements = Element.where("identifier = :identifier AND library = :library AND floor = :floor", {identifier: identifier, library: @library, floor: @floor})

        # Matches all other shelves (HUB, Library of Congress, Dewey Decimal...)
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

  def feedback
    @message = FeedbackMessage.new
    @success = params[:success]
  end

  def create_feedback
    @message = FeedbackMessage.new(message_params)
    @message.save

    redirect_to action: "feedback", success: true
  end

  private

  def message_params
    params.require(:feedback_message).permit(:name, :email, :message)
  end
end
