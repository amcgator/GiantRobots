package GameControl.CustomEvents 
{
	import flash.events.Event;
	import Managers.GameEventManager;
	/**
	 * ...
	 * @author Scano
	 */
	public class LevelEvent extends Event
	{
		public static const LEVEL_START_EVENT:String = "Level Start";
		public static const LEVEL_END_EVENT:String = "Level End";
				
		public function LevelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
		}
		
		public static function RegisterEvents(manager:GameEventManager):void
		{
			manager.RegisterEvent(LEVEL_END_EVENT);
			manager.RegisterEvent(LEVEL_START_EVENT);
		}
		
		/**
		 * Gets a clone of the GameControlEvent
		 * @return A clone of the event
		 */
		public override function clone():Event 
		{ 
			return new LevelEvent(type, bubbles, cancelable);
		} 
		
		/**
		 * Gets the SlashEvent as a string
		 * @return A string representation of the event
		 */
		public override function toString():String 
		{ 
			return formatToString("LevelEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}

}