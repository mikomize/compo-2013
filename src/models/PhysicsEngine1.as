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
	import flash.net.drm.AddToDeviceGroupSetting;
	
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
		private static const FORBID_JUMP_VELOCITY:Number = 0.01;
		private static const MAGNETIC_BRICK_FORCE:Number = 50;
		private static const MAGNETIC_PLAYER_FORCE:Number = 200;
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
		public function createStaticLine(start:Point,end:Point):b2Body
		{
			var dir:Point = end.subtract(start);
			dir.normalize(.5);
			var right:Point = new Point(dir.y,-dir.x);
			
			var nearStart:Point = start.add(dir).add(right);
			var nearEnd:Point = end.subtract(dir).add(right);

			var shapeDef:b2PolygonDef = new b2PolygonDef();
			shapeDef.vertexCount = 4;
			shapeDef.vertices[0].Set(start.x,start.y);
			shapeDef.vertices[1].Set(nearStart.x,nearStart.y);
			shapeDef.vertices[2].Set(nearEnd.x,nearEnd.y);
			shapeDef.vertices[3].Set(end.x,end.y);
			
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.userData = new Object();
			bodyDef.userData.type = "trapez";
		
			var body:b2Body = _world.CreateBody(bodyDef);
			body.CreateShape(shapeDef);
			return body;
		}
		private function isSolid(row:Number,col:Number):Boolean
		{
			return row<0 || col<0 || getRowsCount() <= row || getColsCount() <= col ||  _model.tileManager.getCell(getRowsCount()-1-row,col).getAttrib(TileTypes.MATERIAL_ATTR)!=TileTypes.AIR;
		}
		private function createStatics():void
		{
			var rowsCount:Number = getRowsCount();
			var colsCount:Number = getColsCount();
			var row:Number;
			var col:Number;
			var colFirst:Number;
			var rowFirst:Number;
			//  podłogi
			for(row=0;row<rowsCount;++row){
				for(col=0;col<colsCount;++col){
					colFirst=col;
					for(;col<colsCount && isSolid(row-1,col) && !isSolid(row,col);++col){
					}
					if(colFirst<col){
						createStaticLine(new Point(colFirst,row), new Point(col,row));
					}
				}
			}
			//sufity
			for(row=0;row<rowsCount;++row){
				for(col=0;col<colsCount;++col){
					colFirst=col;
					for(;col<colsCount && isSolid(row+1,col) && !isSolid(row,col);++col){
					}
					if(colFirst<col){
						createStaticLine(new Point(col,row+1), new Point(colFirst,row+1));
					}
				}
			}
			//lewe ściany
			for(col=0;col<colsCount;++col){
				for(row=0;row<rowsCount;++row){
					rowFirst=row;
					for(;row<rowsCount && isSolid(row,col-1) && !isSolid(row,col);++row){
					}
					if(rowFirst<row){
						createStaticLine(new Point(col,row), new Point(col,rowFirst));
					}
				}
			}
			//prawe ściany
			for(col=0;col<colsCount;++col){
				for(row=0;row<rowsCount;++row){
					rowFirst=row;
					for(;row<rowsCount && isSolid(row,col+1) && !isSolid(row,col);++row){
					}
					if(rowFirst<row){
						createStaticLine(new Point(col+1,rowFirst), new Point(col+1,row));
					}
				}
			}
			
		}
		private function createStaticsOld():void
		{
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
		public function initialize():void
		{
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-10, -10);
			worldAABB.upperBound.Set(10+getColsCount(), 10+getRowsCount());
			_world = new b2World(worldAABB, new b2Vec2 (0.0, -9.81), false);
			_world.SetContactListener(new PhysicsEngine1ContactListener());
			for(var index:Number=0;index<2;++index)
				_playerBodies.push(spawnPlayer(index));
			
			createStatics();	
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
			for(var d:Number=0;d<4;++d){
				contactDirections[d] = body.GetUserData().collisions[d]>0;
			}
			//trace(body.GetUserData().collisions);
			body.GetUserData().collisions = new Array(0,0,0,0);
			return contactDirections;
		}
		
		private function _processPlayersIntentions():void
		{
			for(var index:Number=0;index<2;++index){
				var body:b2Body = _playerBodies[index];
				var position:b2Vec2=body.GetPosition();
				var velocity:b2Vec2=body.GetLinearVelocity();
				var player:PlayerA = this.getPlayer(index);
				var direction:Point = player.getIntendedDirection();
				var polarity:Number = player.getPolarity();
				if(polarity){
					var colsCount:Number = getColsCount();
					var rowsCount:Number = getRowsCount();
					//TODO: może by tak stablicować sobie te tile które są z metalu?
					for(var col:Number=0;col<colsCount;++col){
						for(var row:Number=0;row<rowsCount;++row){
							var material:String = _model.tileManager.getCell(getRowsCount()-1-row,col).getAttrib(TileTypes.MATERIAL_ATTR);
							var dir:int = 0;
							if(material == TileTypes.POSITIVE){
								dir = -polarity;
							}else if(material == TileTypes.NEGATIVE){
								dir = polarity;
							}else if(material == TileTypes.METAL){
								dir = 1;
							}
							if(dir){
								var diff:Point = new Point( col+.5 - position.x ,row+.5 - position.y);
								diff.normalize( MAGNETIC_BRICK_FORCE /diff.length);
								body.ApplyForce(new b2Vec2(dir*diff.x,dir*diff.y),position);
							}
						}
					}
					var otherPolarity:Number = this.getPlayer(1-index).getPolarity();
					if(otherPolarity){
						if(otherPolarity == polarity){
							dir = -1;
						}else{
							dir = 1;
						}
						var otherPosition = _playerBodies[1-index].GetPosition();
						diff = new Point( otherPosition.x - position.x ,otherPosition.y - position.y);
						diff.normalize( MAGNETIC_PLAYER_FORCE /diff.length);
						body.ApplyForce(new b2Vec2(dir*diff.x,dir*diff.y),position);
					}
				}
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
									v.Multiply(JUMP_IMPULSE);
									body.ApplyImpulse(v,position);
								}else{
									trace("FORBIDEN JUMP");
								}
							}else if(contactDirections[(d+1)%4] || contactDirections[(d+3)%4]){
								//WALK
								v.Multiply(WALK_FORCE);
								body.ApplyForce(v,position);
							}else{
								//FLY
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