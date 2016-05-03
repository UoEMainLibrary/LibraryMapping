class AdminController < ApplicationController
  def index
    redirect_to action: "map", floor: 1, library: "main"
  end

  def save_svg
    if params[:svg_data] and params[:library] and params[:floor]
      File.write('public/assets/' + params[:library] + '_' + params[:floor] + '.svg', params[:svg_data]);
    end

    if params[:png_data] and params[:library] and params[:floor]
      File.open('public/assets/' + params[:library] + '_' + params[:floor] + '.png', 'wb') do |f|
        f.write(Base64.decode64(params[:png_data]))
      end
    end

    head :ok
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

      res = save_single_element(element)
      p res
      if res != true
        respond_to do |format|
          format.json {render :json => { :errors => res['error'] }, :status => 422}
        end
        return
      end
    end

    render :json => {
        :next_id => Element.maximum(:id).to_i
    }
  end



  def map
    @floor = params[:floor]
    @library = params[:library]

    if params[:elements] then
      @elements = JSON.parse params[:elements]

      newElementsCount = 0
      @elements.each do |element|
        unless Element.exists?(:id => element["id"])
          newElementsCount += 1
        end
        save_single_element(element)
      end

      render :json => {
          :next_id => Element.maximum(:id).to_i.next - newElementsCount
      }
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
    canvasElement.opacity = element["opacity"]
    canvasElement.angle = element["angle"]
    canvasElement.fill = element["fill"]
    canvasElement.scaleX = element["scaleX"]
    canvasElement.scaleY = element["scaleY"]
    canvasElement.element_type_id = element["element_type_id"]
    canvasElement.floor = element["floor"]
    canvasElement.library = element["library"]

    if element["element_type_id"] == ElementType.find_by(name: "Shelf").id

      if element["range_up_opt"] == nil
        element["range_up_opt"] = ''
      end

      if element["range_up_digits"] == nil
        element["range_up_digits"] = ''
      end

      if element["range_up_letters"] == nil
        element["range_up_letters"] = ''
      end

      if element["range_down_opt"] == nil
        element["range_down_opt"] = ''
      end

      if element["range_down_digits"] == nil
        element["range_down_digits"] = ''
      end

      if element["range_down_letters"] == nil
        element["range_down_letters"] = ''
      end

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

      if shelfmark_up == "" and shelfmark_down == ""
        if canvasElement.save
          return true
        else
          return {"error" => canvasElement.errors.full_messages}
        end
      end

      if shelfmark_down != ""
        shelfmark_down = shelfmarkToOrder(shelfmark_down)
        if shelfmark_down == -1
          return {"error" => "Invalid start shelfmark"}
        end
      else
        return {"error" => "Start shelfmark cannot be empty"}
      end

      if shelfmark_up != ""
        shelfmark_up = shelfmarkToOrder(shelfmark_up)
        if shelfmark_up == -1
          return {"error" => "Invalid end shelfmark"}
        end
      else
        return {"error" => "End shelfmark cannot be empty"}
      end

      if shelfmark_down > shelfmark_up
        return {"error" => "Invalid range: start shelfmark should be lower than end shelfmark"}
      end

      # Update shelve's custom attribute
      canvasElement.range_up = shelfmark_up
      canvasElement.range_down = shelfmark_down
      canvasElement.identifier = element["identifier"]
      canvasElement.range_up_opt = element["range_up_opt"]
      canvasElement.range_up_digits = element["range_up_digits"]
      canvasElement.range_up_letters = element["range_up_letters"]
      canvasElement.range_down_opt = element["range_down_opt"]
      canvasElement.range_down_digits = element["range_down_digits"]
      canvasElement.range_down_letters = element["range_down_letters"]

    elsif element["element_type_id"] == ElementType.find_by(name: "Wall").id

      canvasElement.right = element["right"]
      canvasElement.bottom = element["bottom"]

    end

    if canvasElement.save
      return true
    else
      return {"error" => canvasElement.errors.full_messages}
    end

  end

end