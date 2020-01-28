package database.dataloader
{
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent;
    import common.CommonSystem;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import scene.main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class SingleTxtLoader
	{
		public function SingleTxtLoader()
		{
		
		}
		
		public static const TYPE_TEXT:int = 1;
		public static const TYPE_JSON:int = 2;
		public static const TYPE_XML:int = 3;
		
		/**マップファイル読み込み*/
		public static function loadData(url:String, param:Array, callBack:Function, type:int = TYPE_TEXT):void
		{
			MainController.$.view.debugText.addText("<br>背景:" + url);
			//読み込みインスタンスの生成
			var _textloader:URLLoader = new URLLoader();
			//var file:File = File.applicationDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "effect/" + name);
			//URL
			var _requrl:URLRequest = new URLRequest(CommonSystem.FILE_HEAD + url);
			//読み込むデータ型式をテキストに設定
			_textloader.dataFormat = URLLoaderDataFormat.TEXT;
			
			//テキストを読み込み開始し、完了したらtestAreaに代入
			_textloader.addEventListener(Event.COMPLETE, loadComplete);
			
			//FileReference　ロード成功時の処理
			function loadComplete(e:Event):void
			{
				_textloader.removeEventListener(Event.COMPLETE, loadComplete);
				var str:String = e.target.data;
				
				switch (type)
				{
				case TYPE_TEXT: 
					callBack(str, param);
					break;
				case TYPE_JSON: 
					var obj:Object = JSON.parse(str);
					callBack(obj, param);
					break;
				case TYPE_XML:
					//改行の変更
					var getXml:XML = new XML(str);
					callBack(getXml, param);
					break;
					
				}
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