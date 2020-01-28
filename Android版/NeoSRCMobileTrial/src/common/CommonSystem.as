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
			var file:File = dir.resolvePath("NeoSRC//BGM");
			
			COMMON_BGM_PATH = file.nativePath;
			
			file = dir.resolvePath("NeoSRC//SE");
			COMMON_SE_PATH = file.nativePath;
		
			//file = dir.resolvePath("NeoSRC//IMG");
			//COMMON_IMG_PATH = file.nativePath;
		
			//file = dir.resolvePath("NeoSRC//PEX");
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
	
	}
}