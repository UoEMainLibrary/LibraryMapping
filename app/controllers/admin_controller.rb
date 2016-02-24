class AdminController < ApplicationController
  def index
    if params[:elements] then
      @elements = JSON.parse params[:elements]

      @elements.each do |element|
        if Element.exists?(:id => element["id"])
          Element.update(element["id"],
                 :left => element["left"],
                 :top => element["top"],
                 :height => element["height"],
                 :width => element["width"],
                 :opacity => element["opacity"],
                 :angle => element["angle"],
                 :fill => element["fill"],
                 :scaleX => element["scaleX"],
                 :scaleY => element["scaleY"]
                )
        else
          Element.create(
              :left => element["left"],
              :top => element["top"],
              :height => element["height"],
              :width => element["width"],
              :opacity => element["opacity"],
              :angle => element["angle"],
              :fill => element["fill"],
              :scaleX => element["scaleX"],
              :scaleY => element["scaleY"],
              :element_type_id => element["element_type_id"]
          )
        end
      end
    end
  end

  def destroy
    if params[:element_id]
      Element.destroy(params[:element_id])
    end

    head :ok
  end

end