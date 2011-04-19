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
	public class PlayerCharacter extends GameCharacter
	{
		
		public function PlayerCharacter(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);	
			mJumpTime = 0;
			this.createGraphic(8, 8, 0xff112233);
		}
		
		override public function HandleInput():void 
		{
			super.HandleInput();	
			
			
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

			if (FlxG.keys.SPACE) {
				MarioJump();
			}

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
		private function MarioJump():void
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
		
		override public function update():void 
		{
			if (mCurrentlyControlled != null) {
				mCurrentlyControlled.HandleInput();
			}
			HandleInput();
			super.update();
		}
		
		public function SetCurrentlyControlled(GC:ControllableCharacter):void {
			if (mCurrentlyControlled == null)
			{
				mCurrentlyControlled = GC;
			}
			else {
				mCurrentlyControlled.CleanUp();
				mCurrentlyControlled = GC;
			}
		}
		
		public function GetCurrentlyControlled():ControllableCharacter {
			return mCurrentlyControlled;
		}
		
		
		//=========================================================
		/// Member variables
		//=========================================================
		private var mJumpTime:Number;	
		private var mCurrentlyControlled:ControllableCharacter;
		
	}

}