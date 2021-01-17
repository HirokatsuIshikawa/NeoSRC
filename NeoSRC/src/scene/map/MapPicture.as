package scene.map 
{
    import main.MainController;
    import starling.textures.Texture;
    import system.custom.customSprite.CImage;
	/**
     * ...
     * @author ...
     */
    public class MapPicture extends CImage
    {
        /**イメージの名前*/
        public var pictName:String = null;
        /**イベント名*/
        public var eventLabel:String = null;
        /**イベント名*/
        public var imgName:String = null;
        
        public function MapPicture(img:String, name:String ,label:String) 
        {
            imgName = img;
            touchable = false;
            pictName = name;
            eventLabel = label;
            super(MainController.$.imgAsset.getTexture(img));
        }
        
    }

}