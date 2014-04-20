package abba.master
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class Shp {
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
}