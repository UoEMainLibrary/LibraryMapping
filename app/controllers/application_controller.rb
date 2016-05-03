class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def shelfmarkToOrder(shelfmark)
    letters = shelfmark.match(/^((Folio )|(Pamph. )|(Ref. ))?[A-Z]+/)[0]

    if(letters[0..4] == "Ref. ")
      letters = letters[5..letters.length]
    #else if(inHub && letters[0..4] == "Folio. N")

    end

    #TODO: if hub, lcSection, etc
    subclass = HubLcSection.where(:letters => letters).first


    if(!subclass or !shelfmark.match(/(\d+)/))
      return -1
    end

    token = Integer(subclass.token)
    digits = Integer(shelfmark.match(/(\d+)/)[0])
    digits = digits.to_s.rjust(5, "0") # add prepending 0s

    res = Float(token.to_s + '.' + digits)
    return res;
  end

end
