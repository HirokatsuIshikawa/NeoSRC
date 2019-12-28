package common 
{
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CommonLanguage 
	{
		
		public static var LANGUAGE_JP:int = 1;
		
		// ステータス表示用
		public static var StatusName:Array = null;
		private static const STATUS_JP:Array = ["HP", "FP", "TP","攻撃", "防御", "技術", "敏捷", "精神", "潜在", "移動"];
		public static const WORD_JP:Array = ["経験値", "資金", "レベルアップ！"];
				
		/** 言語設定 */
		public static function setLanguage(type:int):void
		{
			switch(type)
			{
				case LANGUAGE_JP:
					StatusName = STATUS_JP;
					break;
			}
		}
		
		public static function getWord(txt:String):String
		{
			var i:int = 0;
			var str:String = null;
			for (i = 0; i < WORD_JP.length; i++)
			{
				if (WORD_JP[i] === txt)
				{
					if (WORD_JP[i] === "資金")
					{
						str = CommonSystem.MONEY_NAME;
					}
					else
					{
						str = WORD_JP[i];
					}
					break;
				}
			}
			return str;
		}
	}
}