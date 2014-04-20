package abba.master
{
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	public class Floor {
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
		public var goldSpr:Spr = new Spr([
			[Clr.magenta.i],[
				" 11 ",
				"1111",
				"1111",
				" 11 ",
			], 0]);
		public var pos:Vct = new Vct;
		public var width:int, pwidth:int;
		public var mirrorFloor:Floor;
		public var arrow:int = -1, isArrowStart:Boolean;
		public var rotate:int = -1, isRotateStart:Boolean;
		public var arrowVel:Vct = new Vct;
		public var beltVel:Vct = new Vct;
		public var goldVel:Vct = new Vct;
		public var beltTicks:Number = 0;
		private static var arrowWays:Array = [1, 0, 0, 1, -1, 0, 0, -1];
		public function setRandom(y:Number):void {
			width = Game.rnd.i(4, 2);
			pwidth = width * spr.size.x;
			pos.x = int(Game.rnd.sx()) + (Game.scrollXDist % 1);
			pos.y = -spr.size.y + y;
			if (Game.rnd.n() < Game.rank * 0.1) {
				arrow = Game.rnd.i(4);
				if (arrow == 3) arrow = 1;
			}
			if (Game.rnd.n() < Game.rank * 0.1) beltVel.x = Game.rnd.n(Game.rank * 0.2, 0.5) * Game.rnd.pm();
			if (Game.rnd.n() < Game.rank * 0.1) {
				rotate = Game.rnd.i(4);
				if (rotate == 3) rotate = 1;
			}
		}
		public function setMirror(f:Floor):void {
			width = f.width;
			pwidth = f.pwidth;
			pos.xy = f.pos;
			pos.x += Game.scr.size.x;
			arrow = f.arrow;
			rotate = f.rotate;
			beltVel.xy = f.beltVel;
			goldVel.xy = f.pos;
			mirrorFloor = f;
			f.mirrorFloor = this;
		}
		private var bp:Vct = new Vct;
		
		public function update():Boolean {
			if (isArrowStart) pos.incrementBy(arrowVel);
			
			if (pos.x < -pwidth) pos.x += Game.scr.size.x * 2;
			else if (pos.x > Game.scr.size.x + pwidth) pos.x -= Game.scr.size.x * 2;
			if (beltVel.x != 0) {
				var d:Number = beltTicks;
				for (var i:int = 0; i < width * 2 + 2; i++) {
					calcEdgePos(d);
					bp.x = epos.x - 2;
					bp.y = epos.y - 2;
					beltSpr.draw(bp);
					
					//goldSpr.draw(bp);
					
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
			
			return pos.y <= Game.scr.size.y + spr.size.y * 2;
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
			
			var f:int = (Game.score / 500);
			var ff:Number = Game.rotationSpeedOri - (f*100);
			
			if (ff != Game.rotationSpeed && ff > 99) {
				trace("chancge: " + Game.rotationSpeed);
				Game.rotationSpeed = ff;
				clearInterval(Game.currentTimer);
				Game.currentTimer = setInterval(Game.rotateStage,Game.rotationSpeed);			
			}
			
			if (arrow >= 0) {
				isArrowStart = mirrorFloor.isArrowStart = true;
				arrowVel.x = arrowWays[arrow * 2];
				arrowVel.y = arrowWays[arrow * 2 + 1];
				mirrorFloor.arrowVel.xy = arrowVel;
			}
			if (rotate >= 0){
				isRotateStart = mirrorFloor.isRotateStart = true;
				Game.rotationReverse = !Game.rotationReverse;
			}
			
			
			
		}
		public function addScore():void {
			Game.score++;
			if (arrow >= 0) Game.score++;
			if (arrow == 1) Game.score += 2;
			if (beltVel.x != 0) Game.score++;
		}
		public function checkHit(p:Vct, size:Vct):Boolean {
			return (p.x + size.x - 1 >= pos.x && p.x <= pos.x + width * spr.size.x - 1 &&
				p.y + size.y - 1 >= pos.y && p.y <= pos.y + spr.size.y - 1);
		}
	}
}