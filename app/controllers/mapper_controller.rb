class MapperController < ApplicationController

	def sites
		@sites = Site.find :all, :conditions => {:active => true}, :order => "id DESC"
	end

	def images
		@site = Site.find_by_name(params[:site])
		# sort by the highest rating -- the ratio
		images = @site.images unless params[:filter]
		images = Image.find_all_by_site_id(@site.id, :conditions => {:hits=> 0, :points => 0}) if params[:filter] == "unsorted"
                images = images.by_mgrs(params[:mgrs]) if params[:mgrs]
		images.each do |i|
			i.delete unless File.exist?("public/"+i.path)
		end
		@images = images.sort_by do |i|
			if (i.hits > 0)
				-1*(i.points/i.hits)+-1*(i.hits*0.1)
			else
				0
			end
		end
                @images.reverse! # *worst* images first (sorry Jeff)
		@images = @images.paginate :per_page => 20, :page => params[:page]
		#@images.paginate :page => params[:page], :per_page => 21
	end
	
	
	def export
	  @site = Site.find_by_name(params[:site])
	  images = @site.images unless params[:filter]
          images = Image.find_all_by_site_id(@site.id, :conditions => {:hits=> 0, :points => 0}) if params[:filter] == "unsorted"
          @images = images
	end

	# currently collects 5 lowest vote-count images from each site,
	# removing thumb dirs, from the end of the list, alphabetically? dumb.
	def index
          # this'll get expensive... try getting a random site?	
          cond = {:active => true}
          cond[:name] = params[:site] unless params[:site].nil?
          logger.warn cond
          sites = Site.find(:all, :conditions => cond)
          logger.warn sites
          @image = Image.find(:first, :conditions => {:site_id => sites}, :order => "hits")
          @vote = params[:ui] != "" ? "/#{params[:ui]}/#{params[:site]}/vote" : "/vote"
          @image.thumb unless @image.nil?
	end

	def sort
		@site = Site.find_by_name(params[:site])
		pool = []
		# this'll get expensive... try getting a random site?
		pool = @site.voted_less_than(50,100) # 100 images with less than 50 votes

		@image = pool[((pool.length-1)*rand).to_i]
		@image.thumb unless @image.nil?
		@sitename = @site.name
                @vote = "/sort/#{@sitename}/vote"
		render "index"
	end

	def vote
              if i = Image.find(params[:id])
                      i.points += params[:points].to_i if params[:points].to_i < 11
                      i.vote(params[:mapmill_id])
              end
              if params[:ui] != ""
                path = "/" + params[:ui] + "/" + params[:site] + "/"
              else
                path = "/"
              end
              path += '?o=x&last='+i.path 
              if  params[:ajax]
                      render :text => "success"
              else
                      redirect_to path 
              end
	end
	
	
	def save_site_location
		redirect_to 'sites'
	end

	def locate_site
		@site = Site.find_by_name(params[:site])
		@image = @site.images.first
		@image.thumb
		render "locate"
	end

	def locate_image
		render "locate"
	end

	def geolocate
		begin
        		location = GeoKit::GeoLoc.geocode(params[:id])
        		render :text => location.lat.to_s+","+location.lng.to_s
		rescue
			render :text => "No results"
		end
	end

	def fullsize_thumb
		image = Image.find(params[:id])
		redirect_to image.fullsize_thumb
	end

end
