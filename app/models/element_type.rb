class ElementType < ActiveRecord::Base
  has_many :element, dependent: :destroy
end
