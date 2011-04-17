package GameControl.GameStates 
{
	import Constants.ConfigConstants;
	import Managers.GameEventManager;
	import Managers.HUDManager;
	import Managers.LevelManager;
	import Managers.RulesManager;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxU;
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
			
			DebugLevel();
			
		}

		public function get player():PlayerCharacter { return mPlayer; }
		
		override public function update():void 
		{
			super.update();
			
			FlxU.collide(mPlayer, this.defaultGroup);
		}
		
		private function DebugLevel():void
		{
			mPlayer = new PlayerCharacter(300, 300);
			
			var floor1:GenericBlock = new GenericBlock(300, 400);
			var floor2:GenericBlock = new GenericBlock(300 - 32, 400);
			var floor3:GenericBlock = new GenericBlock(332, 400);
			
			this.add(floor1);
			this.add(floor2);
			this.add(floor3);
			this.add(mPlayer);
		}
		
		private var mPlayer:PlayerCharacter;
		
	}

}