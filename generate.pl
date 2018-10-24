#!/usr/bin/perl

use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";
use pt qw(get_langs geturl setlocales);

my @langs = get_langs();

my $xml = new XML::Simple;

my $categories = $xml->XMLin("src/xml/categories.xml");

my $groups = $xml->XMLin("src/xml/groups.xml");

my $periods = $xml->XMLin("src/xml/periods.xml");

my $state = $xml->XMLin("src/xml/state.xml");

my $languages = $xml->XMLin("src/xml/languages.xml");

my @tableview = ();

my $location = undef;

my $OUT = "www";

GetOptions (
	"location=s" => \$location,
	"out=s" => \$OUT,
)
  or die("Error in command line arguments\n");

my $t = Template->new({
		INCLUDE_PATH => 'src',
		ENCODING => 'utf8',
		VARIABLES => {
     location => $location,
     langs => $languages->{lang},
		 version => $pt::VERSION
   },
});

foreach my $lang (@{$languages->{lang}}){

	setlocales($lang->{locales});

	my $msilang = lc($lang->{browser});

	if( ! -d "$OUT/$lang->{locales}" ){
		make_path("$OUT/$lang->{locales}");
	}

	my $locappname = __($pt::APPNAME);
	my @elements;

	my $nf = new Number::Format;

	for my $category (@{$categories->{category}}){

		my $data = $xml->XMLin("src/xml/$category->{'filename'}.xml");

		for my $element (@{$data->{element}}){
		 $element->{category} = $category;
		 $element->{url} = geturl($element, $lang->{locales});
		 $tableview["$element->{x}"]["$element->{y}"] = $element;

     for my $foo (keys %$element){
             if(looks_like_number($element->{$foo}) || $foo =~ /elcond/){
                    ( $element->{$foo} = $element->{$foo} ) =~ s/\./$nf->{decimal_point}/g;
             }
     }

		 $t->process('element.html',
			 { 'element' => $element,
				 'elementname' => "name_$lang->{locales}",
				 'state' => $state->{'state'},
				 'cur' => $category->{'filename'},
				 'cur_l' => $category->{'fullname'},
				 'lang' => $lang->{locales},
				 'sitelang' => $lang->{android},
				 title => $locappname
			 },
			 "$OUT/$lang->{locales}/".$element->{'url'}.".html",
			 { binmode => ':utf8' }) or die $t->error;

		 push(@elements,$element);
		}

	  my @sorted = sort {$a->{anumber} <=> $b->{anumber}} @{$data->{element}};
		$t->process('category.html',
			{ 'elements' => [@sorted],
				'cur' => $category->{'filename'},
				'cur_l' => $category->{'fullname'},
				'lang' => $lang->{locales},
				'title' => $locappname,
		  	'elementname' => "name_$lang->{locales}",
				 'sitelang' => $lang->{android},
				'categories' => $categories->{category}
			},
			"$OUT/$lang->{locales}/$category->{'filename'}.html",
			{ binmode => ':utf8' }) or die $t->error;

	}

	my @sortedbyname = sort {$a->{"name_$lang->{locales}"} cmp $b->{"name_$lang->{locales}"}} @elements;
	my @sortedbyanumber = sort {$a->{anumber} <=> $b->{anumber}} @elements;
	my @sortedbyln = sort {$a->{name_Latin} cmp $b->{name_Latin}} @elements;
	my @sortedbyam = sort {$a->{atomicmass} =~ s/,/./r <=> $b->{atomicmass} =~ s/,/./r} @elements;
	my $Collator = Unicode::Collate::Locale->new(locale => $lang->{locales});
	my @langsorted = sort {$Collator->cmp(decode('UTF-8',__($a->{fullname})), decode('UTF-8',__($b->{fullname})))} @{$languages->{lang}};
	my @categorysorted = sort {$Collator->cmp(decode('UTF-8',__($a->{fullname})), decode('UTF-8',__($b->{fullname})))} @{$categories->{category}};

	for my $group (@{$groups->{group}}){

		$t->process('group.html',
			{ 'elements' => [@sortedbyanumber],
				'cur' => $group->{'filename'},
				'cur_l' => $group->{'fullname'},
				'title' => $locappname,
		  	'elementname' => "name_$lang->{locales}",
				'groups' => $groups->{group},
			  'sitelang' => $lang->{android},
		  	'lang' => $lang->{locales},
			},
			"$OUT/$lang->{locales}/$group->{'filename'}.html",
			{ binmode => ':utf8' }) or die $t->error;
	}

	$t->process('index-an.html',
		{ 'elements' => [@sortedbyanumber],
			'title' => 'Atomic number',
		  'elementname' => "name_$lang->{locales}",
			'sitelang' => $lang->{android},
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/index-an.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('index-ln.html',
		{ 'elements' => [@sortedbyln],
			'title' => 'Latin name',
		  'elementname' => "name_$lang->{locales}",
			'sitelang' => $lang->{android},
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/index-ln.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('list.html',
		{ 'elements' => [@sortedbyln],
			'title' => $locappname,
		  'elementname' => "name_$lang->{locales}",
			'sitelang' => $lang->{android},
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/list.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('index-am.html',
		{ 'elements' => [@sortedbyam],
			'title' => 'Atomic mass',
		  'elementname' => "name_$lang->{locales}",
			'sitelang' => $lang->{android},
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/index-am.html",
		{ binmode => ':utf8' }) or die $t->error;

	for my $period (@{$periods->{period}}){
		$t->process('period.html',
			{ 'elements' => [@sortedbyanumber],
				'periods' => $periods->{period},
				'period' => $period->{'number'},
		  	'elementname' => "name_$lang->{locales}",
				'title' => $locappname,
			  'sitelang' => $lang->{android},
		  	'lang' => $lang->{locales},
			},
			"$OUT/$lang->{locales}/p$period->{'number'}.html",
			{ binmode => ':utf8' }) or die $t->error;
	}

	$t->process('period.html',
		{ 'periods' => $periods->{period},
			'title' => $locappname,
		  'elementname' => "name_$lang->{locales}",
			'sitelang' => $lang->{android},
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/p.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('category.html',
		{	'title' => $locappname,
		  'elementname' => "name_$lang->{locales}",
			'lang' => $lang->{locales},
			'sitelang' => $lang->{android},
			'categories' => [@categorysorted]
		},
		"$OUT/$lang->{locales}/category.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('group.html',
		{	'title' => $locappname,
			'groups' => $groups->{group},
			'sitelang' => $lang->{android},
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/group.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('about.html',
		{	'title' => $locappname . ' - ' . lc(__('About')),
			'sitelang' => $lang->{android},
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/about.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('download.html',
		{	'title' => $locappname . ' - ' . lc(__('Download')),
		  'langandroid' => $lang->{android},
		  'lang' => $lang->{locales},
		  'msilang' => $msilang,
			'sitelang' => $lang->{android},
		  'msiversion' => $pt::VERSION,
		},
		"$OUT/$lang->{locales}/download.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('mohs.html',
		{	'title' => 'Mohs scale',
			'sitelang' => $lang->{android},
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/mohs.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('language.html',
		{	'title' => 'Language',
			'languages' => [@langsorted],
			'sitelang' => $lang->{android},
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/language.html",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('manifest.json',
		{	'title' => decode('UTF-8',$locappname),
		  'lang' => $lang->{locales},
		},
		"$OUT/$lang->{locales}/manifest.json",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('tableview.html',
		{	'title' => $locappname,
		  'elements' => [@tableview],
			'categories' => [@{$categories->{category}}],
		 	'elementname' => "name_$lang->{locales}",
		  'lang' => $lang->{locales},
			'sitelang' => $lang->{android},
			'nohomelink' => 'true'
		},
		"$OUT/$lang->{locales}/index.html",
		{ binmode => ':utf8' }) or die $t->error;
}

setlocales();

$t->process('index.html',
	{ 
		'title' => $pt::APPNAME,
		'languages' => $languages->{lang},
		'sitelang' => 'en',
	},
	"$OUT/index.html",
	{ binmode => ':utf8' }) or die $t->error;

if($location){

	$t->process('redir.js',
		{ 
			'title' => $pt::APPNAME,
			'languages' => $languages->{lang},
			'sitelang' => 'en',
		},
		"$OUT/redir.js",
		{ binmode => ':utf8' }) or die $t->error;

	$t->process('language.js',
		{
			'title' => $pt::APPNAME,
			'languages' => $languages->{lang},
			'sitelang' => 'en',
		},
		"$OUT/language.js",
		{ binmode => ':utf8' }) or die $t->error;


	$t->process('404.html',
		{ 
			'title' => 'Not found',
			'sitelang' => 'en',
		},
		"$OUT/404.html",
		{ binmode => ':utf8' }) or die $t->error;

	copy("src/robots.txt", "$OUT/robots.txt");
	copy("src/browserconfig.xml", "$OUT/browserconfig.xml");
}

foreach my $dir (('css', 'img')){
	foreach my $file (glob("src/$dir/*")){
		my ($name,$path) = fileparse($file);
		copy("$path$name", "$OUT/$name");
	}
}
