package database.user.buff 
{
	import database.master.MasterBuffData;
	/**
	 * ...
	 * @author ...
	 */
	//ユニットバフデータ
	public class UnitBuffData extends MasterBuffData
	{
		//ターン
		public var _turn:int = 0;
		
		public function UnitBuffData(baseData:MasterBuffData)
		{
			super();
			//元データからコピー
			_id = baseData.id;
			_name = baseData.name;
			buffParam = baseData.buffParam;
		}
	}

}