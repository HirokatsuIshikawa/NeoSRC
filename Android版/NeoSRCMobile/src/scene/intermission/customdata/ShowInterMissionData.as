package scene.intermission.customdata 
{
	import system.custom.customData.CData;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ShowInterMissionData extends CData
	{
		public static const SHOW:int = 1;
		public static const HIDE:int = 0;
		
		public var name:String = "";
		public var show:int = 1;
		
		
		public function ShowInterMissionData() 
		{
			super();
		}
		
		public function setState(setName:String, num:int):void
		{
			name = setName;
			show = num;
		}
		
		
	}

}