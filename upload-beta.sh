#!/bin/bash

rsync -e ssh \
	--recursive \
	--stats \
	--verbose \
	--times \
	--update \
	www/ \
	vps:/home/www/pt.kle.cz/
