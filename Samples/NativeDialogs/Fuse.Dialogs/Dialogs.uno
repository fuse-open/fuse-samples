using Uno;
using Uno.UX;
using Uno.Threading;
using Uno.Compiler.ExportTargetInterop;
using Fuse.Scripting;

namespace Fuse.Dialogs
{

	public class DialogModule : NativeModule
	{
		public DialogModule()
		{
			AddMember(new NativeFunction("show", (NativeCallback)Show));
		}

		static object[] Show(Context c, object[] args)
		{
			if (args.Length == 0)
				return null;

			var config = (args[0] is Fuse.Scripting.Object) ? (Fuse.Scripting.Object)args[0] : null;

			if (config == null)
				return null;

			var title = config.ContainsKey("title")
				? config["title"] as string
				: null;

			var message = config.ContainsKey("message")
				? config["message"] as string
				: null;

			var positiveButton = config.ContainsKey("positiveButton")
				? CreateButton(c.Dispatcher, config["positiveButton"] as Fuse.Scripting.Object)
				: null;

			var negativeButton = config.ContainsKey("negativeButton")
				? CreateButton(c.Dispatcher, config["negativeButton"] as Fuse.Scripting.Object)
				: null;

			UpdateManager.PostAction(
				new ShowDialogClosure(title, message, positiveButton, negativeButton).Show);

			return null;
		}

		class ShowDialogClosure
		{
			readonly string _title;
			readonly string _message;
			readonly DialogButton _positiveButton;
			readonly DialogButton _negativeButton;

			public ShowDialogClosure(
				string title,
				string message,
				DialogButton positiveButton,
				DialogButton negativeButton)
			{
				_title = title;
				_message = message;
				_positiveButton = positiveButton;
				_negativeButton = negativeButton;
			}

			public void Show()
			{
				var builder = DialogBuilder.Create();

				if (_title != null)
					builder.Title = _title;

				if (_message != null)
					builder.Message = _message;

				if (_positiveButton != null)
					builder.PositiveButton = _positiveButton;

				if (_negativeButton != null)
					builder.NegativeButton = _negativeButton;

				builder.MakeDialog().Show();	
			}

		}

		static DialogButton CreateButton(IDispatcher dispatcher, Fuse.Scripting.Object obj)
		{
			if (obj == null)
				return null;

			var text = obj.ContainsKey("text")
				? obj["text"] as string
				: null;

			var callback = obj.ContainsKey("callback")
				? obj["callback"] as Function
				: null;

			return new DialogButton(text ?? "", new CallbackClosure(dispatcher, callback).Invoke);
		}

		class CallbackClosure
		{
			readonly IDispatcher _dispatcher;
			readonly Function _function;

			public CallbackClosure(IDispatcher dispatcher, Function function)
			{
				_dispatcher = dispatcher;
				_function = function;
			}

			public void Invoke()
			{
				_dispatcher.Invoke(InvokeFunction);
			}

			void InvokeFunction()
			{
				if (_function != null)
					_function.Call();
			}

		}

	}

	public abstract class Dialog
	{
		public abstract void Show();
		public abstract void Hide();
	}

	public class DialogButton
	{
		public readonly string Text;
		public readonly Action Callback;

		public DialogButton(string text, Action callback)
		{
			Text = text;
			Callback = callback;
		}
	}

	public abstract class DialogBuilder
	{
		public static DialogBuilder Create()
		{
			if defined(Android) return new AndroidDialogBuilder();
			if defined(iOS) return new iOSDialogBuilder();

			throw new Exception("Platform not supported");
		}

		public Optional<string> Title { get; set; }
		public Optional<string> Message { get; set; }
		public Optional<DialogButton> PositiveButton { get; set; }
		public Optional<DialogButton> NegativeButton { get; set; }

		protected DialogBuilder()
		{
			Title = Optional.None<string>();
			Message = Optional.None<string>();
			PositiveButton = Optional.None<DialogButton>();
			NegativeButton = Optional.None<DialogButton>();
		}

		public abstract Dialog MakeDialog();
	}

	extern(iOS) internal class iOSDialogBuilder : DialogBuilder
	{
		class iOSDialog : Dialog
		{
			public override void Show() { }
			public override void Hide() { }
		}

		public override Dialog MakeDialog()
		{
			if (Title.HasValue) { }
			if (Message.HasValue) { }
			if (PositiveButton.HasValue) { }
			if (NegativeButton.HasValue) { }
			return new iOSDialog();
		}		
	}

	extern(Android) internal class AndroidDialogBuilder : DialogBuilder
	{

		class AndroidDialog : Dialog
		{
			readonly Java.Object _dialogHandle;

			public AndroidDialog(Java.Object dialogHandle)
			{
				_dialogHandle = dialogHandle;
			}

			public override void Show()
			{
				Show(_dialogHandle);
			}

			public override void Hide()
			{
				Hide(_dialogHandle);
			}

			[Foreign(Language.Java)]
			static void Show(Java.Object handle)
			@{
				((android.app.AlertDialog)handle).show();
			@}

			[Foreign(Language.Java)]
			static void Hide(Java.Object handle)
			@{
				((android.app.AlertDialog)handle).hide();
			@}
		}

		public override Dialog MakeDialog()
		{
			var handle = CreateAlertDialogBuilder();

			if (Title.HasValue)
				SetTitle(handle, Title.Value);

			if (Message.HasValue)
				SetMessage(handle, Message.Value);

			if (PositiveButton.HasValue)
				SetPositiveButton(handle, PositiveButton.Value.Text, PositiveButton.Value.Callback);

			if (NegativeButton.HasValue)
				SetNegativeButton(handle, NegativeButton.Value.Text, NegativeButton.Value.Callback);

			return new AndroidDialog(CreateAlertDialog(handle));
		}

		static void OnPositiveButtonClicked(object callback)
		{
			if (callback is Action)
				((Action)callback)();
		}

		static void OnNegativeButtonClicked(object callback)
		{
			if (callback is Action)
				((Action)callback)();
		}

		[Foreign(Language.Java)]
		static Java.Object CreateAlertDialogBuilder()
		@{
			return new android.app.AlertDialog.Builder(@(Activity.Package).@(Activity.Name).GetRootActivity());
		@}

		[Foreign(Language.Java)]
		static Java.Object CreateAlertDialog(Java.Object handle)
		@{
			return ((android.app.AlertDialog.Builder)handle).create();
		@}

		[Foreign(Language.Java)]
		static void SetTitle(Java.Object handle, string title)
		@{
			((android.app.AlertDialog.Builder)handle).setTitle(title);
		@}

		[Foreign(Language.Java)]
		static void SetMessage(Java.Object handle, string message)
		@{
			((android.app.AlertDialog.Builder)handle).setMessage(message);
		@}

		[Foreign(Language.Java)]
		static void SetPositiveButton(Java.Object handle, string text, Action callback)
		@{
			final Object callbackStore = callback;
			((android.app.AlertDialog.Builder)handle).setPositiveButton(text, new android.content.DialogInterface.OnClickListener() {
					public void onClick(android.content.DialogInterface dialog, int which) {
						@{OnPositiveButtonClicked(object):Call(callbackStore)};
					}
				});
		@}

		[Foreign(Language.Java)]
		static void SetNegativeButton(Java.Object handle, string text, Action callback)
		@{
			final Object callbackStore = callback;
			((android.app.AlertDialog.Builder)handle).setNegativeButton(text, new android.content.DialogInterface.OnClickListener() {
					public void onClick(android.content.DialogInterface dialog, int which) {
						@{OnNegativeButtonClicked(object):Call(callbackStore)};	
					}
				});
		@}

	}

}