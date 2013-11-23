package models
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2PolygonDef;
	import Box2D.Collision.b2AABB;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2World;
	
	import flash.geom.Point;
	
	import maps.TileTypes;
	
	public class PhysicsEngine1 implements PhysicsEngineInterface
	{
		
		[Inject]
		public var _model:GameModel;
		
		private var _world:b2World;
		
		private var _unprocessedTime: Number = 0;
		private var _FRAME_DURATION : Number = 1.0/60;
		private var _playerBodies: Vector.<b2Body> = new Vector.<b2Body>();
		
		private static const FLY_FORCE:Number = 10;
		private static const WALK_FORCE:Number = 20;
		private static const JUMP_IMPULSE:Number = 45;
		
		public function PhysicsEngine1()
		{
		}
		private function getPlayer(index:Number):PlayerA{
			return index?_model.playerB : _model.playerA;
		}
		private function getRowsCount():Number{
			return _model.tileManager.getRowsCount();
		}
		private function getColsCount():Number{
			return _model.tileManager.getColumsCount();
		}
		private function getSpawnPoint(index:Number):Point{
			var rowsCount:Number = getRowsCount();
			var colsCount:Number = getColsCount();
			for(var row:Number=0;row<rowsCount;++row){
				for(var col:Number=0;col<colsCount;++col){
					if( _model.tileManager.getCell(row,col).getAttrib(TileTypes.SPAWN_POINT_ATTR) == 'p' + (index+1)){
						trace("found!",row,col);
						return new Point(col+.5,rowsCount-row-.5);
					}
				}
			}
			throw new Error("Nie ma pola startowego dla gracza " + index);
		}
		private function spawnPlayer(index:Number):b2Body{
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.userData = new Object();
			bodyDef.userData.type = "player";
			bodyDef.userData.index = index;
			bodyDef.userData.collisions = new Array(0,0,0,0);
			var spawnPosition:Point = getSpawnPoint(index);
			bodyDef.position.Set( spawnPosition.x,spawnPosition.y);
			var body:b2Body = _world.CreateBody(bodyDef);
		
			var shapeDef:b2CircleDef = new b2CircleDef();
			shapeDef.radius = 1.0;
			shapeDef.density = 4/Math.PI;//nie pytaj
			shapeDef.friction = 0.3;
			body.CreateShape(shapeDef);
			body.SetMassFromShapes();
			return body;
		}
		private function createStaticRect(leftColumn:Number,bottomRow:Number,rightColumn:Number,topRow:Number):b2Body
		{
			var groundBodyDef:b2BodyDef = new b2BodyDef();
			groundBodyDef.userData = new Object();
			groundBodyDef.userData.type = "tilerect";
			groundBodyDef.userData.leftColumn = leftColumn;
			groundBodyDef.userData.rightColumn = rightColumn;
			groundBodyDef.userData.bottomRow= bottomRow;
			groundBodyDef.userData.topRow= topRow;
			groundBodyDef.position.Set((leftColumn+rightColumn)/2+.5, (bottomRow+topRow)/2+.5);
			var groundBody:b2Body = _world.CreateBody(groundBodyDef);
			var groundShapeDef:b2PolygonDef = new b2PolygonDef();
			groundShapeDef.SetAsBox((1+rightColumn-leftColumn)/2, (1+topRow-bottomRow)/2);
			groundBody.CreateShape(groundShapeDef);
			return groundBody;
		}
		public function initialize():void
		{
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-10, -10);
			worldAABB.upperBound.Set(10+getColsCount(), 10+getRowsCount());
			_world = new b2World(worldAABB, new b2Vec2 (0.0, -9.81), true);
			_world.SetContactListener(new PhysicsEngine1ContactListener());
			for(var index:Number=0;index<2;++index)
				_playerBodies.push(spawnPlayer(index));
			
			createStaticRect(-1,0,-1,getRowsCount()-1);
			createStaticRect(getColsCount(),0,getColsCount(),getRowsCount()-1);
			createStaticRect(0,-1,getColsCount()-1,-1);
			createStaticRect(0, getRowsCount(),getColsCount()-1,getRowsCount());
			
			var rowsCount:Number = getRowsCount();
			var colsCount:Number = getColsCount();
			for(var row:Number=0;row<rowsCount;++row){
				for(var col:Number=0;col<colsCount;++col){
					var colFirst:Number=col;
					for(;col<colsCount && _model.tileManager.getCell(row,col).getAttrib(TileTypes.MATERIAL_ATTR)!=TileTypes.AIR;++col){
					}
					if(colFirst<col){
						createStaticRect(colFirst,rowsCount-row-1,col-1,rowsCount-row-1);
					}
				}
			}
			
		}
		
		public function update(deltaTimeSeconds:Number):void
		{	
			_unprocessedTime += deltaTimeSeconds;
			while(_FRAME_DURATION < _unprocessedTime){
				_step();
			}
		}
		private var DX :Array= new Array(-1,0,1,0);
		private var DY :Array= new Array(0,1,0,-1);
		
		private function getContactDirections(body:b2Body):Array
		{
			var contactDirections:Array = new Array(false,false,false,false);
			var pos:b2Vec2 = body.GetPosition();
			for(var d:Number=0;d<4;++d){
				var dx:Number=DX[d];
				var dy:Number=DY[d];
				var probe_x:Number = pos.x+dx;
				var probe_y:Number = pos.y+dy;
				var row:Number = Math.floor(probe_y);
				var col:Number = Math.floor(probe_x);
		
				contactDirections[d] =  row<0 || col<0 || row>=getRowsCount() || col>=getColsCount() ||  _model.tileManager.getCell(getRowsCount()-1-row,col).getAttrib(TileTypes.MATERIAL_ATTR)!=TileTypes.AIR;
				//contactDirections[d] = body.GetUserData().collisions[d]>0;
			}
			return contactDirections;
		}
		
		private function _processPlayersIntentions():void
		{
			for(var index:Number=0;index<2;++index){
				var body:b2Body = _playerBodies[index];
				var position:b2Vec2=body.GetPosition();
				var player:PlayerA = this.getPlayer(index);
				var direction:Point = player.getIntendedDirection();
				var contactDirections:Array = getContactDirections(body);
				if(index==0){
					//trace("player " + index,contactDirections);
				}
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
								trace("JUMP");
								v.Multiply(JUMP_IMPULSE);
								body.ApplyImpulse(v,position);
							}else if(contactDirections[(d+1)%4] || contactDirections[(d+3)%4]){
								//WALK
								//trace("WALK");
								v.Multiply(WALK_FORCE);
								body.ApplyForce(v,position);
							}else{
								//FLY
								//trace("FLY");
								v.Multiply(FLY_FORCE);
								body.ApplyForce(v,position);
							}
						}
					}
				}
			}
		}
		private function _step():void
		{
			_processPlayersIntentions();
			_world.Step(_FRAME_DURATION, 10);
			_unprocessedTime -= _FRAME_DURATION;
			for(var index:Number=0;index<2;++index){
				var position:b2Vec2=_playerBodies[index].GetPosition();
				//trace(_playerBodies[index].GetAngle());
				getPlayer(index).setAngle(_playerBodies[index].GetAngle());
				getPlayer(index).setPosition(new Point(position.x,position.y));
			}
		}
	}
}