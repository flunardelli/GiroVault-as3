package abba.master
{
	import com.adobe.nativeExtensions.Vibration;
	import com.palDeveloppers.ane.NativeTwitter;
	import com.sticksports.nativeExtensions.gameCenter.GameCenter;
	import so.cuo.platform.admob.Admob;
	
	public class Features
	{
		static public var admob:Admob;
		static public var supportGameCenter:Boolean = false;
		static public var supportTwitter:Boolean = false;
		static public var default_leaderboard:String = "GiroVaultHighScore";
		public function Features()
		{
			if (GameCenter.isSupported) {
				supportGameCenter = true;
				try
				{
					GameCenter.localPlayerAuthenticated.add( localPlayerAuthenticated );
					GameCenter.localPlayerNotAuthenticated.add( localPlayerNotAuthenticated );
					GameCenter.authenticateLocalPlayer();
				}
				catch( error : Error )
				{
					GameCenter.localPlayerAuthenticated.remove( localPlayerAuthenticated );
					GameCenter.localPlayerNotAuthenticated.remove( localPlayerNotAuthenticated );
					trace( error.message );
				}
				
			} 
			
			if (NativeTwitter.isSupported()){
				supportTwitter = true;
			}
			
			admob = Admob.getInstance();
			admob.setKeys("ca-app-pub-6227096075586763/4992569993");
			admob.cacheInterstitial();
		}
		
		public function localPlayerAuthenticated() : void
		{
			GameCenter.localPlayerAuthenticated.remove( localPlayerAuthenticated );
			GameCenter.localPlayerNotAuthenticated.remove( localPlayerNotAuthenticated );
			trace( "localPlayerAuthenticated" );
		}
		
		public function localPlayerNotAuthenticated() : void
		{
			GameCenter.localPlayerAuthenticated.remove( localPlayerAuthenticated );
			GameCenter.localPlayerNotAuthenticated.remove( localPlayerNotAuthenticated );
			trace( "localPlayerNotAuthenticated" );
			supportGameCenter = false;
		}
		
		public function recordScore(s:int):void {
			if (Features.supportGameCenter && GameCenter.isAuthenticated) {
				try
				{
					trace("reportScore() "+default_leaderboard+": "+s);
					GameCenter.localPlayerScoreReported.add( scoreReportSuccess );
					GameCenter.localPlayerScoreReportFailed.add( scoreReportFailed );
					GameCenter.reportScore( default_leaderboard, s );
				}
				catch( error : Error )
				{
					trace( error.message );
				}
			}
		}
		public function scoreReportFailed() : void
		{
			GameCenter.localPlayerScoreReported.remove( scoreReportSuccess );
			GameCenter.localPlayerScoreReportFailed.remove( scoreReportFailed );
			trace( "localPlayerScoreReportFailed" );
		}
		public function showLeaderboard():Boolean {
			trace("GameCenter.showStandardLeaderboard()");
			var ret:Boolean = false;
			if (!GameCenter.isAuthenticated){
				try {
					GameCenter.authenticateLocalPlayer();
				} catch (e:Error){
					trace(e);
				}
			}
			
			try
			{
				//main.addChild(loadingTextField);
				GameCenter.showStandardLeaderboard();
				GameCenter.gameCenterViewRemoved.add( showLeaderboardRemoved );
				ret = true;
			}
			catch( error : Error )
			{
				ret = false;
				trace( error.message );
				//main.removeChild(loadingTextField);
				GameCenter.gameCenterViewRemoved.remove( showLeaderboardRemoved );
			}
			return ret;
		}
		public function showLeaderboardRemoved() : void
		{			
			//main.removeChild(loadingTextField);
			GameCenter.gameCenterViewRemoved.remove( showLeaderboardRemoved );
			trace( "leaderboardLoadFailed" );
		}

		public function tweet(msg:String):void {
			try {
				if (NativeTwitter.instance.isTwitterSetup()) {		
					NativeTwitter.instance.composeTweet(msg, null, null);
				}
			} catch(e:Error) {
				trace(e);
			}
		}
		
		public function scoreReportSuccess() : void
		{
			GameCenter.localPlayerScoreReported.remove( scoreReportSuccess );
			GameCenter.localPlayerScoreReportFailed.remove( scoreReportFailed );
			trace( "localPlayerScoreReported" );
		}
		public function endGame():void {
			if (!Game.isMuted && Vibration.isSupported){
				var vibe:* = new Vibration();
				vibe.vibrate(2000);
			}
		}
		
		public function showAdmob():void {
			if (admob.isInterstitialReady()){
				admob.showInterstitial();
			} else {
				admob.cacheInterstitial();
			}
		}
		
	}
}