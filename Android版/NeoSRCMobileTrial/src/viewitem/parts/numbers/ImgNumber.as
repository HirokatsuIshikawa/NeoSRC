package viewitem.parts.numbers
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ImgNumber extends CSprite
	{
		
		public static const TYPE_NONE:String = "";
		
		public static const TYPE_STATE_Lv:String = "Status_Lv";
		public static const TYPE_STATE_HP:String = "Status_HP";
		public static const TYPE_STATE_FP:String = "Status_FP";
		public static const TYPE_STATE_TP:String = "Status_TP";
		public static const TYPE_STATE_ATK:String = "Status_ATK";
		public static const TYPE_STATE_DEF:String = "Status_DEF";
		public static const TYPE_STATE_TEC:String = "Status_TEC";
		public static const TYPE_STATE_SPD:String = "Status_SPD";
		public static const TYPE_STATE_CAP:String = "Status_CAP";
		public static const TYPE_STATE_MND:String = "Status_MND";
		public static const TYPE_STATE_MOV:String = "Status_MOV";
		
		public static const ADD_NONE:String = "";
		public static const ADD_PERCENT:String = "parcent";
		
		public static const CENTER_SLASH:String = "slash";
		
		private var _numList:Vector.<CImage> = null;
		
		public function ImgNumber()
		{
			super();
			_numList = new Vector.<CImage>;
		}
		
		override public function dispose():void
		{
			refresh();
			_numList = null;
			super.dispose();
		}
		
		public function refresh():void
		{
			var i:int = 0;
			if (_numList != null)
			{
				for (i = 0; i < _numList.length; )
				{
					_numList[0].dispose();
					_numList[0] = null;
					_numList.shift();
				}
			}
		}
		
		public function setNumber(num:Number, type:String = "", color:uint = 0xFFFFFF):void
		{
			refresh();
			var i:int = 0;
			var base_x:int = 0;
			var keta:int = 0;
			var setNum:Number = num;
			var img:CImage = null;
			var labelHeight:int = 0;
			
			// ラベル設定
			if (type.length > 0)
			{
				img = new CImage(MainController.$.imgAsset.getTexture(type));
				img.x = base_x;
				base_x += img.width;
				labelHeight = img.height;
				_numList.push(img);
				addChild(img);
			}
			
			base_x = setImgNumber(setNum, base_x, color, labelHeight);
		
		}
		
		
		public function setNone(color:uint = 0xFFFFFF):void
		{
			refresh();
			var i:int = 0;
			var img:CImage = null;
			
			img = new CImage(MainController.$.imgAsset.getTexture("minus"));
			img.x = 0;
			_numList.push(img);
			addChild(img);
		}
		
		
		public function setMaxNumber(num1:Number, num2:Number, type:String = "", color:uint = 0xFFFFFF):void
		{
			refresh();
			var base_x:int = 0;
			var img:CImage = null;
			var labelHeight:int = 0;
			// ラベル設定
			if (type.length > 0)
			{
				img = new CImage(MainController.$.imgAsset.getTexture(type));
				img.x = base_x;
				base_x += img.width;
				labelHeight = img.height;
				_numList.push(img);
				addChild(img);
			}
			
			base_x = setImgNumber(num1, base_x, color, labelHeight);
			
			// スラッシュ
			img = new CImage(MainController.$.imgAsset.getTexture("slash"));
			img.color = color;
			img.x = base_x;
			base_x += img.width;
			if (labelHeight > 0)
			{
				img.y = (labelHeight - img.height) / 2;
			}
			_numList.push(img);
			addChild(img);
			
			// 後ろの数字
			base_x = setImgNumber(num2, base_x, color, labelHeight);
		
		}
		
		public function addMark(str:String):void
		{
			var img:CImage = new CImage(MainController.$.imgAsset.getTexture(str));
			_numList.push(img);
			img.x = this.width;
			addChild(img);
		}
		
		
		// 数値から画像セット
		private function setImgNumber(num:Number, base_x:int, color:uint, labelHeight:int):int
		{
			var i:int = 0;
			var keta:int = 0;
			var img:CImage = null;
			var setNum:Number = num;
			var useNum:Number = 0;
			//数値設定
			if (setNum == 0)
			{
				img = new CImage(MainController.$.imgAsset.getTexture("number_" + 0));
				img.color = color;
				img.x = base_x;
				base_x += img.width;
				if (labelHeight > 0)
				{
					img.y = (labelHeight - img.height) / 2;
				}
				_numList.push(img);
				addChild(img);
			}
			else
			{
				// 桁数取得
				var len:String = num + "";
				keta = len.length;
				
				// 上の桁から配置
				for (i = keta; i > 0; i--)
				{
					useNum = setNum;
					useNum = (int)(setNum % Math.pow(10, i));
					if (useNum > 0)
					{
						useNum = (int)(useNum / Math.pow(10, i - 1));
					}
					
					img = new CImage(MainController.$.imgAsset.getTexture("number_" + useNum));
					img.color = color;
					img.x = base_x;
					if (labelHeight > 0)
					{
						img.y = (labelHeight - img.height) / 2;
					}
					base_x += img.width;
					_numList.push(img);
					addChild(img);
					setNum = num % Math.pow(10, i - 1);
				}
			}
			return base_x;
		
		}
	
	}

}