package system
{
	import flash.filesystem.File;
	import main.MainViewer;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CommonSystem
	{
		public static var SCENARIO_PATH:String = "";
		public static var FILE_HEAD:String = "";
		
		public static function get MAIN_LOAD_PATH():String
		{
			return FILE_HEAD + SCENARIO_PATH;
		}
		
		public static function getSystemPath(invokePath:String):String
		{
			var file:File = new File(invokePath);
			var path:String = invokePath;
			while (path.length > 0)
			{
				path = file.parent.nativePath;
				file = new File(path);
				var ary:Array = file.getDirectoryListing();
				var findFlg:Boolean = false;
				for (var i:int = 0; i < ary.length; i++)
				{
					if (ary[i].name.indexOf(".srctxt") >= 0 || ary[i].name.indexOf(".srcsys") >= 0)
					{
						findFlg = true;
						break;
					}
				}
				
				if (findFlg)
				{
					break;
				}
			}
			return path;
		}
		
		public static function setScenarioPath(path:String):void
		{	
			MainViewer.SCENARIO_PATH = path;// + "\\img\\map";
			MainViewer.INFO.data.scenarioPath = path;
			MainViewer.INFO.flush();
		}
		
	}

}