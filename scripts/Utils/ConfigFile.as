package Utils
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * A class to load and an XML file
	 * @author mprestia
	 */
	public class ConfigFile
	{
		// The URL loader to load the XML file
		private var mLoader:URLLoader;
		
		// The name of the file to load
		private var mFilename:String;
		
		// The function to call when loading is complete
		private var mCallback:Function;
		
		/**
		 * ConfigFile constructor
		 */
		public function ConfigFile() 
		{
			mLoader = null;
			mFilename = null;
		}
		
		/**
		 * Loads the given XML file
		 * @param	filename The name of the XML file to load
		 * @param	callback The function to call when loading has completed
		 */
		public function Load(filename:String, callback:Function):void 
		{
			// Store the filename to load
			mFilename = filename;
			
			// Sore the callback function
			mCallback = callback;
			
			// Create the URL loader
			var mLoader:URLLoader = new URLLoader();
			
			// Create a URL request for the XML file
			var urlRequest:URLRequest = new URLRequest(filename);
			
			// Start loading the request
			mLoader.load(urlRequest);
			
			// Listen for when the request is done loading
			mLoader.addEventListener(Event.COMPLETE, OnLoadComplete);
			
			// Listen for when the file fails to load
			mLoader.addEventListener(IOErrorEvent.IO_ERROR, OnLoadFailed);
		}
		
		/**
		 * Callback for when the request is done loading
		 * @param	event The event containing the loaded data
		 */
		private function OnLoadComplete(event:Event):void
		{
			trace("Loaded config file " + mFilename + ".");
			
			// Invoke the callback function with the loaded data
			mCallback.call(this, new XML(event.target.data));
			
			event.target.removeEventListener(Event.COMPLETE, OnLoadComplete);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, OnLoadFailed);
			
			// Set the URL loader to null
			mLoader = null;
		}
		
		/**
		 * Callback for if the file load fails
		 * @param	event The IO error event
		 */
		private function OnLoadFailed(event:IOErrorEvent):void
		{
			trace("Failed to load config file " + mFilename + ".");
			
			event.target.removeEventListener(Event.COMPLETE, OnLoadComplete);
			event.target.removeEventListener(IOErrorEvent.IO_ERROR, OnLoadFailed);
			
			// Set the URL loader to null
			mLoader = null;
		}
	}
}