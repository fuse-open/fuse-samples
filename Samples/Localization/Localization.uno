using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;

using Uno.Compiler.ExportTargetInterop;

public class Localization : NativeModule
{
	public Localization()
	{
		AddMember( new NativeFunction("getCurrentLocale", (NativeCallback)GetCurrentLocale) );
	}

	object GetCurrentLocale(Context c, object[] args)
	{
		// GetCurrentLocale will return:
		// from iOS: [language designator]-[script designator]-[region designator] (e.g. zh-Hans-US, en-US, etc.)
		// from Android: [two-leter lowercase language code (ISO 639-1)]_[two-letter uppercase country codes (ISO 3166-1)] (e.g. zh_CN, en_US, etc.)
		return GetCurrentLocale();
	}

	[Foreign(Language.Java)]
	static extern(Android) string GetCurrentLocale()
	@{
		// http://developer.android.com/reference/java/util/Locale.html
		// The language codes are two-letter lowercase ISO language codes (such as "en") as defined by ISO 639-1.
		// The country codes are two-letter uppercase ISO country codes (such as "US") as defined by ISO 3166-1.
		// The variant codes are unspecified.
		// Something like "de_US" for "German as spoken in the US" is possible
		return java.util.Locale.getDefault().toString();
	@}

	[Foreign(Language.ObjC)]
	static extern(iOS) string GetCurrentLocale()
	@{
		// This can return [language designator]-[script designator]-[region designator] (e.g. zh-Hans-US, en-US, etc.)
		// https://developer.apple.com/library/ios/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html
		// iOS9+ now supports smarter language fallbacks
		// https://developer.apple.com/library/ios/technotes/tn2418/_index.html
		return [[NSLocale preferredLanguages] objectAtIndex:0];
	@}

	static extern(!(iOS||Android)) string GetCurrentLocale()
	{
		// return the preferred language for unimplemented platforms
		return "Default";
	}
}