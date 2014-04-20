package abba.master
{
	public class Msg {
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
}