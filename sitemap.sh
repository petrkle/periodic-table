#!/bin/bash

HOME='http://pt.kle.cz'
WWW=www
SITEMAP="$WWW/sitemap.xml"

echo -n '<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
' > $SITEMAP

for url in `find $WWW/ -type f -name "*.html" -not -name "404.html" -printf "%P\n"`
do
	echo "<url><loc>$HOME/$url</loc><changefreq>monthly</changefreq></url>" >> $SITEMAP
done

echo -n '</urlset>' >> $SITEMAP
