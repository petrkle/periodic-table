all:
	cd po ; $(MAKE)
	./generate.pl
	./sitemap.sh
	cp src/robots.txt www
	cp src/.htaccess www
	java -jar $(HOME)/lib/htmlcompressor-1.5.3.jar --compress-js --remove-surrounding-spaces all -r -m '*.html' -o www www

upload:
	./upload.sh

clean:
	rm -rf locale www
