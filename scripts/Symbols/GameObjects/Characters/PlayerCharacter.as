package Symbols.GameObjects.Characters 
{
	import Constants.Enums.WeightClasses;
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
			
			//initialize default variables
			mJumpTime = 0;
			mContactCharacter = null;
			
			this.weight = WeightClasses.WEIGHT_PLAYER;
			
			//debug graphic
			this.createGraphic(8, 8, 0xff112233);
		}
		
		override public function HandleInput():void 
		{
			super.HandleInput();	
			
			if (mCurrentlyControlled != null)
			{
				mCurrentlyControlled.HandleInput();
				
				//check for eject
				if (FlxG.keys.justPressed("ENTER"))
				{
					SetCurrentlyControlled(null);
				}
			}
			else
			{
				//handle key movement
				//move left
				if (FlxG.keys.A || FlxG.keys.LEFT)
				{
					this.acceleration.x = -200;
				}
				//move right
				else if (FlxG.keys.D || FlxG.keys.RIGHT)
				{
					this.acceleration.x = 200;
				}
				//no horizontal movement
				else
				{
					this.velocity.x = 0;
					this.acceleration.x = 0;
				}

				//jump
				if (FlxG.keys.SPACE) 
				{
					MarioJump();
				}
				//take control of object we're touching
				if (FlxG.keys.justPressed("ENTER"))
				{
					if (mContactCharacter != null && mCurrentlyControlled == null)
					{
						mContactCharacter.TakeControl(this);
						SetCurrentlyControlled(mContactCharacter);
					}
				}
					
				//reset getting touched
				mContactCharacter = null;
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
		override public function hitRight(Contact:FlxObject, Velocity:Number):void 
		{
			super.hitRight(Contact, Velocity);
			
			if (Contact is ControllableCharacter)
			{
				mContactCharacter = Contact as ControllableCharacter;
			}
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
			if (mCurrentlyControlled != null)
			{				
				//move along with this
				this.x = mCurrentlyControlled.x;
				this.y = mCurrentlyControlled.y;
			}
			
			HandleInput();
			
			super.update();
		}
		
		public function SetCurrentlyControlled(character:ControllableCharacter):void {
			if (mCurrentlyControlled == null)
			{
				mCurrentlyControlled = character;
				
				//debug "dissapear"
				this.alpha = 0;
				this.solid = false;
				this.fixed = true;
			}
			else 
			{
				mCurrentlyControlled.CleanUp();
				mCurrentlyControlled = character;
				
				this.alpha = 1 ;
				this.solid = true;
				this.fixed = false;
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
		
		private var mContactCharacter:ControllableCharacter;
		
	}

}