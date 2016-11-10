class TaxPayersController < ApplicationController
  def index
    @tax_payer = TaxPayer.new
  end

  def check_unp
    @tax_payer = TaxPayer.new(tax_payer_params)
    if @tax_payer.valid?
      p 'valid!!!'
    else
      p 'invalid!!!'
    end

    render 'index'
  end

  protected

  def tax_payer_params
    params.require(:tax_payer).permit(:unp, :payer_type)
  end
end
