package
{
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.textures.Texture;

	public class Game extends Sprite
	{
		
		[Embed(source = "/assets/twitter.png")]
		public static const TwitterImage:Class;
		
		[Embed(source="/assets/fonts/lcd.ttf", embedAsCFF="false", fontFamily="Dots")]
		private static const Dots:Class;
		
		[Embed(source = "/assets/pause.png")]
		public static const PauseImage:Class;
		
		public function Game() {
			addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event):void {		
			main = this;
			SCR_WIDTH =  stage.stageWidth;
			SCR_HEIGHT = stage.stageHeight;
			initializeFirst();
		}
		
	}
}
var useFilter:Boolean = true;
import com.adobe.nativeExtensions.Vibration;
import com.palDeveloppers.ane.NativeTwitter;
import com.sticksports.nativeExtensions.SilentSwitch;
import com.sticksports.nativeExtensions.gameCenter.GCLeaderboard;
import com.sticksports.nativeExtensions.gameCenter.GCScore;
import com.sticksports.nativeExtensions.gameCenter.GameCenter;

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
import flash.media.Sound;
import flash.media.SoundChannel;
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

var startImg:Image;
var introImg:Image;
var pauseImg:Image;

var twitterImg:Image;

var main:Game;
var SCR_WIDTH:int = 465, SCR_HEIGHT:int = 465;
var bd:BitmapData;
var baseSprite:Sprite;
var bgColor:uint = 0xB7DC11;
var tex:starling.textures.Texture;
var img:Image;

var accelX:Number = 0;
var accelY:Number = 0;
var accelZ:Number = 0;

var fpsText:TextField;

var rotationSpeed:Number;
var rotationSpeedOri:Number = 2000;
var rotationReverse:Boolean = false;
var accel:Accelerometer = new Accelerometer();

var scoreTextField:TextField;
var tweetTextField:TextField;
var pausedTextField:TextField;
var beginTextField:TextField;
var menuTextField:TextField;
var endTextField:TextField;
var loadingTextField:TextField;

var backgroundSe:Snd;
var blur:BlurFilter;

const MENU_MSG:String = "GIROVAULT\n\n\nTAP\nTO\nSTART\n\n\n\n\n\n\n\%LEADERBOARD%";
const BEGIN_MSG:String = "ESCAPE\nFROM\nGIROVAULT";
const END_MSG:String = "GAME OVER\n\n%TWEET%\nMY SCORE IS %SCORE%\n\nTAP TO START\n\n\n\n\n\n\nEXIT";

const TWEET1:String = "So bad";//<=300
const TWEET2:String = "Oh, damn";//<=600
const TWEET3:String = "Warming up";//<=1200
const TWEET4:String = "A bit better";//<=2000
const TWEET5:String = "Much better";//<=3000
const TWEET6:String = "Awesome";//<=4000
const TWEET7:String = "Marvelous";//<=5000
const TWEET8:String = "Almost perfect"; //<=6000
const TWEET9:String = "First"; //<=9000

const TWEET_MSG:String = "TWEET THIS";
const PAUSED_MSG:String = "PAUSED\n\nSOUND: %SOUND%";
const LEADERBOARD_MSG:String = "LEADERBOARD";
const ON_MSG:String = "ON";
const OFF_MSG:String = "OFF";
const LOADING_MSG:String = "LOADING";

var default_leaderboard:String = "GiroVaultHighScore";

var currentTimer:int;

function localPlayerAuthenticated() : void
{
	GameCenter.localPlayerAuthenticated.remove( localPlayerAuthenticated );
	GameCenter.localPlayerNotAuthenticated.remove( localPlayerNotAuthenticated );
	trace( "localPlayerAuthenticated" );
}

function localPlayerNotAuthenticated() : void
{
	GameCenter.localPlayerAuthenticated.remove( localPlayerAuthenticated );
	GameCenter.localPlayerNotAuthenticated.remove( localPlayerNotAuthenticated );
	trace( "localPlayerNotAuthenticated" );
	//supportGameCenter = false;
}

function initializeFirst():void {
	
	rotationSpeed = rotationSpeedOri;
	
	//silent switch support
	SilentSwitch.apply();
	
	if (GameCenter.isSupported) {
		supportGameCenter = true;
		try
		{
			GameCenter.localPlayerAuthenticated.add( localPlayerAuthenticated );
			GameCenter.localPlayerNotAuthenticated.add( localPlayerNotAuthenticated );
			GameCenter.authenticateLocalPlayer();
		}
		catch( error : Error )
		{
			GameCenter.localPlayerAuthenticated.remove( localPlayerAuthenticated );
			GameCenter.localPlayerNotAuthenticated.remove( localPlayerNotAuthenticated );
			trace( error.message );
		}
		
	} 
	
	if (NativeTwitter.isSupported()){
		supportTwitter = true;
	}
	
	Shp.initialize();
	scr = new Scr;
	
	bd = new BitmapData(scr.pixelSize.x, scr.pixelSize.y, true, bgColor);		
	baseSprite = new Sprite;	
	tex = starling.textures.Texture.fromBitmapData(bd);
	img = new Image(tex);
	
	//backgroundSe = new Snd("AudioBackground");
		
	//var blur:BlurFilter = new BlurFilter(1,1,0.9);	
	//img.filter = blur;
	//img.filter = BlurFilter.createGlow(0x00ff00,1.5,8,0.4);
	
	baseSprite.addChild(img);	
	
	scoreTextField = new TextField(SCR_WIDTH - 5, 50, "0", "Dots", 32, Color.BLACK);
	scoreTextField.hAlign = HAlign.RIGHT;
	scoreTextField.vAlign = VAlign.BOTTOM;
	
	
	beginTextField = new TextField(SCR_WIDTH, SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	beginTextField.hAlign = HAlign.CENTER;
	beginTextField.vAlign = VAlign.CENTER;
	
	endTextField = new TextField(SCR_WIDTH, SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	endTextField.hAlign = HAlign.CENTER;
	endTextField.vAlign = VAlign.BOTTOM;
	
	menuTextField = new TextField(SCR_WIDTH, SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	menuTextField.hAlign = HAlign.CENTER;
	menuTextField.vAlign = VAlign.BOTTOM;
	
	tweetTextField = new TextField(SCR_WIDTH, SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	tweetTextField.hAlign = HAlign.CENTER;
	tweetTextField.vAlign = VAlign.CENTER;
	
	pausedTextField = new TextField(SCR_WIDTH, SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	pausedTextField.hAlign = HAlign.CENTER;
	pausedTextField.vAlign = VAlign.CENTER;	
	
	loadingTextField = new TextField(SCR_WIDTH, SCR_HEIGHT, "", "Dots", 32, Color.BLACK);
	loadingTextField.hAlign = HAlign.CENTER;
	loadingTextField.vAlign = VAlign.CENTER;
	
	pauseImg = new Image(starling.textures.Texture.fromBitmap(new Game.PauseImage()));
	
	twitterImg = new Image(starling.textures.Texture.fromBitmap(new Game.TwitterImage()));
	
	main.addChild(new Image(starling.textures.Texture.fromBitmapData(new BitmapData(scr.pixelSize.x, scr.pixelSize.y, false, bgColor))));


	//backround1 = new Game.AudioBackground1();
	//backround1.play(0,999999);
	//backgroundSe.play(9999999);
	//audioData1 = new Game.AudioData1();
	//playMIDIFile(audioData1);
		
	main.addChild(baseSprite);
	main.addChild(scoreTextField);

	pauseImg.x = 10;
	pauseImg.y = 10;
	main.addChild(pauseImg);
	pauseImg.visible = false;
	
	beginTextField.text = BEGIN_MSG;
	beginTextField.visible = false;
	main.addChild(beginTextField);
	
	endTextField.text = END_MSG;
	endTextField.visible = false;
	main.addChild(endTextField);
	
	pausedTextField.text = PAUSED_MSG.replace('%SOUND%',ON_MSG);
	pausedTextField.visible = false;
	main.addChild(pausedTextField);

	loadingTextField.text = LOADING_MSG;
	//loadingTextField.visible = false;
	//main.addChild(loadingTextField);
	
	
	//soundTextField.text = SOUND_MSG+" "+ON_MSG;
	//soundTextField.visible = false;
	//soundTextField.y = pausedTextField.y + 50;
	//main.addChild(soundTextField);

	tweetTextField.text = TWEET_MSG;
	tweetTextField.visible = false;
	tweetTextField.y = endTextField.y + 200;
	main.addChild(tweetTextField);
	
	twitterImg.x = 325;
	twitterImg.y = 487;
	twitterImg.visible = false;
	main.addChild(twitterImg);
	
	if (supportGameCenter) {
		menuTextField.text = MENU_MSG.replace('%LEADERBOARD%',LEADERBOARD_MSG);
	} else {
		menuTextField.text = MENU_MSG.replace('%LEADERBOARD%',"\n");
	}
	
	menuTextField.visible = true;
	main.addChild(menuTextField);
	
	mse = new Mse;
	key = new Key;
	initialize();
	showMenu(true);

	//beginGame();
	
	Starling.current.nativeStage.addEventListener(Event.ACTIVATE, onActivated);
	Starling.current.nativeStage.addEventListener(Event.DEACTIVATE, onDectivated);
	Starling.current.nativeStage.addEventListener(Event.ENTER_FRAME, updateFrame);
		
	currentTimer = setInterval(rotateStage,rotationSpeed);
}

function rotateStage():void {
	img.pivotX = SCR_WIDTH / 2.0;
	img.pivotY = SCR_HEIGHT / 2.0;
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

function updateFrame(event:Event):void {	
	if (img) { 
		bd.lock();
		bd.fillRect(bd.rect, bgColor);
		updateGame();	   
		bd.unlock();
		flash.display3D.textures.Texture(img.texture.base).uploadFromBitmapData(bd);
	}
}

var sin:Function = Math.sin, cos:Function = Math.cos, atan2:Function = Math.atan2; 
var sqrt:Function = Math.sqrt, abs:Function = Math.abs;
var PI:Number = Math.PI, PI2:Number = PI * 2;

class Vct extends Vector3D {
	public function Vct(x:Number = 0, y:Number = 0) {
		super(x, y);
	}
	public function clear():void {
		x = y = 0;
	}
	public function distance(p:Vector3D):Number {
		return getLength(p.x - x, p.y - y);
	}
	public function angle(p:Vector3D):Number {
		return atan2(p.x - x, p.y - y);
	}
	public function addAngle(a:Number, s:Number):void {
		x += sin(a) * s;
		y += cos(a) * s;
	}
	public function rotate(a:Number):void {
		var px:Number = x;
		x = x * cos(a) - y * sin(a);
		y = px * sin(a) + y * cos(a);
	}
	public function set xy(v:Vector3D):void {
		x = v.x;
		y = v.y;
	}
	public function get way():Number {
		return atan2(x, y);
	}
}
var rnd:Rnd = new Rnd;
class Rnd {
	public function n(v:Number = 1, s:Number = 0):Number { return get() * v + s; }
	public function i(v:int, s:int = 0):int { return n(v, s); }
	public function sx(v:Number = 1, s:Number = 0):Number { return n(v, s) * scr.size.x; }
	public function sy(v:Number = 1, s:Number = 0):Number { return n(v, s) * scr.size.y; }
	public function pm():int { return i(2) * 2 - 1; }
	private var x:int, y:int, z:int, w:int;
	function Rnd(v:int = int.MIN_VALUE):void {
		var sv:int;
		if (v == int.MIN_VALUE) sv = getTimer();
		else sv = v;
		x = sv = 1812433253 * (sv ^ (sv >> 30));
		y = sv = 1812433253 * (sv ^ (sv >> 30)) + 1;
		z = sv = 1812433253 * (sv ^ (sv >> 30)) + 2;
		w = sv = 1812433253 * (sv ^ (sv >> 30)) + 3;
	}
	public function get():Number {
		var t:int = x ^ (x << 11);
		x = y; y = z; z = w;
		w = (w ^ (w >> 19)) ^ (t ^ (t >> 8));
		return Number(w) / int.MAX_VALUE;
	}    
}
function getLength(x:Number, y:Number):Number {
	return sqrt(x * x + y * y);
}
function clamp(v:Number, min:Number, max:Number):Number {
	if (v > max) return max;
	else if (v < min) return min;
	return v;
}
function normalizeAngle(v:Number):Number {
	var r:Number = v % PI2;
	if (r < -PI) r += PI2;
	else if (r > PI) r -= PI2;
	return r;
}

var scr:Scr;
class Scr {
	public const LETTER_COUNT:int = 36;
	public var pixelSize:Vct = new Vct(SCR_WIDTH, SCR_HEIGHT);
	public var size:Vct = new Vct(int(SCR_WIDTH / Shp.DOT_SIZE), int(SCR_HEIGHT / Shp.DOT_SIZE));
	public var center:Vct = new Vct(size.x / 2, size.y / 2);
	public var letterSprs:Vector.<Spr> = new Vector.<Spr>(LETTER_COUNT);
	private var letterPatterns:Array = [
		0x4644aaa4, 0x6f2496e4, 0xf5646949, 0x167871f4, 0x2489f697, 0xe9669696, 0x79f99668, 
		0x91967979, 0x1f799976, 0x1171ff17, 0xf99ed196, 0xee444e99, 0x53592544, 0xf9f11119,
		0x9ddb9999, 0x79769996, 0x7ed99611, 0x861e9979, 0x994444e7, 0x46699699, 0x6996fd99,
		0xf4469999, 0xf248];
	function Scr() {
		var lp:uint, d:int = 32;
		var lpIndex:int;
		var lStr:String;
		var lStrs:Array;
		for (var i:int = 0; i < LETTER_COUNT; i++) {
			lStrs = new Array;
			for (var j:int = 0; j < 5; j++) {
				lStr = "";
				for (var k:int = 0; k < 4; k++) {
					if (++d >= 32) {
						lp = letterPatterns[lpIndex++];
						d = 0;
					}
					if (lp & 1 > 0) lStr += "1";
					else lStr += " ";
					lp >>= 1;
				}
				lStrs.push(lStr);
			}
			letterSprs[i] = new Spr([[Clr.white.i], lStrs]);
		}
	}
	public function isIn(p:Vector3D, spacing:Number = 0):Boolean {
		return (p.x >= -spacing && p.x <= pixelSize.x + spacing && 
			p.y >= -spacing && p.y <= pixelSize.y + spacing);
	}
	private var tPos:Vct = new Vct;
	
}
class Shp {
	public static const DOT_SIZE:Number = 3.5;
	public static const BLUR_COUNT:int = 1;
	public static const BLUR_SIZE:int = 1;
	//private static var filters:Vector.<BlurFilter> = new Vector.<BlurFilter>(BLUR_COUNT);
	private static var shps:Vector.<Shp> = new Vector.<Shp>;
	public var bds:Vector.<BitmapData> = new Vector.<BitmapData>(BLUR_COUNT);
	public var rect:Rectangle = new Rectangle;
	public var size:Vct;
	public var type:int;
	public static function initialize():void {
		/*for (var i:int = 1; i < BLUR_COUNT; i++) {
			var w:int = BLUR_SIZE * i / (BLUR_COUNT - 1);
			filters[i] = new BlurFilter(w, w);
		}*/
	}
	public static function n(pattern:Array, colors:Array,
							 isXRev:Boolean = false, isYRev:Boolean = false, isXYSwap:Boolean = false):Shp {
		var t:int = getType(pattern, colors, isXRev, isYRev, isXYSwap);
		for each (var s:Shp in shps) {
			if (s.type == t) return s;
		}
		s = new Shp(pattern, colors, isXRev, isYRev, isXYSwap);
		s.type = t;
		return s;
	}
	private static function getType(pattern:Array, colors:Array,
									isXRev:Boolean, isYRev:Boolean, isXYSwap:Boolean):int {
		var t:int;
		for each (var c:uint in colors) t += c;
		t += pattern.length;
		var s:String = String(pattern[0]);
		for (var i:int = 0; i < s.length; i++) t += s.charCodeAt(i) * (i + 1);
		if (isXRev) t += i + 1;
		if (isYRev) t += i + 2;
		if (isXYSwap) t += i + 3;
		return t;
	}
	function Shp(pattern:Array, colors:Array,
				 isXRev:Boolean, isYRev:Boolean, isXYSwap:Boolean) {
		var xc:int = String(pattern[0]).length;
		var yc:int = pattern.length;
		size = new Vct(xc, yc);
		
		
		var sp:flash.display.Sprite = new flash.display.Sprite;
		var s:Shape = new Shape;
		sp.addChild(s);
		var g:Graphics = s.graphics;
		for (var y:int = 0; y < yc; y++) {
			var p:String = pattern[y];
			for (var x:int = 0; x < xc; x++) {
				if (x >= p.length) break;
				var ci:int = p.charCodeAt(x) - 49;
				if (ci < 0) continue;
				g.beginFill(colors[ci]);
				var dx:int = x;
				if (isXRev) dx = xc - x - 1;
				var dy:int = y;
				if (isYRev) dy = yc - y - 1;
				if (isXYSwap) {
					var t:int = dx; dx = dy; dy = t;
				}
				g.drawRect((dx + 0.1) * DOT_SIZE + BLUR_SIZE, (dy + 0.1) * DOT_SIZE + BLUR_SIZE,
					DOT_SIZE * 0.8, DOT_SIZE * 0.8);
				g.endFill();
			}
		}
		
		
		if (isXYSwap) {
			t = size.x; size.x = size.y; size.y = t;
		}
		rect = new Rectangle(0, 0,        
			size.x * DOT_SIZE + BLUR_SIZE * 2, size.y * DOT_SIZE + BLUR_SIZE * 2);
		for (var i:int = 0; i < BLUR_COUNT; i++) {
			bds[i] = new BitmapData(rect.width, rect.height, true, 0);
			//if (i > 0) sp.filters = [filters[i]];
			bds[i].draw(sp);
		}
		
	}
}
class Spr {
	public static const XREV:int = 1, YREV:int = 2, XYSWAP:int = 3;
	public var shps:Vector.<Shp> = new Vector.<Shp>;
	public var pposs:Vector.<Vct>;
	public var anims:Vector.<int>;
	public var pposIndex:int;
	public var currentAnim:int;
	private var pos:Vct = new Vct;
	private var point:Point = new Point;
	function Spr(patterns:Array) {
		var colors:Array = patterns[0];
		for (var i:int = 1; i < patterns.length; i += 2) {
			var pattern:Array = patterns[i];
			var rev:int = patterns[i + 1];
			var isXRev:Boolean = (rev & XREV) > 0;
			var isYRev:Boolean = (rev & YREV) > 0;
			var shp:Shp;
			shp = Shp.n(pattern, colors);
			shps.push(shp);
			if (rev == XREV) {
				shp = Shp.n(pattern, colors, true);
				shps.push(shp);
			} else if (rev == YREV) {
				shp = Shp.n(pattern, colors, false, true);
				shps.push(shp);
			} else if (rev == XYSWAP) {
				shp = Shp.n(pattern, colors, false, false, true);
				shps.push(shp);
				shp = Shp.n(pattern, colors, true);
				shps.push(shp);
				shp = Shp.n(pattern, colors, true, false, true);
				shps.push(shp);
			}
		}
	}
	public function draw(dp:Vct, anim:int = 0):void {
		currentAnim = anim;
		pos.x = int(dp.x) * Shp.DOT_SIZE;
		pos.y = int(dp.y) * Shp.DOT_SIZE;
		if (!pposs) {
			pposs = new Vector.<Vct>(Shp.BLUR_COUNT);
			anims = new Vector.<int>(Shp.BLUR_COUNT);
			for (var i:int = 0; i < Shp.BLUR_COUNT; i++) {
				pposs[i] = new Vct(pos.x, pos.y);
				anims[i] = anim;
			}
		}
		pposs[pposIndex].xy = pos;
		anims[pposIndex] = anim;
		var pi:int = pposIndex;
		for (i = 0; i < Shp.BLUR_COUNT; i++) {
			point.x = pposs[pi].x - Shp.BLUR_SIZE;
			point.y = pposs[pi].y - Shp.BLUR_SIZE;
			var s:Shp = shps[anims[pi]];
			bd.copyPixels(s.bds[i], s.rect, point, null, null, true);
			
			
			
			if (--pi < 0) pi += Shp.BLUR_COUNT;
		}
		if (++pposIndex >= Shp.BLUR_COUNT) pposIndex = 0;
	}
	public function get size():Vct {
		return shps[currentAnim].size;
	}
}
class Clr {
	private static const BASE_BRIGHTNESS:int = 24;
	private static const WHITENESS:int = 0;
	public var r:int, g:int, b:int;
	public var brightness:Number = 1;
	public function Clr(r:int = 0, g:int = 0, b:int = 0) {
		this.r = r * BASE_BRIGHTNESS;
		this.g = g * BASE_BRIGHTNESS;
		this.b = b * BASE_BRIGHTNESS;
	}
	public function get i():uint {
		return uint(r * brightness) * 0x10000 + uint(g * brightness) * 0x100 + b * brightness;
	}
	public function set rgb(c:Clr):void {
		r = c.r; g = c.g; b = c.b;
	}
	public static var black:Clr = new Clr(0, 0, 0);
	public static var red:Clr = new Clr(174, 196, 64);
	public static var green:Clr = new Clr(174, 196, 64);
	public static var blue:Clr = new Clr(174, 196, 64);
	public static var yellow:Clr = new Clr(0, 0, 0);
	public static var magenta:Clr = new Clr(174, 196, 64);
	public static var cyan:Clr = new Clr(174, 196, 64);
	public static var white:Clr = new Clr(100, 100, 100);
	;
	/*
	public static var black:Clr = new Clr(0, 0, 0);
	public static var red:Clr = new Clr(10, WHITENESS, WHITENESS);
	public static var green:Clr = new Clr(WHITENESS, 10, WHITENESS);
	public static var blue:Clr = new Clr(WHITENESS, WHITENESS, 10);
	public static var yellow:Clr = new Clr(10, 10, WHITENESS);
	public static var magenta:Clr = new Clr(10, WHITENESS, 10);
	public static var cyan:Clr = new Clr(WHITENESS, 10, 10);
	public static var white:Clr = new Clr(10, 10, 10);
	*/
}
class Msg {
	public static var s:Vector.<Msg> = new Vector.<Msg>;
	public static var shownMessages:Vector.<String> = new Vector.<String>;
	public static function addOnce(text:String, p:Vct,
								   vx:Number = 0, vy:Number = 0, ticks:int = 90):Msg {
		if (shownMessages.indexOf(text) >= 0) return null;
		shownMessages.push(text);
		return add(text, p, vx, vy, ticks);
	}
	public static function add(text:String, p:Vct,
							   vx:Number = 0, vy:Number = 0, ticks:int = 90):Msg {
		var m:Msg = new Msg;
		m.text = text;
		m.pos.xy = p;
		m.vel.x = vx / ticks;
		m.vel.y = vy / ticks;
		m.ticks = ticks;
		s.push(m);
		return m;
	}
	public var pos:Vct = new Vct, vel:Vct = new Vct;
	public var text:String, ticks:int;
	public function update():Boolean {
		pos.incrementBy(vel);
		return --ticks > 0;
	}
}
class Ptc {
	public static var s:Vector.<Ptc> = new Vector.<Ptc>;
	public var pos:Vct = new Vct;
	public var vel:Vct = new Vct;
	public var spr:Spr;
	public var ticks:int;
	function Ptc(clr:Clr) {
		spr = new Spr([[clr.i], ["1"], 0]);
	}
	public function update():Boolean {
		pos.incrementBy(vel);
		vel.scaleBy(0.98);
		spr.draw(pos);

		return --ticks > 0;
	}
	public static function add(p:Vct, clr:Clr, force:Number, speed:Number,
							   ticks:Number = 30, angle:Number = 0, angleWidth:Number = Math.PI):void {
		var pt:Ptc = new Ptc(clr);
		for (var i:int = 0; i < force; i++) {
			var pt:Ptc = new Ptc(clr);
			pt.pos.xy = p;
			pt.vel.addAngle(angle + rnd.n(angleWidth) * rnd.pm(),
				speed * rnd.n(1, 0.5));
			pt.ticks = ticks * rnd.n(1, 0.5);
			s.push(pt);
		}
	}
}
var mse:Mse;
class Mse {
	public var pos:Vct = new Vct;
	public var isPressing:Boolean;
	public function Mse() {		
		main.addEventListener(TouchEvent.TOUCH,handleTouch);
	}
	
	private function handleTouch(e:TouchEvent):void {		
		var touch:Touch = e.getTouch(main.stage);
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
			if (!isPaused && pos.x > 0 && pos.x < 35 && pos.y > 0 && pos.y < 35) {
				trace('pause true');
				isPaused = true;
				clearInterval(currentTimer);	
				return true;
			} else if (isPaused && pos.x > 117 && pos.x < 297 && pos.y > 250 && pos.y < 282) {
				trace('pause false');			
				isPaused = false;
				currentTimer = setInterval(rotateStage,rotationSpeed);
				return true;
			}
			//sound
			else if (isPaused && pos.x > 117 && pos.x < 297 && pos.y > 315 && pos.y < 353){
				isMuted = !isMuted;	
				return true;
			}
		} else {
			//leaderboard
			if (supportGameCenter) {
				if (isInMenu && !isPaused && !isInGame && pos.x > 95 && pos.x < 327 && pos.y > 385 && pos.y < 600) {				
					showLeaderboard();
					return true;
				}
			}
			
			//tweet	
			if (supportTwitter) {
				if (!isInMenu && pos.x > 94 && pos.x < 366 && pos.y > 480 && pos.y < 523) {
					tweetscore();
					return true;
				}
			}
			
			if (!isInMenu && pos.x > 162 && pos.x < 253 && pos.y > 572 && pos.y < 601) {
				showMenu(true);
				return true;
			}
		}		
		return false;
	}
	
}
var key:Key;
class Key {
	public var s:Vector.<Boolean> = new Vector.<Boolean>(256);
	
	public var touchLeft:Boolean = false;
	public var touchRight:Boolean = false;
	public var touchJump:Boolean = false;
	public var touchMoving:Boolean = false;
	
	public function Key() {
		main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressed);
		main.stage.addEventListener(KeyboardEvent.KEY_UP, onReleased);
		main.addEventListener(TouchEvent.TOUCH,handleTouch);
		accel.addEventListener(AccelerometerEvent.UPDATE, accelUpdateHandler);
	}
	
	private function accelUpdateHandler(event:AccelerometerEvent):void
	{
		accelX = event.accelerationX.toFixed(3)*30;
		accelY = event.accelerationY.toFixed(3)*30;
		accelZ = event.accelerationZ.toFixed(3)*30;		
		
		touchLeft = false;
		touchRight = false;
		if (accelX > 6) {
			touchLeft = true;
			touchRight = false;
		} else if (accelX < -6){
			touchLeft = false;
			touchRight = true;
		}
		
	}
	
	private function handleTouch(e:TouchEvent):void {		
		var touch:Touch = e.getTouch(main.stage);
		if (!touch)
			return;
		var mousePos:Point = touch.getLocation(main.stage);
		
		switch(touch.phase) {
			case TouchPhase.BEGAN:				
				touchJump = true;
				break;
			case TouchPhase.MOVED:
				touchMoving = true;
				
				if (touch.globalY < touch.previousGlobalY){
					touchJump = true;
				}
				
				break;
			case TouchPhase.ENDED:
				touchJump = false;
				touchMoving = false;
				touchLeft = false;
				touchRight = false;
				break;
		}
	}
	
	private function onPressed(e:KeyboardEvent):void {
		if (e.keyCode > 256)
			return;
		s[e.keyCode] = true;
	}
	private function onReleased(e:KeyboardEvent):void {
		if (e.keyCode > 256)
			return;
		s[e.keyCode] = false;
	}
	public function get isWPressed():Boolean {
		return s[0x26] || s[0x57];
	}
	public function get isAPressed():Boolean {
		return s[0x25] || s[0x41] || touchLeft;
	}
	public function get isSPressed():Boolean {
		return s[0x28] || s[0x53];
	}
	public function get isDPressed():Boolean {
		return s[0x27] || s[0x44] || touchRight;
	}
	private var sVct:Vct = new Vct;
	public function get stick():Vct {
		sVct.clear();
		if (isWPressed) sVct.y -= 1;
		if (isAPressed) sVct.x -= 1;
		if (isSPressed) sVct.y += 1;
		if (isDPressed) sVct.x += 1;
		if (sVct.x != 0 && sVct.y != 0) sVct.scaleBy(0.7);
		return sVct;
	}
	public function get isButtonPressed():Boolean {
		return isButton1Pressed || isButton2Pressed || touchJump;
	}
	public function get isButton1Pressed():Boolean {
		return s[0x5a] || s[0xbe] || s[0x20];
	}
	public function get isButton2Pressed():Boolean {
		return s[0x58] || s[0xbf];
	}
}
class Snd {
	public static var isPlaying:Boolean;
	public var driver:Sound;
	var sChannel:SoundChannel = new SoundChannel();
	var sTransform:SoundTransform = new SoundTransform();
	[Embed(source="/assets/audio/jump.mp3")]
	public static const AudioJump:Class;
	[Embed(source="/assets/audio/walk1.mp3")]
	public static const AudioWalk1:Class;
	[Embed(source="/assets/audio/walk2.mp3")]
	public static const AudioWalk2:Class;
	[Embed(source="/assets/audio/scroll.mp3")]
	public static const AudioScroll:Class;
	[Embed(source="/assets/audio/land.mp3")]
	public static const AudioLand:Class;
	[Embed(source="/assets/audio/dead.mp3")]
	public static const AudioDead:Class;
	
	function Snd(mml:String) { 
		driver = new Snd[mml]() as Sound;		
	}
	
	public function play(loop:uint=0,vol:Number=1):void {
		if (!isMuted) {
			sTransform.volume = vol;
			sChannel = driver.play(0,loop,sTransform);
			isPlaying = true;
		}
	}
}
var score:int, ticks:int;
var isInGame:Boolean;
var isInMenu:Boolean;
var isPaused:Boolean;
var supportGameCenter:Boolean = false;
var supportTwitter:Boolean = false;
var wasClicked:Boolean, wasReleased:Boolean;
var titleTicks:int;
var isMuted:Boolean;

function showMenu(s:Boolean):void {
	if (s) {
		menuTextField.visible = true;
		isInMenu = true;
		isPaused = false;
		isInGame = false;
		endTextField.visible = false;
		twitterImg.visible =false;
		tweetTextField.visible = false;
	} else {
		menuTextField.visible = false;
		isInMenu = false;
	}
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
	img.rotation = 0;
	showMenu(false);
	isInGame = true;
	score = 0;
	ticks = 0;
	beginTextField.visible = true;
	endTextField.visible = false;
	tweetTextField.visible = false;
	twitterImg.visible = false;
	rnd = new Rnd;
	initialize();
}

function tweetscore():void {	
	var msg:String = getTweetMsg()+". My score is %SCORE% in #GiroVault";
	msg = msg.replace("%SCORE%",score);
	trace("tweetscore: "+msg);
	try {
		if (NativeTwitter.instance.isTwitterSetup()) {		
			NativeTwitter.instance.composeTweet(msg, null, null);
		}
	} catch(e:Error) {
		trace(e);
	}
}
function scoreReportFailed() : void
{
	GameCenter.localPlayerScoreReported.remove( scoreReportSuccess );
	GameCenter.localPlayerScoreReportFailed.remove( scoreReportFailed );
	trace( "localPlayerScoreReportFailed" );
}

function scoreReportSuccess() : void
{
	GameCenter.localPlayerScoreReported.remove( scoreReportSuccess );
	GameCenter.localPlayerScoreReportFailed.remove( scoreReportFailed );
	trace( "localPlayerScoreReported" );
}

function showLeaderboard() : void
{
	trace("GameCenter.showStandardLeaderboard()");
	if (!GameCenter.isAuthenticated){
		try {
			GameCenter.authenticateLocalPlayer();
		} catch (e:Error){
			trace(e);
		}
	}
	
	try
	{
		showLoading(true);
		//main.addChild(loadingTextField);
		GameCenter.showStandardLeaderboard();
		GameCenter.gameCenterViewRemoved.add( showLeaderboardRemoved );
	}
	catch( error : Error )
	{
		trace( error.message );
		showLoading(false);
		//main.removeChild(loadingTextField);
		GameCenter.gameCenterViewRemoved.remove( showLeaderboardRemoved );
	}
}


function showLeaderboardRemoved() : void
{
	showLoading(false);
	//main.removeChild(loadingTextField);
	GameCenter.gameCenterViewRemoved.remove( showLeaderboardRemoved );
	trace( "leaderboardLoadFailed" );
}

function endGame():Boolean {
	if (!isInGame) return false;
	isInGame = false;
	wasClicked = wasReleased = false;
	ticks = 0;
	recordScore(score);
	//setScoreRecordViewer();
	
	beginTextField.visible = false;
	pauseImg.visible = false;

	if (supportTwitter) {
		tweetTextField.visible = true;
		twitterImg.visible = true;
	}	

	titleTicks = 30;
	deadSe.play();
	if (!isMuted && Vibration.isSupported){
		var vibe:Vibration = new Vibration();
		vibe.vibrate(2000);
	}
	return true;
}
function updateGame():void {
	
	
	if (!isPaused) {
		updateActors(Ptc.s);
		update();
	}

	scoreTextField.text = String(score);
	ticks++;
	
	
	if (isInGame && !beginTextField.visible && ticks<60) {
		beginTextField.visible = true;
	}
	else if(beginTextField.visible && ticks>=60) {
		beginTextField.visible = false;
	}
	
	if (!isInGame) {		
		if (!endTextField.visible && !isInMenu){
			endTextField.text = END_MSG.replace("%SCORE%",score).replace("%TWEET%",getTweetMsg());
			endTextField.visible = true;
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
		pausedTextField.visible = true;
		//soundTextField.visible = true;
		beginTextField.visible = false;
	}  else {
		//soundTextField.visible = false;
		pausedTextField.visible = false;
		if (isInGame) {
			pauseImg.visible = true;
		}
	}
	
	if (isMuted) {
		pausedTextField.text = PAUSED_MSG.replace('%SOUND%',OFF_MSG);
		//soundTextField.text = SOUND_MSG+" "+OFF_MSG;
	} else {
		pausedTextField.text = PAUSED_MSG.replace('%SOUND%',ON_MSG);
		//soundTextField.text = SOUND_MSG+" "+ON_MSG;
	}
	updateActors(Msg.s);	
}

function getTweetMsg():String {
	if (score <= 300){
		return TWEET1;
	} else if (score <= 600) {
		return TWEET2;
	} else if (score <= 1200) {
		return TWEET3;
	} else if (score <= 2000) {
		return TWEET4;
	} else if (score <= 3000) {
		return TWEET5;
	} else if (score <= 4000) {
		return TWEET6;
	} else if (score <= 5000) {
		return TWEET7;
	} else if (score <= 6000) {
		return TWEET8;
	} else if (score >= 9000) {
		return TWEET9;
	}
}

function onActivated(e:Event):void {
	isPaused = false;
	SilentSwitch.apply();
}
function onDectivated(e:Event):void {
	if (isInGame) isPaused = true;
}
function updateActors(s:*):void {
	for (var i:int = 0; i < s.length; i++) if (!s[i].update()) s.splice(i--, 1);
}

function recordScore(s:int):void {
	if (supportGameCenter && GameCenter.isAuthenticated) {
		try
		{
			trace("reportScore() "+default_leaderboard+": "+s);
			GameCenter.localPlayerScoreReported.add( scoreReportSuccess );
			GameCenter.localPlayerScoreReportFailed.add( scoreReportFailed );
			GameCenter.reportScore( default_leaderboard, s );
		}
		catch( error : Error )
		{
			trace( error.message );
		}
	}
}

//----------------------------------------------------------------
const TITLE:String = "GiroVault"
const DEBUG:Boolean = true;
var walkSes:Vector.<Snd> = new Vector.<Snd>(2);
var jumpSe:Snd, landSe:Snd, deadSe:Snd;
var scrollSe:Snd;
var nextFloorAddDist:Number;
var scrollDist:Number;
var scrollXDist:Number;
var rank:Number;
function initialize():void {
	player = new Player;
	floors = new Vector.<Floor>;
	walkSes[0] = new Snd("AudioWalk1");
	walkSes[1] = new Snd("AudioWalk2");
	jumpSe = new Snd("AudioJump");
	landSe = new Snd("AudioLand");
	scrollSe = new Snd("AudioScroll");
	deadSe = new Snd("AudioDead");
	scrollDist = 0;
	scrollXDist = 0;
	nextFloorAddDist = 0;
	if (!isInGame) rank = 3;
	else rank = 0;
	addFloor(scr.size.y);
	floors[4].pos.x = scr.center.x - floors[4].pwidth / 2;
	floors[5].pos.x = floors[4].pos.x + scr.size.x;
}
function update():void {
	updateActors(floors);
	if (isInGame) {
		player.update();
		rank = sqrt(ticks * 0.005);
	}
	scrollY(0.1 + rank * 0.1);
}
function scrollY(d:Number):void {
	player.pos.y += d;
	for each (var f:Floor in floors) f.pos.y += d;
	for each (var p:Ptc in Ptc.s) p.pos.y += d;
	addFloor(d);
	scrollDist += d;
	if (scrollDist > 5) {
		scrollDist -= 5;
		if (isInGame) {
			scrollSe.play();
			score += 5;
		}
	}
}
function addFloor(d:Number):void {
	nextFloorAddDist -= d;
	while (nextFloorAddDist <= 0) {
		var f:Floor = new Floor;
		f.setRandom(-nextFloorAddDist);
		floors.push(f);
		var mf:Floor = new Floor;
		mf.setMirror(f);
		floors.push(mf);
		nextFloorAddDist += rnd.i(25, 7);
	}
}
function scrollX(d:Number):void {
	player.pos.x += d;
	for each (var f:Floor in floors) f.pos.x += d;
	for each (var p:Ptc in Ptc.s) p.pos.x += d;
	scrollXDist += d;
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
		pos.x = scr.center.x;
		pos.y = scr.size.y * 0.1;
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
				animTicks += abs(sx * 0.3);
				if (sx > 0) baseAnim = 1;
				else baseAnim = 0;
				var wanim:int = int(animTicks) % 2;
				anim = baseAnim + wanim * 2;
				if (wanim != pwanim) {
					walkSes[wanim].play(0);
					floorOn.addScore();
				}
			}
			vel.x *= 0.8;
			if (isJumpReady && key.isButtonPressed) {
				anim = baseAnim + 4;
				vel.y = -3;
				jumpSe.play();
				Ptc.add(footPos, Clr.green, 15, vel.length, 30, vel.way + PI, 0.2);
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
			Ptc.add(footPos, Clr.green, 1, 0.1, 10, vel.way + PI, 0.1);
			if (vel.y > 0) {
				var f:Floor = checkHitFloors(pos, spr.size);
				if (f && f.pos.y + 5 >= pos.y + spr.size.y) {
					floorOn = f;
					f.land();
					isJumpReady = false;
					Ptc.add(footPos, Clr.green, 5, 0.5, 30, PI, PI / 2);
					landSe.play();
				}
			}
		}
		pos.incrementBy(vel);
		bpos.x = pos.x;
		footPos.x = pos.x + spr.size.x / 2;      
		bpos.y = footPos.y = pos.y + spr.size.y;
		if (pos.y < scr.size.y * 0.4) scrollY((scr.size.y * 0.4 - pos.y) * 0.1);
		if (pos.x < scr.size.x * 0.4) scrollX((scr.size.x * 0.4 - pos.x) * 0.1);
		if (pos.x > scr.size.x * 0.6) scrollX((scr.size.x * 0.6 - pos.x) * 0.1);
		spr.draw(pos, anim);
		if (pos.y > scr.size.y) endGame();
	}
}
var floors:Vector.<Floor>;
var resetTimerReverse:uint;
class Floor {
	public var spr:Spr = new Spr([
		[Clr.cyan.i],[
			"1111111",
			"1     1",
			"1     1",
			"1     1",
			"1     1",
			"1     1",
			"1111111",
		], 0]);
	public var arrowSpr:Spr = new Spr([
		[Clr.yellow.i],[
			"  1  ",
			"   1 ",
			"11111",
			"   1 ",
			"  1  ",
		], Spr.XYSWAP]);
	public var rotateSpr:Spr = new Spr([
		[Clr.yellow.i],[
			"1111 ",
			"1   1",
			"1111 ",
			"1  1 ",
			"1   1",
		], 0]);
	public var beltSpr:Spr = new Spr([
		[Clr.magenta.i],[
			" 11 ",
			"1  1",
			"1  1",
			" 11 ",
		], 0]);
	public var pos:Vct = new Vct;
	public var width:int, pwidth:int;
	public var mirrorFloor:Floor;
	public var arrow:int = -1, isArrowStart:Boolean;
	public var rotate:int = -1, isRotateStart:Boolean;
	public var arrowVel:Vct = new Vct;
	public var beltVel:Vct = new Vct;
	public var beltTicks:Number = 0;
	private static var arrowWays:Array = [1, 0, 0, 1, -1, 0, 0, -1];
	public function setRandom(y:Number):void {
		width = rnd.i(4, 2);
		pwidth = width * spr.size.x;
		pos.x = int(rnd.sx()) + (scrollXDist % 1);
		pos.y = -spr.size.y + y;
		if (rnd.n() < rank * 0.1) {
			arrow = rnd.i(4);
			if (arrow == 3) arrow = 1;
		}
		if (rnd.n() < rank * 0.1) beltVel.x = rnd.n(rank * 0.2, 0.5) * rnd.pm();
		if (rnd.n() < rank * 0.1) {
			rotate = rnd.i(4);
			if (rotate == 3) rotate = 1;
		}
	}
	public function setMirror(f:Floor):void {
		width = f.width;
		pwidth = f.pwidth;
		pos.xy = f.pos;
		pos.x += scr.size.x;
		arrow = f.arrow;
		rotate = f.rotate;
		beltVel.xy = f.beltVel;
		mirrorFloor = f;
		f.mirrorFloor = this;
	}
	private var bp:Vct = new Vct;
	
	public function update():Boolean {
		if (isArrowStart) pos.incrementBy(arrowVel);
		
		if (pos.x < -pwidth) pos.x += scr.size.x * 2;
		else if (pos.x > scr.size.x + pwidth) pos.x -= scr.size.x * 2;
		if (beltVel.x != 0) {
			var d:Number = beltTicks;
			for (var i:int = 0; i < width * 2 + 2; i++) {
				calcEdgePos(d);
				bp.x = epos.x - 2;
				bp.y = epos.y - 2;
				beltSpr.draw(bp);
				if (beltVel.x > 0) d++;
				else d--;
			}
			beltTicks += beltVel.x * 0.1;
		}
		bp.xy = pos;
		for (i = 0; i < width; i++) {
			spr.draw(bp);
			if (arrow >= 0) {
				bp.x++; bp.y++;
				arrowSpr.draw(bp, arrow);
				bp.x--; bp.y--;
			} else if (rotate >= 0) {
				bp.x++; bp.y++;
				rotateSpr.draw(bp, 0);
				bp.x--; bp.y--;
			}
			bp.x += spr.size.x;
		}

		return pos.y <= scr.size.y + spr.size.y * 2;
	}
	private var epos:Vct = new Vct;
	private function calcEdgePos(d:Number):void {
		d %= width * 2 + 2;
		if (d < 0) d = width * 2 + 2 + d;
		if (d < width) {
			epos.x = pos.x + d * spr.size.x;
			epos.y = pos.y;
		} else if (d < width + 1) {
			d -= width;
			epos.x = pos.x + pwidth;
			epos.y = pos.y + d * spr.size.y;
		} else if (d < width * 2 + 1) {
			d -= width + 1;
			epos.x = pos.x + pwidth - d * spr.size.x;
			epos.y = pos.y + spr.size.y;
		} else {
			d -= width * 2 + 1;
			epos.x = pos.x;
			epos.y = pos.y + (1 - d) * spr.size.y;
		}
	}
	
	public function land():void {
		
		var f:int = (score / 500);
		var ff:Number = rotationSpeedOri - (f*100);
		
		if (ff != rotationSpeed && ff > 99) {
			trace("chancge: " + rotationSpeed);
			rotationSpeed = ff;
			clearInterval(currentTimer);
			currentTimer = setInterval(rotateStage,rotationSpeed);			
		}
		
		if (arrow >= 0) {
			isArrowStart = mirrorFloor.isArrowStart = true;
			arrowVel.x = arrowWays[arrow * 2];
			arrowVel.y = arrowWays[arrow * 2 + 1];
			mirrorFloor.arrowVel.xy = arrowVel;
		}
		if (rotate >= 0){
			isRotateStart = mirrorFloor.isRotateStart = true;
			rotationReverse = !rotationReverse;
		}
		
		
		
	}
	public function addScore():void {
		score++;
		if (arrow >= 0) score++;
		if (arrow == 1) score += 2;
		if (beltVel.x != 0) score++;
	}
	public function checkHit(p:Vct, size:Vct):Boolean {
		return (p.x + size.x - 1 >= pos.x && p.x <= pos.x + width * spr.size.x - 1 &&
			p.y + size.y - 1 >= pos.y && p.y <= pos.y + spr.size.y - 1);
	}
}
function checkHitFloors(p:Vct, size:Vct):Floor {
	var rf:Floor;
	for each (var f:Floor in floors) {
		if (f.checkHit(p, size)) {
			if (!rf || rf.pos.y < f.pos.y) rf = f
		}
	}
	return rf;
}