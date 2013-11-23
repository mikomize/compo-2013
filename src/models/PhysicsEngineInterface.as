package models
{
	public interface PhysicsEngineInterface
	{
		function initialize(model:GameModel):void;
		function update(deltaTimeSeconds : Number):void;
	}
}