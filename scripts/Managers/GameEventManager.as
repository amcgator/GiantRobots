package Managers 
{
	import flash.events.Event;
	import GameControl.CustomEvents.LevelEvent;
	/**
	 * Acts as a dispatcher of game logic events
	 * @author Scano
	 */
	public class GameEventManager extends GameManager
	{
		//singleton instance
		private static var mInstance:GameEventManager = null;
		//a dictionary object of events to subscribers
		private var mSubscriberDict:Object;
		//all events that have been registered with this service and can be subscribed to
		private var mRegisteredEvents:Array;
		
		public function GameEventManager() 
		{
			super();
			
			mSubscriberDict = new Object();
			mRegisteredEvents = new Array();	
		}
		
		//==================================================
		//Singleton functions
		//==================================================
		public static function Create():void
		{
			if (mInstance == null)
			{
				mInstance = new GameEventManager();
			}
			else
			{
				trace("Tried to create GameEventManager when it already exists");
			}
		}
		
		public static function GetInstance():GameEventManager { return mInstance; }
		
		override public function Init():void 
		{
			super.Init();
			//register all events here
			LevelEvent.RegisterEvents(this);
		}

		override public function Shutdown():void 
		{
			UnregisterAllEvents();
			super.Shutdown();
		}
		/**
		 * Add an event type that can be subscribed to
		 * @param	eventType
		 */
		public function RegisterEvent( eventType:String ):void
		{
			for (var i:int = 0; i < mRegisteredEvents.length; i++) 
			{
				if (mRegisteredEvents[i] == eventType)
				{
					trace("Already registered this event");
					return;
				}
			}
			
			mRegisteredEvents.push(eventType);
			this.addEventListener( eventType, BubbleEvent);
			mSubscriberDict[eventType] = new Array();
		}
		
		/**
		 * Removes an all events, clearing out possible subscriptions
		 */
		public function UnregisterAllEvents():void
		{
			for (var i:int = 0; i < mRegisteredEvents.length; i++) 
			{
				this.removeEventListener( mRegisteredEvents[i], BubbleEvent);
			}
			mRegisteredEvents = new Array();
			mSubscriberDict = new Object();
		}
		
		/**
		 * Adds the object to a list to get sent events that this service gets
		 * @param	subscriber
		 * @param	event
		 */
		public function SubscribeToEvent(subscriber:*, event:String):void
		{
			mSubscriberDict[event].push(subscriber);
		}
		
		/**
		 * Checks if the subscriber is already listening for an event
		 * @param	subscriber
		 * @param	event
		 * @return
		 */
		public function IsSubscribed(subscriber:*, event:String):Boolean
		{
			var array:Array = mSubscriberDict[event] as Array;
			for (var i:int = 0; i < array.length; i++) 
			{
				if (array[i] == subscriber)
				{
					return true;
				}
			}
			return false;
		}
		/**
		 * Removes a subscriber from an event type. the subscriber will no longer receive events
		 * @param	subscriber
		 * @param	event
		 */
		public function UnsubscribeFromEvent(subscriber:*, event:String):void
		{
			var array:Array = mSubscriberDict[event] as Array;
			if (array != null)
			{
				for (var i:int = 0; i < array.length; i++) 
				{
					if (array[i] == subscriber)
					{
						array.splice(i, 1);
						break;
					}
				}
			}
		}
		
		/**
		 * Simply passes the event to all subscribers of it
		 * @param	event
		 */
		private function BubbleEvent(event:Event):void
		{
			var cleanList:Array = new Array();
			var array:Array = mSubscriberDict[event.type] as Array;
			var i:int;
			if (array != null)
			{
				for (i= 0; i < array.length; i++) 
				{
					//clean out any null subscribers found
					if (array[i] == null)
					{
						cleanList.push(array[i]);
					}
					else
					{
						array[i].dispatchEvent(event);
					}
				}
			}
			
			for (i = 0; i < cleanList.length; i++) 
			{
				UnsubscribeFromEvent(cleanList[i], event.type)
			}
		}
				
		
	}

}