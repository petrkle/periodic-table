[% FOREACH loc IN languages -%]

var element[% loc.locales %] = document.getElementById('[% loc.locales %]');
element[% loc.locales %].onclick = function () {
	localStorage.setItem('lang', '[% loc.android %]');
	window.location='../[% loc.locales %]/index.html';
};

[% END -%]

var elementdefault = document.getElementById('defaultlanguage');

elementdefault.onclick = function () {
	localStorage.removeItem('lang');
	window.location='../index.html'
};
