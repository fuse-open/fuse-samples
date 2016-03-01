using Uno;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;

namespace ForeignAccelerometer
{
	[Require("Source.Include", "AccelerometerImpl.hh")]
	extern(iOS)
	class Accelerometer_iOS
	{
		extern(iOS) ObjC.Object _impl;

		public Accelerometer_iOS(AccelerometerUpdatedInternal updateDelegate)
		{
			Init(updateDelegate);
		}

		[Foreign(Language.ObjC)]
		protected extern(iOS) void Init(AccelerometerUpdatedInternal updateDelegate)
		@{
			AccelerometerImpl *impl = [[AccelerometerImpl alloc] initWithCallback: ^(float x, float y, float z) {
				// Normalize acceleration to include gravity
				x *= 9.81;
				y *= 9.81;
				z *= 9.81;

				updateDelegate(x, y, z);
			}];
			@{Accelerometer_iOS:Of(_this)._impl:Set(impl)};
		@}

		[Foreign(Language.ObjC)]
		public extern(iOS) void Start()
		@{
			AccelerometerImpl *impl = (AccelerometerImpl *) @{Accelerometer_iOS:Of(_this)._impl:Get()};
			[impl start];
		@}

		[Foreign(Language.ObjC)]
		public extern(iOS) void Stop()
		@{
			AccelerometerImpl *impl = (AccelerometerImpl *) @{Accelerometer_iOS:Of(_this)._impl:Get()};
			[impl stop];
		@}
	}
}
