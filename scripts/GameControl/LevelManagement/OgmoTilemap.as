package GameControl.LevelManagement
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxQuadTree;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	import org.flixel.FlxObject;
	/**
	 * Custom tilemap used to load in Ogmo information. Is a mis-mash of
	 * other libraries from other flixel uses, including extensions to handle
	 * slope collision
	 * @author Scano
	 */
	public class OgmoTilemap extends FlxTilemap
	{		
		public function OgmoTilemap():void
		{
			super();
		}
		
		public function LoadTilemap(Layer:XML, TileLayer:String, TileGraphic:Class):FlxTilemap
		{
			//load graphics
			_pixels = FlxG.addBitmap(TileGraphic,false, true, String(TileGraphic));
			
			var file:XML = Layer;
			
			width = file.width;
			height = file.height;		
			
			//figure out the map dimmesions based on the xml and set variables			
			_tileWidth = file.descendants(TileLayer).@tileWidth;
			_tileHeight = file.descendants(TileLayer).@tileHeight;
			
			widthInTiles = width / _tileWidth;
			heightInTiles = height / _tileHeight;
			
			totalTiles = widthInTiles * heightInTiles;
			
			_block.width = _tileWidth;
			_block.height = _tileHeight;
			
			//Initialize the data
			_data = new Array();
			for(var di:int; di < totalTiles; di++)
			{
				_data.push(0);
			}
			
			// Not sure yet
			_rects = new Array(totalTiles);
			
			// Set tiles
			var i:XML
			for each (i in file.descendants(TileLayer).tile)
			{
				this.setTile((i.@x / _tileWidth), (i.@y / _tileHeight), i.@id);
			}
			
			//Pre-set some helper variables for later
			_screenRows = Math.ceil(FlxG.height/_tileHeight)+1;
			if(_screenRows > heightInTiles)
				_screenRows = heightInTiles;
			_screenCols = Math.ceil(FlxG.width/_tileWidth)+1;
			if(_screenCols > widthInTiles)
				_screenCols = widthInTiles;
			
			//Refresh collison data
			_bbKey = String(TileGraphic);
			generateBoundingTiles();
			refreshHulls();
			
			
			return this;
		}
		
		public function AddTileMap(state:FlxState = null, collideable:Boolean = true ):void
		{
			this.exists = true;
			if (collideable)
			{
				FlxU.setWorldBounds(0, 0, width, height);
			}
			if (state == null)
			{
				state = FlxG.state;
			}
			state.add(this);
		}
		
		/**
		 * slopecollide and solveSlopeCollide borrowed from Flixel community, edited up
		 * 
		 * slopecollide works similar to FlxU.collide, except that we test collision using solveSlopecollide
		 * @param	Core - the object that we're testing collision against
		 * @return
		 */
		public function slopeCollide(Core:FlxObject):Boolean
		{
			var quadTree:FlxQuadTree = new FlxQuadTree(FlxU.quadTreeBounds.x,FlxU.quadTreeBounds.y,FlxU.quadTreeBounds.width,FlxU.quadTreeBounds.height);
			quadTree.add(this, FlxQuadTree.A_LIST);
			quadTree.add(Core, FlxQuadTree.B_LIST);
			return quadTree.overlap(true, solveSlopeCollide);
		}
		/**
		 * Checks to see if our tilemap collides wit the object provided
		 * @param	Map
		 * @param	Core
		 * @return
		 */
		public function solveSlopeCollide(Map:OgmoTilemap, Core:FlxObject):Boolean
		{
			//variable value to determine how closely we snap to slopes. 3 was the recommended value
			var slopeSnapping:Number = 3;

			//general iterators
			var r:uint;
			var c:uint;
			var d:uint;
			var i:uint;
			var dd:uint;
			var blocks:Array = new Array();
		   
			//how many tiles over the Core object is, horizontally	
			var ix:uint = Math.floor((Core.x - x) / _tileWidth);
			//how many tiles down the Core object is, vertically
			var iy:uint = Math.floor((Core.y - y) / _tileHeight);
			//how many tiles over we're going to check for collision (collision width)
			var iw:uint = Math.ceil((Core.x - x + Core.width) / _tileWidth) - ix;
			//how many tiles down we're going to check for collision (collision height)
			var ih:uint = Math.ceil((Core.y - y + Core.height + 2)/_tileHeight) - iy;
		   
			//Slope related variables
			var blockX:Number;
			var blockY:Number;
			var dotX:Number;
			var slopeY:Number;
			var coreSprite:FlxSprite;
			
			//iterate over height
			for (r = 0; r < ih; r++)
			{
				//make sure we're not out of bounds
				if ((r < 0) || (r >= heightInTiles)) break;
			   
				//d = which row of tiles we're in...
				d = (iy+r)*widthInTiles+ix;
			   
				//iterate over width
				for(c = 0; c < iw; c++)
				{                 
					//make sure we're not out of bounds
					if ((c < 0) || (c >= widthInTiles)) break;                             
				   
					//dd = the data value of the object we're looking at
					dd = _data[d + c];
					
					//is this a collideable tile?
					if (dd >= collideIndex) 
					{
						//the x value of the block we're checking
						blockX = x + (ix + c) * _tileWidth;
						//the y value of the block we're checking
						blockY = y + (iy + r) * _tileHeight;
						//the center of our core object, in the X direction. Must rename this.
						dotX = Core.x + Core.width / 2;
						
						// sloped floors that look like this: /
						if (SLOPE_RIGHT_FLOORS.indexOf(dd) != -1)
						{
							//Character inside slope
							if (dotX  >= blockX && dotX < blockX + _tileWidth + slopeSnapping) 
							{
								//where on the slope are we
								slopeY = blockY + _tileHeight + blockX - dotX;
								if (Core.y + Core.height >= slopeY - slopeSnapping)
								{
									//if we were moving down, hit
									if (Core.velocity.y * FlxG.elapsed >= -1) 
									{
										Core.hitBottom(this, 0);
									}
									if (slopeY < blockY) 
									{
										slopeY = blockY;
									}
									//move to this height
									Core.y = slopeY - Core.height;
									
								}
								//we're where we need to be, return
								return true;
							}
							
						}
						//sloped floors that look like this: \
						else if (SLOPE_LEFT_FLOORS.indexOf(dd) != -1)
						{
							//Character inside slope
							if (dotX  >= blockX - slopeSnapping && dotX < blockX + _tileWidth)
							{
								//where on the slope are we
								slopeY = blockY - blockX + dotX;
								if (Core.y + Core.height >= slopeY - slopeSnapping)
								{
									if (Core.velocity.y * FlxG.elapsed >= -1) 
									{
										Core.hitBottom(this, 0);
									}
									if (slopeY < blockY) 
									{
										slopeY = blockY;
									}
									Core.y = slopeY - Core.height;
								}
								return true;
							}
							
						}
						//sloped ceilings that look like: \
						else if (SLOPE_LEFT_CEILINGS.indexOf(dd) != -1)
						{
							//Character inside slope
							if (dotX  >= blockX && dotX < blockX + _tileWidth) 
							{
								//where on the slope are we
								slopeY = blockY - blockX + dotX;
								if (Core.y <= slopeY + slopeSnapping)
								{
									//stop moving/hit yo head
									if (Core.velocity.y < 0)
									{
										Core.velocity.y = 0;
									}
									//move to directly below the slope
									Core.y = slopeY + slopeSnapping;
									Core.velocity.y += 10;
								}
								c = widthInTiles;
							}
						}
						//sloped ceilings that look like: /
						else if (SLOPE_RIGHT_CEILINGS.indexOf(dd) != -1)
						{
							//Character inside slope
							if (dotX  >= blockX && dotX < blockX + _tileWidth) 
							{
								//where on the slope are we
								slopeY = blockY + _tileHeight + blockX - dotX;
								if (Core.y <= slopeY + slopeSnapping)
								{
									//stop moving/hit yo head
									if (Core.velocity.y < 0)
									{
										Core.velocity.y = 0;
									}
									//move to directly under the slope
									Core.y = slopeY + slopeSnapping;
									//get off me bro
									Core.velocity.y += 10;
								}
								c = widthInTiles;
							}
						}
						else if (HALF_HEIGHT_TILES.indexOf(dd) != -1)
						{
							//character on tile
							if (dotX  >= blockX && dotX < blockX + _tileWidth) 
							{
								//where on the slope are we
								slopeY = blockY + _tileHeight/2;
								if (Core.y + Core.height >= slopeY - slopeSnapping)
								{
									if (Core.velocity.y * FlxG.elapsed >= -1) 
									{
										Core.hitBottom(this, 0);
									}
									if (slopeY < blockY) 
									{
										slopeY = blockY;
									}
									Core.y = slopeY - Core.height;
								}
							}
						}
						else
						{
							//else, save block for regular collision
							blocks.push( { x:x + (ix + c) * _tileWidth, y:y + (iy + r) * _tileHeight, data:dd } );
						}                             
					}
					
				}
			}
			
			//Time to do our regular collisions routine.
			//These won't include any sloped tiles, only old-style rectangular shaped slopes.
			var bl:uint = blocks.length;
			var hx:Boolean = false;
			var hy:Boolean = false;
						
			//Then do all the X collisions
			for(i = 0; i < bl; i++)
			{
				_block.x = blocks[i].x;
				_block.y = blocks[i].y;
				_block.refreshHulls();
				dd = blocks[i].data;
				
				if(FlxU.solveXCollision(_block, Core))
				{
					d = blocks[i].data;
					if(_callbacks[d] != null)
						_callbacks[d](Core,_block.x/_tileWidth,_block.y/_tileHeight,d);
					hx = true;
				}
			}
			
			//Then do all the Y collisions
			for(i = 0; i < bl; i++)
			{
				_block.x = blocks[i].x;
				_block.y = blocks[i].y;
				_block.refreshHulls();
				dd = blocks[i].data;
				if(FlxU.solveYCollision(_block, Core))
				{
					d = blocks[i].data;
					if(_callbacks[d] != null)
						_callbacks[d](Core,_block.x/_tileWidth,_block.y/_tileHeight,d);
					hy = true;
				}
			}
		
			return hx || hy;
		}
		 /*
		Get the location of a pixel x,y point in tiles
		*
		* @paramX The X coordinate of the tile (in pixels).
		* @paramY The Y coordinate of the tile (in pixels).
		*
		* @returnA FlxPoint of the x,y location in tiles
		*/
		public function getTileXY(X:int, Y:int):FlxPoint
		{
				return new FlxPoint(X / _tileWidth + x, Y / _tileHeight + y);
		}
			
		/**
		 * Just for cleanliness, see if the provided tile is listed as a sloped tile
		 * @param	index
		 * @return
		 */
		public function IsSlopedTile(index:uint):Boolean
		{
			var a:Boolean = (SLOPE_LEFT_CEILINGS.indexOf(index) != -1);
			var b:Boolean = (SLOPE_LEFT_FLOORS.indexOf(index) != -1);
			var c:Boolean = (SLOPE_RIGHT_FLOORS.indexOf(index) != -1);
			var d:Boolean = (SLOPE_RIGHT_CEILINGS.indexOf(index) != -1);
			
			return a || b || c || d;
		}
		
		public function get tileHeight():uint
		{
			return _tileHeight;
		}
		public function get tileWidth():uint
		{
			return _tileWidth;
		}
				
		// list the index of the tiles on your spritesheet below! (erase mine!)
		//slopes that look like  /   and are floors
		private static const SLOPE_RIGHT_FLOORS:Array = []; 
		//slopes that look like  \   and are floors
		private static const SLOPE_LEFT_FLOORS:Array = []; 
		//slopes that look like  \   and are ceilings
		private static const SLOPE_LEFT_CEILINGS:Array = []; 
		//slopes that look like  /   and are ceilings
		private static const SLOPE_RIGHT_CEILINGS:Array = []; 
		//half height tiles
		private static const HALF_HEIGHT_TILES:Array = [];
		
	}

}