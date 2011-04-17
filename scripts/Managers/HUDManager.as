package Managers 
{
	import caurina.transitions.Tweener;
	import Constants.GameplayConstants;
	import flash.events.MouseEvent;
	import Utils.MathHelpers;
	/**
	 * ...
	 * @author Scano
	 */
	public class HUDManager extends GameManager
	{
		
		public function HUDManager() 
		{
			super();
		}
		
		//==================================================
		//Singleton functions
		//==================================================
		public static function Create():void
		{
			if (mInstance == null)
			{
				mInstance = new HUDManager();
			}
			else
			{
				trace("Tried to create HUDManager when it already exists");
			}
		}
		
		public static function GetInstance():HUDManager { return mInstance; }
		
		
		override public function Init():void 
		{
			super.Init();
		}
		
		override public function Shutdown():void 
		{
			super.Shutdown();	
			
		}
				
		override public function Update(elapsedTime:Number, totalTime:Number):void 
		{
			super.Update(elapsedTime, totalTime);

		}
		
		//==================================================
		// Member Variables
		//==================================================
		//singleton instance
		private static var mInstance:HUDManager = null;
		
	}

}