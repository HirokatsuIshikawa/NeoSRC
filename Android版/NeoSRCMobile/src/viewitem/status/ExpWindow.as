package viewitem.status 
{
	import a24.tween.Tween24;
	import common.CommonDef;
	import common.CommonLanguage;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CTextArea;
	import flash.text.TextFormatAlign;
	import viewitem.base.WindowItemBase;
	import scene.main.MainController;
	import viewitem.parts.gauge.ExpGauge;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ExpWindow extends WindowItemBase
	{
		private var _gauge:ExpGauge = null;
		private var _nameText:CTextArea = null;
		private var _expText:CTextArea = null;
		private var _moneyText:CTextArea = null;
		//private var _lvUpText:CTextArea = null;
		private var _lvUpImg:CImage = null;
		private var _tween:Tween24 = null;
		
		public function ExpWindow() 
		{
			super(320, 120);
			
			_nameText = new CTextArea(18, 0x0, 0x0, TextFormatAlign.CENTER);
			_nameText.styleName = "custom_text";
			_nameText.width = 320;
			_nameText.height = 40;
			_nameText.y = 20;
			addChild(_nameText);
			
			_expText = new CTextArea(18, 0x0, 0x0, TextFormatAlign.CENTER);
			_expText.styleName = "custom_text";
			_expText.width = 160;
			_expText.height = 40;
			_expText.y = 48;
			addChild(_expText);
			
			_moneyText = new CTextArea(18, 0x0, 0x0, TextFormatAlign.CENTER);
			_moneyText.styleName = "custom_text";
			_moneyText.width = 160;
			_moneyText.height = 40;
			_moneyText.x = 160;
			_moneyText.y = 48;
			addChild(_moneyText);
			
			/*
			_lvUpText = new CTextArea(32, 0xFF4444, 0x0, TextFormatAlign.CENTER);
			_lvUpText.text = CommonLanguage.getWord("レベルアップ！");
			_lvUpText.styleName = "custom_text";
			_lvUpText.width = 320;
			_lvUpText.height = 42;
			_lvUpText.y = 40;
			_lvUpText.visible = false;
			addChild(_lvUpText);
			*/
			
			_gauge = new ExpGauge(300, 16, 100);
			_gauge.x = 10;
			_gauge.y = 80;
			_gauge.maxCallBack = gaugeMax;
			addChild(_gauge);
			
			_lvUpImg = new CImage(MainController.$.imgAsset.getTexture("Sys_LevelUp"));
			_lvUpImg.x = (this.width - _lvUpImg.width) / 2;
			_lvUpImg.y = (this.height - _lvUpImg.height) / 2;
			_lvUpImg.visible = false;
			addChild(_lvUpImg);
			
		}
		
		public function gaugeMax():void
		{
			_lvUpImg.visible = true;
			
			_tween = Tween24.serial(
				Tween24.prop(_lvUpImg).y(40),
				Tween24.tween(_lvUpImg, 0.3,Tween24.ease.CircOut).y(-40),
				Tween24.tween(_lvUpImg, 0.3,Tween24.ease.CircIn).y(40)
			); 
			
			_tween.play();
		}
		
		
		public function setText(name:String, exp:int, money:int):void
		{
			_nameText.text = name;
			_expText.text = CommonLanguage.getWord("経験値") + "：" + exp;
			_moneyText.text = CommonLanguage.getWord("資金") + "：" +  money;
		}
		
		
		public function addPoint(num:int,callBack:Function = null):void
		{
			_gauge.addPoint(num, callBack);
		}
		
		public function setNowPoint(num:int):void
		{
			_gauge.nowPoint = num;
		}
		
		override public function dispose():void
		{
			if (_tween != null)
			{
				_tween.stop();
				_tween = null;
			}
			_nameText.dispose();
			_expText.dispose();
			_moneyText.dispose();
			_lvUpImg.dispose();
			_gauge.dispose();
			super.dispose();
		}
		
		public function getLvUp():int
		{
			return _gauge.getLvUp;
		}
		
		public function getExp():int
		{
			return _gauge.lvUpMod;
		}
		
		
		
	}

}