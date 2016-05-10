class AdminController < ApplicationController
  def index
    #redirect_to action: "map", floor: 1, library: "main"
    @total = UsageStatistic.count
    @found = UsageStatistic.where(found: true).count
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

      if element["range_end_opt"] == nil
        element["range_end_opt"] = ''
      end

      if element["range_end_digits"] == nil
        element["range_end_digits"] = ''
      end

      if element["range_end_letters"] == nil
        element["range_end_letters"] = ''
      end

      if element["range_start_opt"] == nil
        element["range_start_opt"] = ''
      end

      if element["range_start_digits"] == nil
        element["range_start_digits"] = ''
      end

      if element["range_start_letters"] == nil
        element["range_start_letters"] = ''
      end

      # Validate shelfmark
      if (element["range_end_opt"] == "Ref. ")
        shelfmark_end = element["range_end_letters"] + element["range_end_digits"]
      else
        shelfmark_end = element["range_end_opt"] + element["range_end_letters"] + element["range_end_digits"]
      end

      if (element["range_start_opt"] == "Ref. ")
        shelfmark_start = element["range_start_letters"] + element["range_start_digits"]
      else
        shelfmark_start = element["range_start_opt"] + element["range_start_letters"] + element["range_start_digits"]
      end

      if shelfmark_end == "" and shelfmark_start == ""
        if canvasElement.save
          return true
        else
          return {"error" => canvasElement.errors.full_messages}
        end
      end

      if shelfmark_start != ""
        shelfmark_start = shelfmarkToOrder(shelfmark_start, element["identifier"])
        if shelfmark_start == -1
          return {"error" => "Invalid start shelfmark"}
        end
      else
        return {"error" => "Start shelfmark cannot be empty"}
      end

      if shelfmark_end != ""
        shelfmark_end = shelfmarkToOrder(shelfmark_end, element["identifier"])
        if shelfmark_end == -1
          return {"error" => "Invalid end shelfmark"}
        end
      else
        return {"error" => "End shelfmark cannot be empty"}
      end

      if shelfmark_start > shelfmark_end
        return {"error" => "Invalid range: start shelfmark should be lower than end shelfmark"}
      end

      # Update shelve's custom attribute
      canvasElement.range_end = shelfmark_end
      canvasElement.range_start = shelfmark_start
      canvasElement.identifier = element["identifier"]
      canvasElement.range_end_opt = element["range_end_opt"]
      canvasElement.range_end_digits = element["range_end_digits"]
      canvasElement.range_end_letters = element["range_end_letters"]
      canvasElement.range_start_opt = element["range_start_opt"]
      canvasElement.range_start_digits = element["range_start_digits"]
      canvasElement.range_start_letters = element["range_start_letters"]

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