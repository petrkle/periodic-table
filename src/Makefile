all:
	[% FOREACH lang IN languages %]$(MAKE) -f Makefile.[% lang.browser FILTER lower %]
	[% END -%]

clean:
	del /F /Q *.wixobj *.wixpdb *.msi *.exe *.7z components*.wxs files*.wxs
