#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use pt qw(get_langs geturl setlocales);

my $OUT = "msi";

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
		{	'title' => $pt::APPNAME,
			'lang' => $msilang,
		  'version' => $pt::MSIVERSION,
		},
		"$OUT/$msilang.conf",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('msi.wxl',
		{	'title' => $pt::APPNAME,
			'lang' => $msilang,
		},
		"$OUT/$msilang.wxl",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('Makefile.local',
		{	'title' => $pt::APPNAME,
		  'lang' => $msilang,
		  'version' => $pt::MSIVERSION,
		},
		"$OUT/Makefile.$msilang",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('shortcuts.xsl',
		{	'title' => $pt::APPNAME,
		  'lang' => $lang->{locales},
		},
		"$OUT/shortcuts-$msilang.xsl",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('pt.kle.cz.wxs',
		{	'title' => $pt::APPNAME,
		  'msiguid' => $pt::MSIGUID,
		  'lang' => $msilang,
		},
		"$OUT/pt.kle.cz-$msilang.wxs",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('components.xsl',
		{	'title' => $pt::APPNAME,
		  'lang' => $msilang,
		},
		"$OUT/components-$msilang.xsl",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('files.xsl',
		{	'title' => $pt::APPNAME,
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
