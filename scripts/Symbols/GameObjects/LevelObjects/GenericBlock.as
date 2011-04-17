package Symbols.GameObjects.LevelObjects 
{
	import Symbols.GameObjects.GameObject;
	/**
	 * ...
	 * @author ...
	 */
	public class GenericBlock extends GameObject
	{
		
		public function GenericBlock(X:Number = 0, Y:Number = 0 ) 
		{
			super(X, Y);
			
			this.createGraphic(32, 32, 0xff555555);
			
			this.fixed = true;
		}
	
		
	}

}