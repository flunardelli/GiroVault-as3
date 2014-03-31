package 
{
	import flash.errors.EOFError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	public class Cache
	{
		/** the last timestamp a deep save was completed */
		private var mLastSave:Number = -1;
		private static var cacheDir : File ; // Cached data may be purged in low storage situations, and is not backed up by iTunes or iCloud.
		// Instance Vars
		
		public function Cache()
		{
		}
		
		
		
		private static function configDataStorage() : File
		{
			var applicationHome : String = File.userDirectory.nativePath;
			var publicStorage : String = File.documentsDirectory.nativePath;
			var privateStorage : String = File.applicationStorageDirectory.nativePath;
						
			if( version=="IOS" && (os!="Mac" || os!="Win" ) )
			{
				cacheDir = new File( applicationHome + '/Library/Caches' );
				trace("iOS Data Storage");
			}
			else
			{
				cacheDir = new File( privateStorage + '/Caches' );
				trace("Data Storage");
			}
			//trace("- Public: "+_$publicDir.nativePath +"\n- Private: "+_$privateDir.nativePath +"\n- Cache: "+_$cacheDir.nativePath +"\n- Temp: "+_$tempDir.nativePath );
			cacheDir.preventBackup = true;
			return cacheDir;
		}
		
		/**
		 * save the state of the globals object and all of its
		 * sub objects.
		 * @warning
		 * all objects must implement variables in a "public" state.
		 * Private variables are not saved within the persistance manager
		 */
		public static function save(data:Object,ns:String):void{
			var so:SharedObject = SharedObject.getLocal(ns);
			so.data.cache = data;
			so.flush();
			//saveDeep(data,ns);
		}
		
		
		/**
		 * Save the SharedObject to denoted mobile applicationStorageDirectory.
		 */ 
		public static function saveDeep(data:Object,ns:String):void{
			// save on first application save or after
			// every 5 minutes
			//if(mLastSave == -1 || mLastSave < getTime() + 300000){
				//mLastSave = getTime();
			
				var file:File = configDataStorage().resolvePath(ns);
				var fileStream:FileStream = new FileStream(); 
				fileStream.open(file, FileMode.WRITE);
				var ba:ByteArray = new ByteArray();
				ba.writeObject(data);
				fileStream.writeBytes(ba);
				fileStream.close();
			//}   
		}
		
		
		/**
		 * Load the application from the SharedObject be default
		 * if the SharedObject DNE attempt to load from the 
		 * applicationStorageDirectory, if neither exist
		 * create new User object
		 */ 
		public static function load(ns:String):Object{
			var data:Object;
			//registerClassAlias("user", User);
			
			// Create/read a shared-object named "userData"
			var so:SharedObject = SharedObject.getLocal(ns); 
			//var u:User;
			if(so.data != null){
				data = so.data;
				//so.clear();
			}
			
			trace("Loading application...");
			
			if (data != null && data.cache){
				trace("LOADING SAVE DATA");
				data = data.cache;
			} else{
				trace("NO SAVE DATA EXISTS");
				var file:File = configDataStorage().resolvePath(ns);
				if (file.exists){
					trace("Found userSave backup -attempting to load");
					var fileStream:FileStream = new FileStream(); 
					fileStream.open(file, FileMode.READ);
					var ba:ByteArray = new ByteArray();
					fileStream.readBytes(ba);
					fileStream.close();
					try{
						data = ba.readObject();
					}catch( e : EOFError ){
						trace("SharedObject did not exist, attempted userSave load, failed");
					}
				}else{          
					//user = new User();
					trace("created New user...");
				}
			}
			for (var s:String in data) {
				return data;
			}
			return false;
		}
		
		// String helper
		public static function returnFirstWord( s : String ) : String
		{
			var i:int = s.indexOf(" ");
			var len:uint = (i>0) ? i : s.length;
			return s.substring(0, len);
		}
		
		public static function get os() : String
		{
			return returnFirstWord( Capabilities.os );
		}
		
		public static function get version() : String
		{			
			return returnFirstWord( Capabilities.version );
		}
	}
	
	
}



