package parts.popwindow 
{
	import feathers.controls.Button;
	import feathers.controls.NumericStepper;
	import flash.display.BitmapData;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import view.MainController;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class TileConfig extends Sprite
	{
		/**背景*/
		private var m_backImg:Image = null;
		/**時間*/
		private var m_timeStep:NumericStepper = null;
		/**横移動*/
		private var m_xStep:NumericStepper = null;
		/**縦移動*/
		private var m_yStep:NumericStepper = null;
		/**開始ボタン*/
		private var m_btnStart:Button = null;
		
		public function TileConfig() 
		{
			m_backImg = new Image(Texture.fromBitmapData(new BitmapData(128, 128, true, 0x99FF3333)));
			addChild(m_backImg);

			m_timeStep = new NumericStepper();
			m_xStep = new NumericStepper();
			m_yStep = new NumericStepper();
			//時間
			m_timeStep.x = 16;
			m_timeStep.y = 16;
			m_timeStep.value = 1;
			m_timeStep.maximum = 100;
			m_timeStep.minimum = 0;
			m_timeStep.step = 0.1;
			addChild(m_timeStep);
			//横
			m_xStep.x = 16;
			m_xStep.y = 48;
			m_xStep.maximum = 32;
			m_xStep.minimum = -32;
			m_xStep.step = 1;
			addChild(m_xStep);
			//縦
			m_yStep.x = 16;
			m_yStep.y = 80;
			m_yStep.maximum = 32;
			m_yStep.minimum = -32;
			m_yStep.step = 1;
			addChild(m_yStep);
			
			m_btnStart = new Button();
			m_btnStart.x = 76;
			m_btnStart.y = 92;
			m_btnStart.label = "開始";
			m_btnStart.addEventListener(Event.TRIGGERED, function():void {
				MainController.$.view.canvas.moveTile();
			});
			addChild(m_btnStart);
		}
		
		public function get time():Number {
			return m_timeStep.value;
		}
		public function get xNum():int {
			return m_xStep.value;
		}
		public function get yNum():int {
			return m_yStep.value;
		}
		
		
		
	}

}