## MapMill ##

Rate building damage in aerial photos on a scale of 1-3. For each photo shown,
please select "ok" if no building or infrastructure damage is evident; please
select "not ok" if some damage or flooding is evident; and please select "bad"
if buildings etc. seem to be significantly damaged or underwater.

The idea is to aggregate judgements about building damages in US National Grid
cells, which is what FEMA use operationally.  As volunteers judge the level of
damage evident in each photo, the heat map will change color and indicate at a
glance where the worst damage has occurred. Our *hope* is that the aggregation
of the ok/not ok/bad ratings can be used to help guide FEMA resource
deployment, or so was indicated might be the case during RELIEF at Camp Roberts
this summer.

The application itself is adapted from MapMill, which was originally developed
by Jeff Warren for aerial image quality evaluation. 

## Requires ##

* RubyGems == 1.4.2 (this is IMPORTANT, because Ruby sucks)
* Ruby on Rails ~2.3.5
* Ruby 1.8.7 (Ruby 1.9.x doesn't work for now as there is no packaged version of the geohash gem yet for 1.9.x)
* ImageMagick

## Gems ##

    mini_magick
    geokit
    will_paginate
    json
    rdoc

## Setup ##

* Add new directories of images to /public/sites. 
* Run util/index_mgrs.py on the new directory to add the georeferencing. Read
util/README to learn how to get that to work.
* Go to http://<server>:3000/admin and create the new site in the database.
* Thumbnails are generated and dropped in matching 'foo_thumb' folders.

