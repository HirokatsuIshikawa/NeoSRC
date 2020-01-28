package system.custom.customSprite 
{
    import starling.display.Image;
    import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CImage extends Image
	{
		
		
		
		public function CImage(tex:Texture) 
		{
			super(tex);
			this.textureSmoothing = TextureSmoothing.NONE;
			
		}
		
	}

}