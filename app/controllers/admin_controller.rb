class AdminController < ApplicationController
  def index
    redirect_to action: "map", floor: 1
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

      save_single_element(element)
    end

    head :ok
  end



  def map
    @floor = params[:floor]
    if params[:elements] then
      @elements = JSON.parse params[:elements]

      @elements.each do |element|
        save_single_element(element)
      end
    end
  end

  private
  def save_single_element(element)

    shelfmark_up = ""
    if (element["range_up_opt"] == "Ref. ")
      shelfmark_up = element["range_up_letters"] + element["range_up_digits"]
    else
      shelfmark_up = element["range_up_opt"] + element["range_up_letters"] + element["range_up_digits"]
    end

    shelfmark_down = ""
    if (element["range_down_opt"] == "Ref. ")
      shelfmark_down = element["range_down_letters"] + element["range_down_digits"]
    else
      shelfmark_down = element["range_down_opt"] + element["range_down_letters"] + element["range_down_digits"]
    end

    if shelfmark_up != ""
      shelfmark_up = shelfmarkToOrder(shelfmark_up)
      if shelfmark_up == -1
        #return error
      end
    end

    if shelfmark_down != ""
      shelfmark_down = shelfmarkToOrder(shelfmark_down)
      if shelfmark_down == -1
        #return error
      end
    end

    if shelfmark_down >= shelfmark_up
      # return error TODO
    end

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
                     :range_up => shelfmark_up,
                     :range_down => shelfmark_down,
                     :classification => element["classification"],
                     :identifier => element["identifier"],
                     :range_up_opt => element["range_up_opt"],
                     :range_up_digits => element["range_up_digits"],
                     :range_up_letters => element["range_up_letters"],
                     :range_down_opt => element["range_down_opt"],
                     :range_down_digits => element["range_down_digits"],
                     :range_down_letters => element["range_down_letters"],
                     :floor => element["floor"]
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
          :range_up => shelfmark_up,
          :range_down => shelfmark_down,
          :classification => element["classification"],
          :identifier => element["identifier"],
          :range_up_opt => element["range_up_opt"],
          :range_up_digits => element["range_up_digits"],
          :range_up_letters => element["range_up_letters"],
          :range_down_opt => element["range_down_opt"],
          :range_down_digits => element["range_down_digits"],
          :range_down_letters => element["range_down_letters"],
          :floor => element["floor"]
      )
    end
  end

end