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
      @searching = true
      @elementnames = Element.joins(:element_type).where("elements.library = :library AND elements.floor = :floor AND element_types.name like :name", {library: @library, floor: @floor, name: "%#{params[:element_name]}%"})
    end
    # If URL is passing parameters - this is what caused the problem...
    if @shelfmark
        @searching = true
        @original_shelfmark = @shelfmark.dup
        unless browser.platform.ios? or browser.platform.android? or browser.platform.windows_phone?
          @qr = RQRCode::QRCode.new(request.original_url)
        end
        @elements = Element.find_shelf(@library, identifier, @shelfmark)
        if @library == 'murray'
          @floor = @elements.try(:first).try(:floor)
        end
        #@floor = @elements.try(:first).try(:floor)
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
