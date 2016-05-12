var Localization = require("Localization");

// *******************************************
// Localization.getCurrentLocale() will return:
// from iOS: [language designator]-[script designator]-[region designator] (e.g. zh-Hans-US, en-US, etc.)
// from Android: [two-leter lowercase language code (ISO 639-1)]_[two-letter uppercase country codes (ISO 3166-1)] (e.g. zh_CN, en_US, etc.)
// *******************************************
var deviceLocale = Localization.getCurrentLocale().split('-');
// Turns "zh-Hans-US" into "zh-Hans" or "en-GB" into "en", this might not a practical solution for your own app's requirements
deviceLocale = deviceLocale.slice( 0, deviceLocale.length === 3 ? 2 : 1 ).join('-');

var defaultLocale = { language: "en", code: "en_US" };
var supportedLocales = [
	{ language: "zh", 		code: "zh_CN" },
	{ language: "zh_CN", 	code: "zh_CN" },
	{ language: "zh-Hans", 	code: "zh_CN" },
	{ language: "zh_TW", 	code: "zh_TW" },
	{ language: "zh-Hant", 	code: "zh_TW" },
	{ language: "ko", 		code: "ko_KR" },
	{ language: "ko_KR", 	code: "ko_KR" }
];

function findLanguage(obj) {
	return obj.language.toLowerCase() === deviceLocale.toLowerCase();
}

var locale = supportedLocales.find(findLanguage) || defaultLocale;

module.exports = {
	locale: locale.code,
	deviceLocale: deviceLocale
};