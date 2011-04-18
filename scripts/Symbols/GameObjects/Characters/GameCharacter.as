package Symbols.GameObjects.Characters 
{
	import Constants.GameplayConstants;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import Symbols.GameObjects.GameObject;
	/**
	 * ...
	 * @author ...
	 */
	public class GameCharacter extends GameObject
	{
		
		public function GameCharacter(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			this.acceleration.y = GameplayConstants.GRAVITY;
			this.maxVelocity.x = GameplayConstants.MAX_PLAYER_X_VELOCITY;
			this.maxVelocity.y = GameplayConstants.MAX_PLAYER_Y_VELOCITY;
			
		}
		
		public function Jump():void
		{
		}
		
		public function Attack():void
		{
		}
		
		public function SpecialAttack():void
		{
		}
		

		override public function hitBottom(Contact:FlxObject, Velocity:Number):void 
		{
			super.hitBottom(Contact, Velocity);
			
		}
		
		public function Move(xDirection:int = 0, yDirection:int = 0):void
		{			
		}
		
		public function HandleInput():void
		{
			//must override in subclasses
		}
		
		public function CleanUp():void
		{
			
		}
		
		
	}

}