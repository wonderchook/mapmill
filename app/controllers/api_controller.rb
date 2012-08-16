require 'json'

class ApiController < ApplicationController
  def grid
    @site = Site.find_by_name(params[:site])
    # TODO: filter by site
    features = Image.grid.map {|cell|
      {:type => "Feature", :properties => cell, :geometry => {:type => "Polygon", :coordinates => [cell.box]}}
    }
    @grid = {:type => "FeatureCollection", :features => features}
  end
end
