package system.custom.customSprite
{
	import feathers.controls.Button;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CImgButton extends Button
	{
		
		private var _fontSize:int = 0;
		private var _key:String = null;
		private var _value:String = null;
		
		private var _loadFile:String = null;
		private var _loadLabel:String = null;
		
		private var _defaultImg:CImage = null;
		private var _downImg:CImage = null;
		private var _disableImg:CImage = null;
		private var _hoverImg:CImage = null;
		
		public function CImgButton(tex:Texture)
		{
			this.name = "imgBtn";
			super();
			_defaultImg = new CImage(tex);
			
			_downImg = new CImage(tex);
			_downImg.color = 0xAAAAAA;
			
			_hoverImg = new CImage(tex);
			_hoverImg.color = 0xFFFFFF;
			
			_disableImg = new CImage(tex);
			_disableImg.alpha = 0.7;
			
			this.defaultSkin = _defaultImg;
			this.hoverSkin = _hoverImg;
			this.downSkin = _downImg;
			this.disabledSkin = _disableImg;
		}
		
		public function changeImg(tex:Texture):void
		{
			_defaultImg.texture = tex;
			_hoverImg.texture = tex;
			_downImg.texture = tex;
			_disableImg.texture = tex;
			
			this.defaultSkin = _defaultImg;
			this.hoverSkin = _hoverImg;
			this.downSkin = _downImg;
			this.disabledSkin = _disableImg;
			
		}
		
		
		override public function dispose():void
		{
			if (_defaultImg != null)
			{
				_defaultImg.dispose();
			}
			if (_hoverImg != null)
			{
				_hoverImg.dispose();
			}
			if (_hoverImg != null)
			{
				_downImg.dispose();
			}
			if (_disableImg != null)
			{
				_disableImg.dispose();
			}
			
			_defaultImg = null;
			_hoverImg = null;
			_downImg = null;
			_disableImg = null;
			
			super.dispose();
		
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
		
		public function get loadFile():String 
		{
			return _loadFile;
		}
		
		public function set loadFile(value:String):void 
		{
			_loadFile = value;
		}
		
		public function get loadLabel():String 
		{
			return _loadLabel;
		}
		
		public function set loadLabel(value:String):void 
		{
			_loadLabel = value;
		}

	
	}

}