package models
{
	import Box2D.Collision.Shapes.b2CircleDef;
	import Box2D.Collision.Shapes.b2MassData;
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
		private var _FRAME_DURATION : Number = 1.0/30;
		protected var _playerBodies: Vector.<b2Body> = new Vector.<b2Body>();
		private var _particleBodies: Vector.<b2Body> = new Vector.<b2Body>();

		private var particleSpawingPoints : Vector.<Point> = new Vector.<Point>();
		private var magnetPoints : Vector.<Point> = new Vector.<Point>();
		private var knownParticleSpawningPoints : Vector.<Point> = new Vector.<Point>();
		private var savedParticlePolarities: Vector.<Number> = new Vector.<Number>();
		private var savedParticlePaths : Vector.<Vector.<b2Vec2> > = new Vector.<Vector.<b2Vec2> >();
		
		protected static const FLY_FORCE:Number = 10;
		protected static const WALK_FORCE:Number = 20;
		protected static const FORBID_JUMP_VELOCITY:Number = 0.01;
		private static const MAGNETIC_BRICK_FORCE:Number = 50;
		private static const MAGNETIC_PLAYER_FORCE:Number = 200;
		private static const KILL_PARTICLES_PER_FRAME:uint = 1;
		private static const PARTICLE_GRID_RADIUS:uint = 4;

		
		protected function getPlayerFriction():Number
		{
			return 0.3;
		}
		
		protected function getTileFriction():Number
		{
			return 0.2;
		}
		
		protected function getPlayerDampening():Number
		{
			return 0;
		}
		
		protected function getGravity():b2Vec2
		{
			return new b2Vec2 (0.0, -9.81);
		}
			
		protected function getPlayerJumpImpulse():Number
		{
			return 45;
		}
	
		
		public function PhysicsEngine1()
		{
		}
		protected function getPlayer(index:Number):PlayerA{
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
			trace(bodyDef.linearDamping);
			bodyDef.linearDamping  = getPlayerDampening();
			var body:b2Body = _world.CreateBody(bodyDef);
		
			var shapeDef:b2CircleDef = new b2CircleDef();
			shapeDef.radius = 1.0;
			shapeDef.density = 4/Math.PI;//nie pytaj
			shapeDef.friction = getPlayerFriction();
			body.CreateShape(shapeDef);
			body.SetMassFromShapes();
			return body;
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
			shapeDef.friction = getTileFriction();
			
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
		public function initialize():void
		{
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-10, -10);
			worldAABB.upperBound.Set(10+getColsCount(), 10+getRowsCount());
			_world = new b2World(worldAABB, getGravity(), false);
			_world.SetContactListener(new PhysicsEngine1ContactListener());
			for(var index:Number=0;index<2;++index)
				_playerBodies.push(spawnPlayer(index));
			
			createStatics();
			initParticlesSpawningPoints();
			initMagnetPoints();
			createParticles();
		}
		
		private function initParticlesSpawningPoints():void
		{
			//TODO: optimize to linear time
			var rowsCount:Number = getRowsCount();
			var colsCount:Number = getColsCount();
			var row:Number;
			var col:Number;
			//  podłogi
			for(row=0;row<rowsCount;row+=2){
				for(col=0;col<colsCount;col+=2){
					if(!isSolid(row,col) && isNearMagnet(row,col)){
					 	particleSpawingPoints.push(new Point(col+.5,row+.5));
						particleSpawingPoints.push(new Point(col+.5,row+.5));
					}
				}
			}
		}
		private function isNearMagnet(row:Number,col:Number):Boolean{
			for(var r:int = Math.max(0,row-PARTICLE_GRID_RADIUS);r< Math.min(getRowsCount(), row+1+PARTICLE_GRID_RADIUS);++r){
				for(var c:int = Math.max(0,col-PARTICLE_GRID_RADIUS);c< Math.min(getColsCount(), col+1+PARTICLE_GRID_RADIUS);++c){
					var material:String = _model.tileManager.getCell(getRowsCount()-1-r,c).getAttrib(TileTypes.MATERIAL_ATTR);
					if(material == TileTypes.METAL || material == TileTypes.POSITIVE || material == TileTypes.NEGATIVE){
						return true;
					}
				}
			}
			return false;
		}
		private var scouts = 0;
		private static const MAX_SCOUTS:uint = 5;
		
		private function createParticles():void
		{
			var massData:b2MassData = new b2MassData();
			massData.mass = 4;
			for(var i:uint=0;i<_model.particles.length;++i){
				
				var bodyDef:b2BodyDef = new b2BodyDef();
				bodyDef.userData = new Object();
				bodyDef.userData.type = "particle";
				
				var body:b2Body = _world.CreateBody(bodyDef);
				
				body.SetMass(massData);
				
				_particleBodies.push(body);
				killParticle(i);
			}
		}
		
		public function update(deltaTimeSeconds:Number):void
		{	
			pairs=0;
			_unprocessedTime += deltaTimeSeconds;
			while(_FRAME_DURATION < _unprocessedTime){
				_step();
			}
			for(var index:Number=0;index<2;++index){
				var position:b2Vec2=_playerBodies[index].GetPosition();
				getPlayer(index).setAngle(_playerBodies[index].GetAngle());
				getPlayer(index).setPosition(new Point(position.x,position.y));
			}
			updateParticles();
		}
		protected var DX :Array= new Array(-1,0,1,0);
		protected var DY :Array= new Array(0,1,0,-1);
		
		
		protected function getContactDirections(body:b2Body):Array
		{
			var contactDirections:Array = new Array(false,false,false,false);
			for(var d:Number=0;d<4;++d){
				contactDirections[d] = body.GetUserData().collisions[d]>0;
			}
			//trace(body.GetUserData().collisions);
			body.GetUserData().collisions = new Array(0,0,0,0);
			return contactDirections;
		}
		
		protected function _processPlayersIntentions():void
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
		private function updateParticles():void{
			for(var i:uint=0;i<_model.particles.length;++i){
				var data = _particleBodies[i].GetUserData();
				var position:b2Vec2= data.kind == 'replay' ? savedParticlePaths[data.which][Math.max(0,data.frame-1)]   : _particleBodies[i].GetPosition() ;
				_model.particles[i].setPosition(new Point(position.x,position.y));
			}
			
		}
		private function initMagnetPoints():void{
			var colsCount:Number = getColsCount();
			var rowsCount:Number = getRowsCount();
			//TODO: może by tak stablicować sobie te tile które są z metalu?
			for(var col:Number=0;col<colsCount;++col){
				for(var row:Number=0;row<rowsCount;++row){
					var material:String = _model.tileManager.getCell(getRowsCount()-1-row,col).getAttrib(TileTypes.MATERIAL_ATTR);
					if(material == TileTypes.POSITIVE){
					}else if(material == TileTypes.NEGATIVE){
					}else if(material == TileTypes.METAL){
					}else{
						continue;
					}
					magnetPoints.push(new Point(col,row));
				}
			}
		}
		private var pairs:uint=0;
		private function _processMagnetism():void
		{
			var particle_grid:Array = new Array();
			for (var j:uint=0;j<_particleBodies.length;++j){
				var body:b2Body = _particleBodies[j];
				if(body.GetUserData().kind != 'scout'){
					continue;
				}
				var position:b2Vec2 = body.GetPosition(); 
				var gx:int = Math.floor(position.x/PARTICLE_GRID_RADIUS);
				var gy:int = Math.floor(position.y/PARTICLE_GRID_RADIUS);
				if(!(gx in particle_grid)){
					particle_grid[gx]=new Array();
				}
				if(!(gy in particle_grid[gx])){
					particle_grid[gx][gy]=new Array();
				}
				particle_grid[gx][gy].push(j);
			}
			
			if(true||getPlayer(0).getPolarity()||getPlayer(1).getPolarity()){
				var colsCount:Number = getColsCount();
				var rowsCount:Number = getRowsCount();
				//TODO: może by tak stablicować sobie te tile które są z metalu?
				for each (var magnetPoint:Point in magnetPoints){
					var col :Number = magnetPoint.x;
					var row :Number= magnetPoint.y;
						var material:String = _model.tileManager.getCell(getRowsCount()-1-row,col).getAttrib(TileTypes.MATERIAL_ATTR);
						var flip:int = 0;
						if(material == TileTypes.POSITIVE){
							flip = 1;
						}else if(material == TileTypes.NEGATIVE){
							flip = -1;
						}else if(material == TileTypes.METAL){
							flip = 0;
						}else{
							continue;
						}
						for(var index:uint=0;index<2;++index){
							var polarity:int = getPlayer(index).getPolarity();
							if(polarity){
								body = _playerBodies[index];
								position=body.GetPosition();
								
								var diff:Point = new Point( col+.5 - position.x ,row+.5 - position.y);
								diff.normalize( MAGNETIC_BRICK_FORCE /diff.length);
								
								var dir:Number = polarity==flip ? -1:1;
								
								body.ApplyForce(new b2Vec2(dir*diff.x,dir*diff.y),position);
								
							}
						}
						var bx:int = Math.floor( (col+.5)/PARTICLE_GRID_RADIUS);
						var by:int = Math.floor( (row+.5)/PARTICLE_GRID_RADIUS);
						pairs++;
						var force:b2Vec2 = new b2Vec2();
						for(var dx:int=-1;dx<=1;++dx){
							pairs++;
							for(var dy:int=-1;dy<=1;++dy){
								pairs++;
								gx = bx+dx;
								gy = by+dy;
								if(particle_grid[gx] && particle_grid[gx][gy]){
									for each (index in particle_grid[gx][gy]){
										pairs++;
										
										body = _particleBodies[index];
										polarity =  body.GetUserData().polarity;
										position =body.GetPosition();
										
										//diff = new Point( col+.5 - position.x ,row+.5 - position.y);
										var diff_x :Number= col+.5 - position.x;
										var diff_y :Number= row+.5 - position.y;
										var len2 :Number= diff_x*diff_x + diff_y*diff_y;
										dir= polarity==flip ? -1:1;
										diff_x = diff_x * MAGNETIC_BRICK_FORCE * dir / len2;
										diff_y = diff_y * MAGNETIC_BRICK_FORCE * dir / len2;
										
										force.x = diff_x;
										force.y = diff_y;
										body.ApplyForce(force,position);
										
										/*
										diff.normalize( MAGNETIC_BRICK_FORCE /diff.length);
										
										*/
									}
								}
							}
						
					}
				}
			}
		}
		private function _processPlayerMagnetism():void
		{
			for(var index:uint=0;index<2;++index){
				var polarity:int = getPlayer(index).getPolarity();
				if(polarity){
					var otherPolarity:Number = this.getPlayer(1-index).getPolarity();
					if(otherPolarity){
						var dir:Number;
						if(otherPolarity == polarity){
							dir = -1;
						}else{
							dir = 1;
						}
						var body:b2Body = _playerBodies[index];
						var position:b2Vec2=body.GetPosition();
						var otherPosition:b2Vec2 = _playerBodies[1-index].GetPosition();
						var diff:Point = new Point( otherPosition.x - position.x ,otherPosition.y - position.y);
						diff.normalize( MAGNETIC_PLAYER_FORCE /diff.length);
						body.ApplyForce(new b2Vec2(dir*diff.x,dir*diff.y),position);
					}
				}
			}
			
		}
		private function killParticle(index:Number):void
		{
			if(_particleBodies[index].GetUserData().kind == 'scout'){
				scouts --;
				knownParticleSpawningPoints.push(_particleBodies[index].GetUserData().start);
				savedParticlePaths.push(_particleBodies[index].GetUserData().path);
				savedParticlePolarities.push(_particleBodies[index].GetUserData().polarity);
				_particleBodies[index].GetUserData().path = null;
				_particleBodies[index].GetUserData().start = null;
				
			}
			_particleBodies[index].GetUserData().kind = null;
			var kind:String;
			var position:Point ;
			if(particleSpawingPoints.length && scouts < MAX_SCOUTS){
				scouts++;
				_particleBodies[index].GetUserData().polarity = -1+2*(particleSpawingPoints.length%2);
				_model.particles[index].setPolarity(_particleBodies[index].GetUserData().polarity);
				position = particleSpawingPoints.pop();
				kind = 'scout';
				trace ("spawn scout");
				
				_particleBodies[index].GetUserData().start = position;
				_particleBodies[index].GetUserData().path = new Vector.<b2Vec2>();
			}else if(knownParticleSpawningPoints.length){
				
				kind = 'replay';
				trace ("spawn replay");
				var i:uint = Math.floor(Math.random()*knownParticleSpawningPoints.length);
				_model.particles[index].setPolarity(savedParticlePolarities[i]);
				position = knownParticleSpawningPoints[i];
				_particleBodies[index].GetUserData().which = i;
				_particleBodies[index].GetUserData().frame = 0;
			}else{
				return;
			}
			_particleBodies[index].GetUserData().kind = kind;
			_particleBodies[index].SetAngularVelocity(0);
			_particleBodies[index].SetLinearVelocity(new b2Vec2(0,0));
			_particleBodies[index].SetXForm(new b2Vec2(position.x,position.y),0);
		}
		private var currentParticle:uint=0;
		private static const MAX_SAVED_PATH_LEN:uint = 60;
		private function _killParticles():void
		{
			for(var i:uint=0;i<_particleBodies.length;++i){
				var data = _particleBodies[i].GetUserData();
				if(data.kind == 'scout'){
					var position:b2Vec2=_particleBodies[i].GetPosition();
					data.path.push(new b2Vec2(position.x,position.y));
					if(isSolid(Math.floor(position.y),Math.floor(position.x)) || data.path.length >= MAX_SAVED_PATH_LEN ){
						killParticle(i);
					}
				}else if(data.kind == 'replay'){
					if(savedParticlePaths[data.which].length<=data.frame){
						killParticle(i);
					}else{
						data.frame++;
					}
				}else{
					killParticle(i);
				}
			}
		}
		private function _step():void
		{
			_processPlayersIntentions();
			_processMagnetism();
			_processPlayerMagnetism();
			_world.Step(_FRAME_DURATION, 10);
			_unprocessedTime -= _FRAME_DURATION;
			_killParticles();
		}
	}
}