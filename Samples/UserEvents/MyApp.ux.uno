using Uno;
using Uno.UX;

using Fuse;

public partial class MyApp
{
	void OnBump(object s, UserEventArgs args)
	{
		debug_log "Bump";
		if (args.Args == null)
			return;
			
		foreach (var arg in args.Args)
			debug_log arg.Key + ": " + arg.Value;
	}
}

