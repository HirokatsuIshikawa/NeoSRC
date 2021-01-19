package database.dataloader
{
	import common.CommonDef;
	import common.CommonSystem;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import starling.textures.Texture;
	import system.Crypt;
	import main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class MapLoader
	{
		/**読み込みデータ*/
		private static var _loadData:Object = null;
		/**ファイル名*/
		private static var _mapName:String = "新しいマップ";
		
		
		/**マップデータ読み込み*/
		public static function loadMap(data:Object):void
		{
			_loadData = data;
			
			var i:int = 0;
			var j:int = 0;
			
			MainController.$.view.battleMap.setTipArea(_loadData.width, _loadData.height);
			
			var urlList:Vector.<String> = MainController.$.mapTipAsset.getTextureAtlasNames();
			
			// チップ配置
			for (i = 0; i < 3; i++)
			{
				for (j = 0; j < CommonDef.objectLength(_loadData.tip); j++)
				{
					if (_loadData.tip[j].name[i] == null || _loadData.tip[j].name[i] === CommonDef.BLANK_TIP_TEXT)
					{
						continue;
					}
					
					var texUrl:String = CommonSystem.checkUrl(_loadData.tip[j].name[i], urlList);
					MainController.$.view.battleMap.tip[i][j].draw(texUrl, _loadData.tip[j].name[i], false);
				}
			}
			
			// 地形データ
			for (i = 0; i < CommonDef.objectLength(_loadData.tip); i++)
			{
				if (_loadData.tip[i].hasOwnProperty("terrain"))
				{
					MainController.$.view.battleMap.terrain[i].setType( //
					_loadData.tip[i].terrain.type, //
					_loadData.tip[i].terrain.cost, //
					_loadData.tip[i].terrain.agiComp, //
					_loadData.tip[i].terrain.defComp, //
					_loadData.tip[i].terrain.eventNo, //
					_loadData.tip[i].terrain.high,
					_loadData.tip[i].terrain.under,
					_loadData.tip[i].terrain.category //
					);
				}
				else
				{
					MainController.$.view.battleMap.terrain[i].setType(0, 1, 0, 0, 0, 0, false);
				}
			}
			// 画像リフレッシュ
			MainController.$.view.battleMap.refreshTip(0);
			MainController.$.view.battleMap.refreshTip(1);
			MainController.$.view.battleMap.refreshTip(2);
		}
		
		
		//-----------------------------------------------------------------
		//
		// マップ読み込み
		//
		//-----------------------------------------------------------------
		public static function loadMapData(name:String, callBack:Function = null):void
		{
			//読み込みインスタンスの生成
			var _textloader:URLLoader = new URLLoader();
			var file:File = File.applicationDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "map/");
			//URL
			var _requrl:URLRequest = new URLRequest(CommonSystem.FILE_HEAD + file.nativePath + "/" + name);
			//読み込むデータ型式をテキストに設定
			_textloader.dataFormat = URLLoaderDataFormat.TEXT;

			//テキストを読み込み開始し、完了したらtestAreaに代入
			_textloader.addEventListener(Event.COMPLETE, loadComplete);

			//FileReference　ロード成功時の処理
			function loadComplete(e:Event):void
			{
				var str:String = e.target.data;
				//改行の変更
				var obj:Object = JSON.parse(str);
				loadMap(obj);
				MainController.$.view.showBattleMap(callBack);
			}
			_textloader.load(_requrl);
		}
		
		//FileReference　選択が終わった後の処理
		private static function onFileReference_Select(e:Event):void
		{
			var fr:FileReference = null;
			fr = e.target as FileReference;
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
				var strData:String = barrDat.readMultiByte(barrDat.length, "shift-jis");
				
				if (strData.indexOf(Crypt.CODE) == 0)
				{
					strData = strData.replace(Crypt.CODE, "");
					strData = Crypt.decrypt(strData);
				}
				
				//改行の変更
				var obj:Object = JSON.parse(strData);
				loadMap(obj);
				MainController.$.view.showBattleMap();
			}
			
			fr.load(); //ロード開始
		}
		
		
		/**マップデータ保存*/
		public static function saveMapData():void
		{
			var data:Object = new Object();
			data.tip = new Object();
			data.width = MainController.$.view.battleMap.mapWidth;
			data.height = MainController.$.view.battleMap.mapHeight;
			
			for (var i:int = 0; i < MainController.$.view.battleMap.tip[0].length; i++)
			{
				
				data.tip[i] = new Object();
				data.tip[i].name = new Object();
				//data.tip[i].url = new Object();
				data.tip[i].terrain = new Object;
				data.tip[i].name[0] = MainController.$.view.battleMap.tip[0][i].tipName;
				//data.tip[i].url[0] = MainController.$.view.battleMap.tip[0][i].url;
				data.tip[i].name[1] = MainController.$.view.battleMap.tip[1][i].tipName;
				//data.tip[i].url[1] = MainController.$.view.battleMap.tip[1][i].url;
				data.tip[i].name[2] = MainController.$.view.battleMap.tip[2][i].tipName;
				//data.tip[i].url[2] = MainController.$.view.battleMap.tip[2][i].url;
				data.tip[i].terrain.type = MainController.$.view.battleMap.terrain[i].Type;
				data.tip[i].terrain.cost = MainController.$.view.battleMap.terrain[i].Cost;
				data.tip[i].terrain.category = MainController.$.view.battleMap.terrain[i].Category;
				data.tip[i].terrain.defComp = MainController.$.view.battleMap.terrain[i].DefComp;
				data.tip[i].terrain.agiComp = MainController.$.view.battleMap.terrain[i].AgiComp;
				data.tip[i].terrain.eventNo = MainController.$.view.battleMap.terrain[i].EventNo;
				data.tip[i].terrain.high = MainController.$.view.battleMap.terrain[i].High;
			}
			var json:String = JSON.stringify(data);

			if (Crypt.flg)
			{
				json = Crypt.encrypt(json);
				json = Crypt.CODE + json;
			}
			
			var fr:FileReference = new FileReference();
			
			fr.addEventListener(flash.events.Event.COMPLETE, onComplete);
			fr.save(json, _mapName + ".map"); // ダイアログを表示する
			
			function onComplete(e:flash.events.Event):void
			{
				trace(fr.name); // ユーザが指定したファイル名を表示
			}
		
		}
		
		public static function get mapName():String
		{
			return _mapName;
		}
		
		public static function set mapName(value:String):void
		{
			_mapName = value;
		}
	
	}

}