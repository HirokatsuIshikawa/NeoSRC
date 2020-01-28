package scene.map.tip
{
    import common.CommonDef;
	import scene.main.MainController;
    import system.custom.customSprite.CImage;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author
	 */
	public class MapTip extends CImage
	{
		/**ファイル名*/
		private var _tipName:String = null;
		/**所属ファイル名*/
		private var _url:String = null;
		/**タッチ時関数*/
		private var _func:Function = null;
		/**オートタイル*/
		private var _auto:Boolean = false;
		
		/**
		 * @param	tex テクスチャ
		 * @param	name チップ名
		 * @param	base チップ所属画像名
		 */
		public function MapTip(tex:Texture, tipname:String, url:String)
		{
			super(tex);
			//チップ名
			_tipName = tipname;
			//URL名
			_url = url;
			
			_auto = false;
		}
		
		public function touchFunc(func:Function):void
		{
			_func = func;
		}
		
		public function get tipName():String {
			return _tipName;
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function get auto():Boolean
		{
			return _auto;
		}
		
		//描画
		public function draw(url:String, tipName:String, auto:Boolean):void
		{
            if (url === CommonDef.BLANK_TIP_TEXT)
            {
                this.visible = false;
            }
            else
            {
                this.visible = true;
                this.texture = MainController.$.mapTipAsset.getTexture(tipName);
            }
			_auto = auto;
			_tipName = tipName;
			_url = url;
		}
	}
}