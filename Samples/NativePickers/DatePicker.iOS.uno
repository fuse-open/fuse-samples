using Uno;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;

namespace Native.iOS
{
	[Require("Source.Include", "UIKit/UIKit.h")]
	extern(iOS) class DatePicker : 
		Fuse.Controls.Native.iOS.LeafView,
		IDatePickerView
	{

		IDatePickerHost _host;
		IDisposable _valueChangedEvent;

		public DatePicker(IDatePickerHost host) : base(Create())
		{
			_host = host;
			_valueChangedEvent = UIControlEvent.AddValueChangedCallback(Handle, OnDateChanged);
		}

		public override void Dispose()
		{
			base.Dispose();
			_valueChangedEvent.Dispose();
			_valueChangedEvent = null;
			_host = null;
		}

		void OnDateChanged(ObjC.Object sender, ObjC.Object args)
		{
			int year = 0;
			int month = 0;
			int day = 0;
			GetDate(Handle, out year, out month, out day);
			_host.OnDateChanged(year, month, day);
		}

		void IDatePickerView.SetDate(int year, int month, int day)
		{
			SetDate(Handle, MakeNSDate(year, month, day));
		}

		void IDatePickerView.SetMinDate(int year, int month, int day)
		{
			SetMinDate(Handle, MakeNSDate(year, month, day));
		}

		void IDatePickerView.SetMaxDate(int year, int month, int day)
		{
			SetMaxDate(Handle, MakeNSDate(year, month, day));
		}

		Tuple<int,int,int> IDatePickerView.GetDate()
		{
			int year = 0;
			int month = 0;
			int day = 0;
			GetDate(Handle, out year, out month, out day);
			return new Tuple<int,int,int>(year, month, day);
		}

		[Foreign(Language.ObjC)]
		static ObjC.Object Create()
		@{
			return [[UIDatePicker alloc] init];
		@}

		[Foreign(Language.ObjC)]
		void GetDate(ObjC.Object handle, out int year, out int month, out int day)
		@{
			UIDatePicker* dp = (UIDatePicker*)handle;
			NSDate* date = [dp date];
			NSCalendar* calendar [NSCalendar currentCalendar];
			NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date]; 

			*year = [components year];
			*month = [components month];
			*day = [components day];
		@}

		[Foreign(Language.ObjC)]
		ObjC.Object MakeNSDate(int year, int month, int day)
		@{
			NSDateComponents* components = [[NSDateComponents alloc] init];

			[components setYear:year];
			[components setMonth:month];
			[components setDay:day];

			NSCalendar* calendar = [[NSCalendar alloc] initWithCalendaIdentifier:NSGregorianCalendar];
			NSDate* date = [cal dateFromComponents:components];
			[components release];

			return date;
		@}

		[Foreign(Language.ObjC)]
		void SetDate(ObjC.Object handle, ObjC.Object nsDateHandle)
		@{
			UIDatePicker* dp = (UIDatePicker*)handle;
			NSDate* date = (NSDate*)nsDateHandle;
			[dp setDate:date animated:true];
		@}

		[Foreign(Language.ObjC)]
		void SetMinDate(ObjC.Object handle, ObjC.Object nsDateHandle)
		@{
			UIDatePicker* dp = (UIDatePicker*)handle;
			NSDate* date = (NSDate*)nsDateHandle;
			[dp setMaximumDate:date];
		@}

		[Foreign(Language.ObjC)]
		void SetMaxDate(ObjC.Object handle, ObjC.Object nsDateHandle)
		@{
			UIDatePicker* dp = (UIDatePicker*)handle;
			NSDate* date = (NSDate*)nsDateHandle;
			[dp setMinimumDate:date];
		@}

	}

	[Require("Source.Include", "UIKit/UIKit.h")]
	[Require("Source.Include", "UIControlEvent.h")]
	extern(iOS) class UIControlEvent : IDisposable
	{
		public static IDisposable AddValueChangedCallback(ObjC.Object uiControl, Action<ObjC.Object, ObjC.Object> handler)
		{
			return new UIControlEvent(uiControl, handler, extern<int>"(int)UIControlEventValueChanged");
		}

		ObjC.Object _handle;
		ObjC.Object _uiControl;
		readonly int _type;

		UIControlEvent(ObjC.Object uiControl, Action<ObjC.Object, ObjC.Object> handler, int type)
		{
			_handle = Create(uiControl, handler, type);
			_uiControl = uiControl;
			_type = type;
		}

		[Foreign(Language.ObjC)]
		static ObjC.Object Create(ObjC.Object uiControl, Action<ObjC.Object, ObjC.Object> handler, int type)
		@{
			UIControlEventHandler* h = [[UIControlEventHandler alloc] init];
			[h setCallback:handler];
			UIControl* control = (UIControl*)uiControl;
			[control addTarget:h action:@selector(action:forEvent:) forControlEvents:(UIControlEvents)type];
			return h;
		@}

		void IDisposable.Dispose()
		{
			RemoveHandler(_uiControl, _handle, _type);
			_handle = null;
			_uiControl = null;
		}

		[Foreign(Language.ObjC)]
		static void RemoveHandler(ObjC.Object uiControl, ObjC.Object eventHandler, int type)
		@{
			UIControlEventHandler* h = (UIControlEventHandler*)eventHandler;
			UIControl* control = (UIControl*)uiControl;
			[control removeTarget:h action:@selector(action:forEvent:) forControlEvents:(UIControlEvents)type];
		@}

	}
}