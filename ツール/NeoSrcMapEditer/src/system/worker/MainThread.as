package system.worker
{
	import flash.display.Sprite;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import starling.core.Starling;
	import view.MainViewer;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class MainThread
	{
		//スターリン
		private var _starling:Starling;
		//バイナリーで読み込んだGIFデータ
		private var byteData:ByteArray;
		//URLローダー
		private var url_loader:URLLoader;
		
		public function MainThread(spr:Sprite)
		{
			//スターリンセット・開始
			//_starling = new Starling(Viewer, spr.stage);
			_starling = new Starling(MainViewer, spr.stage);
			_starling.antiAliasing = 1;
			_starling.showStats = false;
			//ディスパッチイベント
			//_starling.stage.addEventListener("loadgif", loadGifData);
			//_starling.stage.addEventListener("startBGM", startBGM);
			_starling.start();
		}
	
	}
}