package system.custom.customSprite 
{
	import feathers.controls.Button;
	/**
	 * ...
	 * @author ...
	 */
	public class CButton extends Button
	{
		private var _fontSize:int = 0;
		
		private var _key:String = null;
		private var _value:String = null;
		
		public function CButton(size:int = 24) 
		{
			super();
			styleName = "bigBtn";
			_fontSize = size;
		}
		
		public function get fontSize():int 
		{
			return _fontSize;
		}
		
		public function get key():String 
		{
			return _key;
		}
		
		public function set key(value:String):void 
		{
			_key = value;
		}
		
		public function get value():String 
		{
			return _value;
		}
		
		public function set value(value:String):void 
		{
			_value = value;
		}
		
	}

}