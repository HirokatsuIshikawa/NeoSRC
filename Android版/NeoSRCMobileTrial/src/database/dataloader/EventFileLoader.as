package database.dataloader
{
	import code.org.coderepos.text.encoding.Jcode;
	import common.CommonDef;
	import common.CommonSystem;
	import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
    import main.MainController;
	import system.file.DataLoad;
	
	/**
	 * ...
	 * @author
	 */
	public class EventFileLoader
	{
		
		//テキストロード
		public static function loadEveData(name:String, func:Function, resetLabelFlg:Boolean = true):void
		{
			var i:int = 0;
			//読み込みインスタンスの生成
			var _textloader:URLLoader = new URLLoader();
			var file:File = File.applicationDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "eve/");
			
			//URL
			var _requrl:URLRequest = new URLRequest(CommonSystem.FILE_HEAD + file.nativePath + "/" + name);
			//読み込むデータ型式をテキストに設定
			_textloader.dataFormat = URLLoaderDataFormat.BINARY;
			//テキストを読み込み開始し、完了したらtestAreaに代入
			_textloader.addEventListener(Event.COMPLETE, loadComplete);
            _textloader.addEventListener(IOErrorEvent.IO_ERROR, loadError);
            _textloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityLoadError);
			//FileReference　ロード成功時の処理
			function loadComplete(e:Event):void
			{
				_textloader.removeEventListener(Event.COMPLETE, loadComplete);
                _textloader.removeEventListener(IOErrorEvent.IO_ERROR, loadError);
                _textloader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityLoadError);
				var barrDat:ByteArray = e.target.data;
				var strData:String = barrDat.readMultiByte(barrDat.length, DataLoad.DATA_CODE_UTF8);
				
				strData = strData.replace(/\r\n/g, "\n");
				var ary:Array = strData.split("\n");
				var labelList:Object = new Object();
                //ラベルを付けなおすフラグ
                if (resetLabelFlg)
                {
				    labelList = resetLabel(ary, labelList);
                }
				func(ary, labelList);
			}
            
            function loadError(e:IOErrorEvent):void
            {
                MainController.$.view.alertMessage(_requrl.url + "を読み込めませんでした", "IOエラー");
            }          
            
            function securityLoadError(e:SecurityErrorEvent):void
            {
                MainController.$.view.alertMessage(_requrl.url + "を読み込めませんでした","セキュリティロードエラー")
            }
            
			_textloader.load(_requrl);
		}
		
		public static function resetLabel(ary:Array, labelList:Object):Object
		{
			var i:int = 0;
            if (labelList != null)
            {
                labelList = null;
                labelList = new Object();
            }
            
			//コメントアウト削除
			for (i = 0; i < ary.length; i++)
			{
				// コメントアウト行の排除
				if (ary[i].search("//") == 0)
				{
					ary.splice(i, 1);
					i--;
				}
				// ラベルキーの追加
				else
				{
					//ライン整頓
					//タブ変換
					ary[i] = ary[i].replace(/\t/g, " ");
					
					ary[i] = CommonDef.sortCommandLine(ary[i]);
					
					// ラベルキーの追加
					if (ary[i].length > 0 && ary[i].lastIndexOf(":") == ary[i].length - 1)
					{
						labelList[ary[i]] = i;
					}
				}
			}
            return labelList;
		}
	
	}

}