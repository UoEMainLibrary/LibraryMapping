class MapDisplayController < ApplicationController
  def map
    @a = params[:shelfmark].match(/^((Folio )|(Pham. )|(Ref. ))?[A-Z]+/)[0]
    @b = Integer(params[:shelfmark].match(/(\d+)/)[0])

    @c = Integer(LcSection.where(:letters => @a).first.token)

    @length = Integer((Math.log10(@b)+1))
    @finalNum = @c + Float(@b)/Float((10 ** @length))


  end
end
