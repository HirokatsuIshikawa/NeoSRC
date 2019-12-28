package bgm.soundmanager{
	import flash.events.Event;
	import flash.media.Sound;
	
	
	/**************************************************************
	 *
	 * SeSound
	 * （※SEの特性は「loop無し、重ね再生可」です）
	 * 
	 *************************************************************/
	public class SeSound extends BaseSound{
		
		
		//--------------------------------------------------------------------------
		// コンストラクタ
		//--------------------------------------------------------------------------
		public function SeSound( sound:Sound, soundId:String, isMute:Boolean, loop:Boolean = false ) {
			
			super( sound, soundId, isMute, loop, "SE" );
		}
		
		
		//--------------------------------------------------------------------------
		// 再生
		//--------------------------------------------------------------------------
		public override function play( volumeValue:Number, panValue:Number, fadeTime:Number ):void{
			
			// [1]再生を実行
			_channel = _sound.play();
			if (_channel == null) {
				return;
			}
			isPlaying = true;
			
			_channel.addEventListener(Event.SOUND_COMPLETE, soundComp);
			
			function soundComp(e:Event):void {
				if(_channel != null) {
					_channel.removeEventListener(Event.SOUND_COMPLETE, soundComp);
				}
				isPlaying = false;
			}
			
			volume = _tempVolume = volumeValue;
			
			// [2]ミュート時は音量0で再生状態のまま処理終了
			if ( isMute ) {
				volume = 0;
				return;
			}
			
			// [3]音量トゥイーン。フェードインする場合はいったんvolumeを0に。
			if ( 0 < fadeTime ) 	volume = 0;
			TweenEngine.tweenVolume( _channel, _tempVolume, fadeTime );
			
			// [4]パンは即反映
			setPan( panValue, 0);
		}
		
		
		//--------------------------------------------------------------------------
		// 停止
		//--------------------------------------------------------------------------
		public override function stop():void{
			
			// 再生されていなかったら無効
			if ( ! isPlaying )	return;
			
			isPlaying = false;
			if(_channel != null) {
				_channel.stop();
			}
		}
		
		
		
	}
}