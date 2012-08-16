require 'json'

class ApiController < ApplicationController
  def grid
    @site = Site.find_by_name(params[:site])
    # TODO: filter by site
    cells = Image.select("avg(points) as points, sum(hits) as hits, count(*) as images, box", :group => "mgrs")
    features = cells.map {|cell|
      box = cell.box ? JSON.parse(box) : []
      {:type => "Feature", :properties => cell, :geometry => {:type => "Polygon", :coordinates => [box]}}
    }
    @grid = {:type => "FeatureCollection", :features => features}
  end
end
