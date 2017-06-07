class MapDisplayController < ApplicationController
  def map
    # Select Leaflet image based on browser
    browser = Browser.new(request.user_agent)

    @extension = (browser.chrome? || browser.firefox? || browser.safari?) ? ".svg" : ".png"
    @extension = ".png" if browser.platform.ios? || browser.platform.android?

    # Read URL params
    @shelfmark = params[:shelfmark]
    identifier = params[:identifier] || 'lc_hub'
    @library = params[:library] || 'main'
    @floor = params[:floor] || 1
    @title = params[:title]
    @author = params[:author]
    @element_name = params[:element_name]
    session[:ui_view] = params[:view] if session[:ui_view].nil?

    #search for the icons
    if @element_name
      @searching_element = true
      @elementnames = Element.joins(:element_type).where("elements.library = :library AND elements.floor = :floor AND element_types.name like :name", {library: @library, floor: @floor, name: "%#{params[:element_name]}%"})
    end
    # If URL is passing paramenters
    if @shelfmark
        @is_searching = true
        
        unless browser.platform.ios? or browser.platform.android? or browser.platform.windows_phone?
          @qr = RQRCode::QRCode.new(request.original_url)
        end

        #If Main Library Floor is passed through, else floor needs to be calculated
        if @library == "main"
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
        else
          shelfmarkNumber = shelfmarkToOrder(@shelfmark, identifier)
          @elements = Element.where("range_end >= :shelfmark AND range_start <= :shelfmark AND library = :library AND identifier = :identifier", {shelfmark: shelfmarkNumber, library: @library, identifier: identifier})
          if @elements.any?
            @floor = @elements[0].floor
          end
        end
    end

    respond_to do |format|
      format.js
      format.html
    end

  end

  def save_statistics
    UsageStatistic.create(found: params[:found]) if params[:found]
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
