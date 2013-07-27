function upperCase(text) {
	return text.toUpperCase();
}

function getAuthor() {
	return document.getElementById('authortag').getAttribute('last').toUpperCase();
}

Prince.addScriptFunc("upperCase", upperCase);
Prince.addScriptFunc("getAuthor", getAuthor);