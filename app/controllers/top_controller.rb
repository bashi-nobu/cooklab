class TopController < ApplicationController
  def index
    @videos = Video.all
  end
end
