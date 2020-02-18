package database.master
{
	import database.master.base.MessageCondition;
	
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
		
		/**名前*/
		public var messageName:String = null;
		/**台詞タイプ*/
		public var type:int = 0;
		/**メッセージとコンディション*/
		public var message:Vector.<MessageCondition> = null;
		
		public function MasterBattleMessage()
		{
			message = new Vector.<MessageCondition>();
		}
		
		public function setData(messageKey:String, data:Object):void
		{
			messageName = messageKey;
			
			for (var i:int = 0; i < data.length; i++)
			{
				message[i] = data[i].condition;
			}
		
		}
	
	}

}