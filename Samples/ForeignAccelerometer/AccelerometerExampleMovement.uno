using Uno;
using Uno.Collections;
using Uno.UX;
using Fuse;
using Fuse.Elements;
using ForeignAccelerometer;

public partial class AccelerometerExampleMovement : Behavior
{
	public InteractiveTransform Target { get; private set; }
	
	void AccUpdated(object sender, AccelerometerUpdatedArgs args)
	{
		float3 acceleration = args.Value;
		
		Target.Translation = acceleration.XY * 10;
		Target.ZoomFactor = acceleration.Z * 0.2f + 0.2f;
	}
	
	Accelerometer _accelerometer;

	[UXConstructor]
	public AccelerometerExampleMovement([UXParameter("Target")] InteractiveTransform target)
	{
		Target = target;
		_accelerometer = new Accelerometer();
	}
	
	protected override void OnRooted()
	{
		base.OnRooted();
		_accelerometer.Updated += AccUpdated;
		_accelerometer.Start();
	}

	protected override void OnUnrooted()
	{
		_accelerometer.Stop();
		_accelerometer.Updated -= AccUpdated;
		base.OnUnrooted();
	}
}