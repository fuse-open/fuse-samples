using Uno;
using Uno.Collections;
using Fuse;
using ForeignAccelerometer;

public partial class MainView
{
	void AccUpdated(object sender, AccelerometerUpdatedArgs args)
	{
		float3 acc = args.Value;
		this.myCircle.Offset = float2(acc.X, acc.Y) * -10;
	}

	public MainView() {
		InitializeUX();

		Accelerometer sensor = new Accelerometer();
		sensor.Updated += AccUpdated;
		sensor.Start();
	}
}