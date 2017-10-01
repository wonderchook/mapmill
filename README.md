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

## Installation ##

```
$ bundle install
```
 
## Requires ##

* Ruby ~2.1.5 seems to work
* Ruby on Rails ~2.3.5
* Gems
  * geokit
  * will_paginate
  * json
  * rdoc

Note: ImageMagick and the mini_magick gem were needed by a prior version for
generating thumbnails. The current version either doesn't need them or assumes
that they are being generated elsewhere.

## Setup ##

* Add new directories of images to /public/sites. 
* Run `util/index_mgrs.py` on the new directory to add the georeferencing. Read
util/README to learn how to get that to work.
* Go to http://[server]:3000/admin and create the new site in the database.
* ~~Thumbnails are generated and dropped in matching `foo_thumb` folders.~~

## Credits & License ##

This software was originally written by Jeff Warren, and extensively adapted by
Kate Chapman and Schuyler Erle. Additional contributions were made by Ka-Ping
Yee and Michael Lascarides.

This software is Copyright 2010 Jeffrey Warren.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
