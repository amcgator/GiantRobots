package GameControl.LevelManagement
{
	import flash.geom.Point;
	import org.flixel.FlxG;
	import Symbols.GameObjects.GameObject;
	/**
	 * ...
	 * @author Scano
	 */
	public class Level
	{
		public static const LEVEL_STATE_UNINITIALIZED:int = 0;
		public static const LEVEL_STATE_INITIALIZED:int = 1;
		public static const LEVEL_STATE_LOADED:int = 2;
		public static const LEVEL_STATE_MAX:int = 3;
		
		public function Level(fileName:String) 
		{
			mStartingSpawnPoint = new Point();
			mCurrentSpawnPoint = new Point();
			mLevelObjects = new Array();
			mFileName = fileName;
			
			mState = LEVEL_STATE_UNINITIALIZED;
		}	
		
		/**
		 * Sets up the level for use for the first time. Do not call if the player has already made progress in this level
		 */
		public function Init():void
		{
			//set up the current spawn point to be the initial spawn point
			mCurrentSpawnPoint.x = mStartingSpawnPoint.x;
			mCurrentSpawnPoint.y = mStartingSpawnPoint.y;
			
			mState = LEVEL_STATE_INITIALIZED;
		}
		
		/**
		 * Clears out our level completely, uninitializing it
		 */
		public function Destroy():void
		{
			UnloadLevel();
			
			mLevelObjects.splice(0, mLevelObjects.length);
			
			mLevelObjects = new Array();
			mStartingSpawnPoint = new Point();
			mCurrentSpawnPoint = new Point();
			
			mState = LEVEL_STATE_UNINITIALIZED;
		}
		
		/**
		 * Sets our current player spawn point
		 * @param	x
		 * @param	y
		 */
		public function SetCurrentSpawn(x:Number, y:Number):void
		{
			mCurrentSpawnPoint.x = x;
			mCurrentSpawnPoint.y = y;
		}
		
		/**
		 * Adds an object to this level. Does not put the object on screen - that's what Load is for
		 * @param	obj
		 */
		public function AddObject(obj:GameObject):void
		{
			mLevelObjects.push(obj);
		}
		
		/**
		 * Removes an object from a level. Note: this simply will ensure this object is not reloaded with this level, does not
		 * actually remove it from the screen.
		 * @param	obj
		 */
		public function RemoveObject(obj:GameObject):GameObject
		{
			for (var i:int = 0; i < mLevelObjects.length; i++) 
			{
				if (mLevelObjects[i] == obj)
				{
					var theObject:GameObject = mLevelObjects.splice(i, 1)[0] as GameObject;
					return theObject;
				}
			}
			
			return null;
		}
		
		/**
		 * Throws the level onto the current FlxG.state
		 */
		public function LoadLevel():void
		{
			for (var i:int = 0; i < mLevelObjects.length; i++) 
			{
				FlxG.state.add( mLevelObjects[i] );
				(mLevelObjects[i] as GameObject).exists = true;
			}
			
			mState = LEVEL_STATE_LOADED;
		}
		
		public function UnloadLevel():void
		{
			for (var i:int = 0; i < mLevelObjects.length; i++) 
			{
				(mLevelObjects[i] as GameObject).destroy();
			}
		}
		
		public function GetSpawnPoint():Point { return mCurrentSpawnPoint; }
		public function GetFileName():String { return mFileName; }
		
		/**
		 * Lets us know if this level has already been initialized and loaded
		 * @return
		 */
		public function IsInitialized():Boolean
		{
			return !(mState == LEVEL_STATE_UNINITIALIZED);
		}
		
		//=========================================================
		/// Member variables
		//=========================================================
		//our current spawn (can be updated for checkpoints)
		internal var mCurrentSpawnPoint:Point;
		//our starting spawn point when the player first enters the level
		internal var mStartingSpawnPoint:Point;
		//all of the objects in our level. 
		//NOTE: probably want to optimize this somehow?
		internal var mLevelObjects:Array;
		//the .oel file for our level
		internal var mFileName:String;
		
		//our current state
		private var mState:int;
	}

}