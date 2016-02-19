class AdminController < ApplicationController
  def index
    if params[:elements] then
      @elements = JSON.parse params[:elements]

      @elements.each do |element|

        #TODO define left,top,rot etc.

        #TODO Element.update(element.id, :left => left, :top => top ....)

      end

    end
  end


end