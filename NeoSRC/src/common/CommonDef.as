package common
{
	import a24.tween.Tween24;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author
	 */
	public class CommonDef
	{
		
		[Embed(source="../../asset/system/btn_start_w.png")]
		public static const StartBtnImg:Class;
		
		[Embed(source="../../asset/system/btn_bgm.png")]
		public static const BgmBtnImg:Class;
		
		[Embed(source="../../asset/system/btn_sound.png")]
		public static const SeBtnImg:Class;
		
		[Embed(source="../../asset/system/btn_img.png")]
		public static const ImgBtnImg:Class;

		[Embed(source="../../asset/system/btn_pex.png")]
		public static const PexBtnImg:Class;
		
		[Embed(source="../../asset/system/btn_all.png")]
		public static const AllBtnImg:Class;
		
		[Embed(source="../../asset/system/tex_black.png")]
		public static const TexBlackImg:Class;
		
		// システム用テクスチャ
		//public static var COMMON_TEX:TextureAtlas = null;
		//public static var INTERMISSION_TEX:TextureAtlas = null;
		// 出撃用パーティクルXML
		//public static var LAUNCH_XML:XML = null;
		
		public static const BACK_TEX:Texture = Texture.fromBitmapData(new BitmapData(4, 4, true, 0xAAFFFFFF));
		public static const SELECT_TEX:Texture = Texture.fromBitmapData(new BitmapData(4, 4, true, 0xAA000000));
		public static const BLANK_TIP_TEX:Texture = Texture.fromBitmapData(new BitmapData(32, 32, true, 0x0));
		public static const BLANK_TIP_TEXT:String = "blank";
		
		public static const MOVE_TIP_TEX:Texture = Texture.fromBitmapData(new BitmapData(32, 32, true, 0x888888FF));
		public static const ROOT_TIP_TEX:Texture = Texture.fromBitmapData(new BitmapData(32, 32, true, 0x88FF8888));
		
		public static const MSG_BACK_TEX:Texture = Texture.fromBitmapData(new BitmapData(24, 24, true, 0x888888FF));
		
		public static const WINDOW_W:int = 960;
		public static const WINDOW_H:int = 540;
		public static const WINDOW_RATIO:Number = WINDOW_W / WINDOW_H;
		public static const MASS_SIZE:int = 32;
		
		public static const BATTLE_MATH_DEF:Number = 5.0 / 6.0;

		
		public static var TERRAIN_IMG:Array = ["Wpn_CapS", "Wpn_CapA", "Wpn_CapB", "Wpn_CapC", "Wpn_CapD", "Wpn_CapNone"];
		
		
		public static function formatZero(n:Number, keta:uint):String
		{
			return ("0000000000000000000000000" + n.toString()).substr(-keta);
		}
		
		//親ファイルパス取得
		public static function getParentLocalPath(type:String, path:String):String
		{
			var start:int = path.lastIndexOf("\\" + type + "\\");
			var end:int = path.lastIndexOf("\\");
			
			if (end < 0 || start < 0)
			{
				return path;
			}
			else
			{
				return path.substr(start + 1, end - start - 1);
			}
		}
		
		//親ファイルパス取得
		public static function getParentPath(type:String, path:String):String
		{
			var start:int = path.lastIndexOf("\\");
			
			if (start < 0)
			{
				return path;
			}
			else
			{
				return path.substr(0, start);
			}
		}
		
		//親ファイルパス取得
		public static function getFileName(path:String):String
		{
			var num:int = path.lastIndexOf("\\");
			if (num < 0)
			{
				return path;
			}
			else
			{
				return path.substr(num + 1, path.length);
			}
		}
		
		//ファイル名取得
		public static function getFileKey(path:String):String
		{
			var start:int = path.lastIndexOf("\\");
			var end:int = path.indexOf(".");
			//どちらも入っていなければ全部返す
			if (start < 0 && end < 0)
			{
				return path;
			}
			//フォルダ内でなければ拡張子を除去
			else if (start < 0)
			{
				return path.substr(0, end);
			}
			//拡張子なければ最後のフォルダ名
			else if (end < 0)
			{
				return path.substr(start, path.length);
			}
			//ファイル名のみ
			else
			{
				return path.substr(start, end);
			}
		}
		
		/**オブジェクト長さ取得*/
		public static function objectLength(data:Object):Number
		{
			var i:Number = 0;
			for (var prop:Object in data)
			{
				if (typeof(data[prop]) != "function")
					i++;
			}
			return i;
		}
		;
		
		public static function maskRect(rect:Rectangle, color:uint = 0xFFFFFFFF):Image
		{
			var img:Image = new Image(Texture.fromBitmapData(new BitmapData(rect.width, rect.height, true, color)));
			img.x = rect.x;
			img.y = rect.y;
			return img;
		}
		
		/** リストデータ一斉廃棄 */
		public static function disposeList(array:Object):void
		{
			for each (var object:Object in array)
			{
                if (object == null)
                {
                    continue;
                }
                
				if (object is Array || (object.hasOwnProperty("length") && object.length > 0 && object[0].hasOwnProperty("dispose")))
				{
					//再帰的に実行
					disposeList(object);
					continue;
				}
				
				if (object != null)
                {
                    if (object.hasOwnProperty("removeEventListeners"))
                    {
                        object.removeEventListeners();
                    }
                    if (object.hasOwnProperty("dispose"))
                    {
					    object.dispose();
                    }
                    object = null;
				}
			}
		}
		
		/**地形適正変換*/
		public static function terrainChanger(s:String):int
		{
			switch (s)
			{
			case "S": 
				return 0;
				break;
			case "A": 
				return 1;
				break;
			case "B": 
				return 2;
				break;
			case "C": 
				return 3;
				break;
			case "D": 
				return 4;
				break;
			case "E":
				return 99;
				break;
			case "-": 
				return -1;
				break;
			}
			return -1;
		}
		
		/**地形適正変換*/
		public static function terrainReChanger(num:int):String
		{
			switch (num)
			{
			case 0: 
				return "S";
				break;
			case 1: 
				return "A";
				break;
			case 2: 
				return "B";
				break;
			case 3: 
				return "C";
				break;
			case 4: 
				return "D";
				break;
			case -1: 
				return "-";
				break;
			}
			return "-";
		}
		
		/** コマンドライン整頓 */
		public static function sortCommandLine(line:String):String
		{
			// 連続半角を１つに変換
			while (line.indexOf("  ") >= 0)
			{
				line = CalcInfix.xReplace(line, '  ', ' ');
			}
			// 開始点半角を削除
			while (line.charAt(0) === " ")
			{
				line = line.substring(1, line.length);
			}
			// 終点半角を削除
			while (line.charAt(line.length - 1) === " ")
			{
				line = line.substring(0, line.length - 1);
			}
			return line;
		}
	
		public static function waitTime(waitTime:Number, skip:Boolean):Number
		{
			if (skip)
			{
				waitTime = 0.01;
			}
			return waitTime;
		}
		
	}

}