package viewitem.base 
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import flash.geom.Rectangle;
	import starling.textures.TextureSmoothing;
	import scene.main.MainController;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class WindowItemBase extends CSprite
	{
		protected var _windowImg:CImage = null;
		public function WindowItemBase(width:int, height:int)
		{
			super();
			
			_windowImg = new CImage(MainController.$.imgAsset.getTexture("windowitem"));
			_windowImg.scale9Grid = new Rectangle(6, 6, 20, 20);
			_windowImg.width = width;
			_windowImg.height = height;
			_windowImg.textureSmoothing = TextureSmoothing.NONE;
			addChild(_windowImg);
			
		}
		
		
		override public function dispose():void
		{
			_windowImg.dispose();
			super.dispose();
		}
	}
}