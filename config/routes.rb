ActionController::Routing::Routes.draw do |map|
  
  map.connect 'sites', :controller => 'mapper', :action => 'sites'
  map.connect 'geolocate/:id', :controller => 'mapper', :action => 'geolocate'
  map.connect 'embed', :controller => 'mapper', :action => 'index', :style => 'embed'
  map.connect 'images/:site', :controller => 'mapper', :action => 'images'
  map.connect 'export/:site.:format', :controller => 'mapper', :action => 'export'
  map.connect 'grid/:site.:format', :controller => 'api', :action => 'grid'
  map.connect 'images/:site/:filter', :controller => 'mapper', :action => 'images'
  map.connect 'locate/site/:site', :controller => 'mapper', :action => 'locate_site'
  map.connect 'locate/image/:id', :controller => 'mapper', :action => 'locate_image'
  map.connect 'locate/site/:site/save', :controller => 'mapper', :action => 'save_site_location'
  map.connect 'locate/:id', :controller => 'mapper', :action => 'locate_image'

  map.root :controller => "mapper", :ui => ""
  map.connect 'vote/:id/:points', :controller => 'mapper', :action => 'vote', :site => "", :ui => ""

  map.connect 'sort/:site', :controller => 'mapper', :action => 'sort', :ui => "sort"
  map.connect 'sort/:site/vote/:id/:points', :controller => 'mapper', :action => 'vote', :ui => "sort"

  map.connect 'review/:site', :controller => 'mapper', :action => 'index', :ui => "review"
  map.connect 'review/:site/vote/:id/:points', :controller => 'mapper', :action => 'vote', :ui => "review"

  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
