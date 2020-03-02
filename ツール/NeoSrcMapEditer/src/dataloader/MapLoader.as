package dataloader
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import starling.textures.Texture;
	import system.CommonDef;
	import system.CommonSystem;
	import system.Crypt;
	import system.UserImage;
	import main.MainController;
	import main.MainViewer;
	
	/**
	 * ...
	 * @author
	 */
	public class MapLoader
	{
		/**読み込みデータ*/
		private var m_loadData:Object = null;
		/**ファイル名*/
		private var m_mapName:String = "新しいマップ";
		
		public function MapLoader()
		{
		
		}
		
		/**マップデータ読み込み*/
		public function loadMap(data:Object):void
		{
			m_loadData = data;
			var file:File = new File(MainViewer.SCENARIO_PATH + "\\map\\tipimg\\");// 
			//var str:String = File.applicationDirectory.resolvePath("img\\map").nativePath;
			var itemNum:int = CommonDef.objectLength(data.tip);
			var list:Array = new Array();
			var i:int = 0;
			
			var j:int = 0;
			var re:RegExp = new RegExp("\\\\", "g");
			var reg:RegExp = new RegExp("/", "g");
						
			for (i = 0; i < CommonDef.objectLength(data.tip); i++)
			{
				for (j = 0; j < CommonDef.objectLength(data.tip[i].url); j++)
				{
					
					var base:String = data.tip[i].url[j];
					var url:String = base.replace(re, "/");
					
					if (url === "blank")
					{
						continue;
					}
					else if (list.indexOf(url) < 0)
					{
						list.push(url);
					}
				}
			}
			
			
			MainController.$.view.canvas.setTipArea(m_loadData.width, m_loadData.height);
			
			var urlList:Vector.<String> = UserImage.$.tileAssetList.getTextureAtlasNames();
			
			// チップ配置
			for (i = 0; i < 3; i++)
			{
				for (j = 0; j < CommonDef.objectLength(m_loadData.tip); j++)
				{
					if (m_loadData.tip[j].name[i] == null || m_loadData.tip[j].name[i] === "blank")
					{
						continue;
					}
					
					var texUrl:String = UserImage.$.checkUrl(m_loadData.tip[j].name[i], urlList);
					
					//テクスチャ
					var vtex:Texture = UserImage.$.getTipTex(m_loadData.tip[j].name[i]);// TextureManager.loadMapTexture(url, m_loadData.tip[j].name[i]);
					MainController.$.view.canvas.tip[i][j].draw(texUrl, m_loadData.tip[j].name[i], false);
				}
			}
			
			// 地形データ
			for (i = 0; i < CommonDef.objectLength(m_loadData.tip); i++)
			{
				if (m_loadData.tip[i].hasOwnProperty("terrain"))
				{
					MainController.$.view.canvas.terrain[i].setType( //
					true, m_loadData.tip[i].terrain.type, //
					m_loadData.tip[i].terrain.cost, //
					m_loadData.tip[i].terrain.agiComp, //
					m_loadData.tip[i].terrain.defComp, //
					m_loadData.tip[i].terrain.eventNo, //
					m_loadData.tip[i].terrain.high, m_loadData.tip[i].terrain.under, m_loadData.tip[i].terrain.category //
					);
				}
				else
				{
					MainController.$.view.canvas.terrain[i].setType(true, 0, 1, 0, 0, 0, 0, false);
				}
			}
			// 画像リフレッシュ
			MainController.$.view.canvas.refreshTip(0);
			MainController.$.view.canvas.refreshTip(1);
			MainController.$.view.canvas.refreshTip(2);
			MainController.$.view.canvas.refreshTerrain();
			MainController.$.view.setMapCenter();
		}
		
		public function loadMapData():void
		{
			
			var fr:FileReference = new FileReference();
			fr.addEventListener(flash.events.Event.SELECT, onFileReference_Select);
			//fr.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			//必要なら...
			//fr.addEventListener(ProgressEvent.PROGRESS, onFileReference_Progress);
			//fr.addEventListener(Event.CANCEL, onFileReference_Cancel);
			//fr.addEventListener(IOErrorEvent.IO_ERROR, onFileReference_IOError);
			//fr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onFileReference_SecurityError);
			
			//フィルタ拡張子を指定
			var ff:FileFilter = new FileFilter("新型SRCマップデータ", "*.map");
			//ファイル選択ダイアログ起動
			fr.browse([ff]);
		}
		
		//FileReference　選択が終わった後の処理
		private function onFileReference_Select(e:flash.events.Event):void
		{
			var fr:FileReference = null;
			fr = e.target as FileReference;
			fr.removeEventListener(flash.events.Event.SELECT, onFileReference_Select);
			fr.addEventListener(flash.events.Event.COMPLETE, loadComplete);
			fr.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			
			function loadProgress(evt:ProgressEvent):void
			{
				trace("Loaded " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes.");
			}
			//FileReference　ロード成功時の処理
			function loadComplete(e:flash.events.Event):void
			{
				var barrDat:ByteArray = e.target.data;
				//漢字コード変換（shift-jis　－＞　UTF8）
				var strData:String = barrDat.readMultiByte(barrDat.length, "utf-8");
				
				if (strData.indexOf(Crypt.CODE) == 0)
				{
					strData = strData.replace(Crypt.CODE, "");
					strData = Crypt.decrypt(strData);
				}
				
				
				UserImage.$.loadAssetStart(loadAssetComp);
				
				function loadAssetComp():void
				{
					//改行の変更
					var obj:Object = JSON.parse(strData);
					loadMap(obj);
					MainController.$.view.endStartWindow();
				}
			}
			
			fr.load(); //ロード開始
		}
		
		
		/**マップデータ保存*/
		public function saveMapData():void
		{
			var data:Object = new Object();
			data.tip = new Object();
			data.width = MainController.$.view.canvas.mapWidth;
			data.height = MainController.$.view.canvas.mapHeight;
			
			for (var i:int = 0; i < MainController.$.view.canvas.tip[0].length; i++)
			{
				
				data.tip[i] = new Object();
				data.tip[i].name = new Object();
				//data.tip[i].url = new Object();
				data.tip[i].terrain = new Object;
				data.tip[i].name[0] = MainController.$.view.canvas.tip[0][i].tipName;
				//data.tip[i].url[0] = MainController.$.view.canvas.tip[0][i].url;
				data.tip[i].name[1] = MainController.$.view.canvas.tip[1][i].tipName;
				//data.tip[i].url[1] = MainController.$.view.canvas.tip[1][i].url;
				data.tip[i].name[2] = MainController.$.view.canvas.tip[2][i].tipName;
				//data.tip[i].url[2] = MainController.$.view.canvas.tip[2][i].url;
				data.tip[i].terrain.type = MainController.$.view.canvas.terrain[i].type;
				data.tip[i].terrain.cost = MainController.$.view.canvas.terrain[i].cost;
				data.tip[i].terrain.category = MainController.$.view.canvas.terrain[i].category;
				data.tip[i].terrain.defComp = MainController.$.view.canvas.terrain[i].defComp;
				data.tip[i].terrain.agiComp = MainController.$.view.canvas.terrain[i].agiComp;
				data.tip[i].terrain.eventNo = MainController.$.view.canvas.terrain[i].eventNo;
				data.tip[i].terrain.under = MainController.$.view.canvas.terrain[i].under;
				data.tip[i].terrain.high = MainController.$.view.canvas.terrain[i].high;
			}
			var json:String = JSON.stringify(data);
			
			if (Crypt.flg)
			{
				json = Crypt.encrypt(json);
				json = Crypt.CODE + json;
			}
			
			var fr:FileReference = new FileReference();
			
			fr.addEventListener(flash.events.Event.COMPLETE, onComplete);
			fr.save(json, m_mapName + ".map"); // ダイアログを表示する
			
			function onComplete(e:flash.events.Event):void
			{
				trace(fr.name); // ユーザが指定したファイル名を表示
			}
		
		}
		
		public function get mapName():String
		{
			return m_mapName;
		}
		
		public function set mapName(value:String):void
		{
			m_mapName = value;
		}
		
		public static function LoadFolderPath(compFunc:Function):void
		{
			var loadfile:File = new File();
			//終了後の処理
			loadfile.addEventListener(Event.SELECT, function(evSel:Event):void
			{
				var path:String = loadfile.nativePath;
				compFunc(path);
			});
			
			//ファイル選択ダイアログ起動
			loadfile.browseForDirectory("シナリオフォルダ選択");
		}
	
		
		//ファイルからの直読み
		public function loadInvokePath(mainPath:String):void
		{
			var loadfile:File = new File(mainPath);
			
			loadfile.addEventListener(Event.COMPLETE, loadComplete);
			loadfile.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			function loadProgress(evt:ProgressEvent):void
			{
				trace("Loaded " + evt.bytesLoaded + " of " + evt.bytesTotal + " bytes.");
			}
			
			//FileReference　ロード成功時の処理
			function loadComplete(e:flash.events.Event):void
			{
				var barrDat:ByteArray = e.target.data;
				//漢字コード変換（shift-jis　－＞　UTF8）
				var strData:String = barrDat.readMultiByte(barrDat.length, "utf-8");
				
				if (strData.indexOf(Crypt.CODE) == 0)
				{
					strData = strData.replace(Crypt.CODE, "");
					strData = Crypt.decrypt(strData);
				}
				
				
				UserImage.$.loadAssetStart(loadAssetComp);
				
				function loadAssetComp():void
				{
					//改行の変更
					var obj:Object = JSON.parse(strData);
					loadMap(obj);
					MainController.$.view.endStartWindow();
				}
			}
			
			loadfile.load(); //ロード開始
		}
		
	}

}