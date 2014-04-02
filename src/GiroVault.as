package
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	
	[SWF( width="600", height="600", backgroundColor="#B7DC11", frameRate="24" )]
	public class GiroVault extends Sprite
	{
		private var _starling:Starling;
		
		[Embed(source = "/assets/logo.png")]
		public static const LogoImage:Class;
		
		public var logoImage:Bitmap;
		
		public static var settings:Object = {};
		
		public function GiroVault()
		{
			//stage.align = StageAlign.TOP_LEFT;
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			var fact:Number = stage.fullScreenHeight / stage.fullScreenWidth;
			
			var stageWidth:int  = (fact == 1.5) ? (380): 380;
			var stageHeight:int = (fact == 1.5) ? (570): 680;
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			settings = Cache.load('girovault-settings');
			if (!settings) {
				settings = {};
			}
			
			logoImage = new LogoImage();
				
			logoImage.x = (stage.fullScreenWidth / 2) - (logoImage.width /2);
			logoImage.y = (stage.fullScreenHeight / 2) - (logoImage.height /2); 	
			addChild(logoImage);
			
			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			// create a suitable viewport for the screen size
			// 
			// we develop the game in a *fixed* coordinate system of 320x480; the game might 
			// then run on a device with a different resolution; for that case, we zoom the 
			// viewPort to the optimal size for any display and load the optimal textures.
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL, false);
			
			// create the AssetManager, which handles all required assets for this resolution
			
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			//trace(stage.fullScreenSourceRect);
			//trace(viewPort.width);
			//trace(scaleFactor);
			
			_starling = new Starling(Game, stage, viewPort);
			_starling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			_starling.stage.stageHeight = stageHeight; // <- same size on all devices!
			_starling.simulateMultitouch  = false;
			_starling.enableErrorChecking = false;
			
			
			_starling.showStats = false;
			
			/*
			
			
			_starling = new Starling(Game, stage, stage.fullScreenSourceRect);
			_starling.stage.stageWidth = stage.fullScreenWidth;
			_starling.stage.stageHeight = stage.fullScreenHeight;
			_starling.enableErrorChecking = true;			
			_starling.showStats = true;
			_starling.start();
			*/
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				//removeChild(background);
				
				//var game:Game = mStarling.root as Game;
				//var bgTexture:Texture = Texture.fromBitmap(background, false, false, scaleFactor);
				
				//game.start(bgTexture, assets);
				removeChild(logoImage);
				_starling.start();
			});
		}
		
	}
}