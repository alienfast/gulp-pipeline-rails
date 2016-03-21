Rails.application.routes.draw do

  #mount Foo::Engine => "/foo"

  scope controller: :home do
    get '/' => :home
  end
end
