package scene.intermission.save
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImgButton;
	import flash.filesystem.File;
	import starling.events.Event;
	import system.file.DataLoad;
	import scene.intermission.save.item.DataListItem;
	import scene.intermission.save.item.LoadListItem;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class LoadList extends DataList
	{
		
		private var _loadList:Vector.<LoadListItem> = null;
		protected var _loadCompFunc:Function = null;
		protected var _loadCompCount:int = 0;
		protected var _saveFileFlg:Boolean = false;
		protected var _newGameBtn:CImgButton = null;
		protected var _continueBtn:CImgButton = null;
		
		public function LoadList(func:Function)
		{
			super();
			_loadCompFunc = func;
			setListItem();
		}
		
		override public function dispose():void
		{
			CommonDef.disposeList(_loadList);
			
			
			removeChild(_newGameBtn);
			_newGameBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.pushNewGameBtn);
			_newGameBtn.dispose();
			_newGameBtn = null;
			
			removeChild(_continueBtn);
			_continueBtn.removeEventListener(Event.TRIGGERED, MainController.$.view.pushContinueBtn);
			_continueBtn.dispose();
			_continueBtn = null;
			
			_loadCompFunc = null;
			super.dispose();
		}
		
		protected function setListItem():void
		{
			
			var i:int = 0;
			var loadMax:int = CommonSystem.SAVE_NUM;
			_loadCompCount = 0;
			_saveFileFlg = false;
			_loadList = new Vector.<LoadListItem>();
			
			for (i = 0; i < loadMax; i++)
			{
				var loadCount:int = i + 1;
				var loadName:String = CommonSystem.SAVE_NAME.replace("{0}", CommonDef.formatZero(loadCount, 2) + ".srcsav");
				DataLoad.loadSaveData(loadName, i, setListData);
			}
			
			MAX_LIST_AREA = (DataListItem.LIST_HEIGHT + 20) * loadMax - 20;
			
			_newGameBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_newgame"));

			_newGameBtn.x = 820;
			_newGameBtn.y = 360;
			_newGameBtn.width = 96;
			_newGameBtn.height = 64;
			_newGameBtn.addEventListener(Event.TRIGGERED, MainController.$.view.pushNewGameBtn);
			addChild(_newGameBtn);
			
			_continueBtn = new CImgButton(MainController.$.imgAsset.getTexture("btn_QuickLoad"));

			_continueBtn.x = 820;
			_continueBtn.y = 460;
			_continueBtn.width = 96;
			_continueBtn.height = 64;
			_continueBtn.addEventListener(Event.TRIGGERED, MainController.$.view.pushContinueBtn);
			
			var continueName:String = CommonSystem.SAVE_NAME.replace("{0}", "中断データ");
			var file:File =  File.desktopDirectory.resolvePath(CommonSystem.SCENARIO_PATH + "save/" + continueName + ".srcsav")

			if (file.exists)
			{
				_saveFileFlg = true;
				addChild(_continueBtn);
			}
			
		}
		
		protected function setListData(data:String, num:int):void
		{
			var loadData:LoadListItem = new LoadListItem(MainController.$.view.returnLoadSaveData, num, data);
			
			if (data != null)
			{
				_saveFileFlg = true;
			}
			
			loadData.x = 0;
			loadData.y = (DataListItem.LIST_HEIGHT + 20) * num;
			_listSpr.addChild(loadData);
			_loadList.push(loadData);
			
			_loadCompCount++;
			if (_loadCompCount >= CommonSystem.SAVE_NUM)
			{
				_loadCompFunc(_saveFileFlg);
			}
		}
	
	}

}