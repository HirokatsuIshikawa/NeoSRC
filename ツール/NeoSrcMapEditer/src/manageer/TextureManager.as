package manageer 
{
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class TextureManager 
	{
		
		public static var mapTexList:Vector.<Texture>;
		public static var mapTexNameList:Vector.<String>;
        
		public static function init():void
		{
			mapTexList = new Vector.<Texture>;
            mapTexNameList = new Vector.<String>
		}
		
		
		public static function loadMapTexture(url:String, name:String):Texture
		{
			var tex:Texture = null;
			for (var i:int = 0; i < mapTexNameList.length; i++ )
			{
				if (name == mapTexNameList[i])
				{
					tex = mapTexList[i];
					break;
				}
			}
			
			if (tex == null)
			{
                tex = AtlasManager.getAtlas(url).getTexture(name);
                mapTexList.push(tex);
                mapTexNameList.push(name);
			}
			
			
			return tex;
		}
		
		
	}

}