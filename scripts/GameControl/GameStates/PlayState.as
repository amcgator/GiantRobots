package GameControl.GameStates 
{
	import Constants.ConfigConstants;
	import flash.geom.Point;
	import GameControl.CustomEvents.LevelEvent;
	import Managers.GameEventManager;
	import Managers.HUDManager;
	import Managers.LevelManager;
	import Managers.RulesManager;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxU;
	import Symbols.GameObjects.Characters.GameCharacter;
	import Symbols.GameObjects.Characters.IronManRobot;
	import Symbols.GameObjects.Characters.NonPlayerCharacter;
	import Symbols.GameObjects.Characters.PlayerCharacter
	import Symbols.GameObjects.LevelObjects.GenericBlock;

	/**
	 * ...
	 * @author Scano
	 */
	public class PlayState extends FlxState
	{
		public function PlayState()
		{
			super();
		}
		
		override public function create():void 
		{
			super.create();
			
			FlxState.bgColor = 0x000000;

			//create the managers
			GameEventManager.Create();
			LevelManager.Create();
			RulesManager.Create();
			HUDManager.Create();
			
			//initialize all of the managers
			GameEventManager.GetInstance().Init();
			RulesManager.GetInstance().Init();
			HUDManager.GetInstance().Init();
			LevelManager.GetInstance().Init();
			
			//add event listener for level loading
			GameEventManager.GetInstance().SubscribeToEvent(this,LevelEvent.LEVEL_LOADED);
			this.addEventListener(LevelEvent.LEVEL_LOADED, OnLevelLoaded);
			
			//start up the first level
			LevelManager.GetInstance().NextLevel();

		}
			
		/**
		 * Returns the player
		 */
		public function get player():PlayerCharacter 
		{ 
			return mPlayer; 
		}
		
		override public function update():void 
		{
			super.update();
			
			FlxU.collide(mPlayer, this.defaultGroup);
			FlxU.collide(mnonPlayer, this.defaultGroup);
			FlxU.collide(ironManRobot, this.defaultGroup);
			
		}
		
		private function DebugLevel():void
		{
			mPlayer = new PlayerCharacter(300, 300);
			mnonPlayer = new NonPlayerCharacter(350, 350);
			
			var floor:GenericBlock = new GenericBlock(300 - 32, 400, 1000, 20);
			
			ironManRobot = new IronManRobot(345, 365);

			this.add(floor);
			this.add(mPlayer);
			this.add(mnonPlayer);
			this.add(ironManRobot);
		}
		
		/**
		 * Event handler for when the level is done loading. Puts the player in place
		 */
		private function OnLevelLoaded(event:LevelEvent):void
		{
			var spawnPoint:Point = event.level.GetSpawnPoint();
			
			mPlayer = new PlayerCharacter( spawnPoint.x, spawnPoint.y);
			
			this.add(mPlayer);
			
			//debug
			ironManRobot = new IronManRobot(mPlayer.x + 100, mPlayer.y);
			this.add(ironManRobot);
		}
		
		//=====================================================
		/// Member variables
		//=====================================================
		private var mPlayer:PlayerCharacter;
		private var mnonPlayer:NonPlayerCharacter;
		private var ironManRobot:GameCharacter;
		
	}

}