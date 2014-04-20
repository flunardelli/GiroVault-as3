package abba.master
{
	import flash.geom.Vector3D;

	public class Vct extends Vector3D {
		public function Vct(x:Number = 0, y:Number = 0) {
			super(x, y);
		}
		public function clear():void {
			x = y = 0;
		}
		public function distance(p:Vector3D):Number {
			return Utils.getLength(p.x - x, p.y - y);
		}
		public function angle(p:Vector3D):Number {
			return Utils.atan2(p.x - x, p.y - y);
		}
		public function addAngle(a:Number, s:Number):void {
			x += Utils.sin(a) * s;
			y += Utils.cos(a) * s;
		}
		public function rotate(a:Number):void {
			var px:Number = x;
			x = x * Utils.cos(a) - y * Utils.sin(a);
			y = px * Utils.sin(a) + y * Utils.cos(a);
		}
		public function set xy(v:Vector3D):void {
			x = v.x;
			y = v.y;
		}
		public function get way():Number {
			return Utils.atan2(x, y);
		}
	}
}