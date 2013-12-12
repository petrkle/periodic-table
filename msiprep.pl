#!/usr/bin/perl

use strict;
use warnings;
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
use POSIX qw (setlocale LC_ALL LC_COLLATE);
use Locale::Messages qw (nl_putenv);
use Encode;
use Text::Iconv;
Locale::Messages->select_package ('gettext_pp');
require './func.pl';

my $OUT = "msi";

my $appname = "Periodic Table";

my $msiversion = "13.12.1201";

my $xml = new XML::Simple;

my $languages = $xml->XMLin("src/xml/languages.xml");

my $t = Template->new({
		INCLUDE_PATH => 'src',
		ENCODING => 'utf8',
});

foreach my $lang(@{$languages->{lang}}){

	setlocales($lang->{locales});

	my $msilang = lc($lang->{browser});

	$t->process('exe.conf',
		{	'title' => $appname,
			'lang' => $msilang,
		  'version' => $msiversion,
		},
		"$OUT/$msilang.conf",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('msi.wxl',
		{	'title' => $appname,
			'lang' => $msilang,
		},
		"$OUT/$msilang.wxl",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('Makefile.local',
		{	'title' => $appname,
		  'lang' => $msilang,
		  'version' => $msiversion,
		},
		"$OUT/Makefile.$msilang",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('shortcuts.xsl',
		{	'title' => $appname,
		  'lang' => $lang->{locales},
		},
		"$OUT/shortcuts-$msilang.xsl",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('pt.kle.cz.wxs',
		{	'title' => $appname,
		  'lang' => $msilang,
		},
		"$OUT/pt.kle.cz-$msilang.wxs",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('components.xsl',
		{	'title' => $appname,
		  'lang' => $msilang,
		},
		"$OUT/components-$msilang.xsl",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('files.xsl',
		{	'title' => $appname,
		  'lang' => $msilang,
		},
		"$OUT/files-$msilang.xsl",
		{ binmode => ':utf8' }) or die $t->error;
}

setlocales();

$t->process('Makefile',
	{	
		'languages' => [@{$languages->{lang}}],
	},
	"$OUT/Makefile",
	{ binmode => ':utf8' }) or die $t->error;
