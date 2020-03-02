package parts.header
{
	import feathers.controls.Button;
	import feathers.controls.TextArea;
	import feathers.controls.ToggleButton;
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import system.CommonDef;
	import system.Crypt;
	import system.UserImage;
	import main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class Header extends Sprite
	{
		/**背景*/
		private var _backImg:Image = null;
		/**セーブボタン*/
		private var _saveBtn:Button = null;
		/**ロードボタン*/
		private var _loadBtn:Button = null;
		/**画像出力ボタン*/
		private var _cryptBtn:Button = null;
		/**背景選択ボタン*/
		private var _BackImgBtn:Button = null;
		/**背景選択ボタン*/
		private var _MapSizeBtn:Button = null;
		
		/**パレット呼び出しボタン*/
		private var _palletBtn:Button = null;
		/**出撃出力呼び出しボタン*/
		private var _launchBtn:Button = null;
		
		
		private var _posTextX:TextArea = null;
		private var _posTextY:TextArea = null;
		
		/**セレクター呼び出しボタン*/
		//private var _selecterBtn:Button = null;
		
		public function Header()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**セット*/
		private function onStage(e:starling.events.Event):void
		{
			var i:int = 0;
			_backImg = new Image(Texture.fromBitmapData(new BitmapData(CommonDef.WINDOW_W, 32, true, 0xAA444444)));
			addChild(_backImg);
			
			//保存ボタン
			_saveBtn = new Button();
			_saveBtn.x = 64;
			_saveBtn.y = 4;
			_saveBtn.label = "記録";
			_saveBtn.addEventListener(Event.TRIGGERED, function():void
			{
				MainController.$.view.mapLoader.saveMapData();
			});
			addChild(_saveBtn);
			
			//読み込みボタン
			_loadBtn = new Button();
			_loadBtn.x = 96;
			_loadBtn.y = 4;
			_loadBtn.label = "読込";
			_loadBtn.addEventListener(Event.TRIGGERED, function():void
			{
				MainController.$.view.mapLoader.loadMapData();
			});
			addChild(_loadBtn);
			
			//画像出力
			_cryptBtn = new Button();
			_cryptBtn.x = 136;
			_cryptBtn.y = 4;
			_cryptBtn.width = 48;
			_cryptBtn.label = "通常";
			
			_cryptBtn.addEventListener(Event.TRIGGERED, function():void
			{
				if (Crypt.flg)
				{	
					_cryptBtn.label = "通常";
					Crypt.flg = false;
				}
				else
				{
					_cryptBtn.label = "暗号化";
					Crypt.flg = true;
				}
				
			});
			addChild(_cryptBtn);
			
			// マップサイズ
			_MapSizeBtn = new Button();
			_MapSizeBtn.x = 200;
			_MapSizeBtn.y = 4;
			_MapSizeBtn.width = 48;
			_MapSizeBtn.label = "サイズ";
			_MapSizeBtn.addEventListener(Event.TRIGGERED, function():void
			{
				
				MainController.$.view.startSizeWindow();
			
			});
			addChild(_MapSizeBtn);
			
			_palletBtn = new Button()
			_palletBtn.x = 332;
			_palletBtn.y = 4;
			_palletBtn.width = 64;
			_palletBtn.label = "パレット";
			_palletBtn.addEventListener(Event.TRIGGERED, function():void
			{
				MainController.$.view.showPallet();
			});
			addChild(_palletBtn);
			
			_launchBtn = new Button()
			_launchBtn.x = 420;
			_launchBtn.y = 4;
			_launchBtn.width = 64;
			_launchBtn.label = "配置位置";
			_launchBtn.addEventListener(Event.TRIGGERED, function():void
			{
				MainController.$.view.showLaunchWindow();
			});
			
			addChild(_launchBtn);
			
			_posTextX = new TextArea();
			_posTextX.x = 500;
			_posTextX.y = 4;
			_posTextX.width = 64;
			_posTextX.height = 28;
			_posTextX.text = "x:" + 0;
			addChild(_posTextX);
			
			_posTextY = new TextArea();
			_posTextY.x = 580;
			_posTextY.y = 4;
			_posTextY.width = 64;
			_posTextY.height = 28;
			_posTextY.text = "y:" + 0;
			addChild(_posTextY);
		
		}
		
		public function setPosText(x:int, y:int):void
		{
			_posTextX.text = "x:" + (Math.floor(x/32) + 1);
			_posTextY.text = "y:" + (Math.floor(y/32) + 1);
		}
		
		
	}

}