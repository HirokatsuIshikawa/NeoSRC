package scene.talk.common
{
	import common.CommonDef;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import system.custom.customSprite.CTextArea;
	import flash.text.TextFormatAlign;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ImgDef
	{
		public static function setImgSpr(tex:Texture, param:Object):CSprite
		{
			var setSpr:CSprite = new CSprite();
			var setImg:CImage = new CImage(tex);
			var width:int = tex.width;
			var height:int = tex.height;
			var ratio:Number = width / height;
			if (param.hasOwnProperty("name"))
			{
				setSpr.name = param.name;
			}
			else
			{
				setSpr.name = "nameless";
			}
			
			//サイズ
			if (param.hasOwnProperty("size"))
			{
				var sizeStr:String = param.size;
				
				switch (sizeStr.toLowerCase())
				{
				case "center": 
				case "free": 
					if (param.hasOwnProperty("scale"))
					{
						setImg.scale = param.scale;
					}
					else if (param.hasOwnProperty("scaleX") || param.hasOwnProperty("scaleY"))
					{
						if (!param.hasOwnProperty("scaleX"))
						{
							param.scaleX = 1;
						}
						if (!param.hasOwnProperty("scaleY"))
						{
							param.scaleY = 1;
						}
						setImg.scaleX = param.scaleX;
						setImg.scaleY = param.scaleY;
					}
					else
					{
						if (!param.hasOwnProperty("width") || param.width === "-")
						{
							param.width = setImg.width;
						}
						
						if (!param.hasOwnProperty("height") || param.height === "-")
						{
							param.height = setImg.height;
						}
						setImg.width = param.width;
						setImg.height = param.height;
					}
					break;
				case "just": 
					setImg.width = CommonDef.WINDOW_W;
					setImg.height = CommonDef.WINDOW_H;
					break;
				case "fill": 
					//縦横幅、小さい方に合わせて拡大
					setImg.readjustSize();
					if (width >= height * CommonDef.WINDOW_RATIO)
					{
						setImg.width = CommonDef.WINDOW_W  * (CommonDef.WINDOW_H / height);
						setImg.height = CommonDef.WINDOW_H;
					}
					else
					{
						setImg.width = CommonDef.WINDOW_W;
						setImg.height = CommonDef.WINDOW_H * (CommonDef.WINDOW_W / width);
					}
					break;
				}
			}
			
			setImg.x = -setImg.width / 2;
			setImg.y = -setImg.height / 2;
			
			//反転
			if (param.hasOwnProperty("reverse"))
			{
				if (param.reverse === "xy")
				{
					setImg.scaleX = -1;
					setImg.scaleY = -1;
					setImg.x += setImg.width;
					setImg.y += setImg.height;
				}
				else if (param.reverse === "x")
				{
					setImg.scaleX = -1;
					setImg.x += setImg.width;
				}
				else if (param.reverse === "y")
				{
					setImg.scaleY = -1;
					setImg.y += setImg.height;
				}
			}
			
			if (sizeStr.toLowerCase() == "free")
			{
				if (!param.hasOwnProperty("x") || param.x === "-")
				{
					param.x = CommonDef.WINDOW_W / 2;
				}
				
				if (!param.hasOwnProperty("y") || param.y === "-")
				{
					param.y = CommonDef.WINDOW_H / 2;
				}
				
				if (param.hasOwnProperty("align") && param.align === "left")
				{
					setSpr.x = param.x + setImg.width / 2;
					setSpr.y = param.y + setImg.height / 2;
				}
				else
				{
					setSpr.x = param.x;
					setSpr.y = param.y;
				}
			}
			else if (sizeStr.toLowerCase() === "fill")
			{
				if (width >= height * CommonDef.WINDOW_RATIO)
				{
					setSpr.x = setImg.width / 2 + -1 * (setImg.width - CommonDef.WINDOW_W) / 2;
					setSpr.y = setImg.height / 2;
				}
				else
				{
					setSpr.y = setImg.height / 2 + -1 * (setImg.height - CommonDef.WINDOW_H) / 2;
					setSpr.x = setImg.width / 2;
				}
				
			}
			else
			{
				setSpr.x = setImg.width / 2;
				setSpr.y = setImg.height / 2;
			}
			
			if (param.hasOwnProperty("addx"))
			{
				setSpr.x += Number(param.addx);
			}
			if (param.hasOwnProperty("addy"))
			{
				setSpr.y += Number(param.addy);
			}
			
			if (param.hasOwnProperty("alpha"))
			{
				setSpr.alpha = param.alpha;
			}
			else
			{
				setSpr.alpha = 1;
			}
			if (setSpr.alpha > 0)
			{
				setSpr.visible = true;
			}
			else
			{
				setSpr.visible = false;
			}
			setSpr.addChild(setImg);
			return setSpr;
		}
		
		public static function setTextSpr(param:Object):CSprite
		{
			var setSpr:CSprite = new CSprite();
			var fontSize:int = 18;
			var fontColor:uint = 0x0;
			var input:Boolean = false;
			var backColor:uint = 0xFFFFFFFF;
			var align:String = TextFormatAlign.LEFT;
			var multiline:Boolean = false;
			if (param.hasOwnProperty("fontsize"))
			{
				fontSize = param.fontsize;
			}
			if (param.hasOwnProperty("fontcolor"))
			{
				fontColor = Number(param.fontcolor);
			}
			if (param.hasOwnProperty("backcolor"))
			{
				backColor = Number(param.backcolor);
			}
			
			if (param.hasOwnProperty("input") && param.input === "on")
			{
				input = true;
			}
			if (param.hasOwnProperty("multiline") && param.input === "on")
			{
				multiline = true;
			}
			
			if (param.hasOwnProperty("align"))
			{
				align = param.align;
			}
			
			var textSpr:CTextArea = new CTextArea(fontSize, fontColor, backColor, align, input, multiline);
			
			var width:int = 120;
			var height:int = 40;
			
			if (param.hasOwnProperty("width"))
			{
				width = param.width;
			}
			if (param.hasOwnProperty("height"))
			{
				height = param.height;
			}
			
			if (param.hasOwnProperty("objalign"))
			{
				if (param.objalign === "center")
				{
					textSpr.x = -width / 2;
				}
				else
				{
					textSpr.x = 0;
				}
				
			}
			else
			{
					textSpr.x = 0;
			}
			
			
			textSpr.width = width;
			textSpr.height = height;
			
			if (param.hasOwnProperty("name"))
			{
				setSpr.name = param.name;
			}
			else
			{
				setSpr.name = "nameless";
			}
			
			if (param.hasOwnProperty("text"))
			{
				var textStr:String = (param.text as String).replace(/¥n/g, "\n");
				
				textSpr.text = textStr;
			}
			
			if (!param.hasOwnProperty("x") || param.x === "-")
			{
				param.x = CommonDef.WINDOW_W / 2;
			}
			
			if (!param.hasOwnProperty("y") || param.y === "-")
			{
				param.y = CommonDef.WINDOW_H / 2;
			}
			
			setSpr.x = param.x;
			setSpr.y = param.y;
			
			if (param.hasOwnProperty("addx"))
			{
				setSpr.x += Number(param.addx);
			}
			if (param.hasOwnProperty("addy"))
			{
				setSpr.y += Number(param.addy);
			}
			
			if (param.hasOwnProperty("alpha"))
			{
				setSpr.alpha = param.alpha;
			}
			else
			{
				setSpr.alpha = 1;
			}
			if (setSpr.alpha > 0)
			{
				setSpr.visible = true;
			}
			else
			{
				setSpr.visible = false;
			}
			setSpr.addChild(textSpr);
			return setSpr;
		}
	}
}