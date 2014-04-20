package abba.master
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

	public class Snd {
		public static var isPlaying:Boolean;
		public var driver:Sound;
		public var sChannel:SoundChannel = new SoundChannel();
		public var sTransform:SoundTransform = new SoundTransform();
		[Embed(source="/assets/audio/jump.mp3")]
		public static const AudioJump:Class;
		[Embed(source="/assets/audio/walk1.mp3")]
		public static const AudioWalk1:Class;
		[Embed(source="/assets/audio/walk2.mp3")]
		public static const AudioWalk2:Class;
		[Embed(source="/assets/audio/scroll.mp3")]
		public static const AudioScroll:Class;
		[Embed(source="/assets/audio/land.mp3")]
		public static const AudioLand:Class;
		[Embed(source="/assets/audio/dead.mp3")]
		public static const AudioDead:Class;
		
		function Snd(mml:String) { 
			driver = new Snd[mml]() as Sound;		
		}
		
		public function play(loop:uint=0,vol:Number=1):void {
			if (!Game.isMuted) {
				sTransform.volume = vol;
				sChannel = driver.play(0,loop,sTransform);
				isPlaying = true;
			}
		}
	}
}