ActionController::Routing::Routes.draw do |map|
  
  map.connect 'sort/:site', :controller => 'mapper', :action => 'sort'
  map.connect 'sites', :controller => 'mapper', :action => 'sites'
  map.connect 'geolocate/:id', :controller => 'mapper', :action => 'geolocate'
  map.connect 'embed', :controller => 'mapper', :action => 'index', :style => 'embed'
  map.connect 'images/:site', :controller => 'mapper', :action => 'images'
  map.connect 'export/:site.:format', :controller => 'mapper', :action => 'export'
  map.connect 'images/:site/:filter', :controller => 'mapper', :action => 'images'
  map.connect 'locate/site/:site', :controller => 'mapper', :action => 'locate_site'
  map.connect 'locate/image/:id', :controller => 'mapper', :action => 'locate_image'
  map.connect 'locate/site/:site/save', :controller => 'mapper', :action => 'save_site_location'
  map.connect 'locate/:id', :controller => 'mapper', :action => 'locate_image'
  map.connect 'vote/:id/:points', :controller => 'mapper', :action => 'vote', :site => ""
  map.connect 'vote/:id/:points/:site', :controller => 'mapper', :action => 'vote'

  
  map.root :controller => "mapper"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
