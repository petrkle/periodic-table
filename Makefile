COMPRESS=java -jar $(HOME)/lib/htmlcompressor-1.5.3.jar --compress-js --compress-css --remove-surrounding-spaces all -r -m '*.html' -o

help:
	@echo "help         - this help"
	@echo "web          - generate pt.kle.cz"
	@echo "upload       - upload files on web"
	@echo "beta         - upload files on test web"
	@echo "pt.zip       - hosted app for Chrome store"
	@echo "clean        - remove generated files"

web:
	cd po ; $(MAKE)
	./generate.pl --location https://pt.kl.cz --out www
	./sitemap.sh
	$(COMPRESS) www www

upload:
	./upload.sh

beta:
	./upload-beta.sh

pt.zip: chrome/manifest.json
	zip -r pt.zip chrome

clean:
	rm -rf locale www pt.zip
