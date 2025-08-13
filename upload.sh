#!/bin/bash

find www -name "*.html" -exec sed -i "s/pt.kl.cz/pt.kle.cz/g" \{\} \;

for foo in `find www -type f -not -name "*.gz"`; do gzip -c --best $foo > $foo.gz; done

for foo in `find www -type f -not -name "*.gz"`; do brotli -c -Z $foo > $foo.br; echo -n "."; done

rsync -e ssh \
	--recursive \
	--stats \
	--verbose \
	--times \
	--delete-after \
	--update \
	www/ \
	vps.kle.cz:/home/www/pt.kle.cz/
