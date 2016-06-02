using Uno;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Scripting;

namespace Native
{
	internal interface IDatePickerHost
	{
		void OnDateChanged(int year, int month, int day);
	}

	internal interface IDatePickerView
	{
		Tuple<int,int,int> GetDate();
		void SetDate(int year, int month, int day);
		void SetMinDate(int year, int month, int day);
		void SetMaxDate(int year, int month, int day);
	}

	public partial class DatePicker : Panel, IDatePickerHost
	{
		IDatePickerView DatePickerView
		{
			get { return NativeView as IDatePickerView; }
		}

		void IDatePickerHost.OnDateChanged(int year, int month, int day)
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