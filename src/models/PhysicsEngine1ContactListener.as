package models
{
	import Box2D.Collision.b2ContactPoint;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2ContactResult;
	import Box2D.Dynamics.b2ContactListener;
	
	public class PhysicsEngine1ContactListener extends b2ContactListener
	{
		public function PhysicsEngine1ContactListener()
		{
			super();
		}
		private function direction(n:b2Vec2 ):Number{
			if(Math.abs(n.x)>Math.abs(n.y)){
				if(n.x<0){
					return 0;
				}else{
					return 2;
				}
			}else{
				if(n.y<0){
					return 3;
				}else{
					return 1;
				}
			}
		}
		public override function Add(point:b2ContactPoint) : void
		{
			if(point.shape1.GetBody().GetUserData().type == "player"){
				point.shape1.GetBody().GetUserData().collisions[direction( point.normal)]++;
			}
			if(point.shape2.GetBody().GetUserData().type == "player"){
				var v:b2Vec2 = new b2Vec2(-point.normal.x,-point.normal.y);
				point.shape2.GetBody().GetUserData().collisions[direction( v)]++;
			}
		}
		
		public override function Persist(point:b2ContactPoint) : void
		{
			// handle persist point
			
		}
		
		public override function Remove(point:b2ContactPoint) : void
		{
			if(point.shape1.GetBody().GetUserData().type == "player"){
				point.shape1.GetBody().GetUserData().collisions[direction( point.normal)]--;
			}
			if(point.shape2.GetBody().GetUserData().type == "player"){
				var v:b2Vec2 = new b2Vec2(-point.normal.x,-point.normal.y);
				point.shape2.GetBody().GetUserData().collisions[direction( v)]--;
			}	
		}
		
		public override function Result(point:b2ContactResult) : void
		{
			// handle results
			
		}
	}
}