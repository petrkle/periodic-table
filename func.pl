use strict;
use warnings;

$Template::Stash::ROOT_OPS->{ 'l' }    = sub {
	return decode('UTF-8', __(shift));
};

$Template::Stash::ROOT_OPS->{ 'url' }    = sub {
	return geturl(shift, shift); 
};

sub get_langs{
	my @langs = ();
	my @files = glob("po/*.po");
	foreach my $foo(@files){
		push(@langs, basename($foo, ('.po')));
	}
	return @langs;
}

sub geturl {
	my $element = shift;
	my $lang = shift;
	my $converter = Text::Iconv->new("UTF-8", "ASCII//TRANSLIT");
	return lc($converter->convert($element->{"name_$lang"}));
}

sub setlocales {
	my $lang = shift || 'en_US';
	nl_putenv("LANGUAGE=$lang.UTF-8");
	nl_putenv("LANG=$lang.UTF-8");
	nl_putenv("LC_COLLATE=$lang");
	setlocale(LC_ALL, $lang.".UTF-8");
	setlocale(LC_COLLATE, $lang.".UTF-8");
}

1;
