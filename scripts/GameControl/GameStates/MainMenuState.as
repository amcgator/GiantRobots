package GameControl.GameStates 
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxRect;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	/**
	 * ...
	 * @author Scano
	 */
	public class MainMenuState extends FlxState
	{
		
		public function MainMenuState() 
		{
			super();
		}
		
		override public function create():void 
		{
			super.create();
			
			mStartButton = new FlxButton( FlxG.width / 2, FlxG.height / 2, OnStartClick);
			
			var buttonText:FlxText = new FlxText(0, 0, 200, "Start");
			buttonText.setFormat(null, 10, 0xff000000);
			
			mStartButton.loadText( buttonText );
			//mStartButton.add(buttonText);
			
			this.add(mStartButton);
		}
		
		override public function update():void 
		{
			super.update();
		}
		
		private function OnStartClick():void
		{
			FlxG.state = new PlayState();
		}
		
		private var mStartButton:FlxButton;
	}

}