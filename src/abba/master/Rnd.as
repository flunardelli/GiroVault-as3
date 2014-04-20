package abba.master
{
	import flash.utils.getTimer;

	public class Rnd {
		
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
		public function n(v:Number = 1, s:Number = 0):Number { 
			return get() * v + s; 
		}
		public function i(v:int, s:int = 0):int { 
			return n(v, s); 
		}
		public function sx(v:Number = 1, s:Number = 0):Number { 
			return n(v, s) * Game.scr.size.x; 
		}
		public function sy(v:Number = 1, s:Number = 0):Number { 
			return n(v, s) * Game.scr.size.y; 
		}
		public function pm():int { 
			return i(2) * 2 - 1; 
		}
		
	}

}