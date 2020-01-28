package database.master
{
	import database.master.base.StateCondition;
	
	/**
	 * ...
	 * @author ...
	 */
	public class MasterBattleMessage
	{
		/***/
		public static const STATE_NONE:int = 0;
		/**攻撃*/
		public static const STATE_ATK:int = 1;
		/**ダメージ*/
		public static const STATE_DMG:int = 2;
		/**回避*/
		public static const STATE_AVO:int = 3;
		/**防御*/
		public static const STATE_DEF:int = 4;
		
		
		
		/**メッセージ本体*/
		public var message:String = null;
		/**名前*/
		public var name:String = null;
		/**台詞タイプ*/
		public var type:int = 0;
		public var condition:StateCondition = null;
		
		public function MasterBattleMessage(data:Object)
		{
			
		}
	
	}

}