package system.custom.customSprite
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CSprite extends Sprite
	{
		public var _touchLabel:String = null;
		public var _moveLabel:String = null;
		
		public var _touchFlg:Boolean = false;
		
		/**コンストラクタ*/
		public function CSprite()
		{
			super();
		}
		
		public function clearChildEvent(func:Function = null):void
		{
			while (this.numChildren > 0)
			{
				var obj:DisplayObject = this.getChildAt(0);
				if (obj != null)
				{
					// 関数を持っていたら消去
					if (func != null)
					{
						obj.removeEventListener(TouchEvent.TOUCH, func);
					}
				}
			}
		}
		
		
		/**乗っているものをすべて廃棄*/
		override public function dispose():void
		{
			while (this.numChildren > 0)
			{
				
				var obj:DisplayObject = this.getChildAt(0);
				if (obj != null)
				{

					if (obj.hasOwnProperty("dispose"))
					{
						obj.dispose();
					}
				}
				this.removeChild(obj);
				obj = null;
			}
			super.dispose();
		}
	}
}