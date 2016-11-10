class TaxPayer
  include ActiveModel::Model
  PAYER_TYPES = ['physical', 'legal']

  attr_accessor :unp, :payer_type

  validates :payer_type, inclusion: PAYER_TYPES
  validates :unp, unp_number: true

end
