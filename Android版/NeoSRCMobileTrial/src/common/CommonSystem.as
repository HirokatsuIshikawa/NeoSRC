package common
{
	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	import scene.main.MainController;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CommonSystem
	{
		private static var INFO:SharedObject = null;
		/**資金名*/
		public static var MONEY_NAME:String = "資金";
		/**シナリオフォルダパス*/
		public static var SCENARIO_PATH:String = "";
		
		/**端末用ヘッドパス*/
		public static var FILE_HEAD:String = "";
		
		/**会話タイプ*/
		public static var TALK_TYPE:String = "icon";
		
		/**セーブデータ名*/
		public static var SAVE_NAME:String = "";
		
		/**セーブデータ数*/
		public static var SAVE_NUM:int = 3;
		
		/**ニューゲームEve*/
		public static var START_EVE:String = "";
		
		public static var COMMON_BGM_PATH:String = "";
		public static var COMMON_SE_PATH:String = "";
		//public static var COMMON_IMG_PATH:String = "";
		//public static var COMMON_PEX_PATH:String = "";
		
		public static var INTERMISSION_DATA:Object = "";
		public static var STRENGTH_MONEY:Array = [10000, 20000, 30000, 40000, 50000];
		
		/***/
		
		public static function initInfo():void
		{
			INFO = SharedObject.getLocal("NeoSrcInfo");
			COMMON_BGM_PATH = INFO.data.CommonBgmPath;
			COMMON_SE_PATH = INFO.data.CommonSePath;
			//COMMON_IMG_PATH = INFO.data.CommonImgPath;
			//COMMON_PEX_PATH = INFO.data.CommonPexPath;
			var i:int = 0;
		}
		
		public static function initPhoneInfo():void
		{
			
			var dir:File = File.userDirectory;
			var file:File = dir.resolvePath("シミュラマPになろう//BGM");
			
			COMMON_BGM_PATH = file.nativePath;
			
			file = dir.resolvePath("シミュラマPになろう//SE");
			COMMON_SE_PATH = file.nativePath;
		
			//file = dir.resolvePath("シミュラマPになろう//IMG");
			//COMMON_IMG_PATH = file.nativePath;
		
			//file = dir.resolvePath("シミュラマPになろう//PEX");
			//COMMON_PEX_PATH = file.nativePath;
		
		}
		
		public static function setCommonBgmPath(path:String):void
		{
			INFO.data.CommonBgmPath = path;
			INFO.flush();
			COMMON_BGM_PATH = path;
		}
		
		public static function setCommonSePath(path:String):void
		{
			INFO.data.CommonSePath = path;
			INFO.flush();
			COMMON_SE_PATH = path;
		}
		
		/*
		   public static function setCommonImgPath(path:String):void
		   {
		   INFO.data.CommonImgPath = path;
		   INFO.flush();
		   COMMON_IMG_PATH = path;
		   }
		
		   public static function setCommonPexPath(path:String):void
		   {
		   INFO.data.CommonPexPath = path;
		   INFO.flush();
		   COMMON_PEX_PATH = path;
		   }
		 */
		/**ロードパス*/
		public static function get MAIN_LOAD_PATH():String
		{
			return FILE_HEAD + SCENARIO_PATH;
		}
		
		/**アプリケーション終了*/
		public static function finishAPK(e:Event = null):void
		{
			var app:NativeApplication = NativeApplication.nativeApplication;
			// AIR アプリケーションを終了する
			app.exit(0);
		}
		
		public static function setStrengthMoney(str:String):void
		{
			var i:int = 0;
			STRENGTH_MONEY = str.split(",");
			
			for (i = 0; i < STRENGTH_MONEY.length; i++)
			{
				STRENGTH_MONEY[i] = (int)(STRENGTH_MONEY[i]);
			}
		
		}
		
		/**URL確認*/
		public static function checkUrl(tileName:String, urlList:Vector.<String>):String
		{
			var i:int = 0;
			var flg:String = "";
			for (i = 0; i < urlList.length; i++)
			{
				var urlTexNameList:Vector.<String> = MainController.$.mapTipAsset.getTextureAtlas(urlList[i]).getNames();
				if (urlTexNameList.indexOf(tileName) >= 0)
				{
					flg = urlList[i];
					break;
				}
			}
			return flg;
		}
		
		
		//ファイル検索（モバイルの場合はヘッダをつける）
		public static function searchFile(url:String, fileName:String):String
		{
			var getUrl:String = null;
			var dirfile:File = new File(url);
			var getList:Array = dirfile.getDirectoryListing();
			var i:int = 0;
			//ファイルを検索
			for each (var file:File in getList)
			{
				if (!file.isDirectory)
				{
					var numAll:int = file.nativePath.length - fileName.length;
					var index:int = file.nativePath.lastIndexOf(fileName);
					
					if (file.nativePath.lastIndexOf(fileName + ".") == numAll - 4)
					{
						return file.nativePath;
					}
					else if (file.nativePath.lastIndexOf(fileName) == numAll)
					{
						return file.nativePath;
					}
				}
			}
			//ディレクトリ内検索
			for each (var dir:File in getList)
			{
				if (dir.isDirectory)
				{
					var findUrl:String = searchFile(dir.nativePath, fileName);
					if (findUrl != null)
					{
						return findUrl;
					}
				}
			}
			
			return null;
		}
	}
}