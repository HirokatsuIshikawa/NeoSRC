package scene.intermission.save
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import scene.intermission.save.item.DataListItem;
	import main.MainController;
	
	/**
	 * データリスト選択
	 * @author ishikawa
	 */
	public class DataList extends CSprite
	{
		/**暗幕画像*/
		private var _backImg:CImage = null;
		protected var _baseSpr:CSprite = null;
		protected var _listSpr:CSprite = null;
		
		public var SHOW_AREA:int = DataListItem.LIST_HEIGHT * 3;
		public var MAX_LIST_AREA:int = DataListItem.LIST_HEIGHT * 4;
		
		public function DataList()
		{
			super();
			
			//暗幕設定
			_backImg = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
			_backImg.alpha = 0.8;
			_backImg.width = CommonDef.WINDOW_W;
			_backImg.height = CommonDef.WINDOW_H;
			addChild(_backImg);
			
			_baseSpr = new CSprite();
			//_baseSpr.mask = CommonDef.maskRect(new Rectangle(240, 20, 480, CommonDef.WINDOW_H - 40));
			_baseSpr.mask = new Quad(DataListItem.LIST_WIDTH, SHOW_AREA);
			_baseSpr.mask.x = 240;
			_baseSpr.mask.y = 20;
			addChild(_baseSpr);
			
			_listSpr = new CSprite();
			_listSpr.x = 240;
			_listSpr.y = 20;
			_baseSpr.addChild(_listSpr);
			_listSpr.addEventListener(TouchEvent.TOUCH, moveArea);
		
		}
		
		override public function dispose():void
		{
			_listSpr.removeEventListener(TouchEvent.TOUCH, moveArea);
			_backImg.dispose();
			_baseSpr.dispose();
			_listSpr.dispose();
			super.dispose();
		}
		
		/** ドラッグ&ドロップハンドラー */
		protected function moveArea(eventObject:TouchEvent):void
		{
			var target:DisplayObject = eventObject.currentTarget as DisplayObject;
			
			var myTouch:Touch = eventObject.getTouch(target, TouchPhase.MOVED);
			
			if (myTouch)
			{
				var nMoveY:Number = myTouch.globalY - myTouch.previousGlobalY;
				
				target.y += nMoveY;
				
				// 縦位置修正
				if (target.y > 20)
				{
					target.y = 20;
				}
				else if (target.y < -(MAX_LIST_AREA - SHOW_AREA - 20))
				{
					target.y = -(MAX_LIST_AREA - SHOW_AREA - 20);
				}
				
			}
		}
	
	}

}