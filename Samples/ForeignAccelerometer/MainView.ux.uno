using Uno;
using Uno.Collections;
using Fuse;
using ForeignAccelerometer;

public partial class MainView
{
	void AccUpdated(object sender, AccelerometerUpdatedArgs args)
	{
		float3 acceleration = args.Value;
		this.myCircle.Offset = acceleration.XY * 10;
		this.circleScale.Factor = acceleration.Z * 0.2f + 0.2f;
	}

	public MainView() {
		InitializeUX();

		Accelerometer sensor = new Accelerometer();
		sensor.Updated += AccUpdated;
		sensor.Start();
	}
}
