package database.user 
{
	import starling.textures.Texture;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class TextureManagerItem 
	{
        public var tex:Texture;
        public var name:String;
        public var url:String;
		
		public function dispose():void
		{
			if (tex != null)
			{
				tex.dispose();
			}
			tex = null;
			name = null;
			url = null;
			
		}
		
		
		
	}

}