package scene.map.battle 
{
	import system.custom.customSprite.CSprite;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class AttackPredictList extends CSprite
	{
		
		private var _predictList:Vector.<AttackPredictItem> = null;
		
		public function AttackPredictList(list:Vector.<AttackListItem>) 
		{
			
			_predictList = new Vector.<AttackPredictItem>;
			
			for (var i:int = 0; i < list.length; i++ )
			{
				var predict:AttackPredictItem = new AttackPredictItem();
				predict.setState(list[i]);
				predict.alpha = 1;
				predict.visible = true;
				predict.y = i * predict.height;
				addChild(predict);
			}
		}
	}
}