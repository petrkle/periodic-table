function splash() {
	
	var language = '';
	if ( navigator && navigator.userAgent && (language = navigator.userAgent.match(/android.*\W(\w\w)-(\w\w)\W/i))){
					language = language[1];
	}

	if (!language && navigator) {
					if (navigator.language) {
									language = navigator.language;
					} else if (navigator.browserLanguage) {
									language = navigator.browserLanguage;
					} else if (navigator.systemLanguage) {
									language = navigator.systemLanguage;
					} else if (navigator.userLanguage) {
									language = navigator.userLanguage;
					}
					language = language.substr(0, 2);
	}

	if(typeof(Storage)!=="undefined"){
		if (localStorage.getItem('lang') != null) {
			language = localStorage.getItem('lang');
		}
	}

	switch (language) {
[% FOREACH loc IN languages -%]
		case '[% loc.android -%]':
			redir('[% loc.locales -%]');
			break;
		case '[% loc.browser -%]':
			redir('[% loc.locales -%]');
			break;
[% END -%]
		default:
			redir('en_US');
			break;
	}
};

function redir(lang){
		window.location.replace(lang + "/index.html");
}

splash();
