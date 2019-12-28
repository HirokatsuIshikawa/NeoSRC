package bgm
{
	import a24.tween.Tween24;
	import bgm.soundmanager.SoundManager;
	import common.CommonSystem;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class SingleMusic
	{
		/**現在のBGMボリューム*/
		private static var _VolBGM:Number = 1;
		private static var _VolSE:Number = 1;
		
		/**現在演奏中*/
		public static var SET_BGM:String = "";
		public static var NOW_BGM:String = "";
		
		/**BGMパス*/
		public static const BGM_FILE_PATH:String = "music/";
		
		/**ジングルパス*/
		public static const JINGLE_FILE_PATH:String = "music/";
		
		/**読み込み中関数*/
		private static var _progFunc:Function = null;
		
		/**SEパス*/
		public static const SE_FILE_PATH:String = "music/";
		
		private static var _midiPlaying:Boolean = false;
		
		/**コンストラクタ*/
		public function SingleMusic()
		{
			throw new Error("[Alert] Audio クラスは static なのでインスタンスは作れません。");
		}
		
		public static function init():void
		{
			SoundManager.init();
			SoundManager.muteBGM();
			SoundManager.muteSE();
		}
		
		private static var _timer:Timer;
		
		
		public static function playBGMData(data:Object):void
		{
			var file:File = null;
			var url:String = null;
			var vol:Number = 1;
			var fade:Number = 0;
			if (data.hasOwnProperty("file"))
			{
				if (data.file === "")
				{
					return;
				}
				url = CommonSystem.MAIN_LOAD_PATH + "sound/" + data.file;
				file = new File(url);
				
				if (!file.exists)
				{
					url = CommonSystem.FILE_HEAD + CommonSystem.searchFile(CommonSystem.MAIN_LOAD_PATH + "sound/", data.file);
					file = new File(url);
				}
				
				//ファイルの有無を確認
				if (!file.exists)
				{
					if (CommonSystem.COMMON_BGM_PATH != null)
					{
						
						url = CommonSystem.FILE_HEAD + CommonSystem.COMMON_BGM_PATH + "/" + data.file;
						file = new File(url);
						if (!file.exists)
						{
							url = CommonSystem.FILE_HEAD + CommonSystem.searchFile(CommonSystem.COMMON_BGM_PATH + "/", data.file);
							file = new File(url);
						}
						
						if (!file.exists)
						{
							url = null;
						}
					}
					else
					{
						url = null;
					}
					
				}
			}
			else
			{
				url = null;
			}
			if (data.hasOwnProperty("vol"))
			{
				vol = data.vol;
			}
			if (data.hasOwnProperty("fade"))
			{
				fade = data.fade;
			}
			
			//ファイルの有無を確認
			if (url != null)
			{
				playBGM(url, vol, fade);
			}
			else
			{
				url = null;
				
			}
		}
		
		/**BGM演奏*/
		public static function playBGM(url:String, vol:Number = 1, fade:Number = 0):void
		{
			if (url == null)
			{
				return;
			}
			try
			{
				SET_BGM = url;
				//同じ曲は継続して鳴らす
				if (NOW_BGM != SET_BGM || NOW_BGM.length <= 0)
				{
					//鳴らしていないときは新たにならす
					if (NOW_BGM.length <= 0)
					{
						SoundManager.stopBGM_ID("bgm");
						SoundManager.removeBGM("bgm"); //
						NOW_BGM = SET_BGM;
						_VolBGM = vol;
						
						if (url.indexOf(".mid") >= 0)
						{
							startMidi(url, vol, fade);
						}
						else
						{
							_midiPlaying = false;
							var file:File = new File(url);
							if (!file.exists)
							{
								return;
							}
							
							SoundManager.addExternalBGM("bgm", url);
							SoundManager.play("bgm", fade, _VolBGM); // 即再生
						}
					}
					//別の曲のときはフェードアウトしてから鳴らす
					else
					{
						if (_midiPlaying)
						{
							if (fade > 0)
							{
								_midiPlaying = false;
								MidiPlayer.stop(fade);
								_timer = new Timer(fade * 1000);
								_timer.addEventListener(TimerEvent.TIMER, returnNextBGM(url, vol, fade));
								_timer.start();
							}
							else
							{
								_midiPlaying = false;
								nextBgmStart(url, vol, fade);
							}
						}
						else
						{
							_midiPlaying = false;
							Tween24.serial( //
							SoundManager.setVolumeBGM(0, fade), //
							Tween24.wait(fade) //
							).onComplete(nextBgmStart, url, vol, fade).play();
						}
					}
				}
				
			}
			catch (e:Event)
			{
			}
		}
		
		private static function returnNextBGM(url:String, vol:Number = 1, fade:Number = 0):Function
		{
			return function():void
			{
				nextBgmStart(url, vol, fade);
			}
		}
		
		private static function nextBgmStart(url:String, vol:Number = 1, fade:Number = 0):void
		{
			
			SoundManager.stopBGM_ID("bgm");
			SoundManager.removeBGM("bgm"); //
			if (_timer != null)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, returnNextBGM(url, vol, fade));
			}
			_timer = null;
			
			_VolBGM = vol;
			
			SoundManager.stopBGM_ID("bgm");
			SoundManager.removeBGM("bgm"); //
			if (url.indexOf(".mid") >= 0)
			{
				startMidi(url, vol, fade);
				NOW_BGM = SET_BGM;
			}
			else
			{
				
				_midiPlaying = false;
				var file:File = new File(url);
				if (!file.exists)
				{
					return;
				}
				SoundManager.addExternalBGM("bgm", url);
				SoundManager.play("bgm", fade, 100 * _VolBGM); // 即再生
				NOW_BGM = SET_BGM;
			}
		}
		
		public static function startMidi(url:String, vol:Number, fade:Number):void
		{
			var file:File;
			if (fade > 0)
			{
				MidiPlayer.driver.volume = _VolBGM;
			}
			else
			{
				MidiPlayer.driver.volume = vol;
			}
			
			_VolBGM = vol;
			file = new File(url);
			
			if (file.exists)
			{
				MidiPlayer.play(url);
				_midiPlaying = true;
			}
			
			if (file.exists)
			{
				if (fade > 0)
				{
					Tween24.tween(MidiPlayer.driver, fade, null, {volume: vol}).play();
				}
			}
		
			//MidiPlayer.play(CommonSystem.SCENARIO_PATH + "sound/" + url);
		}
		
		public static function endBGMData(param:Object):void
		{
			var time:Number = 0;
			
			if (param.hasOwnProperty("fade"))
			{
				time = param.fade;
			}
			
			endBGM(time);
		}
		
		private static var _stopTween:Tween24;
		
		/**BGM演奏終了*/
		public static function endBGM(outfade:Number):void
		{
			SET_BGM = "";
			NOW_BGM = "";
			/**BGM演奏切り替え*/
			_stopTween = Tween24.serial( //
			SoundManager.setVolumeBGM(0, outfade), //
			Tween24.wait(outfade)).onComplete( //
			function():void
			{
				SoundManager.stopBGM();
			});
			_stopTween.play();
		}
		
		/**BGM演奏*/
		public static function stopBGM(vol:Number = 0, fade:Number = 1):void
		{
			if (_stopTween != null)
			{
				_stopTween.stop();
			}
			
			SET_BGM = "";
			NOW_BGM = "";
			try
			{
				SoundManager.stopBGM_ID("bgm");
				SoundManager.removeBGM("bgm"); //
				SoundManager.setVolumeBGM(0, fade);
			}
			catch (e:Event)
			{
				
			}
		}
		
		/**一時停止*/
		public static function pauseBGM():void
		{
			NOW_BGM = "";
			try
			{
				SoundManager.stopBGM_ID("bgm");
				SoundManager.removeBGM("bgm"); //
				SoundManager.setVolumeBGM(0);
			}
			catch (e:Event)
			{
				
			}
		}
		
		/**一時停止解除*/
		public static function restartBGM():void
		{
			if (SET_BGM != null && SET_BGM.length > 0)
			{
				playBGM(SET_BGM);
			}
		}
		
		/**読み込み効果音再生*/
		public static function playLoadDataSE(data:Object):void
		{
			var file:File = null;
			var url:String = "";
			var vol:Number = 1;
			
			if (data.hasOwnProperty("file"))
			{
				url = CommonSystem.MAIN_LOAD_PATH + "sound/" + data.file;
				file = new File(url);
				
				if (!file.exists)
				{
					url = CommonSystem.FILE_HEAD + CommonSystem.searchFile(CommonSystem.MAIN_LOAD_PATH + "sound/", data.file);
					file = new File(url);
				}
				
				//ファイルの有無を確認
				if (!file.exists)
				{
					url = CommonSystem.FILE_HEAD + CommonSystem.COMMON_SE_PATH + "/" + data.file;
					file = new File(url);
					
					if (!file.exists)
					{
						url = CommonSystem.FILE_HEAD + CommonSystem.searchFile(CommonSystem.COMMON_SE_PATH + "/", data.file);
						file = new File(url);
					}
					
					if (!file.exists)
					{
						url = null;
					}
				}
			}
			else
			{
				url = null;
			}
			
			if (data.hasOwnProperty("vol"))
			{
				vol = data.vol;
			}
			
			if (url != null)
			{
				playLoadSE(url, vol);
			}
			else
			{
				url = null;
				
			}
		}
		
		/**読み込み効果音再生*/
		public static function playLoadSE(url:String, vol:Number = 1):void
		{
			try
			{
				
				SoundManager.stopSE_ID("se");
				SoundManager.removeSE("se"); //
				_VolSE = vol;
				SoundManager.addExternalSE("se", url);
				SoundManager.play("se", 0, _VolSE);
			}
			catch (e:Event)
			{
				
			}
		}
		
		/**ボリューム変更*/
		public static function changeVolumeBgmData(param:Object):void
		{
			if (!param.hasOwnProperty("fade"))
			{
				param.fade = 1.0;
			}
			
			changeVolumeBgm(param.vol, param.fade);
		}
		
		/**ボリューム変更*/
		public static function changeVolumeBgm(vol:Number, fade:Number = 0):void
		{
			_VolBGM = vol;
			if (fade > 0)
			{
				SoundManager.setVolumeBGM(_VolBGM, fade);
			}
			else
			{
				SoundManager.setVolumeBGM(_VolBGM);
			}
		}
		
		/**BGMボリューム設定*/
		public static function bgmVol(num:Number):void
		{
			SoundManager.volumeBGM = _VolBGM;
		}
		
		/**SEボリューム設定*/
		public static function seVol(num:Number):void
		{
			SoundManager.volumeSE = _VolSE;
		}
	}
}