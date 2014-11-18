#!/bin/bash

find www -name "*.html" -exec sed -i "s/pt.kl.cz/pt.kle.cz/g" \{\} \;

rsync -e ssh \
	--recursive \
	--stats \
	--verbose \
	--times \
	--update \
	www/ \
	vps.kle.cz:/home/www/pt.kle.cz/
