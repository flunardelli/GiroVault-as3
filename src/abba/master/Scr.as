package abba.master
{
	import flash.geom.Vector3D;

	public class Scr {
		public const LETTER_COUNT:int = 36;
		public var pixelSize:Vct = new Vct(Game.SCR_WIDTH, Game.SCR_HEIGHT);
		public var size:Vct = new Vct(int(Game.SCR_WIDTH / Shp.DOT_SIZE), int(Game.SCR_HEIGHT / Shp.DOT_SIZE));
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
						if ((lp & 1) > 0) lStr += "1";
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
}