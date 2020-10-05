package system
{
	import common.CommonDef;
	import common.CommonLanguage;
	import common.CommonSystem;
	import database.dataloader.CharaDataLoader;
	import database.dataloader.single.SingleTxtLoader;
	import flash.filesystem.File;
	import starling.assets.AssetManager;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ...
	 */
	public class InitialLoader
	{
		
		/**マネージャー*/
		private static var _manager:InitialLoader = new InitialLoader();
		
		/**instance getter
		 *
		 * @return UserImageインスタンス
		 * */
		public static function get $():InitialLoader
		{
			return _manager;
		}
		
		/**コンストラクタ*/
		public function InitialLoader()
		{
			if (_manager)
			{
				throw new ArgumentError("UserImage is singleton class");
			}
		}
		
		/**基礎設定システムデータ*/
		//private var _systemData:Object = null;
		private var _loadDataFolderName:Vector.<String> = null;
		
		/**キャラデータローダー*/
		private var _charaLoader:CharaDataLoader = null;
		
		/**ロード関数リスト*/
		private var _loadFuncList:Vector.<Function> = null;
		private var _loadFuncCount:int = 0;
		
		public function loadAssetStart(data:Object):void
		{
			
			if (data.hasOwnProperty("money"))
			{
				CommonSystem.MONEY_NAME = data.money;
			}
			else
			{
				CommonSystem.MONEY_NAME = "資金";
			}
			//_systemData = data;
			CommonSystem.TALK_TYPE = data.talk_type;
			CommonSystem.START_EVE = data.startEve;
			CommonSystem.SAVE_NAME = data.saveName;
			//強化資金
			if (data.hasOwnProperty("strengthMoney"))
			{
				CommonSystem.setStrengthMoney(data.strengthMoney);
			}
			MainController.$.model.playerParam.nextEve = data.startEve;
			//セーブデータ数設定・仮で最大50
			CommonSystem.SAVE_NUM = data.saveNum;
			CommonSystem.INTERMISSION_DATA = data.interMission;
			if (CommonSystem.SAVE_NUM > 50)
			{
				CommonSystem.SAVE_NUM = 50;
			}
			
			var i:int = 0;
			_loadDataFolderName = new Vector.<String>();
			for (i = 0; i < data.loadDataList.length; i++)
			{
				_loadDataFolderName.push(data.loadDataList[i]);
			}
			
			MainController.$.imgAsset = new AssetManager();
			MainController.$.mapTipAsset = new AssetManager();
			;
			MainController.$.view.waitDark(true);
			InitialLoader.$.loadAsset();
		}
		
		/**画像アセットロード*/
		public function loadAsset():void
		{
			MainController.$.imgAsset = new AssetManager();
			var file:File = new File(CommonSystem.SCENARIO_PATH);
			//tileAssetList[_assetLoadCount].keepAtlasXmls = true;
			MainController.$.imgAsset.verbose = true;
			MainController.$.imgAsset.enqueue(file.resolvePath("asset"));
			MainController.$.imgAsset.enqueue();
			//読み込み開始
			MainController.$.imgAsset.loadQueue(compLoadAsset, null, progressLoadAsset);
		}
		
		private function compLoadAsset():void
		{
			loadMapTipAsset();
		}
		
		private function progressLoadAsset(ratio:Number):void
		{
			
			MainController.$.view.darkField.setLoadingText("Asset:" + CommonDef.formatZero(int(ratio * 100), 3));
		}
		
		/**画像アセットロード*/
		public function loadMapTipAsset():void
		{
			MainController.$.mapTipAsset = new AssetManager();
			var file:File = new File(CommonSystem.SCENARIO_PATH + "//map");
			//tileAssetList[_assetLoadCount].keepAtlasXmls = true;
			MainController.$.mapTipAsset.verbose = true;
			MainController.$.mapTipAsset.enqueue(file.resolvePath("tipimg"));
			MainController.$.mapTipAsset.enqueue();
			//読み込み開始
			MainController.$.mapTipAsset.loadQueue(compMapAsset, null, progressMapAsset);
		}
		
		private function compMapAsset():void
		{
			MainController.$.view.darkField.initLoadingText();
			loadListStart();
		}
		
		private function progressMapAsset(ratio:Number):void
		{
			
			MainController.$.view.darkField.setLoadingText("MapTip:" + CommonDef.formatZero(int(ratio * 100), 3));
		}
		
		private function loadListStart():void
		{
			//読み込みリスト
			_loadFuncList = Vector.<Function>([ //
			dataLoadStart, //
			loadBuffData, //
			unitLoadStart, //
			loadTalkImgData, //
			loadBattleMessageStart, //
            loadCommanderMessageStart, //
			//loadCommonParticle //
			]);
			//初期化
			_loadFuncCount = 0;
			_loadFuncList[_loadFuncCount]();
		}
		
		//次の読み込みを行う
		private function loadListNext():void
		{
			MainController.$.view.debugMessage("カウント" + _loadFuncCount);
			_loadFuncCount++;
			if (_loadFuncCount < _loadFuncList.length)
			{
				_loadFuncList[_loadFuncCount]();
			}
			else
			{
				initLoadComp();
			}
		}
		
		// ユニットデータロード開始
		public function dataLoadStart():void
		{
			//キャラデータ読み込み
			_charaLoader = new CharaDataLoader();
			
			MainController.$.view.debugMessage("キャラ読み込み開始");
			//バフ読み込み開始
			//loadBuffData();
			loadListNext();
		}
		
		//バフ→ユニット→画像→パーティクル
		
		// バフデータ読み込み
		private function loadBuffData():void
		{
			if (_loadDataFolderName.length <= 0)
			{
				loadListNext();
			}
			else
			{
				_charaLoader.loadCharaData(_loadDataFolderName, CharaDataLoader.TYPE_BUFF, loadListNext);
			}
		}
		
		// キャラデータ読み込み開始
		private function unitLoadStart():void
		{
			if (_loadDataFolderName.length <= 0)
			{
				loadListNext();
			}
			else
			{
				_charaLoader.loadCharaData(_loadDataFolderName, CharaDataLoader.TYPE_UNIT, loadListNext);
			}
		}
		
		// 会話キャラ・ユニットデータ読み込み
		private function loadTalkImgData():void
		{
			if (_loadDataFolderName.length <= 0)
			{
				loadListNext();
			}
			else
			{
				_charaLoader.loadCharaData(_loadDataFolderName, CharaDataLoader.TYPE_CHARA, loadListNext);
			}
		}
		
		// バトルメッセージデータ読み込み開始
		private function loadBattleMessageStart():void
		{
			if (_loadDataFolderName.length <= 0)
			{
				loadListNext();
			}
			else
			{
				_charaLoader.loadCharaData(_loadDataFolderName, CharaDataLoader.TYPE_MESSAGE, loadListNext);
			}
		}
        
        
		// 軍師データ読み込み開始
		private function loadCommanderMessageStart():void
		{
			if (_loadDataFolderName.length <= 0)
			{
				loadListNext();
			}
			else
			{
				_charaLoader.loadCharaData(_loadDataFolderName, CharaDataLoader.TYPE_COMMANDER, loadListNext);
			}
		}
		
		// コモンパーティクルPEX読み込み
		/*
		   private function loadCommonParticle():void
		   {
		   CommonDef.LAUNCH_XML = MainController.$.imgAsset[CommonSystem.ASSET_IMG].getXml("launch");
		   loadListNext();
		   }
		 */
		
		/**キャラデータ読み込み完了後*/
		private function initLoadComp():void
		{
			MainController.$.view.debugMessage("キャラデータ読み込み完了");
			
			// 言語設定
			CommonLanguage.setLanguage(CommonLanguage.LANGUAGE_JP);
			
			//CommonDef.INTERMISSION_TEX = MainController.$.imgAsset[CommonSystem.ASSET_IMG].getTextureAtlas("intermission");
			//CommonDef.COMMON_TEX = MainController.$.imgAsset[CommonSystem.ASSET_IMG].getTextureAtlas("system");
			MainController.$.view.exitBtnSet();
			
			//キャラ画像読み込み
			MainController.$.view.loadImgComp();
		}
	
	}

}