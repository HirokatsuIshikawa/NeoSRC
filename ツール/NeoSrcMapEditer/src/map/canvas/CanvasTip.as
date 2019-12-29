package map.canvas
{
	import starling.display.Image;
	import starling.textures.Texture;
	import system.UserImage;
	
	/**
	 * ...
	 * @author
	 */
	public class CanvasTip extends Image
	{
		/**ファイル名*/
		private var m_tipName:String = null;
		/**所属ファイル名*/
		private var m_url:String = null;
		/**タッチ時関数*/
		private var m_func:Function = null;
		/**オートタイル*/
		private var m_auto:Boolean = false;
		
		/**
		 * @param	tex テクスチャ
		 * @param	name チップ名
		 * @param	base チップ所属画像名
		 */
		public function CanvasTip(tex:Texture, tipname:String, url:String)
		{
			super(tex);
			//チップ名
			m_tipName = tipname;
			//URL名
			m_url = url;
			
			m_auto = false;
            touchable = false;
		}
		
		public function touchFunc(func:Function):void
		{
			m_func = func;
		}
		
		public function get tipName():String {
			return m_tipName;
		}
		
		public function get url():String 
		{
			return m_url;
		}
		
		public function get auto():Boolean
		{
			return m_auto;
		}
		
		//描画
		public function draw(url:String, tipName:String, auto:Boolean):void
		{
            if (url === "blank")
            {
                this.visible = false;
            }
            else
            {
                this.visible = true;
                this.texture = UserImage.$.getTipTex(tipName);// TextureManager.loadMapTexture(url, tipName);
            }
			m_auto = auto;
			m_tipName = tipName;
			m_url = url;
		}
	}
}