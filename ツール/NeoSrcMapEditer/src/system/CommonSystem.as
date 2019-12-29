package system 
{
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
		
	}

}