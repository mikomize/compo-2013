package models
{
	public interface PhysicsEngineInterface
	{
		public function initialize(model:GameModel);
		public function update(deltaTimeSeconds : float);
	}
}