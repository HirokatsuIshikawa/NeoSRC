package database.user.buff
{
	import database.master.MasterBuffData;
	import database.master.base.BuffParam;
	import database.master.base.LearnLevelData;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SkillBuffData extends MasterBuffData
	{
		//レベルリスト
		private var _turn:int = 0;
		private var _skillLv:int = 0;
		
		public function SkillBuffData()
		{
			if (buffParam == null)
			{
				buffParam = new Vector.<BuffParam>();
			}
			super();
		}
		
		public function setObjData(data:Object):void
		{
			_id = data.id;
			_name = data.name;
			_skillLv = data.skillLv;
			_turn = data.turn;
			
			var i:int = 0;
			
			if (buffParam == null)
			{
				buffParam = new Vector.<BuffParam>();
			}
			
			for (i = 0; i < data.buffParam.length; i++)
			{
				var buffData:BuffParam = new BuffParam(data.buffParam[i]._param);
				buffParam.push(buffData);
			}
		
		}
		
		public function setMasterData(baseData:MasterBuffData, setTurn:int, skillLv:int):void
		{
			if (buffParam == null)
			{
				buffParam = new Vector.<BuffParam>();
			}
			//元データからコピー
			_id = baseData.id;
			_name = baseData.name;
			buffParam.push(baseData.buffParam[skillLv]);
			_turn = setTurn;
		}
		
		public function get turn():int
		{
			return _turn;
		}
		
		public function set turn(value:int):void
		{
			_turn = value;
		}
		
		public function get skillLv():int
		{
			return _skillLv;
		}
		
		public function set skillLv(value:int):void
		{
			_skillLv = value;
		}
	}
}