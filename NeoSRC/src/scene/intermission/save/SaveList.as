package scene.intermission.save
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImgButton;
	import starling.events.Event;
	import system.file.DataLoad;
	import scene.intermission.save.item.DataListItem;
	import scene.intermission.save.item.SaveListItem;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class SaveList extends DataList
	{
		
		private var _saveList:Vector.<SaveListItem> = null;
		private var _closeBtn:CImgButton = null;
		protected var _saveCompCount:int = 0;
		
		public function SaveList()
		{
			super();
			setListItem();
		}
		
		override public function dispose():void
		{
			CommonDef.disposeList(_saveList);
			
			if (_closeBtn)
			{
				removeChild(_closeBtn);
				_closeBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeSaveList);
				_closeBtn.dispose();
			}
			_closeBtn = null;
			
			super.dispose();
		}
		
		protected function setListItem():void
		{
			var i:int = 0;
			var saveMax:int = CommonSystem.SAVE_NUM;
			_saveList = new Vector.<SaveListItem>();
			_saveCompCount = 0;
			
			
			MainController.$.view.waitDark(true);
			for (i = 0; i < saveMax; i++)
			{
				var saveCount:int = i + 1;
				var saveName:String = CommonSystem.SAVE_NAME.replace("{0}", CommonDef.formatZero(saveCount, 2) + ".srcsav");
				DataLoad.loadSaveData(saveName, i, setListData);
			}
			
			MAX_LIST_AREA = (DataListItem.LIST_HEIGHT + 20) * saveMax - 20;
			
			_closeBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_Return"));
			_closeBtn.x = 820;
			_closeBtn.y = 460;

			_closeBtn.width = 96;
			_closeBtn.height = 64;
			_closeBtn.addEventListener(Event.TRIGGERED, MainController.$.view.interMission.closeSaveList);
			addChild(_closeBtn);
		}
		
		protected function setListData(data:String, num:int):void
		{
			var saveData:SaveListItem = new SaveListItem(MainController.$.view.interMission.returnSaveFunc, num, data);
			saveData.x = 0;
			saveData.y = (DataListItem.LIST_HEIGHT + 20) * num;
			_listSpr.addChild(saveData);
			_saveList.push(saveData);
			
			_saveCompCount++;
			if (_saveCompCount >= CommonSystem.SAVE_NUM)
			{
				MainController.$.view.waitDark(false);
			}
		}
	
	}

}