package bgm.soundmanager {
	import a24.tween.Tween24;
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.SoundShortcuts;
	import flash.media.*;
	
	
	/**************************************************************
	 *
	 * TweenEngine
	 * （※Tweenerが肩代わりしてくれています）
	 * 
	 *************************************************************/
	public class TweenEngine {
		
		
		//--------------------------------------------------------------------------
		// コンストラクタ
		//--------------------------------------------------------------------------
		public function TweenEngine() {}
		
		
		// 初期設定
		//--------------------------------------------------------------------------
		public static function init():void {
			
			SoundShortcuts.init();
		}
		
		// 音量のフェード操作
		//--------------------------------------------------------------------------
		public static function tweenVolume( channel:SoundChannel, volume:Number, time:Number = 1.0 ):void {
			var trans:SoundTransform = channel.soundTransform;
			// ボリュームを入れ替えて再セット
			//Tweener.addTween( trans, { volume:volume, time:time } );
			Tween24.tween(trans, time, null, {volume:volume}).onUpdate(updateVolume).play();
			
			function updateVolume():void
			{
				channel.soundTransform = trans;
			}
		}
		
		// パンのフェード操作
		//--------------------------------------------------------------------------
		public static function tweenPan( channel:SoundChannel, pan:Number, time:Number = 1.0 ):void{
			var trans:SoundTransform = channel.soundTransform;
			Tweener.addTween( trans, { pan:pan, time:time } );
		}
	}
}