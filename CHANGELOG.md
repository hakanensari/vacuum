1.1.1
=====

* Added back Request#curl as a deprecated method.

1.1.0
=====

* Removed Request#get!. Bloat.
* Added Request#get_all to fetch responses from all venues
  simultaneously.
* Added Request#associate_tags= to set associate tags for all locales.
* Added Request#keys= to set distinct keys for locales.
* Request#get validates presence of key and locale.
* Renamed Request#curl to Request#curl_opts.

1.0.0
=====

* Added #each and #map to Response. #find no longer yields.

1.0.0.beta4
===========

* Sucker::Request#get! raises an error if response is not valid.

1.0.0.beta3
===========

* Sucker::Response#find yields to a block if given one.
* Renamed #node to #find
