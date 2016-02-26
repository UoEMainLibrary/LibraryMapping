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
                 :scaleY => element["scaleY"],
                 :range_up => element["range_up"],
                 :range_down => element["range_down"],
                 :classification => element["classification"],
                 :identifier => element["identifier"]
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
              :element_type_id => element["element_type_id"],
              :range_up => element["range_up"],
              :range_down => element["range_down"],
              :classification => element["classification"],
              :identifier => element["identifier"]
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

  def save_element
    if params[:element]
      element = JSON.parse params[:element]

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
                       :scaleY => element["scaleY"],
                       :range_up => element["range_up"],
                       :range_down => element["range_down"],
                       :classification => element["classification"],
                       :identifier => element["identifier"]
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
            :element_type_id => element["element_type_id"],
            :range_up => element["range_up"],
            :range_down => element["range_down"],
            :classification => element["classification"],
            :identifier => element["identifier"]
        )
      end
    end

    head :ok
  end

end