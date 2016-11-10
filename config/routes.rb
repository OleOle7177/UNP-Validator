Rails.application.routes.draw do

  root to: 'tax_payers#index'

  resources :tax_payers, path: 'tax-payer' do
    collection do
      post 'check_unp'
    end
  end

end
