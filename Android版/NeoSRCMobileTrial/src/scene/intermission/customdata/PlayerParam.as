package scene.intermission.customdata
{
	import common.CommonSystem;
	import system.custom.customData.CData;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class PlayerParam extends CData
	{
		
		public var money:int = 0;
		public var sideName:String = null;
		public var nextEve:String = null;
		public var nowEve:String = null;
		public var clearEve:String = null;
		public var playingMapBGM:String = null;
		public var playingMapBGMVol:Number = 1.0;
		
		public var intermissonData:Vector.<ShowInterMissionData> = null;
		public var intermissionBackURL:String = null;
		
		/** ローカル変数 */
		public var playerVariable:Vector.<PlayerVariable> = null;
		
		public function PlayerParam()
		{
			sideName = "味方";
			intermissonData = new Vector.<ShowInterMissionData>();
			
			playerVariable = new Vector.<PlayerVariable>();
		}
		
		public function setIntermissionParam(name:String, state:int):void
		{
			var i:int = 0;
			for (i = 0; i < intermissonData.length; i++)
			{
				if (intermissonData[i].name === name)
				{
					intermissonData.splice(i, 1);
					break;
				}
			}
				
			if((int)(CommonSystem.INTERMISSION_DATA[name].show) != state )
			{
				var interMissionItem:ShowInterMissionData = new ShowInterMissionData();
				interMissionItem.setState(name ,state);
				intermissonData.push(interMissionItem);
			}
		}
		
		//グローバル以外の変数を削除
		public function refreshVariable():void
		{
			var i:int = 0;
			for (i = 0; i < playerVariable.length; i++)
			{
				if (!playerVariable[i].getGlobal())
				{
					playerVariable[i] = null;
					playerVariable.splice(i, 1);
					i--;
				}
			}
		}
		
		override public function loadObject(data:Object):void
		{
			var i:int = 0;
			super.loadObject(data);
			
			for (i = 0; i < playerVariable.length; i++)
			{
				playerVariable[i].setGlobal(true);
			}
			var j:int = 0;
		}
	}
}