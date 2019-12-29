package map.pallet
{
	import feathers.controls.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author
	 */
	public class PalletTip extends Image
	{
		/**ファイル名*/
		private var m_name:String = null;
		/**所属ファイル名*/
		private var m_url:String = null;
		
		/**
		 * @param	tex テクスチャ
		 * @param	name チップ名
		 * @param	base チップ所属画像名
		 */
		public function PalletTip(tex:Texture, name:String, url:String)
		{
			super(tex);
			m_name = name;
			m_url = url;
			//this.addEventListener(TouchEvent.TOUCH, clickHandler);
		}
		
		
		public function get url():String 
		{
			return m_url;
		}
		
		public function get tipName():String 
		{
			return m_name;
		}
	}
}