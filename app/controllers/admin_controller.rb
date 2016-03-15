class AdminController < ApplicationController
  def index
    redirect_to action: "map", floor: 1
  end

  def save_svg
    if params[:svg_data]
      File.write('app/assets/images/main_1.svg', params[:svg_data]);
    end

    head :ok
  end

  def destroy
    p "yolo"
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

    if Element.exists?(:id => element["id"])
      canvasElement = Element.find(element["id"])
    else
      canvasElement = Element.new
    end

      # Set element general attributes
      canvasElement.left = element["left"]
      canvasElement.top = element["top"]
      canvasElement.height = element["height"]
      canvasElement.width = element["width"]
      canvasElement.opacity = element["opacity"]
      canvasElement.angle = element["angle"]
      canvasElement.fill = element["fill"]
      canvasElement.scaleX = element["scaleX"]
      canvasElement.scaleY = element["scaleY"]
      canvasElement.element_type_id = element["element_type_id"]
      canvasElement.floor = element["floor"]

      if element["element_type_id"] == 11

        # Validate shelfmark
        if (element["range_up_opt"] == "Ref. ")
          shelfmark_up = element["range_up_letters"] + element["range_up_digits"]
        else
          shelfmark_up = element["range_up_opt"] + element["range_up_letters"] + element["range_up_digits"]
        end

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

        # Update shelve's custom attribute
        canvasElement.range_up = shelfmark_up
        canvasElement.range_down = shelfmark_down
        canvasElement.classification = element["classification"]
        canvasElement.identifier = element["identifier"]
        canvasElement.range_up_opt = element["range_up_opt"]
        canvasElement.range_up_digits = element["range_up_digits"]
        canvasElement.range_up_letters = element["range_up_letters"]
        canvasElement.range_down_opt = element["range_down_opt"]
        canvasElement.range_down_digits = element["range_down_digits"]
        canvasElement.range_down_letters = element["range_down_letters"]
      end

      canvasElement.save

    end

end