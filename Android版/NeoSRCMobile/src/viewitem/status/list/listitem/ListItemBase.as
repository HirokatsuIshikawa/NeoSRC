package viewitem.status.list.listitem 
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import flash.geom.Rectangle;
	import starling.textures.TextureSmoothing;
	import main.MainController;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ListItemBase extends CSprite
	{
		protected var _listImg:CImage = null;
		public function ListItemBase(width:int, height:int)
		{
			super();
			
			_listImg = new CImage(MainController.$.imgAsset.getTexture("listitem"));
			_listImg.scale9Grid = new Rectangle(6, 6, 20, 20);
			_listImg.width = width;
			_listImg.height = height;
			_listImg.textureSmoothing = TextureSmoothing.NONE;
			addChild(_listImg);
			
		}
		
		
		override public function dispose():void
		{
			_listImg.dispose();
			super.dispose();
		}
	}
}