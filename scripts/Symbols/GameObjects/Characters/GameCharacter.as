package Symbols.GameObjects.Characters 
{
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
			
			mJumpTime = 0;
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
		
		public function Move(xDirection:int = 0, yDirection:int = 0):void
		{
			
		}
		
		/**
		 * Overrides hitBottom to reset the jump time variable
		 * @param	Contact
		 * @param	Velocity
		 */
		override public function hitBottom(Contact:FlxObject, Velocity:Number):void 
		{
			super.hitBottom(Contact, Velocity);
			
			mJumpTime = 0;
		}
		
		/**
		 * does the standard arc jump
		 */
		protected function MarioJump():void
		{
			//if the player is holding down jump and we haven't held it past the max time
			if((mJumpTime >= 0) && (FlxG.keys.SPACE))
			{
				//add the new itme
				mJumpTime += FlxG.elapsed;
				//if we're past our max jump hold time
				if(mJumpTime > 0.25)
					mJumpTime = -1;
			}
			else
			{
				mJumpTime = -1;
			}
			//if jumping is still valid
			if(mJumpTime > 0)
			{
				if(mJumpTime < 0.065)
					velocity.y = -180;
				else
					velocity.y = -maxVelocity.y;
			}
		}
		
		//=========================================================
		/// Member variables
		//=========================================================
		private var mJumpTime:Number;
		
		
	}

}