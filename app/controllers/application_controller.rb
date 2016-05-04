class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def shelfmarkToOrder(shelfmark, identifier)

    if identifier == "lc_main" || identifier == "lc_hub"
      letters = shelfmark.match(/^((Folio )|(Pamph. )|(Ref. ))?[A-Z]+/)[0]

     if letters[0..4] == "Ref. "
       letters = letters[5..letters.length]
     end

     if identifier == "lc_main"
       subclass = LcSection.where(:letters => letters).first
     elsif identifier == "lc_hub"
       subclass = HubLcSection.where(:letters => letters).first
     end


      if !subclass or !shelfmark.match(/(\d+)/)
        return -1
      end

      token = Integer(subclass.token)
      digits = Integer(shelfmark.match(/(\d+)/)[0])
      digits = digits.to_s.rjust(5, "0") # add prepending 0s

      res = Float(token.to_s + '.' + digits)
      return res

    elsif identifier == "dewey_main"

      shelfmark = shelfmark.gsub(/[^0-9A-Za-z]/, '')
      shelfmark = shelfmark.match(/^[^\d]*(\d+)/)[0]

      if !shelfmark
        return -1
      end

      res = Float("."+shelfmark)
      return res

    end

  end

end
