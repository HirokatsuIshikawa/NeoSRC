package scene.intermission.customdata
{
	import system.custom.customData.CData;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class AddIntermissionLabelData extends CData
	{
		private var _labelName:String = null;
		private var _labelKey:String = null;
		private var _labelViewFlg:Boolean = false;
		
		private var _posX:int = 0;
		private var _posY:int = 0;
		
		public function AddIntermissionLabelData()
		{
			super();
		}
		
		public function setLabel(name:String, key:String, setX:int, setY:int,flg:Boolean):void
		{
			_labelName = name;
			_labelKey = key;
			_labelViewFlg = flg;
			_posX = setX;
			_posY = setY;
		}
		
		public function get labelName():String
		{
			return _labelName;
		}
		
		public function set labelName(value:String):void
		{
			_labelName = value;
		}
		
		public function get labelKey():String
		{
			return _labelKey;
		}
		
		public function set labelKey(value:String):void
		{
			_labelKey = value;
		}
		
		public function get labelViewFlg():Boolean
		{
			return _labelViewFlg;
		}
		
		public function set labelViewFlg(value:Boolean):void
		{
			_labelViewFlg = value;
		}
	
	}

}