class ApiController < ApplicationController

  def grid
    @site = Site.find_by_name(params[:site])
    @grid = Image.select("avg(points) as points, sum(hits) as hits, grid", :group => "mgrs")
  end

end
