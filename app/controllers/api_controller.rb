require 'json'

class ApiController < ApplicationController
  def grid
    @site = Site.find_by_name(params[:site])
    features = Image.grid(@site).map {|cell|
      {:type => "Feature", :properties => cell, :geometry => {:type => "Polygon", :coordinates => [cell.box]}}
    }
    @grid = {:type => "FeatureCollection", :features => features}
  end
end
