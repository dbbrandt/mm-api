class VueController < ApplicationController
  def index
    render file: Rails.public_path.join("vue","index.html"), layout: false # /public/templates/home.html
  end
end