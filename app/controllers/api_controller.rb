require 'json'

class ApiController < ApplicationController
  def grid
    @site = Site.find_by_name(params[:site])
    @grid = Image.select("avg(points) as points, sum(hits) as hits, box", :group => "mgrs")
    @grid.each {|g| g.box = JSON.parse(g.box) if g.box }
  end
end
