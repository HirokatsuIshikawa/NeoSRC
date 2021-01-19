package database.dataloader
{
	import main.MainController;
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import common.CommonDef;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;
    import system.manageer.AtlasManager;
    import system.manageer.TextureManager;
	import starling.display.Image;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import system.CommonDef;
	import view.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class TipLoader
	{
		
		//パレットタイプ
		private var _palletType:String = "";
		/**チップ種類一覧*/
		private var _tipList:Array = null;
		/**読み込みローダー*/
		private var _loader:BulkLoader = null;
		
		public function TipLoader()
		{
		
		}
		
		private function onComplete(e:flash.events.Event):void
		{
			MainController.$.view.pallet.reset();
			//読み込み画像リスト
			var imgList:Vector.<Texture> = new Vector.<Texture>;
			//画像名リスト
			var nameList:Array = new Array();
			//ファイル親位置
			var parent:String = null;
			var localParent:String = null;
			var xml:XML = null;
			var isXml:Boolean = false;
			var loader:BulkLoader = e.target as BulkLoader;
			loader.removeEventListener(BulkLoader.PROGRESS, onProgress);
			loader.removeEventListener(BulkLoader.COMPLETE, onComplete);
			loader.removeEventListener(BulkLoader.ERROR, onError);
			trace("全ファイルの読み込みが完了しました。");
			//displayItems();
			
			//読み込んだアイテムをセット
			for (var i:int = 0; i < loader.items.length; i++)
			{
				//画像ファイルの場合
				if (loader.items[i].type == "image")
				{
					//var img:Image = Image.fromBitmap(loader.getBitmap(loader.items[i].url.url));
					//imgList[
					//this.addChild(img);
					parent = CommonDef.getParentPath(_palletType, loader.items[i].url.url);
					localParent = CommonDef.getParentLocalPath(_palletType, loader.items[i].url.url);
					imgList.push(Texture.fromBitmap(loader.getBitmap(loader.items[i].url.url)));
					nameList.push(CommonDef.getFileName(loader.items[i].url.url));
				}
				//XMLファイルの場合
				else if (loader.items[i].type == "xml")
				{
					isXml = true;
					xml = loader.getXML(loader.items[i].url.url);
					parent = CommonDef.getParentPath(_palletType, loader.items[i].url.url);
					localParent = CommonDef.getParentLocalPath(_palletType, loader.items[i].url.url);
				}
			}
			//XMLタイプ
			if (isXml == true)
			{
				//テクスチャ名
                var url:String = localParent + "\\" + xml.@imagePath;
				var tex:String = parent + "\\" + xml.@imagePath;
				var atlas:TextureAtlas = AtlasManager.setAtlas(Texture.fromBitmap(loader.getBitmap(tex)), xml, url);
				
				for (i = 0; i < xml.SubTexture.length(); i++)
				{
					//ファイル名
					var imtx:String = xml.SubTexture[i].@name;
					//テクスチャ
					var vtex:Texture = TextureManager.loadMapTexture(url, imtx);
					
					MainController.$.view.pallet.pushTip(vtex, imtx, url);
				}
			}
			else
			{
				for (i = 0; i < imgList.length; i++)
				{
					MainController.$.view.pallet.pushTip(imgList[i], nameList[i], localParent);
				}
			}
			MainController.$.view.pallet.pushComp();
		}
		
		/**チップ一覧セット*/
		public function tipListSet(type:String):void
		{
			var file:File = File.applicationDirectory.resolvePath("img//map//" + type);
			_palletType = type;
			// フォルダ内のすべてのファイルとフォルダを取得
			var files:Array = file.getDirectoryListing();
			// 配列の中身を列挙
			_tipList = new Array();
			for (var i:int = 0; i < files.length; i++)
			{
				var f:File = files[i];
				if (f.isDirectory)
				{
					_tipList.push(f.name);
				}
				else if (f.type === ".xml")
				{
					_tipList.push(f.name);
				}
			}
			
			MainController.$.view.pallet.selecter.setList(type, _tipList, loadStart);
			
			loadStart(type, _tipList[0]);
		}
		
		/**マップチップ読み込み*/
		private function loadMapTip(type:String, name:String):void
		{
			// フォルダ内のすべてのファイルとフォルダを取得
			
			var file:File = File.applicationDirectory.resolvePath("img\\map\\" + type + "\\" + name);
			//XMLファイルの場合
			if (file.name.indexOf(".xml") >= 0)
			{
				_loader.add(file.nativePath);
				_loader.add(file.nativePath.replace(".xml", ".png"));
			}
			//フォルダの場合
			else if (file.isDirectory == true)
			{
				var files:Array = file.getDirectoryListing();
				// 配列の中身を列挙
				_tipList = new Array();
				for (var i:int = 0; i < files.length; i++)
				{
					var f:File = files[i];
					if (f.type === ".png" || f.type === ".jpg" || f.type === ".bmp")
					{
						_loader.add(f.nativePath);
					}
				}
			}
		}
		
		/**読み込み開始*/
		public function loadStart(type:String, name:String):void
		{
			_loader = new BulkLoader();
			loadMapTip(type, name);
			_loader.addEventListener(BulkLoader.PROGRESS, onProgress);
			_loader.addEventListener(BulkLoader.COMPLETE, onComplete);
			_loader.addEventListener(BulkLoader.ERROR, onError);
			_loader.start();
		}
		
		/**読み込み度数*/
		public function onProgress(e:BulkProgressEvent):void
		{
			trace("e.percentLoaded:", e.percentLoaded, "e.weightPercent:", e.weightPercent, "e.ratioLoaded:", e.ratioLoaded);
		}
		
		/**バルクローダーエラー*/
		private function onError(e:ErrorEvent):void
		{
			var loader:BulkLoader = e.target as BulkLoader;
			trace("エラーが発生しました。");
			loader.removeFailedItems();
		}
	}

}