package database.user.buff
{
	import database.master.MasterBuffData;
	import database.master.base.LearnLevelData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CharaBuffData extends MasterBuffData
	{
		//レベルリスト
		public var _levelList:Vector.<LearnLevelData> = null;
		
		public function CharaBuffData(baseData:MasterBuffData, levelList:Vector.<LearnLevelData>)
		{
			super();
			//元データからコピー
			_id = baseData.id;
			_name = baseData.name;
			buffParam = baseData.buffParam;
			//レベルリスト
			_levelList = levelList;
		}
		
	}
}