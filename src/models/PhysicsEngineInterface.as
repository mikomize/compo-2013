package models
{
	public interface PhysicsEngineInterface
	{
		function initialize():void;
		function update(deltaTimeSeconds : Number):void;
	}
}