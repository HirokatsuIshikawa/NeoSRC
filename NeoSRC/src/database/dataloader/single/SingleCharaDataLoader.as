package database.dataloader.single
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import common.CommonDef;
	import common.CommonSystem;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class SingleCharaDataLoader
	{
		/**読み込みデータ*/
		private var _loadData:Object = null;
		/**コールバック*/
		private var _callBack:Function = null;
		
		public function SingleCharaDataLoader()
		{
		
		}
		
		/**マップファイル読み込み*/
		public function loadCharaData(name:String, callBack:Function):void
		{
			_callBack = callBack;
			//読み込みインスタンスの生成
			var _textloader:URLLoader = new URLLoader();
			var file:File = File.applicationDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "data");
			//URL
			var _requrl:URLRequest = new URLRequest(file.nativePath + "\\" + name + ".srcdat");
			//読み込むデータ型式をテキストに設定
			_textloader.dataFormat = URLLoaderDataFormat.TEXT;
			
			//テキストを読み込み開始し、完了したらtestAreaに代入
			_textloader.addEventListener(Event.COMPLETE, loadComplete);
			
			//FileReference　ロード成功時の処理
			function loadComplete(e:Event):void
			{
				var str:String = e.target.data;
				//改行の変更
				var obj:Object = JSON.parse(str);
				_callBack(obj);
			}
			_textloader.load(_requrl);
		}
		
		/**読み込み度数*/
		public function onProgress(e:BulkProgressEvent):void
		{
			trace("e.percentLoaded:", e.percentLoaded, "e.weightPercent:", e.weightPercent, "e.ratioLoaded:", e.ratioLoaded);
		}
		
		/**バルクローダーエラー*/
		private function onError(e:ErrorEvent):void
		{
			var loader:BulkLoader = e.target as BulkLoader;
			trace("エラーが発生しました。");
			loader.removeFailedItems();
		}
	
	}

}