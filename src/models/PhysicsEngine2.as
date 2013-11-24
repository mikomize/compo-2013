package models
{
	import flash.geom.Point;
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;

	public class PhysicsEngine2 extends PhysicsEngine1
	{
		public function PhysicsEngine2()
		{
			super();
		}
		
		private static const PLAYER_AIR_CONTROL_SPEED:int = 4;
		private static const PLAYER_GROUND_CONTROL_SPEED:int = 10;
		
		override protected function getPlayerFriction():Number
		{
			return 1;
		}
		
		override protected function getTileFriction():Number
		{
			return 1;
		}
		
		override protected function getPlayerDampening():Number
		{
			return 2;
		}
		
		override protected function getGravity():b2Vec2
		{
			return new b2Vec2 (0.0, -15.81);
		}
		
		override protected function getPlayerJumpImpulse():Number
		{
			return 100;
		}
		
		private function setSpeed(body:b2Body, v:b2Vec2):void
		{
			var currentV:b2Vec2 = body.GetLinearVelocity();
			if (v.x > 0 && v.x > currentV.x ||  v.x < 0 && v.x < currentV.x) {
				currentV.x = v.x;
				body.SetLinearVelocity(currentV);
			}
		}
		
		override protected function _processPlayersIntentions():void
		{
			
			for(var index:Number=0;index<2;++index){
				var body:b2Body = _playerBodies[index];
				var position:b2Vec2=body.GetPosition();
				var velocity:b2Vec2=body.GetLinearVelocity();
				var player:PlayerA = this.getPlayer(index);
				var direction:Point = player.getIntendedDirection();
				var contactDirections:Array = getContactDirections(body);
				if(direction.x || direction.y){
					for(var d:Number=0;d<4;++d){
						var dx:Number=DX[d];
						var dy:Number=DY[d];
						var adx:Number=Math.abs(dx)*direction.x;
						var ady:Number=Math.abs(dy)*direction.y;
						var v:b2Vec2=new b2Vec2(adx,ady);
						
						if(direction.x*dx+direction.y*dy >0){
							if(contactDirections[(d+2)%4]){
								//JUMP
								var jumpVelocity:Number = velocity.x*dx + velocity.y*dy;
								if(jumpVelocity < FORBID_JUMP_VELOCITY){
									v.Multiply(getPlayerJumpImpulse());
									body.ApplyImpulse(v,position);
								}else{
									trace("FORBIDEN JUMP");
								}
							}else if(contactDirections[(d+1)%4] || contactDirections[(d+3)%4]){
								//WALK
								if (v.y == 0) {
									v.Multiply(PLAYER_GROUND_CONTROL_SPEED);
									setSpeed(body, v);
								} else {
									v.Multiply(WALK_FORCE);
									body.ApplyForce(v,position);
								}
							}else{
								//FLY
								if (v.y == 0) {
									v.Multiply(PLAYER_AIR_CONTROL_SPEED);
									setSpeed(body, v);
								} else {
									v.Multiply(FLY_FORCE);
									body.ApplyForce(v,position);
								}
							}
						}
					}
				}
			}
		}
	}
}