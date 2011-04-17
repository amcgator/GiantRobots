package GameControl.LevelManagement 
{
	import Constants.GameAssets;
	import Constants.GameplayConstants;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import symbols.levelmanagement.Level;
	import symbols.levelmanagement.OgmoTilemap;
	import Utils.ConfigFile;
	/**
	 * ...
	 * @author Scano
	 */
	public class OgmoXMLParser extends EventDispatcher
	{
		
		public function OgmoXMLParser() 
		{
			super();
		}
		
		/**
		 * Reads a level xml and parses it out
		 * @param	level
		 */
		public function LoadLevel(level:Level, xmlName:String):void
		{
			mCurrentLevel = level;
			var levelConfig:ConfigFile = new ConfigFile();
			levelConfig.Load(xmlName, ParseLevelXML);
		}
		
		public function ParseLevelXML(data:XML):void
		{
			//parse the main level
			//var ogmoTile:OgmoTilemap = new OgmoTilemap();
			//ogmoTile.LoadTilemap(data, "stage", GameAssets.GameTiles);

			for each (var obj:XML in data.objects) 
			{
				FactoryObjects(obj, mCurrentLevel);
			}
			
			dispatchEvent(new Event("LEVEL LOADED") );
		}
		
		/**
		 * Factories out the objects and adds them to the provided level
		 * @param	obj - the XML that contains all of the objects in a level
		 * @param	level - the level to add the objects to
		 */
		private function FactoryObjects(obj:XML, level:Level):void
		{
			
		}
		
		public function get level():Level { return mCurrentLevel; }
		
	
		private var mCurrentLevel:Level;
	}

}