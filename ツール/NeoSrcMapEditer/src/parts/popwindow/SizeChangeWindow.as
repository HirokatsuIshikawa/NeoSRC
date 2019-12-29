package parts.popwindow
{
	import feathers.controls.Button;
	import feathers.controls.NumericStepper;
	import feathers.controls.TextArea;
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import system.CommonSystem;
	import system.file.DataLoad;
	import view.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class SizeChangeWindow extends Sprite
	{
		private var _okBtn:Button = null;
		private var _cancelBtn:Button = null;
		
		/**背景*/
		private var _backImg:Image = null;
		/**縦サイズ*/
		private var _widthLabel:TextArea = null;
		private var _widthStep:NumericStepper = null;
		/**横サイズ*/
		private var _heightLabel:TextArea = null;
		private var _heightStep:NumericStepper = null;
		
		public function SizeChangeWindow()
		{
			super();
			_backImg = new Image(Texture.fromBitmapData(new BitmapData(240, 160, true, 0x99FF3333)));
			addChild(_backImg);
			
			//横ラベル
			_widthLabel = new TextArea();
			_widthLabel.text = "横";
			_widthLabel.x = 16;
			_widthLabel.y = 48;
			addChild(_widthLabel);
			//横
			_widthStep = new NumericStepper();
			_widthStep.x = 48;
			_widthStep.y = 48;
			_widthStep.maximum = 60;
			_widthStep.minimum = 15;
			_widthStep.value = MainController.$.view.canvas.mapWidth;
			_widthStep.step = 1;
			addChild(_widthStep);
			//縦ラベル
			_heightLabel = new TextArea();
			_heightLabel.text = "縦";
			_heightLabel.x = 128;
			_heightLabel.y = 48;
			addChild(_heightLabel);
			
			//縦
			_heightStep = new NumericStepper();
			_heightStep.x = 160;
			_heightStep.y = 48;
			_heightStep.maximum = 60;
			_heightStep.minimum = 15;
			_heightStep.value = MainController.$.view.canvas.mapHeight;
			_heightStep.step = 1;
			addChild(_heightStep);
			
			//読み込みボタン
			_okBtn = new Button();
			_okBtn.x = 4;
			_okBtn.y = 92;
			_okBtn.width = 64;
			_okBtn.height = 24;
			
			_okBtn.label = "OK";
			_okBtn.addEventListener(Event.TRIGGERED, function():void
			{
				MainController.$.view.endSizeWindow(true, _widthStep.value, _heightStep.value);
				/*
				MainController.$.view.mapLoader.mapName = _textInput.text;
				MainController.$.view.canvas.setTipArea(_widthStep.value, _heightStep.value);
				MainController.$.view.endStartWindow();
				*/
			});
			addChild(_okBtn);
			//新規作成ボタン
			_cancelBtn = new Button();
			_cancelBtn.x = 72;
			_cancelBtn.y = 92;
			_cancelBtn.width = 64;
			_cancelBtn.height = 24;
			_cancelBtn.label = "キャンセル";
			_cancelBtn.addEventListener(Event.TRIGGERED, function():void
			{
				MainController.$.view.endSizeWindow(false);
			});
			addChild(_cancelBtn);
		}
	}

}