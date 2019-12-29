package system
{
	import flash.filesystem.File;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	import starling.utils.AssetManager;
	import view.MainViewer;
	
	public class UserImage
	{
		//システム用
		[Embed(source = "../../asset/map_pallet_icon.png")]
		public static const img_pallet:Class;
		//システム用
		[Embed(source = "../../asset/map_pallet_icon.xml", mimeType = "application/octet-stream")]
		public static const xml_pallet:Class;
		//システム画像アトラス
		protected var m_systemAtlas:TextureAtlas = null;
		//アセットマネージャー
		public var tileAssetList:AssetManager = null;
		
		
		public var tileNameList:Vector.<String> = null;
		public var autoTileNameList:Vector.<String> = null;
		public var autoObjNameList:Vector.<String> = null;
		
		
		public var assetSelectNum:int = 0;
		
		public function initAssetManager():void
		{
			tileAssetList = new AssetManager();			
			tileNameList = new Vector.<String>();		
			autoTileNameList = new Vector.<String>();		
			autoObjNameList = new Vector.<String>();
		}
		
		/**リスト一覧を設定*/
		public function setTileListName():void
		{
			var texNamelist:Vector.<String> = tileAssetList.getTextureNames();
			//var urlList:Vector.<String> = tileAssetList.getTextureAtlasNames();
			
			var i:int = 0;
			
			for (i = 0; i < texNamelist.length; i++ )
			{
				var str:String = texNamelist[i].toLowerCase();
				var listName:String = "";
				//var chectText:String = checkUrl(texNamelist[i], urlList);

								
				//オートタイルリスト設定
				if (str.indexOf("autotile") == 0)
				{
					listName = str.substr(0, str.lastIndexOf("_"));
					//含まれていなければ追加
					if (autoTileNameList.indexOf(listName) < 0)
					{
						autoTileNameList.push(listName);
					}
				}
				//オートオブジェリスト設定
				else if (str.indexOf("autoobj") == 0)
				{
					listName = str.substr(0, str.lastIndexOf("_"));
					//含まれていなければ追加
					if (autoObjNameList.indexOf(listName) < 0)
					{
						autoObjNameList.push(listName);
					}
				}
				//ノーマルリストを追加
				else
				{
					listName = str.substr(0, 1);
					//含まれていなければ追加
					if (tileNameList.indexOf(listName) < 0)
					{
						tileNameList.push(listName);
					}
				}
			}
		}
		
		/**URL確認*/
		public function checkUrl(tileName:String, urlList:Vector.<String>):String
		{
			var i:int = 0;
			var flg:String = "";
			for (i = 0; i < urlList.length; i++ )
			{
				var urlTexNameList:Vector.<String> = UserImage.$.tileAssetList.getTextureAtlas(urlList[i]).getNames();
				if (urlTexNameList.indexOf(tileName) >= 0)
				{
					flg = urlList[i];
					break;
				}				
			}
			return flg;
		}
		
		public function loadAssetStart(callBack:Function):void
		{
			var file:File = new File(MainViewer.SCENARIO_PATH + "\\map");
			tileAssetList = new AssetManager();
			tileAssetList.keepAtlasXmls = true;
			tileAssetList.verbose = true;
			tileAssetList.enqueue(file.resolvePath("tipimg"));
			tileAssetList.loadQueue(function loading(num:Number):void
			{
				if (num >= 1.0)
				{
					setTileListName();
					callBack();
				}
			});
		}
		
		public function getTipTex(name:String):Texture
		{
			return tileAssetList.getTexture(name);
		}
		
		
		//マステクスチャ設定
		private var _planeAtlas:TextureAtlas;
		
		/**マネージャー*/
		private static var _manager:UserImage = new UserImage();
		
		/**instance getter
		 *
		 * @return UserImageインスタンス
		 * */
		public static function get $():UserImage
		{
			return _manager;
		}
		
		
		public function get systemAtlas():TextureAtlas
		{
			return m_systemAtlas;
		}
		
		/**コンストラクタ*/
		public function UserImage()
		{
			if (_manager)
			{
				throw new ArgumentError("UserImage is singleton class");
			}
		}
		
		/**キャラ画像ゲット
		 * @param s:String = 画像名
		 * @return Imageインスタンス
		 * */
		public function getCharaImg(s:String):Image
		{
			return new Image(_planeAtlas.getTexture(s));
		}
		
		/**初期化*/
		public function init():void
		{
			//_charaAtlas = new TextureAtlas(Texture.fromBitmap(new _charaImg()), XML(new _charaXml()));
			//_planeAtlas = getAtlas(Texture.fromBitmap(new _planeImg()), XML(new _planeXml()));
		}
		
		public function getAtlas(tex:Texture, xml:XML):TextureAtlas
		{
			var atlas:TextureAtlas = new TextureAtlas(tex, xml);
			return atlas;
		}
		
		public function makeSystemAtlas():void
		{
			var texture:Texture = Texture.fromEmbeddedAsset(img_pallet);
			var xml:XML = XML(new xml_pallet());
			
			m_systemAtlas = new TextureAtlas(texture, xml);
		}
		
		public function getSystemTex(str:String):Texture
		{
			return m_systemAtlas.getTexture(str);
		}
	
	}
}
