Rails.application.routes.draw do

  mount Icol::Engine => "/icol"
  devise_for :users
end
