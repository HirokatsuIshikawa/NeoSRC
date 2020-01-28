package scene.map.basepoint 
{
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class BasePoint extends CSprite
	{
		/**枠画像*/
		protected var _frameImg:CImage = null;
		/**占領軍番号*/
		protected var _sideNum:int = 0;
		/**占領軍名*/
		protected var _sideName:String = null;
		
		/**拠点名*/
		protected var _pointName:String = null;
		/**占領ポイント*/
		protected var _occupationPoint:int;
		
		public function BasePoint() 
		{
			super();
		}
		
	}

}