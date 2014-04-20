package abba.master
{
	import flash.geom.Point;

	public class Spr {
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
				Game.bd.copyPixels(s.bds[i], s.rect, point, null, null, true);
				
				
				
				if (--pi < 0) pi += Shp.BLUR_COUNT;
			}
			if (++pposIndex >= Shp.BLUR_COUNT) pposIndex = 0;
		}
		public function get size():Vct {
			return shps[currentAnim].size;
		}
	}
}