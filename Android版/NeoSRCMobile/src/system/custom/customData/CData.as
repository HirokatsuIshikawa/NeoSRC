package system.custom.customData
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import main.MainController;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CData
	{
		public function loadObject(data:Object):void
		{
			loadData(this, data);
		}
		
		public function loadData(obj:Object, data:Object):void
		{
			var key:String = null;
			for (key in data)
			{
				//タイプを所持していたら優先で設定
				if (data.hasOwnProperty("type"))
				{
					obj.type = data.type;
				}
				
				if (data[key] is Array)
				{
					var i:int = 0;
					var myClassName:String = getQualifiedClassName(obj[key]).replace("::", ".");
					myClassName = myClassName.replace("__AS3__.vec.Vector.<", "");
					myClassName = myClassName.replace(">", "");
					var myClass:Class = Class(getDefinitionByName(myClassName));
					for (i = 0; i < data[key].length; i++)
					{
						var item:* = new myClass();
						//obj[key][i] = new myClass();
						loadData(item, data[key][i]);
						obj[key].push(item);
					}
					
				}
				else
				{
					if (obj.hasOwnProperty(key))
					{
						obj[key] = data[key];
					}
					else
					{
						MainController.$.view.alertMessage("読み込んだデータ内に無いデータがあります", key);
					}
				}
			}
		}
	}
}