using Uno;
using Uno.Compiler.ExportTargetInterop;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;

namespace Native.Android
{
	extern(Android) class DatePicker : 
		Fuse.Controls.Native.Android.LeafView,
		IDatePickerView
	{

		IDatePickerHost _host;

		public DatePicker(IDatePickerHost host) : base(Create())
		{
			_host = host;
			Init(Handle, OnDateChanged);
		}

		public override void Dispose()
		{
			base.Dispose();
			_host = null;
		}

		void IDatePickerView.SetDate(int year, int month, int day)
		{
			SetDate(Handle, year, month, day);
		}

		void IDatePickerView.SetMinDate(int year, int month, int day)
		{
			SetMinDate(Handle, year, month, day);
		}

		void IDatePickerView.SetMaxDate(int year, int month, int day)
		{
			SetMaxDate(Handle, year, month, day);
		}

		Tuple<int,int,int> IDatePickerView.GetDate()
		{
			var date = new int[3];
			GetDate(Handle, date);
			return new Tuple<int,int,int>(date[0], date[1], date[2]);
		}

		void OnDateChanged(int year, int month, int day)
		{
			_host.OnDateChanged(year, month, day);
		}

		[Foreign(Language.Java)]
		static Java.Object Create()
		@{
			return new android.widget.DatePicker(@(Activity.Package).@(Activity.Name).GetRootActivity());
		@}

		[Foreign(Language.Java)]
		void Init(Java.Object datePickerHandle, Action<int,int,int> onDateChangedCallback)
		@{
			android.widget.DatePicker datePicker = (android.widget.DatePicker)datePickerHandle;
			java.util.Calendar c = java.util.Calendar.getInstance();

			int y = c.get(java.util.Calendar.YEAR);
			int m = c.get(java.util.Calendar.MONTH);
			int d = c.get(java.util.Calendar.DAY_OF_MONTH);

			datePicker.init(y, m, d, new android.widget.DatePicker.OnDateChangedListener() {

				public void onDateChanged(android.widget.DatePicker view, int year, int month, int day) {
					onDateChangedCallback.run(year, month, day);
				}

			});
		@}

		[Foreign(Language.Java)]
		void SetDate(Java.Object datePickerHandle, int year, int month, int day)
		@{
			android.widget.DatePicker datePicker = (android.widget.DatePicker)datePickerHandle;
			datePicker.updateDate(year, month, day);
		@}

		[Foreign(Language.Java)]
		void SetMinDate(Java.Object datePickerHandle, int year, int month, int day)
		@{
			android.widget.DatePicker datePicker = (android.widget.DatePicker)datePickerHandle;
			datePicker.updateDate(year, month, day);
		@}

		[Foreign(Language.Java)]
		void SetMaxDate(Java.Object datePickerHandle, int year, int month, int day)
		@{
			android.widget.DatePicker datePicker = (android.widget.DatePicker)datePickerHandle;
			datePicker.updateDate(year, month, day);
		@}

		[Foreign(Language.Java)]
		void GetDate(Java.Object datePickerHandle, int[] x)
		@{
			android.widget.DatePicker datePicker = (android.widget.DatePicker)datePickerHandle;
			x.set(0, datePicker.getYear());
			x.set(1, datePicker.getMonth());
			x.set(2, datePicker.getDayOfMonth());
		@}

	}
}

