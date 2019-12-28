package scene.intermission.customdata
{
	import system.custom.customData.CData;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class AddIntermissionBtnData extends CData
	{
		private var _btnName:String = null;
		private var _btnTexName:String = null;
		private var _btnEventFile:String = null;
		private var _btnEventLabel:String = null;
		
		private var _posX:int = 0;
		private var _posY:int = 0;
		
		public function AddIntermissionBtnData()
		{
		
		}
		
		public function setBtnEvent(name:String, texName:String, file:String, label:String, setX:int = 0, setY:int = 0):void
		{
			_btnName = name;
			_btnTexName = texName;
			_btnEventFile = file;
			_btnEventLabel = label;
			_posX = setX;
			_posY = setY;
		}
		
		public function get btnTexName():String
		{
			return _btnTexName;
		}
		
		public function get btnEventFile():String
		{
			return _btnEventFile;
		}
		
		public function get btnEventLabel():String
		{
			return _btnEventLabel;
		}
		
		public function get btnName():String
		{
			return _btnName;
		}
		
		public function set btnName(value:String):void
		{
			_btnName = value;
		}
		
		public function set btnTexName(value:String):void
		{
			_btnTexName = value;
		}
		
		public function set btnEventFile(value:String):void
		{
			_btnEventFile = value;
		}
		
		public function set btnEventLabel(value:String):void
		{
			_btnEventLabel = value;
		}
		
		public function get posX():int
		{
			return _posX;
		}
		
		public function set posX(value:int):void
		{
			_posX = value;
		}
		
		public function get posY():int
		{
			return _posY;
		}
		
		public function set posY(value:int):void
		{
			_posY = value;
		}
	
	}

}