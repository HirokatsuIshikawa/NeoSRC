package converter.parse
{
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ImgDataParse
	{
		
		public static const STATE_NONE:int = 0;
		public static const STATE_CHARA:int = 1;
		public static const STATE_UNIT:int = 2;
		
		
		public static function parseCharaImgData(str:String):Array
		{
			var charaCount:int = -1;
			// 状態
			var state:int = STATE_NONE;
			var xmlStr:String = "";
			
			// 変換データ
			var data:Array = new Array();
			// ※gは繰り返しフラグ
			// 改行
			str = str.replace(/\r\n/g, "\n");
			// タブ
			str = str.replace(/\t/g, "");
			// 半角
			str = str.replace(/ /g, "");
			var ary:Array = str.split("\n");
			
			for (var i:int = 0; i < ary.length; i++)
			{
				var line:String = ary[i];
				if (line.length <= 0)
				{
					continue;
				}
				
				var cmdList:Array = line.split(":");
				var cmd:String = cmdList[0];
				cmd = cmd.toLowerCase();
				
				switch (cmd)
				{
				case "chara": 
					state = STATE_CHARA;
					xmlStr = cmdList[1];
					
					if (!data.hasOwnProperty("charaData"))
					{
						data.charaData = new Array();
					}
					break;
				case "unit": 
					state = STATE_UNIT;
					xmlStr = cmdList[1];
					if (!data.hasOwnProperty("unitData"))
					{
						data.unitData = new Array();
					}
					break;
				default:
					if (state == STATE_CHARA)
					{
						if (cmd === "name")
						{
							charaCount++;
							data.charaData[charaCount] = new Object();
							data.charaData[charaCount].name = cmdList[1];
							data.charaData[charaCount].imgUrl = xmlStr;
						}
						parseCharaImg(data.charaData[charaCount], line);
					}
					else if (state == STATE_UNIT)
					{
						parseUnitImg(data.unitData, line, xmlStr);
					}
					break;
				}
			}
			return data;
		}
		
		// 画像データパース
		private static function parseCharaImg(data:Object, line:String):void
		{
			var i:int = 0;
			var ary:Array;
			var param:Array;
			// 基本表情
			if (line.indexOf("basic:") == 0)
			{
				data.basicList = new Array();
				
				line = line.replace("basic:", "");
				
				param = line.split(",");
				
				for (i = 0; i < param.length; i++)
				{
					data.basicList.push(param[i]);
				}
			}
			// 指定表情
			else if (line.indexOf(":") >= 0)
			{
				ary = line.split(",");
				for (i = 0; i < ary.length; i++)
				{
					param = ary[i].split(":");
					switch (param[0].toLowerCase())
					{
					case "nickname":
						data.nickname = param[1];
						break;
					case "unit": 
						data.unit = param[1];
						break;
					case "type": 
						if (param[1] === "立ち絵")
						{
							param[1] = "stand";
						}
						else if (param[1] === "アイコン")
						{
							param[1] = "icon";
						}
						data.defaultType = param[1].toLowerCase();
						;
						break;
					case "x": 
						data.add_x = param[1];
						break;
					case "y": 
						data.add_y = param[1];
						break;
					}
				}
			}
			else
			{
				if (!data.hasOwnProperty("imgList"))
				{
					data.imgList = new Array();
				}
				
				var faceData:Object = new Object();
				
				ary = line.split(",");
				
				faceData.name = ary[0];
				faceData.file = ary[1];
				faceData.layer = Number(ary[2]);
				data.imgList.push(faceData);
			}
		}
		
		
		// 画像データパース
		private static function parseUnitImg(data:Array, line:String, xmlPath:String):void
		{
			var unitData:Object = new Object();
			var param:Array = line.split(":");
			
			if (param.length > 0)
			{
				unitData.name	= param[0];
				unitData.img	= param[1];
				unitData.url	= xmlPath;
				data.push(unitData);
			}
			
		}
	}
}