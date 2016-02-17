class AdminController < ApplicationController
  def index
    @elements = Element.all.to_json

  end
end