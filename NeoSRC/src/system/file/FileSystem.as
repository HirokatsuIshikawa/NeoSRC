package system.file
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import system.Crypt;
    /**
     * ...
     * @author ishikawa
     */
    public class FileSystem
    {
        
        public static var ENCRY:Boolean = false;
        
        public static function outPutText(data:String, path:File):void
        {
            // 暗号化
            if (ENCRY)
            {
                data = Crypt.encrypt(data);
                data = "CryptingData:" + data;
            }
            // 文字列を書き込む
            var stream:FileStream = new FileStream();
            stream.open(path, FileMode.WRITE);
            stream.writeUTFBytes(data);
            stream.close();
        
        }
    
    }

}