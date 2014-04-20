package abba.master
{
	public class Clr {
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
}