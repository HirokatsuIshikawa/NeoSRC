package system.custom.customSprite
{
	import system.custom.customSprite.CSprite;
	import flash.geom.Point;
	import starling.display.Quad;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ImageBoard extends CSprite
	{
		
		private var _baseSpr:CSprite = null;
		private var _image:Vector.<CImage> = null;
		private var _charaName:String = null;
		private var _nickName:String = null;
		private var _addX:int = 0;
		private var _addY:int = 0;
		private var IMG_BASE:int = 16;
		private var _imgPartsList:Vector.<String> = null;
		
		public function ImageBoard(add:Point = null, area:Quad = null)
		{
			_baseSpr = new CSprite();
			_imgPartsList = new Vector.<String>();
			if (add != null)
			{
				_addX = add.x;
				_addY = add.y;
			}
			else
			{
				_addX = 0;
				_addY = 0;
			}
			
			_image = new Vector.<CImage>;
			super();
			if (area != null)
			{
				this.mask = area;
			}
			addChild(_baseSpr);
		}
		
		public function setAdd(addX:int, addY:int):void
		{
			_addX = addX;
			_addY = addY;
		}
		
		public function addImage(img:CImage, type:String = "stand"):void
		{
			if (_baseSpr == null)
			{
				_baseSpr = new CSprite();
			}
			
			switch (type)
			{
			case "icon": 
				img.height = 128 * img.height / img.width;
				img.width = 128;
				_baseSpr.x = IMG_BASE + img.width / 2;
				_baseSpr.y = IMG_BASE - img.height / 2 + 64;
				img.x = -64;
				img.y = -12;
				img.textureSmoothing = TextureSmoothing.BILINEAR;
				break;
			case "stand": 
				_baseSpr.x = 80;
				_baseSpr.y = 80;
				img.x = -_addX;
				img.y = -_addY;
				break;
			}
			/* 回転処理、使う時は平面を切る */
			/*
			   var rotate:Number = 0;
			   addEventListener(Event.ENTER_FRAME, function():void {
			   _baseSpr.rotation = Math.PI / 180 * rotate;
			   rotate++;
			   });
			 */
			_image.push(img);
			_baseSpr.addChild(img);
		}
		
		public function changeImage(img:CImage, layer:int, type:String = "stand"):void
		{
			
			_image[layer].dispose();
			_image[layer] = null;
			switch (type)
			{
			case "icon": 
				img.height = 128 * img.height / img.width;
				img.width = 128;
				_baseSpr.x = IMG_BASE + img.width / 2;
				_baseSpr.y = IMG_BASE - img.height / 2 + 64;
				img.x = -64;
				img.y = -12;
				img.textureSmoothing = TextureSmoothing.BILINEAR;
				break;
			case "stand": 
				_baseSpr.x = 80;
				_baseSpr.y = 80;
				img.x = -_addX;
				img.y = -_addY + 80;
				break;
			}
			
			_image[layer] = img;
	
		}
		
		public function imgClear():void
		{
			if (_baseSpr == null)
			{
				return;
			}
			for (var i:int = 0; i < _image.length; )
			{
				_baseSpr.removeChild(_image[i]);
				_image[i].dispose();
				_image[i] = null;
				_image.shift();
			}
			_baseSpr.width = 0;
			_baseSpr.height = 0;
		}
		
		override public function dispose():void
		{
			for (var i:int = 0; i < _image.length; )
			{
				_baseSpr.removeChild(_image[i]);
				_image[i].dispose();
				_image[i] = null;
				_image.shift();
			}
			removeChild(_baseSpr);
			_baseSpr = null;
			
			super.dispose();
		}
		
		public function get charaName():String
		{
			return _charaName;
		}
		
		public function set charaName(value:String):void
		{
			_charaName = value;
		}
		
		public function get zeroPos():int 
		{
			return -_baseSpr.y;
		}
		
		public function get nickName():String 
		{
			return _nickName;
		}
		
		public function set nickName(value:String):void 
		{
			_nickName = value;
		}
		
		public function get imgPartsList():Vector.<String> 
		{
			return _imgPartsList;
		}
		
		public function set imgPartsList(value:Vector.<String>):void 
		{
			_imgPartsList = value;
		}
	
	}

}