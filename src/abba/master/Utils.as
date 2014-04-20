package abba.master
{
	public class Utils
	{
		static public var sin:Function = Math.sin;
		static public var cos:Function = Math.cos; 
		static public var atan2:Function = Math.atan2; 
		static public var sqrt:Function = Math.sqrt;
		static public var abs:Function = Math.abs;
		static public var PI:Number = Math.PI;
		static public var PI2:Number = PI * 2;
		
		public function Utils()
		{
		}
		static public function getLength(x:Number, y:Number):Number {
			return sqrt(x * x + y * y);
		}
		static public function clamp(v:Number, min:Number, max:Number):Number {
			if (v > max) return max;
			else if (v < min) return min;
			return v;
		}
		static public function normalizeAngle(v:Number):Number {
			var r:Number = v % PI2;
			if (r < -PI) r += PI2;
			else if (r > PI) r -= PI2;
			return r;
		}
	}
}