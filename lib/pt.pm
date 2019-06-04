use utf8;
use locale;

use autodie qw(:all);
use Template;
use Template::Stash;
use XML::Simple;
use File::Copy;
use File::Path qw(make_path);
use File::Basename;
use Locale::TextDomain ( 'ptable' ,  './locale/' );
use Encode;
use Number::Format;
use Unicode::Collate::Locale;
use Scalar::Util qw(looks_like_number);
Locale::Messages->select_package ('gettext_pp');
use Getopt::Long;

$Template::Stash::ROOT_OPS->{ 'l' }    = sub {
	return decode('UTF-8', sprintf __ shift, shift);
};

$Template::Stash::ROOT_OPS->{ 'url' }    = sub {
	return geturl(shift, shift); 
};

package pt;
use strict;
use warnings;
use POSIX qw (setlocale LC_ALL LC_COLLATE);
use Locale::Messages qw (nl_putenv);
use Exporter qw(import);
 
our @EXPORT_OK = qw(get_langs geturl setlocales);

our $VERSION = '19.06.0501';
our $MSIGUID = '196a8ed2-1218-4a02-8d29-3a3c93f22fb5';
our $APPNAME = 'Periodic Table';

sub get_langs{
	my @langs = ();
	my @files = glob("../po/*.po");
	foreach my $foo(@files){
		push(@langs, basename($foo, ('.po')));
	}
	return @langs;
}

sub geturl {
	my $element = shift;
	my $lang = shift;
	if ($lang =~ /(ru_RU|be_BY|uk_UA|zh_CN|ja_JP)/){
		$lang = 'Latin';
	}
	use Text::Unidecode qw(unidecode);
	return lc(unidecode($element->{"name_$lang"}));
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
