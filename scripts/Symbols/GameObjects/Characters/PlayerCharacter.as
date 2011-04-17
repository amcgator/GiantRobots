package Symbols.GameObjects.Characters 
{
	import Constants.GameplayConstants;
	import flash.utils.Dictionary;
	import GameControl.GameStates.PlayState;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxObject;
	import Symbols.GameObjects.GameObject;
	/**
	 * ...
	 * @author ...
	 */
	public class PlayerCharacter extends GameObject
	{
		
		public function PlayerCharacter(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			
			this.acceleration.y = GameplayConstants.GRAVITY;
			this.maxVelocity.x = GameplayConstants.MAX_PLAYER_X_VELOCITY;
			this.maxVelocity.y = GameplayConstants.MAX_PLAYER_Y_VELOCITY;
		}
		
		override public function update():void 
		{
			//handle key movement
			if (FlxG.keys.A || FlxG.keys.LEFT)
			{
				this.acceleration.x = -200;
			}
			else if (FlxG.keys.D || FlxG.keys.RIGHT)
			{
				this.acceleration.x = 200;
			}
			else
			{
				this.velocity.x = 0;
				this.acceleration.x = 0;
			}
			
			
			super.update();
		}
		
		public function Jump():void
		{		
			
		}
		
		private function DebugGraphic():void
		{
			this.createGraphic(32, 32);
		}

		private var mCurrentlyControlled:GameCharacter;
		
	}

}