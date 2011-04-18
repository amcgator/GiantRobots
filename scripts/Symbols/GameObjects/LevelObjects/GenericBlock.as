package Symbols.GameObjects.LevelObjects 
{
	import Symbols.GameObjects.GameObject;
	/**
	 * ...
	 * @author ...
	 */
	public class GenericBlock extends GameObject
	{
		
		public function GenericBlock(X:Number = 0, Y:Number = 0, Width:Number = 32, Height:Number = 32, Color:uint=0xffffffff) 
		{
			super(X, Y);
			
			this.createGraphic(Width, Height, Color);
			
			this.fixed = true;
		}
	
		
	}

}