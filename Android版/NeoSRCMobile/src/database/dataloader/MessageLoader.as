package database.dataloader
{
	import code.org.coderepos.text.encoding.Jcode;
	import common.CommonDef;
	import common.CommonSystem;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import system.file.DataLoad;
	
	/**
	 * ...
	 * @author
	 */
	public class MessageLoader
	{
		
		//テキストロード
		public static function loadEveData(name:String, func:Function):void
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
			//FileReference　ロード成功時の処理
			function loadComplete(e:Event):void
			{
				_textloader.removeEventListener(Event.COMPLETE, loadComplete);
				var barrDat:ByteArray = e.target.data;
				var strData:String = barrDat.readMultiByte(barrDat.length, DataLoad.DATA_CODE_UTF8);
				/*
				if (strData.indexOf("スタート:") < 0)
				{
					strData = Jcode.from_sjis(barrDat);
				}
				*/
				
				strData = strData.replace(/\r\n/g, "\n");
				var ary:Array = strData.split("\n");
				var labelAry:Array = new Array();
				resetLabel(ary, labelAry);
				func(ary, labelAry);
			}
			_textloader.load(_requrl);
		}
		
		public static function resetLabel(ary:Array, labelAry:Array):void
		{
			var i:int = 0;
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
					if (ary[i].lastIndexOf(":") == ary[i].length - 1)
					{
						labelAry[ary[i]] = [i];
					}
				}
			}
		}
	
	}

}