package scene.intermission.save
{
	import system.custom.customSprite.CSprite;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class SelectConfirmPopup extends CSprite
	{
		/**OK時のコールバック*/
		private var _okConfirmCallBack:Function = null;
		
		/**コンストラクタ*/
		public function SelectConfirmPopup(msg:String, btnMsg:String = "OK")
		{
			super(msg, btnMsg);
		
		}
		
		/**ボタン押下処理*/
		public function pushBtn(event:Event):void
		{
			this.parent.removeChild(this);
			dispose();
		}
		
		/**廃棄*/
		override public function dispose():void
		{
			_okConfirmCallBack = null;
			super.dispose();
		}
	
	}

}