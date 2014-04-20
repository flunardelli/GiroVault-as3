package
{
	import flash.display.BitmapData;
	
	import abba.master.Features;
	import abba.master.Rnd;
	import abba.master.Scr;
	import abba.master.Snd;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.deg2rad;
	
	

	public class Game extends Sprite
	{
		
		//[Embed(source = "/assets/twitter.png")]
		//public static const TwitterImage:Class;
		
		[Embed(source="/assets/fonts/lcd.ttf", embedAsCFF="false", fontFamily="Dots")]
		private static const Dots:Class;
		
		public static var scr:Scr;
		
		public static var isMuted:Boolean;
		
		public static var SCR_WIDTH:int = 465, SCR_HEIGHT:int = 465;
		
		public static var bd:BitmapData;
		
		public static var rnd:Rnd = new Rnd;
		
		//----------------------------------------------------------------
		public static var TITLE:String = "GiroVault"
		public static var DEBUG:Boolean = true;
		public static var walkSes:Vector.<Snd> = new Vector.<Snd>(2);
		public static var jumpSe:Snd, landSe:Snd, deadSe:Snd;
		public static var scrollSe:Snd;
		public static var nextFloorAddDist:Number;
		public static var scrollDist:Number;
		public static var scrollXDist:Number;
		public static var rank:Number;
		
		public static var rotationSpeed:Number;
		public static var rotationSpeedOri:Number = 2000;
		public static var rotationReverse:Boolean = false;
		
		public static var score:int, ticks:int, currentTimer:int;
		
		public static var img:Image;
		
		public static var useAccelerometer:Boolean;
		public static var features:Features;
		//[Embed(source = "/assets/pause.png")]
		//public static const PauseImage:Class;
		
		//[Embed(source = "/assets/left.png")]
		//public static const LeftImage:Class;
		
		//[Embed(source = "/assets/right.png")]
		//public static const RightImage:Class;
		
		//[Embed(source = "/assets/body.png")]
		//public static const BodyImage:Class;
		
		// Embed the Atlas XML
		[Embed(source="/assets/sprites.xml", mimeType="application/octet-stream")]
		public static const AtlasXml:Class;
		
		// Embed the Atlas Texture:
		[Embed(source="/assets/sprites.png")]
		public static const AtlasTexture:Class;
		
		public static var atlas:TextureAtlas;
		
		public function Game() {
			
			var texture:Texture = Texture.fromBitmap(new AtlasTexture());
			var xml:XML = XML(new AtlasXml());
			atlas = new TextureAtlas(texture, xml);
			
			if (GiroVault.settings.hasOwnProperty('isMuted')) {
				isMuted = GiroVault.settings.isMuted;			
			}
			if (GiroVault.settings.hasOwnProperty('useAccelerometer')) {
				useAccelerometer = GiroVault.settings.useAccelerometer;			
			}
			addEventListener(Event.ADDED_TO_STAGE, init);	
			
		}
		
		private function init(e:Event):void {		
			main = this;
			Game.SCR_WIDTH =  stage.stageWidth;
			Game.SCR_HEIGHT = stage.stageHeight;
			initializeFirst();
		}
		
		static public function rotateStage():void {
			img.pivotX = Game.SCR_WIDTH / 2.0;
			img.pivotY = Game.SCR_HEIGHT / 2.0;
			img.x = img.pivotX;
			img.y = img.pivotY;
			
			if (isInGame) {
				if (img.rotation > 360 || img.rotation < -360) {
					img.rotation = 0
				} else {
					if (rotationReverse) {
						img.rotation -= deg2rad(1);			
					} else {
						img.rotation += deg2rad(1);
					}
				}
			}
		}
	}
}

var useFilter:Boolean = true;




import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.StageOrientation;
import flash.display3D.textures.Texture;
import flash.events.AccelerometerEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.Vector3D;
import flash.media.AudioPlaybackMode;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.net.getClassByAlias;
import flash.sensors.Accelerometer;
import flash.utils.ByteArray;
import flash.utils.clearInterval;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;
import flash.utils.setInterval;
import flash.utils.setTimeout;

import abba.master.Clr;
import abba.master.Features;
import abba.master.Floor;
import abba.master.Key;
import abba.master.Msg;
import abba.master.Ptc;
import abba.master.Rnd;
import abba.master.Scr;
import abba.master.Shp;
import abba.master.Snd;
import abba.master.Spr;
import abba.master.Utils;
import abba.master.Vct;

import starling.core.Starling;
import starling.core.starling_internal;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.KeyboardEvent;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.BlurFilter;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import starling.utils.HAlign;
import starling.utils.VAlign;
import starling.utils.deg2rad;

var deadCounter:Number = 0;

var deaths:Object = {};
var startImg:Image;
var introImg:Image;
var pauseImg:Image;
var exitImg:Image;
var leaderboardImg:Image;
var body:Image;

var twitterImg:Image;

var leftImg:Image;
var rightImg:Image;

var main:Game;


var baseSprite:Sprite;
var bgColor:uint = 0xB7DC11;
var tex:starling.textures.Texture;



var fpsText:TextField;




var scoreTextField:TextField;
//var tweetTextField:TextField;
//var pausedTextField:TextField;
//var useAccelerometerTextField:TextField;
var beginTextField:TextField;
var menuTextField:TextField;
var endTextField:TextField;
var loadingTextField:TextField;
var useAccelerometerImg:Image;
var backImg:Image;
var soundImg:Image;

var backgroundSe:Snd;
var blur:BlurFilter;

const MENU_MSG:String = "GIROVAULT\n\n\nTAP\nTO\nSTART";
const BEGIN_MSG:String = "ESCAPE\nFROM\nGIROVAULT";
const END_MSG:String = "GAME OVER\n\nYOUR SCORE IS %SCORE%\n\nTAP TO START";

const TWEET1:String = "So bad";//<=300
const TWEET2:String = "Oh, damn";//<=600
const TWEET3:String = "Warming up";//<=1200
const TWEET4:String = "A bit better";//<=2000
const TWEET5:String = "Much better";//<=3000
const TWEET6:String = "Awesome";//<=4000
const TWEET7:String = "Marvelous";//<=5000
const TWEET8:String = "Almost perfect"; //<=6000
const TWEET9:String = "Perfect"; //<=9000
const TWEET10:String = "You'll be remembered such a hero"; //<=10000
//const TWEET_MSG:String = "TWEET THIS";
//const PAUSED_MSG:String = "TAP TO BACK\n\nSOUND: %SOUND%\n\nACCELEROMETER: %ACCEL%";
//const LEADERBOARD_MSG:String = "LEADERBOARD";
//const ON_MSG:String = "ON";
//const OFF_MSG:String = "OFF";
const LOADING_MSG:String = "LOADING";







function initializeFirst():void {
	
	Game.rotationSpeed = Game.rotationSpeedOri;
	
	//silent switch support
	//SilentSwitch.apply();
	SoundMixer.audioPlaybackMode  =  AudioPlaybackMode.AMBIENT;
	
	Game.features = new Features();

	Shp.initialize();
	Game.scr = new Scr;
	
	Game.bd = new BitmapData(Game.scr.pixelSize.x, Game.scr.pixelSize.y, true, bgColor);		
	baseSprite = new Sprite;	
	tex = starling.textures.Texture.fromBitmapData(Game.bd);
	Game.img = new Image(tex);
	
	
	//backgroundSe = new Snd("AudioBackground");
		
	//var blur:BlurFilter = new BlurFilter(1,1,0.9);	
	//img.filter = blur;
	//img.filter = BlurFilter.createGlow(0x00ff00,1.5,8,0.4);
	
	baseSprite.addChild(Game.img);	
	
	scoreTextField = new TextField(Game.SCR_WIDTH - 5, 50, "0", "Dots", 32, Color.BLACK);
	scoreTextField.hAlign = HAlign.RIGHT;
	scoreTextField.vAlign = VAlign.BOTTOM;
	
	
	beginTextField = new TextField(Game.SCR_WIDTH, Game.SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	beginTextField.hAlign = HAlign.CENTER;
	beginTextField.vAlign = VAlign.CENTER;
	
	endTextField = new TextField(Game.SCR_WIDTH, Game.SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	endTextField.hAlign = HAlign.CENTER;
	endTextField.vAlign = VAlign.CENTER;
	
	menuTextField = new TextField(Game.SCR_WIDTH, Game.SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	menuTextField.hAlign = HAlign.CENTER;
	menuTextField.vAlign = VAlign.CENTER;
	
	//tweetTextField = new TextField(Game.SCR_WIDTH, Game.SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	//tweetTextField.hAlign = HAlign.CENTER;
	//tweetTextField.vAlign = VAlign.CENTER;
	
	//pausedTextField = new TextField(Game.SCR_WIDTH, Game.SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	//pausedTextField.hAlign = HAlign.CENTER;
	//pausedTextField.vAlign = VAlign.CENTER;	
	
	//useAccelerometerTextField = new TextField(Game.SCR_WIDTH, Game.SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	//useAccelerometerTextField.hAlign = HAlign.CENTER;
	//useAccelerometerTextField.vAlign = VAlign.CENTER;	
	
	
	loadingTextField = new TextField(Game.SCR_WIDTH, Game.SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	loadingTextField.hAlign = HAlign.CENTER;
	loadingTextField.vAlign = VAlign.CENTER;
	
	//pauseImg = new Image(starling.textures.Texture.fromBitmap(new Game.PauseImage()));
	pauseImg = new Image(Game.atlas.getTexture("pause"));
	//twitterImg = new Image(starling.textures.Texture.fromBitmap(new Game.TwitterImage()));
	
	
	main.addChild(new Image(starling.textures.Texture.fromBitmapData(new BitmapData(Game.scr.pixelSize.x, Game.scr.pixelSize.y, false, bgColor))));
	
	//leftImg = new Image(starling.textures.Texture.fromBitmap(new Game.LeftImage()));
	//rightImg = new Image(starling.textures.Texture.fromBitmap(new Game.RightImage()));
	leftImg = new Image(Game.atlas.getTexture("left"));
	rightImg = new Image(Game.atlas.getTexture("right"));
	//backround1 = new Game.AudioBackground1();
	//backround1.play(0,999999);
	//backgroundSe.play(9999999);
	//audioData1 = new Game.AudioData1();
	//playMIDIFile(audioData1);
		
	main.addChild(baseSprite);
	main.addChild(scoreTextField);

	pauseImg.x = 10;
	pauseImg.y = 10;
	pauseImg.name = 'pause';
	main.addChild(pauseImg);
	pauseImg.visible = false;
	
	beginTextField.text = BEGIN_MSG;
	beginTextField.visible = false;
	main.addChild(beginTextField);
	
	endTextField.text = END_MSG;
	endTextField.visible = false;
	main.addChild(endTextField);
	
	//pausedTextField.text = PAUSED_MSG.replace('%SOUND%',ON_MSG).replace('%ACCEL%',OFF_MSG);
	//pausedTextField.visible = false;
	//main.addChild(pausedTextField);
	
	loadingTextField.text = LOADING_MSG;
	//loadingTextField.visible = false;
	//main.addChild(loadingTextField);
	
	soundImg = new Image(Game.atlas.getTexture("sound-on"));
	useAccelerometerImg = new Image(Game.atlas.getTexture("accel-on"));
	backImg = new Image(Game.atlas.getTexture("back"));
	
	//soundTextField.text = SOUND_MSG+" "+ON_MSG;
	//soundTextField.visible = false;
	//soundTextField.y = pausedTextField.y + 50;
	//main.addChild(soundTextField);

	//tweetTextField.text = TWEET_MSG;
	//tweetTextField.visible = false;
	//tweetTextField.y = endTextField.y + 200;
	//main.addChild(tweetTextField);
	
	
	backImg.x = Game.SCR_WIDTH /2 - backImg.width/2;
	backImg.y = Game.SCR_HEIGHT /2 - backImg.height;
	backImg.name = 'back';
	backImg.visible = false;
	main.addChild(backImg);

	useAccelerometerImg.x = Game.SCR_WIDTH /2 - useAccelerometerImg.width/2;
	useAccelerometerImg.y = backImg.y+useAccelerometerImg.height;
	useAccelerometerImg.name = 'accelerometer';
	useAccelerometerImg.visible = false;
	main.addChild(useAccelerometerImg);

	soundImg.x = Game.SCR_WIDTH /2 - soundImg.width/2;
	soundImg.y = useAccelerometerImg.y+soundImg.height;
	soundImg.name = 'sound';
	soundImg.visible = false;
	main.addChild(soundImg);
	
	twitterImg = new Image(Game.atlas.getTexture("twitter"));
	twitterImg.x = Game.SCR_WIDTH /2 - twitterImg.width/2;
	twitterImg.y = endTextField.textBounds.bottom+42;
	twitterImg.name = 'twitter';
	twitterImg.visible = false;
	main.addChild(twitterImg);
	
	leftImg.x = 0;
	leftImg.y = Game.SCR_HEIGHT - 74;
	leftImg.name = 'left';
	leftImg.visible = false;
	main.addChild(leftImg);
			
	rightImg.x = Game.SCR_WIDTH - 189;
	rightImg.y = Game.SCR_HEIGHT - 74;
	rightImg.name = 'right';
	rightImg.visible = false;
	main.addChild(rightImg);
	
	
	
	exitImg = new Image(Game.atlas.getTexture("exit"));
	exitImg.x = Game.SCR_WIDTH /2 - exitImg.width/2;
	exitImg.y = Game.SCR_HEIGHT - exitImg.height;
	exitImg.name = 'exit';
	exitImg.visible = false;
	main.addChild(exitImg);
	

	menuTextField.text = MENU_MSG;
	menuTextField.visible = true;
	main.addChild(menuTextField);
	
	leaderboardImg = new Image(Game.atlas.getTexture("leaderboard"));
	leaderboardImg.x = Game.SCR_WIDTH /2 - leaderboardImg.width/2;
	leaderboardImg.y = Game.SCR_HEIGHT - leaderboardImg.height;
	leaderboardImg.name = 'leaderboard';
	leaderboardImg.visible = (Features.supportGameCenter) ? true : false;
	main.addChild(leaderboardImg);
	
	mse = new Mse;
	key = new Key(main);
	initialize();
	showMenu(true);

	//beginGame();
	
	Starling.current.nativeStage.addEventListener(Event.ACTIVATE, onActivated);
	Starling.current.nativeStage.addEventListener(Event.DEACTIVATE, onDectivated);
	Starling.current.nativeStage.addEventListener(Event.ENTER_FRAME, updateFrame);
		
	Game.currentTimer = setInterval(Game.rotateStage,Game.rotationSpeed);
}



function updateFrame(event:Event):void {	
	if (Game.img) { 
		Game.bd.lock();
		Game.bd.fillRect(Game.bd.rect, bgColor);
		updateGame();	   
		Game.bd.unlock();
		flash.display3D.textures.Texture(Game.img.texture.base).uploadFromBitmapData(Game.bd);
	}
}



var mse:Mse;
class Mse {
	public var pos:Vct = new Vct;
	public var touch:Touch;
	public var isPressing:Boolean;
	public function Mse() {		
		main.addEventListener(TouchEvent.TOUCH,handleTouch);
	}
	
	private function handleTouch(e:TouchEvent):void {		
		touch = e.getTouch(main.stage);
		if (!touch)
			return;
		var mousePos:Point = touch.getLocation(main.stage);
		
		switch(touch.phase) {
			case TouchPhase.BEGAN:
				isPressing = true;
				pos.x = mousePos.x; 
				pos.y = mousePos.y;
				break;
			case TouchPhase.MOVED:				
				pos.x = mousePos.x; 
				pos.y = mousePos.y;			
				break;
			case TouchPhase.ENDED:
				//isPressing = false;			
				//trace(e.target);
				isPressing = handleHUD();				
				trace(pos);
				trace(isPressing);
				break;
		}
	}
	
	private function handleHUD():Boolean {
		//pause
		if (isInGame) {
			if (!isPaused && touch.target is Image && touch.target.name == 'pause') {
				trace('pause true');
				isPaused = true;
				clearInterval(Game.currentTimer);	
				return true;
			} else if (isPaused && touch.target is Image && touch.target.name == 'back') {
				trace('pause false');			
				isPaused = false;
				Game.currentTimer = setInterval(Game.rotateStage,Game.rotationSpeed);
				return true;
			}
			//sound
			else if (isPaused && touch.target is Image && touch.target.name == 'sound'){
				Game.isMuted = !Game.isMuted;	
				GiroVault.settings.isMuted = Game.isMuted;
				Cache.save(GiroVault.settings,'girovault-settings');
				return true;
			} else if (isPaused && touch.target is Image && touch.target.name == 'accelerometer') {
				
				Game.useAccelerometer = !Game.useAccelerometer;	
				
				key.dispose();
				key = new Key(main);
				
				GiroVault.settings.useAccelerometer = Game.useAccelerometer;
				Cache.save(GiroVault.settings,'girovault-settings');
				
				return true;
			}
		} else {
			//leaderboard
			if (Features.supportGameCenter) {
				if (isInMenu && !isPaused && !isInGame && touch.target is Image && touch.target.name == 'leaderboard') {		
					trace('leaderboard');
					showLeaderboard();
					return true;
				}
			}
			
			//tweet	
			if (Features.supportTwitter) {
				if (!isInMenu && touch.target is Image && touch.target.name == 'twitter') {
					tweetscore();
					return true;
				}
			}
			
			if (!isInMenu && touch.target is Image && touch.target.name == 'exit') {
				showMenu(true);
				return true;
			}
		}		
		return false;
	}
	
}
var key:Key;


var isInGame:Boolean;
var isInMenu:Boolean;
var isPaused:Boolean;



var wasClicked:Boolean, wasReleased:Boolean;
var titleTicks:int;


function showMenu(s:Boolean):void {
	if (s) {
		menuTextField.visible = true;
		isInMenu = true;
		if (Features.supportGameCenter) {
			leaderboardImg.visible = true;			
		}
		isPaused = false;
		isInGame = false;
		endTextField.visible = false;
		exitImg.visible = false;
		twitterImg.visible = false;
		//tweetTextField.visible = false;
		//rightImg.visible = false;
		//leftImg.visible = false;
		showGamePad = false;
	} else {
		menuTextField.visible = false;
		leaderboardImg.visible = false;
		exitImg.visible = false;
		isInMenu = false;
	}
}

function set showGamePad(v:Boolean):void {
	rightImg.visible = v;
	leftImg.visible = v;
}

function showLoading(s:Boolean):void {
	if (s) {
		main.addChild(loadingTextField);
		showMenu(false);
	} else {
		main.removeChild(loadingTextField);
		showMenu(true);
	}
}

function beginGame():void {
	Game.img.rotation = 0;
	showMenu(false);
	isInGame = true;
	Game.score = 0;
	Game.ticks = 0;
	beginTextField.visible = true;
	endTextField.visible = false;
	exitImg.visible = false;
	//tweetTextField.visible = false;
	twitterImg.visible = false;
	//leftImg.visible = true;
	//rightImg.visible = true;	
	showGamePad = !Game.useAccelerometer;
	Game.rnd = new Rnd;
	initialize();
}

function tweetscore():void {	
	var msg:String = getTweetMsg()+". My score is %SCORE% in #GiroVaultGame";
	msg = msg.replace("%SCORE%",Game.score);
	trace("tweetscore: "+msg);
	Game.features.tweet(msg);
}


function showLeaderboard() : void
{
	trace("GameCenter.showStandardLeaderboard()");
	
	showLoading(true);
	Game.features.showLeaderboard();
	showLoading(false);
}



function endGame():Boolean {
	if (!isInGame) return false;
	isInGame = false;
	wasClicked = wasReleased = false;
	Game.ticks = 0;
	Game.features.recordScore(Game.score);
	//setScoreRecordViewer();
	
	beginTextField.visible = false;
	pauseImg.visible = false;

	if (Features.supportTwitter) {
		//tweetTextField.visible = true;
		twitterImg.visible = true;
	}	

	titleTicks = 30;
	Game.deadSe.play();
	
	
	Game.features.endGame();
	return true;
}
function updateGame():void {
	
	
	if (!isPaused) {
		updateActors(Ptc.s);
		update();
		
	}

	scoreTextField.text = String(Game.score);
	Game.ticks++;
	
	
	if (isInGame && !beginTextField.visible && Game.ticks<60) {
		beginTextField.visible = true;
	} else if (beginTextField.visible && Game.ticks>=60) {
		beginTextField.visible = false;
	}
	
	if (!isInGame) {		
		if (!endTextField.visible && !isInMenu){
			endTextField.text = END_MSG.replace("%SCORE%",Game.score);
			endTextField.visible = true;
			exitImg.visible = true;
			if (Features.supportTwitter) {
				twitterImg.visible = true;
			}
			//leftImg.visible = false;
			//rightImg.visible = false;
			showGamePad = false;
			deadCounter++;
			deaths[Game.score] = {pos:player.pos};
			var rand:Number = Math.round(Math.random() * 2);
			trace('dead counter: '+deadCounter+' -> '+rand);
			if (deadCounter>1) {
				Game.features.showAdmob();			
			}

		}
		
		if (mse.isPressing) {
			if (wasReleased) wasClicked = true;
		} else {
			if (wasClicked) beginGame();
			if (--titleTicks <= 0) wasReleased = true;
		}		
	}
	if (isPaused) {
		pauseImg.visible = false;
		backImg.visible = true;
		useAccelerometerImg.visible = true;
		soundImg.visible = true;
		//soundTextField.visible = true;
		beginTextField.visible = false;
		//leftImg.visible = false;
		//rightImg.visible = false;
		showGamePad = false;
	}  else {
		//soundTextField.visible = false;
		backImg.visible = false;
		useAccelerometerImg.visible = false;
		soundImg.visible = false;
		if (isInGame) {
			pauseImg.visible = true;
			if (!Game.useAccelerometer) {
				//leftImg.visible = true;
				//rightImg.visible = true;
				showGamePad = true;
			}
		}
	}
	
	if (Game.isMuted) {
		soundImg.texture = Game.atlas.getTexture("sound-off");
		//pausedTextField.text = PAUSED_MSG.replace('%SOUND%',OFF_MSG);
		//soundTextField.text = SOUND_MSG+" "+OFF_MSG;
	} else {
		soundImg.texture = Game.atlas.getTexture("sound-on");
		//pausedTextField.text = PAUSED_MSG.replace('%SOUND%',ON_MSG);
		//soundTextField.text = SOUND_MSG+" "+ON_MSG;
	}
	
	if (Game.useAccelerometer) {
		useAccelerometerImg.texture = Game.atlas.getTexture("accel-on");
		//pausedTextField.text = pausedTextField.text.replace('%ACCEL%',ON_MSG);			
	} else {
		useAccelerometerImg.texture = Game.atlas.getTexture("accel-off");
		//pausedTextField.text = pausedTextField.text.replace('%ACCEL%',OFF_MSG);
	}
	
	updateActors(Msg.s);	
}

function getTweetMsg():String {
	if (Game.score <= 300){
		return TWEET1;
	} else if (Game.score <= 600) {
		return TWEET2;
	} else if (Game.score <= 1200) {
		return TWEET3;
	} else if (Game.score <= 2000) {
		return TWEET4;
	} else if (Game.score <= 3000) {
		return TWEET5;
	} else if (Game.score <= 4000) {
		return TWEET6;
	} else if (Game.score <= 5000) {
		return TWEET7;
	} else if (Game.score <= 6000) {
		return TWEET8;
	} else if (Game.score >= 9000) {
		return TWEET9;
	} else if (Game.score >= 10000) {
		return TWEET10;
	} else {
		return TWEET1;		
	}
}

function onActivated(e:Event):void {
	isPaused = false;
	//SilentSwitch.apply();
}
function onDectivated(e:Event):void {
	if (isInGame) isPaused = true;
}
function updateActors(s:*):void {
	for (var i:int = 0; i < s.length; i++) if (!s[i].update()) s.splice(i--, 1);
}




function initialize():void {
	player = new Player;
	floors = new Vector.<Floor>;
	Game.walkSes[0] = new Snd("AudioWalk1");
	Game.walkSes[1] = new Snd("AudioWalk2");
	Game.jumpSe = new Snd("AudioJump");
	Game.landSe = new Snd("AudioLand");
	Game.scrollSe = new Snd("AudioScroll");
	Game.deadSe = new Snd("AudioDead");
	Game.scrollDist = 0;
	Game.scrollXDist = 0;
	Game.nextFloorAddDist = 0;
	if (!isInGame) Game.rank = 3;
	else Game.rank = 0;
	addFloor(Game.scr.size.y);
	floors[4].pos.x = player.pos.x;
	floors[4].pos.y = player.pos.y + 12;
	//floors[4].pos.x = Game.scr.center.x - floors[4].pwidth / 2;
	floors[5].pos.x = floors[4].pos.x + Game.scr.size.x;
	floors[5].pos.y = Game.scr.size.y;
	
}
function update():void {
	updateActors(floors);
	if (isInGame) {
		player.update();
		Game.rank = Utils.sqrt(Game.ticks * 0.005);
	}
	scrollY(0.1 + Game.rank * 0.1);
}
function scrollY(d:Number):void {
	player.pos.y += d;
	for each (var f:Floor in floors) f.pos.y += d;
	for each (var p:Ptc in Ptc.s) p.pos.y += d;
	addFloor(d);
	Game.scrollDist += d;
	if (Game.scrollDist > 5) {
		Game.scrollDist -= 5;
		if (isInGame) {
			Game.scrollSe.play();
			Game.score += 5;
		}
	}
}
function addFloor(d:Number):void {
	Game.nextFloorAddDist -= d;
	while (Game.nextFloorAddDist <= 0) {
		var f:Floor = new Floor;
		f.setRandom(-Game.nextFloorAddDist);
		floors.push(f);
		var mf:Floor = new Floor;
		mf.setMirror(f);
		floors.push(mf);
		Game.nextFloorAddDist += Game.rnd.i(25, 7);
	}
}
function scrollX(d:Number):void {
	player.pos.x += d;
	for each (var f:Floor in floors) f.pos.x += d;
	for each (var p:Ptc in Ptc.s) p.pos.x += d;
	Game.scrollXDist += d;
}
var player:Player;
class Player {
	public var spr:Spr = new Spr([
		[Clr.green.i],[
			"  11  ",
			"  11",
			"   1",
			" 1111",
			"   1 1",
			" 111",
			"    1",
		],Spr.XREV,[
			" 11   ",
			" 11",
			"   1",
			" 11111",
			"1  1 ",
			"  1 11",
			"  1",
		],Spr.XREV,[
			"  11   ",
			"  11",
			"1  1  ",
			" 11111",
			"   1  1",
			"111 1 ",
			"     111",
		],Spr.XREV,[
			"  11   ",
			"  11",
			" 1 1 ",
			"  111",
			"   1 1",
			"  1 1",
			"  1 1",
		],Spr.XREV,[
		"  11   ",
		"  11",
		" 1 1 ",
		"  111",
		"   1 1",
		"  1 1",
		"  1 1",
		],Spr.XREV
	]);
	public var pos:Vct = new Vct;
	public var bpos:Vct = new Vct, footPos:Vct = new Vct;
	public var vel:Vct = new Vct;
	public var animTicks:Number = 0;
	public var anim:int, baseAnim:int;
	public var floorOn:Floor;
	public var isJumpReady:Boolean;
	function Player() {
		pos.x = Game.scr.center.x;
		pos.y = Game.scr.size.y * 0.1;
	}
	public function update():void {
		if (floorOn) {
			pos.y = floorOn.pos.y - spr.size.y;
			vel.x += floorOn.arrowVel.x * 0.25 + floorOn.beltVel.x * 0.25;
			vel.y = 0;
			var sx:Number = key.stick.x;
			if (sx != 0) {
				vel.x += sx * 0.3;
				var pwanim:int = int(animTicks) % 2;
				animTicks += Utils.abs(sx * 0.3);
				if (sx > 0) baseAnim = 1;
				else baseAnim = 0;
				var wanim:int = int(animTicks) % 2;
				anim = baseAnim + wanim * 2;
				if (wanim != pwanim) {
					Game.walkSes[wanim].play(0);
					floorOn.addScore();
				}
			}
			vel.x *= 0.8;
			if (isJumpReady && key.isButtonPressed) {
				anim = baseAnim + 4;
				vel.y = -3;
				Game.jumpSe.play();
				//Ptc.add(footPos, Clr.green, 15, vel.length, 30, vel.way + Utils.PI, 0.2);
				floorOn = null;
			} else {
				if (!floorOn.checkHit(bpos, spr.size)) floorOn = null;
			}
		}
		if (!key.isButtonPressed) isJumpReady = true;
		if (!floorOn) {
			if (key.isButtonPressed) vel.y += 0.1;
			else vel.y += 0.2;
			vel.x += key.stick.x * 0.05;
			vel.x *= 0.98;
			if (vel.y > 0 && anim < 6) anim = baseAnim + 6;
			animTicks = int(animTicks) - 0.01;
			Ptc.add(footPos, Clr.green, 1, 0.1, 10, vel.way + Utils.PI, 0.1);
			if (vel.y > 0) {
				var f:Floor = checkHitFloors(pos, spr.size);
				if (f && f.pos.y + 5 >= pos.y + spr.size.y) {
					floorOn = f;
					f.land();
					isJumpReady = false;
					Ptc.add(footPos, Clr.green, 5, 0.5, 30, Utils.PI, Utils.PI / 2);
					Game.landSe.play();
				}
			}
		}
		pos.incrementBy(vel);
		bpos.x = pos.x;
		footPos.x = pos.x + spr.size.x / 2;      
		bpos.y = footPos.y = pos.y + spr.size.y;
		if (pos.y < Game.scr.size.y * 0.4) scrollY((Game.scr.size.y * 0.4 - pos.y) * 0.1);
		if (pos.x < Game.scr.size.x * 0.4) scrollX((Game.scr.size.x * 0.4 - pos.x) * 0.1);
		if (pos.x > Game.scr.size.x * 0.6) scrollX((Game.scr.size.x * 0.6 - pos.x) * 0.1);
		spr.draw(pos, anim);
		if (pos.y > Game.scr.size.y) endGame();
	}
}
var floors:Vector.<Floor>;
var resetTimerReverse:uint;

function checkHitFloors(p:Vct, size:Vct):Floor {
	var rf:Floor;
	for each (var f:Floor in floors) {
		if (f.checkHit(p, size)) {
			if (!rf || rf.pos.y < f.pos.y) rf = f
		}
	}
	return rf;
}