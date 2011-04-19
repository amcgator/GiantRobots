package Symbols.GameObjects.Characters 
{
	/**
	 * ...
	 * @author Steve and Alicia
	 */
	public class NonPlayerCharacter extends GameCharacter 
	{
		
		public function NonPlayerCharacter(X:Number = 0, Y:Number = 0)  
		{
			super(X, Y);	
			this.createGraphic(8, 8, 0xff00ff00);
		}

		override public function update():void 
		{
			if (mCurrentlyControlled != null) {
				mCurrentlyControlled.AI();
			}
			else {
				AI();
			}
			super.update();
		}
		
		override public function AI(): void 
		{
			//base movement here
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
		private var mCurrentlyControlled:ControllableCharacter;
	}

}