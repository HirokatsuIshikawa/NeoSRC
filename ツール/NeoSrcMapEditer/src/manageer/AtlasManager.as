package manageer
{
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    /**
     * ...
     * @author ishikawa
     */
    public class AtlasManager
    {
        
        public static var mapAtlasList:Vector.<TextureAtlas>;
        public static var mapAtlasNameList:Vector.<String>;
        
        public static function init():void
        {
            mapAtlasList = new Vector.<TextureAtlas>;
            mapAtlasNameList = new Vector.<String>
        }
        
        public static function setAtlas(tex:Texture, xml:XML, url:String):TextureAtlas
        {
            var atlas:TextureAtlas = null;
			for (var i:int = 0; i < mapAtlasNameList.length; i++ )
			{
				if (url == mapAtlasNameList[i])
				{
					atlas = mapAtlasList[i];
					break;
				}
			}
            
            if (atlas == null)
            {
                atlas = new TextureAtlas(tex, xml);
                mapAtlasList.push(atlas);
                mapAtlasNameList.push(url);
            }
            return atlas;
        }
        
        public static function getAtlas(url:String):TextureAtlas
        {
            var atlas:TextureAtlas = null;
            for (var i:int = 0; i < mapAtlasNameList.length; i++ )
			{
				if (url == mapAtlasNameList[i])
				{
					atlas = mapAtlasList[i];
					break;
				}
			}
            return atlas;
        }
        
    
    }

}