package scene.talk
{
	import common.CommonDef;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class EveParam
	{
		/** データ化 */
		public static function getParam(data:Array):Object
		{
			var i:int = 0;
			var param:Object = new Object();
			
			for (i = 1; i < data.length; i++)
			{
				var ary:Array = data[i].split(":");
				if (ary.length <= 1)
				{
					continue;
				}
				param[ary[0].toLowerCase()] = ary[1];
				
			}
			
			return param;
		}
	
	}

}