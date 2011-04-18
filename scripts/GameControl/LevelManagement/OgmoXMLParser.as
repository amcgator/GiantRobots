package GameControl.LevelManagement 
{
	import Constants.GameAssets;
	import Constants.GameplayConstants;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import Symbols.GameObjects.Characters.IronManRobot;
	import Symbols.GameObjects.LevelObjects.GenericBlock;
	import GameControl.LevelManagement.Level;
	import GameControl.LevelManagement.OgmoTilemap;
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
			for each (var spawn:XML in obj.playerSpawn) 
			{
				mCurrentLevel.mStartingSpawnPoint.x = Number(spawn.@x);
				mCurrentLevel.mStartingSpawnPoint.y = Number(spawn.@y);
			}
			for each (var genericBlock:XML in obj.genericBlock)
			{
				var block:GenericBlock = new GenericBlock( Number(genericBlock.@x), Number(genericBlock.@y) );
				mCurrentLevel.AddObject(block);
			}
			for each(var ironMan:XML in obj.ironMan)
			{
				var iron:IronManRobot = new IronManRobot( Number(ironMan.@x), Number(ironMan.@y) );
				//deal with the "Active" value here
				mCurrentLevel.AddObject(block);
			}
		}
		
		public function get level():Level { return mCurrentLevel; }
		
	
		private var mCurrentLevel:Level;
	}

}