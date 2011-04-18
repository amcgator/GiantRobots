package Symbols.GameObjects.Characters 
{
	import Symbols.GameObjects.GameObject;
	/**
	 * Represents a character that can either be controlled by the player or by AI
	 * @author Scano
	 */
	public class ControllableCharacter extends GameCharacter
	{
		//Control Enums - what state of control is this character in?
		
		//invalid state - if we're here, we hit a bug
		public static const CONTROL_STATE_INVALID:int = 0;
		//the player is in control
		public static const CONTROL_STATE_PLAYER:int = 1;
		//the ai is in control
		public static const CONTROL_STATE_AI:int = 2;
		//the character is dormant, with nothing in control
		public static const CONTROL_STATE_DORMANT:int = 3;
		//the max state, also invalid
		public static const CONTROL_STATE_MAX:int = 4;
		
		public function ControllableCharacter(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			
			mControlState = CONTROL_STATE_DORMANT;
			mController = null;
		}
		
		override public function update():void 
		{
			super.update();
		
			//maybe have stuff in here for AI?
		}
		
		/**
		 * Take over this device
		 * @param	controller - who is taking control?
		 */
		public function TakeControl(controller:GameObject):void
		{
			if (mController != null)
			{
				//reject the old controller somehow
			}
			
			//switch state according to who's taking over
			if (controller is PlayerCharacter)
			{
				ChangeState(CONTROL_STATE_PLAYER);
			}
			else
			{
				ChangeState(CONTROL_STATE_AI);
			}
			mController = controller;
		}
		
		/**
		 * Sets this character to dormant, kicking out its current controller (if any)
		 * @return
		 */
		public function DisableControl():GameObject
		{
			var oldController:GameObject = mController;
			
			ChangeState(CONTROL_STATE_DORMANT);
			
			//if old controller isn't null, reject is somehow here
			
			mController = null;
			return oldController;
		}
		
		/**
		 * Returns true if this device is player controlled
		 * @return
		 */
		public function IsPlayerControlled():Boolean
		{
			return (mControlState == CONTROL_STATE_PLAYER);
		}
		
		/**
		 * Returns true if this device is currently lying dormant
		 * @return
		 */
		public function IsDormant():Boolean
		{
			return (mControlState == CONTROL_STATE_DORMANT);
		}
		
		/**
		 * Handles state changes
		 * @param	newState
		 */
		protected function ChangeState(newState:int):void
		{
			//clean up old state
			switch(mControlState)
			{
				case CONTROL_STATE_PLAYER:
					break;
				case CONTROL_STATE_AI:
					break;
				case CONTROL_STATE_DORMANT:
					break;
				default:
					break;
			}
			
			mControlState = newState;
			
			//introduce new state
			switch(mControlState)
			{
				case CONTROL_STATE_PLAYER:
					break;
				case CONTROL_STATE_AI:
					break;
				case CONTROL_STATE_DORMANT:
					break;
				default:
					break;
			}
		}
		
		
		//is the player controlling this, or is it AI control, or is it dead/dormant?
		protected var mControlState:int;
		
		//who is currently controlling this character?
		protected var mController:GameObject;
	}

}