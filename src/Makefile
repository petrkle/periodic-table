all:
	[% FOREACH lang IN languages %]$(MAKE) -f Makefile.[% lang.browser FILTER lower %]
	[% END -%]
