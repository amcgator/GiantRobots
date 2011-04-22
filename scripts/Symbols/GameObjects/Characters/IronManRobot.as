package Symbols.GameObjects.Characters 
{
	import Constants.Enums.WeightClasses;
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Steve and Alicia
	 */
	public class IronManRobot extends ControllableCharacter 
	{
		
		public function IronManRobot(X:Number = 0, Y:Number = 0) 
		{
			super(X,Y);
			mJumpTime = 0;
			this.createGraphic(15, 35, 0xffff0000);
						
			this.weight = WeightClasses.WEIGHT_ROBOTS;
		}
		

		override public function AI(): void 
		{
			//movement done when computer is the controller
		}
		
		override public function HandleInput():void 
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

			if (FlxG.keys.SPACE) {
				MarioJump();
			}
		}
		
		override public function Move(xDirection:int = 0, yDirection:int = 0):void
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

		override public function CleanUp():void
		{
			
		}
		
		
		//=========================================================
		/// Member variables
		//=========================================================
		private var mJumpTime:Number;		
		
		
	}

}