package viewitem.base
{
	import a24.tween.Tween24;
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import starling.textures.TextureSmoothing;
	import main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class GaugeBase extends CSprite
	{
		/**バック画像*/
		protected var _backImg:CImage = null;
		/**ゲージ画像*/
		protected var _gaugeImg:CImage = null;
		/**最大値*/
		protected var _maxPoint:int = 0;
		/**現在地*/
		protected var _nowPoint:int = 0;
		
		
		public function GaugeBase(setWidth:int, setHeight:int, maxPoint:int)
		{
			super();
			if (maxPoint > 0)
			{
				_maxPoint = maxPoint;
			}
			else
			{
				_maxPoint = 100;
			}
			_nowPoint = 0;
			_backImg = new CImage(MainController.$.imgAsset.getTexture("tex_white"));
			_backImg.textureSmoothing = TextureSmoothing.NONE;
			_backImg.width = setWidth;
			_backImg.height = setHeight;
			_gaugeImg = new CImage(MainController.$.imgAsset.getTexture("tex_blue"));
			_gaugeImg.textureSmoothing = TextureSmoothing.NONE;
			_gaugeImg.width = 0;
			_gaugeImg.height = setHeight;
			
			addChild(_backImg);
			addChild(_gaugeImg);
		
		}
		
		
		override public function dispose():void
		{
			CommonDef.disposeList([_backImg, _gaugeImg]);
			super.dispose();
		}
		
		public function get nowPoint():int
		{
			_gaugeImg.width = _backImg.width * _nowPoint / _maxPoint;
			return _nowPoint;
		}
		
		public function set nowPoint(value:int):void
		{
			_nowPoint = value;
		}

	}

}