class TaxPayersController < ApplicationController
  def index
    @tax_payer = TaxPayer.new
  end

  def check_unp
  end
end
