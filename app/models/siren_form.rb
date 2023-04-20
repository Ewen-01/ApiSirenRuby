class SirenForm
  include ActiveModel::Model
  
  attr_accessor :siren, :name


  
  validates :siren, presence: true, length: { is: 9 }, numericality: { only_integer: true }, unless: -> { siren.blank? }
  validates :name, presence: true, unless: -> { name.blank? }
  

end