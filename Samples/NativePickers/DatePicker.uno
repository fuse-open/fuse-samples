using Uno;
using Uno.Time;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Scripting;

namespace Native
{
	internal interface IDatePickerHost
	{
		void OnDateChanged(LocalDate date);
	}

	internal interface IDatePickerView
	{
		LocalDate CurrentDate { get; }
		void SetDate(LocalDate date);
		void SetMinDate(LocalDate date);
		void SetMaxDate(LocalDate date);
	}

	public partial class DatePicker : Panel, IDatePickerHost
	{
		IDatePickerView DatePickerView
		{
			get { return NativeView as IDatePickerView; }
		}

		void IDatePickerHost.OnDateChanged(LocalDate date)
		{
			// TODO: implement JS event
		}

		protected override IView CreateNativeView()
		{
			if defined(Android)
			{
				return new Native.Android.DatePicker(this);
			}
			else if defined(iOS)
			{
				return new Native.iOS.DatePicker(this);
			}
			else
			{
				return base.CreateNativeView();
			}
		}
	}
}