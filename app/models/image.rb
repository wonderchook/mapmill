PRECISION=100000.0
def round_to(value)
  (value.to_f*PRECISION).round.to_f / PRECISION
end
class Image < ActiveRecord::Base

	belongs_to :site
        named_scope :by_mgrs, lambda {|mgrs| {:conditions => {:mgrs => mgrs}}}

	def vote(key, rating)
          participant_id = nil
          p = self.site.unique_participant(key)
          Vote.create!(:participant_id => p.id, :image_id => self.id,
                       :email => session[:email], :rating => rating)
          self.hits += 1
          self.save
	end

	def sitename
		self.path.split("/")[2]
	end

        def url
          if path.start_with? "http" or path.start_with "/"
            path
          else
            "/" + path
          end
        end

	#def filename
	#	self.path.split("/").last
	#end

	def fullsize_thumb
                return thumbnail if thumbnail
		thumb_path = 'public/fullsize_thumbnails/'+self.site.name
    		Dir.mkdir('public/fullsize_thumbnails') unless File.exists?('public/fullsize_thumbnails')
#		require 'mini_magick'
# 		unless File.exists?(thumb_path+'/'+self.filename)
# 			image = MiniMagick::Image.from_file('public/sites/'+self.site.name+"/"+self.filename)
# 			image.crop "180x135+1500+1000"#+(image.width/2-90)+"+"+(image.height/2-60)
# 			Dir.mkdir(thumb_path) unless File.exists?(thumb_path)
# 			thumbnail = File.open(thumb_path+'/'+filename,"wb+")
# 			image.write thumb_path+'/'+filename
# 			thumbnail.close
# 		end
		'/fullsize_thumbnails/'+self.site.name+'/'+filename
	end
	def thumb
                return thumbnail if thumbnail
		thumb_path = 'public/thumbnails/'+self.site.name
#               require 'mini_magick'
# 		unless File.exists?(thumb_path+'/'+self.filename)
# 			image = MiniMagick::Image.open('public/sites/'+self.site.name+"/"+self.filename)
# 			image.resize "180X120"
# 			Dir.mkdir(thumb_path) unless File.exists?(thumb_path)
# 			thumbnail = File.open(thumb_path+'/'+filename,"wb+")
# 			image.write thumb_path+'/'+filename
# 			thumbnail.close
# 		end
		'/thumbnails/'+self.site.name+'/'+filename
	end
        def self.grid(site)
          cells = self.all(:select=> "mgrs, case when sum(hits) = 0 then 0.0 else 10.0-(sum(points)/sum(hits)::float) end as damage, sum(hits) as views, count(*) as images, box",
                           :group => "mgrs, box",
                           :conditions => { :site_id => site })
          cells.each do |cell|
            if cell.box
              cell.box = JSON.parse(cell.box)
              cell.box.map! {|coords| coords.map! {|value| round_to(value)}}
              cell.damage = round_to(cell.damage)
            end
          end
          cells
        end
end
