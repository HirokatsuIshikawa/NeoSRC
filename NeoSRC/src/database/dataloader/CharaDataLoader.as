package database.dataloader
{
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import common.CommonSystem;
	import converter.parse.BuffDataParse;
	import converter.parse.CharaDataParse;
	import converter.parse.ImgDataParse;
	import converter.parse.MessageDataParse;
	import database.master.MasterBattleMessage;
	import database.master.MasterBuffData;
	import database.master.MasterCharaData;
	import database.user.FaceData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.filesystem.File;
	import scene.main.MainController;
	
	/**
	 * ...
	 * キャラデータとついては居るけど、全体的な作品データ読み込み用
	 * @author
	 */
	public class CharaDataLoader
	{
		public static const TYPE_UNIT:String = "Unit";
		public static const TYPE_CHARA:String = "Chara";
		public static const TYPE_BUFF:String = "Buff";
		public static const TYPE_MESSAGE:String = "Message";
		
		/**読み込みデータ*/
		private var _loadData:Object = null;
		private var _loadPathList:Vector.<String> = null;
		/**コールバック*/
		private var _callBack:Function = null;
		
		/**データローダー*/
		private var _dataLoader:BulkLoader = null;
		
		private var _dataNameList:Vector.<String> = null;
		
		public function CharaDataLoader()
		{
		
		}
		
		/**画像データ読み込み*/
		public function loadCharaData(name:Vector.<String>, type:String, callBack:Function):void
		{
			var count:int = 0;
			_callBack = callBack;
			_dataLoader = new BulkLoader();
			_dataNameList = new Vector.<String>;
			
			for (var i:int = 0; i <= name.length; i++)
			{
				var fileName:String = "";
				if (i == name.length)
				{
					fileName = CommonSystem.SCENARIO_PATH + "data/" + type;
				}
				else
				{
					fileName = CommonSystem.SCENARIO_PATH + "data/" + name[i] + "/" + type;
				}
				
				var file:File = File.applicationDirectory.resolvePath(fileName + ".srcdat");
				
				if (!file.exists)
				{
					file = File.applicationDirectory.resolvePath(fileName + ".txt");
					
					if (!file.exists)
					{
						continue;
					}
				}
				
				var path:String = file.nativePath;
				//MainController.$.view.debugText.addText("<br>path_"+ i + ":" + path);
				_dataLoader.add(CommonSystem.FILE_HEAD + path);
				_dataNameList[count] = CommonSystem.FILE_HEAD + path;
				
				count++;
					//MainController.$.view.debugText.addText("<br>path_"+ i + ":" + path);
			}
			
			//MainController.$.view.debugText.addText("inPath:" + _dataNameList[0]);
			//読み込むデータがなければ飛ばす
			if (count > 0)
			{
				switch (type)
				{
				case TYPE_UNIT: 
					_dataLoader.addEventListener(BulkLoader.COMPLETE, loadUnitDataListComp);
					break;
				case TYPE_CHARA: 
					_dataLoader.addEventListener(BulkLoader.COMPLETE, loadImgDataListComp);
					break;
				case TYPE_BUFF: 
					_dataLoader.addEventListener(BulkLoader.COMPLETE, loadBuffDataListComp);
					break;
				case TYPE_MESSAGE: 
					_dataLoader.addEventListener(BulkLoader.COMPLETE, loadMessageDataListComp);
					break;
				}
				_dataLoader.addEventListener(BulkLoader.PROGRESS, onProgress);
				_dataLoader.addEventListener(BulkLoader.ERROR, onError);
				trace("キャラリストデータ読み込み。");
				MainController.$.view.debugText.addText("キャラリストデータ読み込み開始");
				_dataLoader.start();
			}
			else
			{
				callBack();
			}
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
		private function loadUnitDataListComp(e:Event):void
		{
			
			//var data:Vector.<MasterCharaData> = new Vector.<MasterCharaData>();
			
			_dataLoader.removeEventListener(BulkLoader.COMPLETE, loadUnitDataListComp);
			_dataLoader.removeEventListener(BulkLoader.PROGRESS, onProgress);
			_dataLoader.removeEventListener(BulkLoader.ERROR, onError);
			
			/*
			   for (var i:int = 0; i < _dataNameList.length; i++)
			   {
			   data.push(loaddata);
			   }
			 */
			
			MainController.$.view.debugText.addText("キャラデータ取得");
			//モデルに、キャラデータを入れる
			for (var j:int = 0; j < _dataNameList.length; j++)
			{
				//MainController.$.view.debugText.addText("順番：" + j + ":" + _dataNameList.length);
				var data:Object;
				if (_dataNameList[j].indexOf(".srcdat") >= 0)
				{
					data = JSON.parse(_dataLoader.getText(_dataNameList[j]));
						//var length:int = CommonDef.objectLength(data);
				}
				else
				{
					data = CharaDataParse.parseCharaData(_dataLoader.getText(_dataNameList[j]));
				}
				
				for (var i:int = 0; i < data.length; i++)
				{
					
					//MainController.$.view.debugText.addText("データ読み込み" + j + ":" + i);
					var charaData:MasterCharaData = new MasterCharaData(data[i]);
					MainController.$.view.debugText.addText(charaData.name);
					MainController.$.model.masterCharaData.push(charaData);
				}
			}
			
			_callBack();
		
		}
		
		/**データリスト読み込み完了*/
		private function loadImgDataListComp(e:Event):void
		{
			var i:int = 0;
			var j:int = 0;
			_dataLoader.removeEventListener(BulkLoader.COMPLETE, loadImgDataListComp);
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
		
		/**バフリスト読み込み完了*/
		private function loadBuffDataListComp(e:Event):void
		{
			var i:int = 0;
			var j:int = 0;
			//イベント消去
			_dataLoader.removeEventListener(BulkLoader.COMPLETE, loadBuffDataListComp);
			_dataLoader.removeEventListener(BulkLoader.PROGRESS, onProgress);
			_dataLoader.removeEventListener(BulkLoader.ERROR, onError);
			
			MainController.$.view.debugText.addText("バフデータ取得");
			
			//モデルに、キャラデータを入れる
			for (i = 0; i < _dataNameList.length; i++)
			{
				var data:Object;
				if (_dataNameList[i].indexOf(".srcdat") >= 0)
				{
					data = JSON.parse(_dataLoader.getText(_dataNameList[i]));
				}
				else
				{
					data = BuffDataParse.parseBuffData(_dataLoader.getText(_dataNameList[i]));
				}
				
				for (j = 0; j < data.length; j++)
				{
					var buffData:MasterBuffData = new MasterBuffData();
					buffData.setData(j, data[j]);
					MainController.$.model.masterBuffData.push(buffData);
				}
				
			}
			
			_callBack();
		
		}
		
		
		/**バフリスト読み込み完了*/
		private function loadMessageDataListComp(e:Event):void
		{
			var i:int = 0;
			var j:int = 0;
			//イベント消去
			_dataLoader.removeEventListener(BulkLoader.COMPLETE, loadMessageDataListComp);
			_dataLoader.removeEventListener(BulkLoader.PROGRESS, onProgress);
			_dataLoader.removeEventListener(BulkLoader.ERROR, onError);
			
			MainController.$.view.debugText.addText("メッセージデータ取得");
			
			//メッセージを入れる
			for (i = 0; i < _dataNameList.length; i++)
			{
				var data:Object;
				if (_dataNameList[i].indexOf(".srcdat") >= 0)
				{
					data = JSON.parse(_dataLoader.getText(_dataNameList[i]));
				}
				else
				{
					data = MessageDataParse.parseData(_dataLoader.getText(_dataNameList[i]));
				}
				
				for (var key:String in data)
				{
					var messageData:MasterBattleMessage = new MasterBattleMessage();
					messageData.setData(key, data[key]);
					MainController.$.model.masterBattleMessageData.push(messageData);
				}
			}
			
			_callBack();
		
		}
	
	
	}

}