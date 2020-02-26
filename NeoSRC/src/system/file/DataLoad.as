package system.file
{
	import code.org.coderepos.text.encoding.Jcode;
	import common.CommonSystem;
	import converter.parse.SystemParse;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import system.Crypt;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class DataLoad
	{
		public static const DATA_CODE_UTF8:String = "UTF-8";
		public static const DATA_CODE_UTF16:String = "unicode";
		public static const DATA_CODE_EUC:String = "euc-jp";
		public static const DATA_CODE_JIS:String = "iso-2022-jp";
		public static const DATA_CODE_SJIS:String = "shift_jis";
		
		public static function Load(name:String, file:String, compFunc:Function, code:String = DATA_CODE_UTF8):void
		{
			var loadfile:File = new File();
			//終了後の処理
			loadfile.addEventListener(Event.SELECT, fileLoadComp)
			
			function fileLoadComp(evSel:Event):void
			{
				loadfile.removeEventListener(Event.COMPLETE, fileLoadComp);
				var fr:FileReference = null;
				fr = evSel.target as FileReference;
				fr.addEventListener(Event.COMPLETE, loadComplete);
				fr.addEventListener(ProgressEvent.PROGRESS, loadProgress);
				function loadProgress(evt:ProgressEvent):void
				{
					trace("Loaded " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes.");
				}
				//FileReference　ロード成功時の処理
				function loadComplete(e:Event):void
				{
					
					fr.removeEventListener(Event.COMPLETE, loadComplete);
					fr.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
					var fileType:String = e.currentTarget.extension;
					var barrDat:ByteArray = e.target.data;
					//漢字コード変換（shift-jis　－＞　UTF-8）
					
					var strData:String = "";
					
					if (fileType === "srctxt")
					{
						strData = barrDat.readMultiByte(barrDat.length, DATA_CODE_UTF8);
						if (strData.indexOf("スタートファイル") < 0)
						{
							strData = Jcode.from_sjis(barrDat);
						}
						
						var txtData:Object = SystemParse.parseSystenData(strData);
						var path:String = loadfile.parent.nativePath + "\\";
						CommonSystem.SCENARIO_PATH = path;
						MainController.$.view.debugText.addText(path);
						compFunc(txtData);
					}
					else
					{
						strData = barrDat.readMultiByte(barrDat.length, DATA_CODE_UTF8);
						convertJson(strData);
					}
				}
				
				function convertJson(strData:String):void
				{
					//改行の変更
					var obj:Object = JSON.parse(strData);
					var path:String = loadfile.parent.nativePath + "\\";
					/*
					   while(path.indexOf("\\") >= 0) {
					   path = path.replace("\\", "//");
					   }
					 */
					CommonSystem.SCENARIO_PATH = path;
					MainController.$.view.debugText.addText(path);
					compFunc(obj);
				}
				
				fr.load(); //ロード開始
			}
			//fr.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			//必要なら...
			//fr.addEventListener(ProgressEvent.PROGRESS, onFileReference_Progress);
			//fr.addEventListener(Event.CANCEL, onFileReference_Cancel);
			//fr.addEventListener(IOErrorEvent.IO_ERROR, onFileReference_IOError);
			//fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileReference_SecurityError);
			
			//フィルタ拡張子を指定
			var ff:FileFilter = new FileFilter(name, file);
			//ファイル選択ダイアログ起動
			loadfile.browseForOpen("open", [ff]);
		}
		
		public static function LoadPath(name:String, file:String, compFunc:Function):void
		{
			var loadfile:File = new File();
			//終了後の処理
			loadfile.addEventListener(Event.SELECT, function(evSel:Event):void
			{
				var path:String = loadfile.nativePath;
				compFunc(path);
			});
			
			//フィルタ拡張子を指定
			var ff:FileFilter = new FileFilter(name, file);
			//ファイル選択ダイアログ起動
			loadfile.browseForOpen("open", [ff]);
		}
		
		public static function LoadFolderPath(compFunc:Function):void
		{
			var loadfile:File = new File();
			//終了後の処理
			loadfile.addEventListener(Event.SELECT, function(evSel:Event):void
			{
				var path:String = loadfile.nativePath;
				compFunc(path);
			});
			
			//ファイル選択ダイアログ起動
			loadfile.browseForDirectory("コモンBGMフォルダ選択");
		}
		
		/**スマホ用、ファイル読み込み*/
		public static function loadPhoneList(file:Array):Object
		{
			var i:int = 0;
			var dir:File = File.userDirectory;
			var homefile:File = dir.resolvePath("シミュラマPになろう//Scenario");
			var getList:Array = homefile.getDirectoryListing();
			var getpath:Vector.<String> = new Vector.<String>;
			var getname:Vector.<String> = new Vector.<String>;
			var count:int = 0;
			
			for each (var data:File in getList)
			{
				if (data.isDirectory)
				{
					var folder:Array = data.getDirectoryListing();
					for each (var r_data:File in folder)
					{
						var breakFlg:Boolean = false;
						
						for (i = 0; i < file.length; i++)
						{
							if (r_data.name.indexOf(file[i]) >= 0)
							{
								getpath.push(r_data.nativePath);
								getname.push(r_data.name);
								count++;
								breakFlg = true;
								break;
							}
						}
						if (breakFlg)
						{
							break;
						}
					}
				}
			}
			
			var obj:Object = new Object;
			obj.path = getpath;
			obj.name = getname;
			obj.count = count;
			return obj;
		}
		
		public static function LoadPhoneData(path:String, compFunc:Function, code:String = DATA_CODE_UTF8):void
		{
			var fr:File = new File(path);
			fr.addEventListener(Event.COMPLETE, loadComplete);
			fr.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			function loadProgress(evt:ProgressEvent):void
			{
				trace("Loaded " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes.");
			}
			//FileReference　ロード成功時の処理
			function loadComplete(e:Event):void
			{
				var barrDat:ByteArray = e.target.data;
				//漢字コード変換（shift-jis　－＞　UTF-8）
				var strData:String = barrDat.readMultiByte(barrDat.length, code);
				
				//改行の変更
				
				var fileType:String = e.currentTarget.extension;
				var obj:Object = null;
				if (fileType === "srctxt")
				{
					if (strData.indexOf("スタートファイル") < 0)
					{
						strData = Jcode.from_sjis(barrDat);
					}
					obj = SystemParse.parseSystenData(strData);
				}
				else
				{
					obj = JSON.parse(strData);
				}
				var path:String = fr.parent.nativePath + "/";
				CommonSystem.SCENARIO_PATH = path;
				
				compFunc(obj);
			}
			fr.load();
		}
		
		public static function ReadText(name:String, file:String, compFunc:Function, code:String = DATA_CODE_UTF8):void
		{
			var fr:FileReference = new FileReference();
			//終了後の処理
			fr.addEventListener(Event.SELECT, function(evSel:Event):void
			{
				var fr:FileReference = null;
				fr = evSel.target as FileReference;
				fr.addEventListener(Event.COMPLETE, loadComplete);
				fr.addEventListener(ProgressEvent.PROGRESS, loadProgress);
				function loadProgress(evt:ProgressEvent):void
				{
					trace("Loaded " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes.");
				}
				//FileReference　ロード成功時の処理
				function loadComplete(e:Event):void
				{
					var barrDat:ByteArray = e.target.data;
					//漢字コード変換（shift-jis　－＞　UTF-8）
					var strData:String = barrDat.readMultiByte(barrDat.length, code);
					compFunc(strData);
				}
				fr.load(); //ロード開始
			});
			//フィルタ拡張子を指定
			var ff:FileFilter = new FileFilter(name, "*" + file);
			//ファイル選択ダイアログ起動
			fr.browse([ff]);
		}
		
		//テキストロード
		public static function loadSaveData(name:String, num:int, func:Function):void
		{
			//読み込みインスタンスの生成
			var _textloader:URLLoader = new URLLoader();
			var file:File = File.applicationDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "save/" + name);
			
			if (file.exists)
			{
				//URL
				var _requrl:URLRequest = new URLRequest(CommonSystem.FILE_HEAD + file.nativePath);
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
					func(strData, num);
				}
				_textloader.load(_requrl);
			}
			else
			{
				func(null, num);
			}
		}
		
		//テキストロード
		public static function loadMapSaveData():void
		{
			
			var saveName:String = CommonSystem.SAVE_NAME.replace("{0}", "中断データ");
			//読み込みインスタンスの生成
			var _textloader:URLLoader = new URLLoader();
			var file:File = File.applicationDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "save/" + saveName + ".srcsav");
			
			if (file.exists)
			{
				//URL
				var _requrl:URLRequest = new URLRequest(CommonSystem.FILE_HEAD + file.nativePath);
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
					
					//Crypt.decrypt(strData);
					
					MainController.$.view.loadContinueComp(strData);
				}
				_textloader.load(_requrl);
			}
			else
			{
				//func(null);
			}
		}
		
		/**コマンドライン引数でのメインシステム読み込み*/
		public static function loadInvokePath(mainPath:String, compFunc:Function):void
		{
			
			var loadfile:File = new File(mainPath);
			
			loadfile.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			function loadProgress(evt:ProgressEvent):void
			{
				trace("Loaded " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes.");
			}
			
			//終了後の処理
			loadfile.addEventListener(Event.COMPLETE, loadComp);
			
			function loadComp(e:Event):void
			{
				
				loadfile.removeEventListener(ProgressEvent.PROGRESS, loadProgress);
				loadfile.removeEventListener(Event.COMPLETE, loadComp);
				
				var fileType:String = e.currentTarget.extension;
				var barrDat:ByteArray = e.target.data;
				//漢字コード変換（shift-jis　－＞　UTF-8）
				
				var strData:String = "";
				
				if (fileType === "srctxt")
				{
					strData = barrDat.readMultiByte(barrDat.length, DATA_CODE_UTF8);
					if (strData.indexOf("スタートファイル") < 0)
					{
						strData = Jcode.from_sjis(barrDat);
					}
					
					var txtData:Object = SystemParse.parseSystenData(strData);
					var path:String = loadfile.parent.nativePath + "\\";
					CommonSystem.SCENARIO_PATH = path;
					MainController.$.view.debugText.addText(path);
					compFunc(txtData);
				}
				else
				{
					strData = barrDat.readMultiByte(barrDat.length, DATA_CODE_UTF8);
					convertJson(strData);
				}
				
				function convertJson(strData:String):void
				{
					//改行の変更
					var obj:Object = JSON.parse(strData);
					var path:String = loadfile.parent.nativePath + "\\";
					/*
					   while(path.indexOf("\\") >= 0) {
					   path = path.replace("\\", "//");
					   }
					 */
					CommonSystem.SCENARIO_PATH = path;
					MainController.$.view.debugText.addText(path);
					compFunc(obj);
				}
			
			}
			
			loadfile.load();
		}
	
	}

}