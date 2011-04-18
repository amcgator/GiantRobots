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
	public class PlayerCharacter extends GameObject
	{
		
		public function PlayerCharacter(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);	
			this.createGraphic(1, 1);
		}
		
		override public function update():void 
		{
			if (mCurrentlyControlled != null) {
				mCurrentlyControlled.HandleInput();
			}
			
			super.update();
		}
		
		public function SetCurrentlyControlled(GC:GameCharacter):void {
			if (mCurrentlyControlled == null)
			{
				mCurrentlyControlled = GC;
			}
			else {
				mCurrentlyControlled.CleanUp();
				mCurrentlyControlled = GC;
			}
		}
		
		public function GetCurrentlyControlled():GameCharacter {
			return mCurrentlyControlled;
		}
		
		private var mCurrentlyControlled:GameCharacter;
		
	}

}