package common.util
{
    import database.master.MasterCharaData;
    import database.user.UnitCharaData;
    import scene.main.MainController;
    
    /**
     * キャラデータユーティリティ
     * @author ishikawa
     */
    public class CharaDataUtil
    {
        /**IDから、マスターキャラデータを取得*/
        public static function getIdMasterCharaData(id:int):MasterCharaData
        {
            var charaData:MasterCharaData = null;
            for (var i:int = 0; i < MainController.$.model.masterCharaData.length; i++)
            {
                if (id == MainController.$.model.masterCharaData[i].id)
                {
                    charaData = MainController.$.model.masterCharaData[i];
                }
            }
            return charaData;
        }
        
        /**
         * 名前から、マスターキャラデータを取得
         * */
        public static function getMasterCharaDataName(name:String):MasterCharaData
        {
            var i:int = 0;
            var selectData:MasterCharaData = null;
            var masterChara:Vector.<MasterCharaData> = MainController.$.model.masterCharaData;
            
            for (i = 0; i < masterChara.length; i++)
            {
                if (name == masterChara[i].nickName)
                {
                    selectData = masterChara[i];
                    break;
                }
            }
            if (selectData == null)
            {
                for (i = 0; i < masterChara.length; i++)
                {
                    if (name == masterChara[i].name)
                    {
                        selectData = masterChara[i];
                        break;
                    }
                }
            }
            
            return selectData;
        }
        
        public static function getPlayerCharaForName(name:String):UnitCharaData
        {
            var i:int = 0;
            var data:UnitCharaData = null;
            var playerUnitData:Vector.<UnitCharaData> = MainController.$.model.PlayerUnitData;
            for (i = 0; i < playerUnitData.length; i++)
            {
                if (name == playerUnitData[i].masterData.nickName)
                {
                    data = playerUnitData[i];
                    break;
                }
            }
            if (data == null)
            {
                for (i = 0; i < playerUnitData.length; i++)
                {
                    if (name == playerUnitData[i].masterData.name)
                    {
                        data = playerUnitData[i];
                        break;
                    }
                }
            }
            
            return data;
        }
    
    }
}