MO_PATH=../locale/

compile:
	@for i in $$(ls *.po); do \
	    mkdir -p $(MO_PATH)$${i%.po}/LC_MESSAGES ; \
	    msgfmt $$i -o $(MO_PATH)$${i%.po}/LC_MESSAGES/ptable.mo; \
	done
