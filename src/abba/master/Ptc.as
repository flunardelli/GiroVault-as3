package abba.master
{
	public class Ptc {
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
				pt = new Ptc(clr);
				pt.pos.xy = p;
				pt.vel.addAngle(angle + Game.rnd.n(angleWidth) * Game.rnd.pm(),
					speed * Game.rnd.n(1, 0.5));
				pt.ticks = ticks * Game.rnd.n(1, 0.5);
				s.push(pt);
			}
		}
	}
}