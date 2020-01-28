package system.file
{
	import common.CommonDef;
	import common.CommonSystem;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import code.org.coderepos.text.encoding.Jcode;
	import system.Crypt;
	import scene.intermission.save.ConfirmPopup;
	import scene.main.MainController;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class DataSave
	{
		
		public static function Save(name:String, file:String, data:Object, func:Function = null, ary:Array = null):void
		{
			var json:String = JSON.stringify(data);
			var fr:FileReference = new FileReference();
			
			fr.addEventListener(Event.COMPLETE, onComplete);
			fr.save(json, name + file); // ダイアログを表示する
			function onComplete(e:Event):void
			{
				if (func != null)
				{
					if (ary != null)
					{
						func(ary);
					}
					else
					{
						func();
					}
				}
				trace(fr.name); // ユーザが指定したファイル名を表示
			}
		}
		
		/**テキスト書き込み*/
		public static function WriteText(name:String, file:String, text:String, func:Function = null, ary:Array = null):void
		{
			
			var byte:ByteArray = Jcode.to_sjis(text);
			var fr:FileReference = new FileReference();
			
			fr.addEventListener(Event.COMPLETE, onComplete);
			fr.save(text, name + file); // ダイアログを表示する
			
			function onComplete(e:Event):void
			{
				if (func != null)
				{
					if (ary != null)
					{
						func(ary);
					}
					else
					{
						func();
					}
				}
				trace(fr.name); // ユーザが指定したファイル名を表示
			}
		}
		
		public static function saveGameFile(saveNum:int):void
		{
			
			MainController.$.view.waitDark(true);
			var i:int = 0;
			var data:Object = new Object();
			var unitList:Object = new Object();
			var nowDate:Date = new Date();
			var nowDateStr:String = "";
			
			CommonDef.formatZero(saveCount, 2)
			nowDateStr += nowDate.fullYear + "/" + CommonDef.formatZero(nowDate.month, 2) + "/" + CommonDef.formatZero(nowDate.date, 2) + " " + CommonDef.formatZero(nowDate.hours, 2) + ":" + CommonDef.formatZero(nowDate.minutes, 2) + ":" + CommonDef.formatZero(nowDate.seconds, 2);
			
			data.playerData = MainController.$.model.playerParam;
			
			/**セーブ用ユニットデータ*/
			for (i = 0; i < MainController.$.model.PlayerUnitData.length; i++)
			{
				unitList[i] = new Object();
				unitList[i].name = MainController.$.model.PlayerUnitData[i].name;
				unitList[i].lv = MainController.$.model.PlayerUnitData[i].nowLv;
				unitList[i].exp = MainController.$.model.PlayerUnitData[i].exp;
				unitList[i].strengthPoint = MainController.$.model.PlayerUnitData[i].strengthPoint;
				unitList[i].customBgmPath = MainController.$.model.PlayerUnitData[i].customBgmPath;
					//unitList[i].name = MainController.$.model.PlayerUnitData[i].name;
			}
			//data.unitList = MainController.$.model.PlayerUnitData;
			data.unitList = unitList;
			data.time = nowDateStr;
			
			var saveCount:int = saveNum + 1;
			var saveName:String = CommonSystem.SAVE_NAME.replace("{0}", CommonDef.formatZero(saveCount, 2) + "");
			var json:String = JSON.stringify(data);
			var path:File = File.desktopDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "save/" + saveName + ".srcsav");
			
			//DataSave.Save( CommonSystem.SCENARIO_PATH + "save/テストセーブ", ".srcsav", data);
			//DataSave.Save( "テストセーブ", ".srcsav", data);
			if (path != null)
			{
				FileSystem.outPutText(json, path);
			}
			else
			{
				
			}
			
			MainController.$.view.waitDark(false);
		}
		
		//中断セーブデータ
		public static function saveMapGameFile():void
		{
			
			MainController.$.view.waitDark(true);
			var i:int = 0;
			var j:int = 0;
			var data:Object = new Object();
			var unitList:Object = new Object();
			var mapDateList:Object = new Object();
			var nowDate:Date = new Date();
			var nowDateStr:String = "";
			
			nowDateStr += nowDate.fullYear + "/" + CommonDef.formatZero(nowDate.month, 2) + "/" + CommonDef.formatZero(nowDate.date, 2) + " " + CommonDef.formatZero(nowDate.hours, 2) + ":" + CommonDef.formatZero(nowDate.minutes, 2) + ":" + CommonDef.formatZero(nowDate.seconds, 2);
			
			data.playerData = MainController.$.model.playerParam;
			data.mapPath = MainController.$.model.mapPath;
			
			/**セーブ用ユニットデータ*/
			for (i = 0; i < MainController.$.model.PlayerUnitData.length; i++)
			{
				unitList[i] = new Object();
				unitList[i].name = MainController.$.model.PlayerUnitData[i].name;
				unitList[i].lv = MainController.$.model.PlayerUnitData[i].nowLv;
				unitList[i].exp = MainController.$.model.PlayerUnitData[i].exp;
				unitList[i].strengthPoint = MainController.$.model.PlayerUnitData[i].strengthPoint;
				unitList[i].customBgmPath = MainController.$.model.PlayerUnitData[i].customBgmPath;
			}
			data.unitList = unitList;
			
			/**セーブ用マップユニットデータ*/
			for (i = 0; i < MainController.$.map.sideState.length; i++)
			{
				//勢力データ
				mapDateList[i] = new Object();
				mapDateList[i].name = MainController.$.map.sideState[i].name;
				mapDateList[i].state = MainController.$.map.sideState[i].state;
				mapDateList[i].unitDate = new Object();
				for (j = 0; j < MainController.$.map.sideState[i].battleUnit.length; j++)
				{
					//基本データ
					mapDateList[i].unitDate[j] = new Object();
					
					mapDateList[i].unitDate[j].masterName = MainController.$.map.sideState[i].battleUnit[j].masterData.name;
					mapDateList[i].unitDate[j].id = MainController.$.map.sideState[i].battleUnit[j].id;
					mapDateList[i].unitDate[j].battleId = MainController.$.map.sideState[i].battleUnit[j].battleId;
					
					mapDateList[i].unitDate[j].name = MainController.$.map.sideState[i].battleUnit[j].name;
					mapDateList[i].unitDate[j].lv = MainController.$.map.sideState[i].battleUnit[j].nowLv;
					mapDateList[i].unitDate[j].exp = MainController.$.map.sideState[i].battleUnit[j].exp;
					mapDateList[i].unitDate[j].strengthPoint = MainController.$.map.sideState[i].battleUnit[j].strengthPoint;
					mapDateList[i].unitDate[j].customBgmPath = MainController.$.map.sideState[i].battleUnit[j].customBgmPath;
					//マップ上データ
					mapDateList[i].unitDate[j].HP = MainController.$.map.sideState[i].battleUnit[j].nowHp;
					mapDateList[i].unitDate[j].FP = MainController.$.map.sideState[i].battleUnit[j].nowFp;
					mapDateList[i].unitDate[j].TP = MainController.$.map.sideState[i].battleUnit[j].nowTp;
					
					mapDateList[i].unitDate[j].posX = MainController.$.map.sideState[i].battleUnit[j].PosX;
					mapDateList[i].unitDate[j].posY = MainController.$.map.sideState[i].battleUnit[j].PosY;
					
					mapDateList[i].unitDate[j].moveCount = MainController.$.map.sideState[i].battleUnit[j].moveCount;
					
					mapDateList[i].unitDate[j].joinFlg = MainController.$.map.sideState[i].battleUnit[j].joinFlg;
					mapDateList[i].unitDate[j].moveState = MainController.$.map.sideState[i].battleUnit[j].moveState;
					mapDateList[i].unitDate[j].launched = MainController.$.map.sideState[i].battleUnit[j].launched;
					mapDateList[i].unitDate[j].alive = MainController.$.map.sideState[i].battleUnit[j].alive;
					mapDateList[i].unitDate[j].commandType = MainController.$.map.sideState[i].battleUnit[j].commandType;
					mapDateList[i].unitDate[j].onMap = MainController.$.map.sideState[i].battleUnit[j].onMap;
					mapDateList[i].unitDate[j].buffList = MainController.$.map.sideState[i].battleUnit[j].buffList;
				}
			}
			
			var mapEventList:Object = new Object();
			for (i = 0; i < MainController.$.view.eveManager.eventList.length; i++)
			{
				mapEventList[i] = new Object();
				mapEventList[i].label = MainController.$.view.eveManager.eventList[i].label;
				mapEventList[i].param = MainController.$.view.eveManager.eventList[i]._param;
				mapEventList[i].type = MainController.$.view.eveManager.eventList[i].type;
			}
			
			data.mapDateList = mapDateList;
			data.time = nowDateStr;
			data.mapEventList = mapEventList;
			
			var saveName:String = CommonSystem.SAVE_NAME.replace("{0}", "中断データ");
			var json:String = JSON.stringify(data);
			var path:File = File.desktopDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "save/" + saveName + ".srcsav");
			
			//json = Crypt.encrypt(json);
			
			if (path != null)
			{
				FileSystem.outPutText(json, path);
			}
			else
			{
				
			}
			
			MainController.$.view.waitDark(false);
		}
	
	}

}