package abba.master
{
	import flash.events.AccelerometerEvent;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.KeyboardEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Key {
		public var s:Vector.<Boolean> = new Vector.<Boolean>(256);
		
		public var touchLeft:Boolean = false;
		public var touchRight:Boolean = false;
		public var touchJump:Boolean = false;
		public var touchMoving:Boolean = false;
		public var accel:Accelerometer = new Accelerometer();
		
		public var accelX:Number = 0;
		public var accelY:Number = 0;
		public var accelZ:Number = 0;
		
		private var _main:Game;
		
		public function Key(main) {
			_main = main; 
			_main.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressed);
			_main.stage.addEventListener(KeyboardEvent.KEY_UP, onReleased);
			_main.addEventListener(TouchEvent.TOUCH,handleTouch);
			
			if (Game.useAccelerometer) {
				accel.addEventListener(AccelerometerEvent.UPDATE, accelUpdateHandler);
				//leftImg.visible = false;
				//rightImg.visible = false;
			} else {
				//leftImg.visible = true;
				//rightImg.visible = true;
			}
		}
		
		public function dispose():void {
			_main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPressed);
			_main.stage.removeEventListener(KeyboardEvent.KEY_UP, onReleased);
			_main.removeEventListener(TouchEvent.TOUCH,handleTouch);
			accel.removeEventListener(AccelerometerEvent.UPDATE, accelUpdateHandler);
		}
		
		public function accelUpdateHandler(event:AccelerometerEvent):void
		{
			accelX = parseFloat(event.accelerationX.toFixed(3))*30;
			accelY = parseFloat(event.accelerationY.toFixed(3))*30;
			accelZ = parseFloat(event.accelerationZ.toFixed(3))*30;		
			
			touchLeft = false;
			touchRight = false;
			if (accelX > 6) {
				touchLeft = true;
				touchRight = false;
			} else if (accelX < -6){
				touchLeft = false;
				touchRight = true;
			}
			
		}
		
		private function handleTouch(e:TouchEvent):void {		
			var touches:Vector.<Touch> = e.getTouches(_main.stage);
			if (touches.length == 0){
				return;
			}
			
			if (touches.length >= 1)
			{
				for each(var touch:Touch in touches) {
					var currentPos:Point  = touch.getLocation(_main.stage);
					//var previousPos:Point = touch.getPreviousLocation(main.stage);
					trace(touch.phase,touch.id,touch.target.name);
					switch(touch.phase) {
						case TouchPhase.BEGAN:	
							if (!(touch.target is Image) || touch.target.name == null) {
								touchJump = true;					
							} 
							if (!Game.useAccelerometer && touch.target is Image && touch.target.name == 'left') {
								touchLeft = true;
							} 
							if (!Game.useAccelerometer && touch.target is Image && touch.target.name == 'right') {
								touchRight = true;
							}
							break;
						case TouchPhase.MOVED:
							touchMoving = true;
							
							if (touch.globalY < touch.previousGlobalY){
								touchJump = true;
							}
							
							break;
						case TouchPhase.ENDED:				
							touchJump = false;
							if (touch.target.name == 'left') {
								touchMoving = false;
								touchLeft = false;								
							}
							if (touch.target.name == 'right') {
								touchMoving = false;
								touchRight = false;
							}
							break;
					}				
				}
				
			}
			//var mousePos:Point = touch.getLocation(main.stage);
			
			
		}
		
		private function onPressed(e:KeyboardEvent):void {
			if (e.keyCode > 256)
				return;
			s[e.keyCode] = true;
		}
		private function onReleased(e:KeyboardEvent):void {
			if (e.keyCode > 256)
				return;
			s[e.keyCode] = false;
		}
		public function get isWPressed():Boolean {
			return s[0x26] || s[0x57];
		}
		public function get isAPressed():Boolean {
			return s[0x25] || s[0x41] || touchLeft;
		}
		public function get isSPressed():Boolean {
			return s[0x28] || s[0x53];
		}
		public function get isDPressed():Boolean {
			return s[0x27] || s[0x44] || touchRight;
		}
		private var sVct:Vct = new Vct;
		public function get stick():Vct {
			sVct.clear();
			if (isWPressed) sVct.y -= 1;
			if (isAPressed) sVct.x -= 1;
			if (isSPressed) sVct.y += 1;
			if (isDPressed) sVct.x += 1;
			if (sVct.x != 0 && sVct.y != 0) sVct.scaleBy(0.7);
			return sVct;
		}
		public function get isButtonPressed():Boolean {
			return isButton1Pressed || isButton2Pressed || touchJump;
		}
		public function get isButton1Pressed():Boolean {
			return s[0x5a] || s[0xbe] || s[0x20];
		}
		public function get isButton2Pressed():Boolean {
			return s[0x58] || s[0xbf];
		}
	}

}