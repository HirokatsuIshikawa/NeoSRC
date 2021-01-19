package viewitem.status.list.listitem 
{
    import database.user.GenericUnitData;
    import database.user.UnitCharaData;
    import main.MainController;
    import starling.textures.Texture;
    import system.custom.customSprite.CImage;
	/**
     * ...
     * @author ...
     */
    public class OrganizeSelectIcon extends CImage
    {

        private var _unitCharaData:UnitCharaData = null;
        private var _genericUnitData:GenericUnitData = null;
        
        public function get genericUnitData():GenericUnitData 
        {
            return _genericUnitData;
        }
        
        public function get unitCharaData():UnitCharaData 
        {
            return _unitCharaData;
        }
        
        public function OrganizeSelectIcon(unitData:UnitCharaData, genericData:GenericUnitData) 
        {
            _unitCharaData = unitData;
            _genericUnitData = genericData;
            
            var tex:Texture = null;
            
            if (_unitCharaData != null)
            {
                tex = MainController.$.imgAsset.getTexture(_unitCharaData.masterData.unitsImgName);
            }
            else if (_genericUnitData != null)
            {
                tex = MainController.$.imgAsset.getTexture(_genericUnitData.data.unitsImgName);
            }
            super(tex);
        }
        
        
        override public function dispose():void
        {
            super.dispose();
        }
    }
}