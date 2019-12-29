package map.canvas 
{
	import starling.display.Image;
	/**
	 * ...
	 * @author 
	 */
	public class CopyTip 
	{
	
		private var m_img:Image = null;
		private var m_name:String = null;
		private var m_url:String = null;
		
		private var m_posX:int = 0;
		private var m_posY:int = 0;
		
		private var m_auto:Boolean = false;
		
		public function get img():Image 
		{
			return m_img;
		}
		
		public function set img(value:Image):void 
		{
			m_img = new Image(value.texture);
		}
		
		public function get name():String 
		{
			return m_name;
		}
		
		public function set name(value:String):void 
		{
			m_name = value;
		}
		
		public function get url():String 
		{
			return m_url;
		}
		
		public function set url(value:String):void 
		{
			m_url = value;
		}
		
		public function get posX():int 
		{
			return m_posX;
		}
		
		public function set posX(value:int):void 
		{
			m_posX = value;
		}
		
		public function get posY():int 
		{
			return m_posY;
		}
		
		public function set posY(value:int):void 
		{
			m_posY = value;
		}
		
		public function get auto():Boolean 
		{
			return m_auto;
		}
		
		public function set auto(value:Boolean):void 
		{
			m_auto = value;
		}
		
		
		
		
	}

}