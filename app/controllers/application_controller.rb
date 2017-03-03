class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  # Maps shelfmarks in different classification to LibraryMapping's ordering system
  def shelfmarkToOrder(shelfmark, identifier)

    # Library of Congress classifications
    # Add other LoC collections here
    if identifier == "lc_main" || identifier == "lc_hub" || identifier == "lc_murray" || identifier == "lc_murray_hub" || identifier == "lc_newcollege" || identifier == "lc_newcollege_hub"

      #todo catch errors here
      begin
        letters = shelfmark.match(/^((Folio )|(Pamph. )|(Ref. ))?[A-Z]+/)[0]
      rescue
        return -1
      end


     if letters[0..4] == "Ref. "
       letters = letters[5..letters.length]
     end

     if identifier == "lc_main"
       subclass = LcSection.where(:letters => letters).first
     elsif identifier == "lc_hub"
       subclass = HubLcSection.where(:letters => letters).first
     elsif identifier == "lc_murray"
       subclass = MurrayLcSection.where(:letters => letters).first
     elsif identifier == "lc_murray_hub"
       subclass = MurrayLcSection.where(:letters => letters).first
     elsif identifier == "lc_newcollege_hub"
       subclass = NewcollegeLcSection.where(:letters => letters).first
     elsif identifier == "lc_newcollege"
       subclass = NewcollegeLcSection.where(:letters => letters).first
     end


      if !subclass or !shelfmark.match(/(\d+)/)
        return -1
      end

      token = Integer(subclass.token)
      digits = Integer(shelfmark.match(/(\d+)/)[0])
      digits = digits.to_s.rjust(5, "0") # add prepending 0s

      res = Float(token.to_s + '.' + digits)
      return res

    # Dewey Decimal classifications
    # Add other Dewey Decimal collections here
    elsif identifier == "dewey_main" || identifier == "journal_main"

      offset = 0

      # Add offsets if Folios or Pamphlets
      if shelfmark[0] == 'F'
        offset = 1
        shelfmark = shelfmark[2..-1]
      elsif identifier == "journal_main"
        shelfmark = shelfmark[5..-1]
      elsif shelfmark[0] == 'P'
        offset = 2
        shelfmark = shelfmark[2..-1]
      end

      shelfmark = shelfmark.gsub(/[^0-9A-Za-z]/, '')
      shelfmark = shelfmark.match(/^[^\d]*(\d+)/)[0]

      if !shelfmark
        return -1
      end

      res = Float("."+shelfmark) - offset
      return res

    end

  end

end
