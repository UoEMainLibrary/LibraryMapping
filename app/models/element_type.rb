class ElementType < ActiveRecord::Base
  has_many :elements, dependent: :destroy
end
