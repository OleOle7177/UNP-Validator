Rails.application.routes.draw do

  root to: 'tax_payers#index'

  resources :tax_payers, path: '' do
    collection do
      post 'check_unp', path: ''
    end
  end

end
