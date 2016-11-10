class TaxPayer < Struct.new(:unp, :payer_type)
  include ActiveModel::Model

  validates :payer_type, inclusion: ['physical', 'legal']
end
