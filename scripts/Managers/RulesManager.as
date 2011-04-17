package Managers 
{
	import Constants.GameplayConstants;
	import flash.events.Event;
	/**
	 * ...
	 * @author Scano
	 */
	public class RulesManager extends GameManager
	{
		
		public function RulesManager() 
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
				mInstance = new RulesManager();
			}
			else
			{
				trace("Tried to create RulesManager when it already exists");
			}
		}
		public static function GetInstance():RulesManager { return mInstance; }
		
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
				
		public function Reset():void
		{
		}
		
		//=============================================
		/// Member Variables
		//=============================================
		//singleton instance
		private static var mInstance:RulesManager = null;

		
		
	}

}