package database.dataloader
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import code.org.coderepos.text.encoding.Jcode;
	import common.CommonDef;
	import converter.parse.CharaDataParse;
	import converter.parse.ImgDataParse;
	import converter.parse.SystemParse;
	import database.master.MasterCharaData;
	import database.user.FaceData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import common.CommonSystem;
	import flash.utils.ByteArray;
	import main.MainController;

	/**
	 * ...
	 * @author
	 */
	public class CharaImgDataLoader
	{
		/**読み込みデータ*/
		private var _loadData:Object = null;
		private var _loadPathList:Vector.<String> = null;
		/**コールバック*/
		private var _callBack:Function = null;

		/**データローダー*/
		private var _dataLoader:BulkLoader = null;
		
		private var _dataNameList:Vector.<String> = null;
		
		public function CharaImgDataLoader()
		{

		}
				
		/**画像データ読み込み*/
		public function loadCharaImgData(name:Vector.<String>, callBack:Function):void
		{
			_callBack = callBack;
			_dataLoader = new BulkLoader();
			_dataNameList = new Vector.<String>;
			
			for (var i:int = 0; i < name.length; i++ ) {
				var file:File = File.applicationDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "data/talk/" + name[i] + ".srcimg");
				if (!file.exists)
				{
					file = File.applicationDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "data/talk/" + name[i] + ".txt");
				}
				
				
				var path:String = file.nativePath;
				//MainController.$.view.debugText.addText("<br>path_"+ i + ":" + path);
				_dataLoader.add(CommonSystem.FILE_HEAD + path);				
				_dataNameList[i] = CommonSystem.FILE_HEAD + path;
				
				//MainController.$.view.debugText.addText("<br>path_"+ i + ":" + path);
			}
			
				//MainController.$.view.debugText.addText("inPath:" + _dataNameList[0]);
			_dataLoader.addEventListener(BulkLoader.COMPLETE, loadDataListComp);
			_dataLoader.addEventListener(BulkLoader.PROGRESS, onProgress);
			_dataLoader.addEventListener(BulkLoader.ERROR, onError);
			trace("キャラ画像リストデータ読み込み。");			
			MainController.$.view.debugText.addText("キャラ画像リストデータ読み込み開始");
			_dataLoader.start();
		}
		


		/**読み込み度数*/
		public function onProgress(e:BulkProgressEvent):void
		{
			trace("e.percentLoaded:", e.percentLoaded, "e.weightPercent:", e.weightPercent, "e.ratioLoaded:", e.ratioLoaded);
			//MainController.$.view.debugText.addText("e.percentLoaded:" + e.percentLoaded);
		}

		/**バルクローダーエラー*/
		private function onError(e:ErrorEvent):void
		{
			
			MainController.$.view.debugText.addText("キャラデータエラー");
			var loader:BulkLoader = e.target as BulkLoader;
			trace("エラーが発生しました。");
			loader.removeFailedItems();
		}
		
		/**データリスト読み込み完了*/
		private function loadDataListComp(e:Event):void
		{
			var i:int = 0;
			var j:int = 0;
			_dataLoader.removeEventListener(BulkLoader.COMPLETE, loadDataListComp);
			_dataLoader.removeEventListener(BulkLoader.PROGRESS, onProgress);
			_dataLoader.removeEventListener(BulkLoader.ERROR, onError);
			
			MainController.$.view.debugText.addText("キャラ画像データ取得");
			//モデルに、キャラデータを入れる
			for (i = 0; i < _dataNameList.length; i++)
			{
				var data:Object;
				if (_dataNameList[i].indexOf(".srcimg") >= 0)
				{
					data = JSON.parse(_dataLoader.getText(_dataNameList[i]));
				}
				else
				{
					data = ImgDataParse.parseCharaImgData(_dataLoader.getText(_dataNameList[i]));
				}
				
				if (data.hasOwnProperty("charaData"))
				{
					for (j = 0; j < data.charaData.length; j++)
					{
						var faceData:FaceData = new FaceData(data.charaData[j]);
						MainController.$.model.masterCharaImageData.push(faceData);
					}
				}
				
				if (data.hasOwnProperty("unitData"))
				{
					for (j = 0; j < data.unitData.length; j++)
					{
						MainController.$.model.masterUnitImageData.addUnitImgData(data.unitData[j]);
					}
				}
					
			}
			
			_callBack();
		
		}

	}

}