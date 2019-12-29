package system.file
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import system.CommonSystem;
	
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
			loadfile.addEventListener(Event.SELECT, function(evSel:Event):void
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
					//改行の変更
					var obj:Object = JSON.parse(strData);
					var path:String = loadfile.parent.nativePath + "/";
					/*
					   while(path.indexOf("\\") >= 0) {
					   path = path.replace("\\", "//");
					   }
					 */
					CommonSystem.SCENARIO_PATH = path;
					compFunc(obj);
				}
				fr.load(); //ロード開始
			});
			//fr.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			//必要なら...
			//fr.addEventListener(ProgressEvent.PROGRESS, onFileReference_Progress);
			//fr.addEventListener(Event.CANCEL, onFileReference_Cancel);
			//fr.addEventListener(IOErrorEvent.IO_ERROR, onFileReference_IOError);
			//fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileReference_SecurityError);
			
			//フィルタ拡張子を指定
			var ff:FileFilter = new FileFilter(name, "*" + file);
			//ファイル選択ダイアログ起動
			loadfile.browseForOpen("open", [ff]);
		}
		
		/**スマホ用、ファイル読み込み*/
		public static function loadPhoneList(file:String):Object
		{
			var dir:File = File.userDirectory;
			var homefile:File = dir.resolvePath("NeoSRC/Scenario");
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
						if (r_data.name.indexOf(file) >= 0)
						{
							getpath.push(r_data.nativePath);
							getname.push(r_data.name);
							count++;
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
				var obj:Object = JSON.parse(strData);
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
	
	}

}