package converter
{
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    import converter.parse.CharaDataParse;
    import system.FileSystem;
    
    /**
     * ...
     * @author ishikawa
     */
    public class CharaDataConverter
    {
        
        /**
         * キャラデータコンバート
         * @param files
         */
        public static function convertChara(files:Array, pathString:String = null):void
        {
            
            var basePath:String = "";
            
            if (pathString == null)
            {
                basePath = files[0].parent.nativePath + "/convert/";
            }
            else
            {
                basePath = pathString;
            }
            
            for each (var file:File in files)
            {
                if (file.isDirectory)
                {
                    convertChara(file.getDirectoryListing(), basePath + "/" + file.name + "/");
                }
                else
                {
                    var fileAry:Array = file.name.split(".");
                    var path:File = File.desktopDirectory.resolvePath(basePath + fileAry[0] + ".srcdat");
                    
                    file.addEventListener(Event.COMPLETE, loadComplete);
                    function loadComplete(e:Event):void
                    {
                        file.removeEventListener(Event.COMPLETE, loadComplete);
                        var barrDat:ByteArray = e.target.data;
                        var strData:String = barrDat.readMultiByte(barrDat.length, Main.DATA_CODE_SJIS);
                        
                        var convertData:Object = CharaDataParse.parseCharaData(strData);
                        var writeData:String = JSON.stringify(convertData);
                        FileSystem.outPutText(writeData, path);
                    }
                    file.load();
                }
            }
        }
    }

}