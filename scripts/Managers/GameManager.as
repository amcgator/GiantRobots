package Managers 
{
	import flash.events.EventDispatcher;
	/**
	 * Base class for all managers in the game. Made into a class instead of an interface to allow for
	 * future expansion as needed
	 * @author Scano
	 */
	public class GameManager extends EventDispatcher
	{
		
		public function GameManager() 
		{
			super();
			mActive = false;
		}
		
		/**
		 * Starts up the manager
		 */
		public function Init():void
		{
			mActive = true;
		}
		
		public function Update(elapsedTime:Number, totalTime:Number):void
		{
			if (!mActive) { return; }
		}
				
		public function Shutdown():void
		{
			mActive = false;
		}
		
		public function Suspend():void
		{
			mActive = false;
		}
		
		public function Resume():void
		{
			mActive = true;
		}
		
		public function get active():Boolean { return mActive; }
		//if the manager is active and updating
		protected var mActive:Boolean;
		
	}

}