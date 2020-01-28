package scene.intermission.save.item
{
	import common.CommonDef;
	import common.CommonSystem;
	import starling.events.Event;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class LoadListItem extends DataListItem
	{
		protected var _saveFunc:Function = null;
		protected var _number:int = 0;
		protected var _loadData:Object = null;
		
		public function LoadListItem(func:Function, num:int, data:String)
		{
			
			super();
			_number = num;
			
			if (data != null)
			{
				var listData:Object = JSON.parse(data);
				_noText.text = "データ" + (num + 1);
				if (listData.playerData.hasOwnProperty("clearEve"))
				{
					if (listData.playerData.clearEve != null)
					{
						var str:String = listData.playerData.clearEve;
						
						_clearText.text = str.replace(".srceve", "");
					}
				}
				
				_timeText.text = listData.time;
				_saveBtn.changeImg(MainController.$.imgAsset.getTexture("btn_listload"));
				_saveBtn.visible = true;
				setEnable(true);
				_loadData = listData;
				_saveFunc = func(_loadData);
				_saveBtn.addEventListener(Event.TRIGGERED, _saveFunc);
			}
			else
			{
				_saveBtn.visible = false;
				_noText.text = "空きデータ";
				_clearText.text = "";
				_timeText.text = "";
				setEnable(false);
			}
		
		}
		
		override public function dispose():void
		{
			if (_saveBtn != null)
			{
				_saveBtn.removeEventListener(Event.TRIGGERED, _saveFunc);
			}
			
			_saveFunc = null;
			if (_loadData != null)
			{
				_loadData = null;
			}
			
			super.dispose();
		}
	
	}

}