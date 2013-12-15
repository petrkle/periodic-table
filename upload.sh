#!/bin/bash

find www -name "*.html" -exec sed -i "s/pt.kl.cz/pt.kle.cz/g" \{\} \;

(cd www/ && lftp -e 'mirror --reverse -v && exit' pt.kle.cz)
