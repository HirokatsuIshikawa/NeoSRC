package scene.map.panel
{
	import common.CommonDef;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import flash.desktop.NativeApplication;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameOverPanel extends CSprite
	{
		private var _backImg:CImage = null;
		private var _endBtn:CImgButton = null;
		private var _continueBtn:CImgButton = null;
		
		public function GameOverPanel()
		{
			
			_backImg = new CImage(CommonDef.COMMON_TEX.getTexture("tex_black"));
			_backImg.alpha = 0.7;
			_backImg.width = CommonDef.WINDOW_W;
			_backImg.height = CommonDef.WINDOW_H;
			addChild(_backImg);
			
			_continueBtn = new CImgButton(CommonDef.COMMON_TEX.getTexture("btn_Return"));
			_continueBtn.alpha = 1;
			_continueBtn.x = CommonDef.WINDOW_W / 3;
			_continueBtn.y = CommonDef.WINDOW_H * 4 / 5;
			_continueBtn.addEventListener(Event.TRIGGERED, pushContinue);
			addChild(_continueBtn);
			
			_endBtn = new CImgButton(CommonDef.COMMON_TEX.getTexture("btn_Return"));
			_endBtn.alpha = 1;
			_endBtn.x = CommonDef.WINDOW_W * 2 / 3;
			_endBtn.y = CommonDef.WINDOW_H * 4 / 5;
			_endBtn.addEventListener(Event.TRIGGERED, pushEnd);
			addChild(_endBtn);
		
		}
		
		override public function dispose()
		{
			
			_backImg.dispose();
			_backImg = null;
			
			_continueBtn.removeEventListener(Event.TRIGGERED, pushContinue);
			_continueBtn.dispose();
			_continueBtn = null;
			
			_endBtn.removeEventListener(Event.TRIGGERED, pushEnd);
			_endBtn.dispose();
			_endBtn = null;
			
			super.dispose();
		
		}
		
		public function pushContinue(e:Event)
		{
		
		}
		
		public function pushEnd(e:Event)
		{
			var app:NativeApplication = NativeApplication.nativeApplication;
			// AIR アプリケーションを終了する
			app.exit(0);
		}
	
	}

}