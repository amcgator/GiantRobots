package Managers 
{
	import caurina.transitions.Tweener;
	import Constants.GameplayConstants;
	import flash.events.Event;
	import GameControl.LevelManagement.Level;
	import GameControl.LevelManagement.OgmoXMLParser;
	import Managers.GameEventManager;
	import Utils.MathHelpers;
	/**
	 * ...
	 * @author Scano
	 */
	public class LevelManager extends GameManager
	{
		
		public function LevelManager() 
		{
			super();
		
		}
		
		//==================================================
		//Singleton functions
		//==================================================
		public static function Create():void
		{
			if (mInstance == null)
			{
				mInstance = new LevelManager();
			}
			else
			{
				trace("Tried to create LevelManager when it already exists");
			}
		}
		
		public static function GetInstance():LevelManager { return mInstance; }
		
		
		override public function Init():void 
		{
			super.Init();
			
			Reset();
			
			//initialize our level variables
			mCurrentLevel = null;
			mCurrentLevelIndex = -1;
			
			//create our xml parser for levels
			mParser = new OgmoXMLParser();	
			
			//generate empty levels for each level we're making
			for (var i:int = 0; i < GameplayConstants.GAME_LEVELS.length; i++) 
			{
				mLevels.push(new Level( GameplayConstants.GAME_LEVELS[i] ) );
			}
			
		}
		
		override public function Update(elapsedTime:Number, totalTime:Number):void 
		{
			super.Update(elapsedTime, totalTime);
			
		}
		
		
		override public function Shutdown():void 
		{
			super.Shutdown();
			
			if (mLevels != null)
			{
				for each (var level:Level in mLevels) 
				{
					//level.Shutdown();
				}
			}
								
			mCurrentLevel = null;
			mCurrentLevelIndex = -1;
		}
		
		public function Reset():void
		{
			if (mLevels != null)
			{
				mLevels.splice(0, mLevels.length);
			}
			mLevels = new Array();
		
		}
				
		public function AddLevel(level:Level, index:int = -1):void
		{
			if (index < 0)
			{
				mLevels.push(level);
			}
			else
			{
				var backEnd:Array = mLevels.slice(index);
				
				mLevels = mLevels.splice(0, index - 1);
				mLevels.push(level);
				mLevels = mLevels.concat(backEnd);
			}
		}
		
		public function RemoveLevel(level:Level):void
		{
			for (var i:int = 0; i < mLevels.length; i++) 
			{
				if (mLevels[i] == level)
				{
					mLevels.splice(i, 1);
				}
			}
		}
		
		public function RemoveLevelIndex(index:int):void
		{
			mLevels.splice(index, 1);
		}
		
		//Unloads the current level and moves on the to next level
		public function NextLevel():Boolean
		{
			UnloadCurrentLevel();
			
			mCurrentLevelIndex++;
			
			if (mCurrentLevelIndex >= mLevels.length)
			{
				//win
				//GameEventManager.GetInstance().dispatchEvent(new GameControlEvent(GameControlEvent.CHANGE_STATE, "Win"));
				return false;
			}
			else
			{
				mCurrentLevel = mLevels[mCurrentLevelIndex];
				LoadCurrentLevel();
				return true;
			}
		}
		
		public function ReloadLevel():void
		{
			UnloadCurrentLevel();
			LoadCurrentLevel();
		}
				
		private function LoadCurrentLevel():void
		{
			mParser.addEventListener("LEVEL LOADED", OnLevelLoaded);
			mParser.LoadLevel( mCurrentLevel, mCurrentLevel.GetFileName());
		}
		
		private function UnloadCurrentLevel():void
		{
			if (mCurrentLevel != null)
			{
				mCurrentLevel.UnloadLevel();
			}
		}
		
		/**
		 * Once the parser has loaded the level, set it up to run
		 * @param	event
		 */
		private function OnLevelLoaded(event:Event):void
		{
			mCurrentLevel.Init();
			mCurrentLevel.LoadLevel();
		}
			
		//==================================================
		// Accessors
		//==================================================
		public function GetCurrentLevel():Level { return mCurrentLevel; }
		public function GetCurrentLevelIndex():int { return mCurrentLevelIndex; }
		
		//==================================================
		// Member Variables
		//==================================================
		//singleton instance
		private static var mInstance:LevelManager = null;
		//the current level we're on
		private var mCurrentLevel:Level
		//the current index of the level we're on
		private var mCurrentLevelIndex:int;
		//collection of levels 
		private var mLevels:Array;
		//our level parser
		private var mParser:OgmoXMLParser;

		
	}

}