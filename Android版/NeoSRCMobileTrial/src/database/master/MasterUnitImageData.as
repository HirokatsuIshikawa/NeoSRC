package database.master
{
	import database.user.FaceData;
	import database.user.UnitImageItem;
	import starling.display.Image;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class MasterUnitImageData
	{
		private var _imageList:Vector.<UnitImageItem> = null;
		
		public function MasterUnitImageData()
		{
			_imageList = new Vector.<UnitImageItem>;
		}
		
		public function addUnitImgData(data:Object):void
		{
			var setData:UnitImageItem = new UnitImageItem();
			setData.image = data.img;
			setData.name = data.name;
			
			_imageList.push(setData);
			
		}
		
		public function getUnitImgName(name:String):String
		{
			
			var i:int = 0;
			var imageStr:String = null;
			for (i = 0; i < _imageList.length; i++)
			{
				if (name == _imageList[i].name)
				{
					imageStr = _imageList[i].image;
				}
				
			}
			return imageStr;
		}
		
		public function get imageList():Vector.<UnitImageItem> 
		{
			return _imageList;
		}
	
	}

}