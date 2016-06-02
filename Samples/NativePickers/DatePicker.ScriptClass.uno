using Uno;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Scripting;

namespace Native
{
	public partial class DatePicker
	{
		static DatePicker()
		{
			ScriptClass.Register(typeof(DatePicker),
				new ScriptMethod<DatePicker>("setDate", setDate, ExecutionThread.MainThread),
				new ScriptMethod<DatePicker>("setMinDate", setDate, ExecutionThread.MainThread),
				new ScriptMethod<DatePicker>("setMaxDate", setDate, ExecutionThread.MainThread),
				new ScriptMethod<DatePicker>("getDate", getDate, ExecutionThread.MainThread));
		}

		static void setDate(DatePicker datePicker, object[] args)
		{
			if (args.Length != 3)
			{
				Fuse.Diagnostics.UserError("DatePicker.setDate requires 3 arguments. (year, month day)", datePicker);
				return;
			}
			var dpv = datePicker.DatePickerView;
			if (dpv != null)
				dpv.SetDate(Marshal.ToInt(args[0]), Marshal.ToInt(args[1]), Marshal.ToInt(args[2]));
		}

		static void setMinDate(DatePicker datePicker, object[] args)
		{
			if (args.Length != 3)
			{
				Fuse.Diagnostics.UserError("DatePicker.setMinDate requires 3 arguments. (year, month day)", datePicker);
				return;
			}
			var dpv = datePicker.DatePickerView;
			if (dpv != null)
				dpv.SetMinDate(Marshal.ToInt(args[0]), Marshal.ToInt(args[1]), Marshal.ToInt(args[2]));
		}

		static void setMaxDate(DatePicker datePicker, object[] args)
		{
			if (args.Length != 3)
			{
				Fuse.Diagnostics.UserError("DatePicker.setMaxDate requires 3 arguments. (year, month day)", datePicker);
				return;
			}
			var dpv = datePicker.DatePickerView;
			if (dpv != null)
				dpv.SetMaxDate(Marshal.ToInt(args[0]), Marshal.ToInt(args[1]), Marshal.ToInt(args[2]));
		}

		static object getDate(DatePicker datePicker, object[] args)
		{
			var dpv = datePicker.DatePickerView;
			if (dpv != null)
			{
				var d = dpv.GetDate();
				return new [] { d.Item1, d.Item2, d.Item3 };
			}
			return null;
		}
	}
}