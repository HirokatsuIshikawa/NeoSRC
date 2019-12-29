package other.nouse
{
    import com.adobe.images.JPGEncoder;
    import com.adobe.images.PNGEncoder;
    import com.hurlant.crypto.Crypto;
    import com.hurlant.crypto.symmetric.ICipher;
    import com.hurlant.crypto.symmetric.IPad;
    import com.hurlant.crypto.symmetric.PKCS5;
    import com.hurlant.util.Base64;
    import com.hurlant.util.Hex;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import other.Crypt;
    
    /**
     * ...
     * @author ishikawa
     */
    public class ImgConverter
    {
        
        public static function convertImg(files:Array):void
        {
            var convertData:Object = new Object();
            var path:File = File.desktopDirectory.resolvePath(files[0].parent.nativePath + "/convert/imgData.srcimg");
            var jpgConv:JPGEncoder = new JPGEncoder();
            var count:int = 0;
            
            function compLoad():void
            {
                count++;
                if (count == files.length)
                {
                    var writeData:String = JSON.stringify(convertData);
                    // 文字列を書き込む
                    var stream:FileStream = new FileStream();
                    stream.open(path, FileMode.WRITE);
                    stream.writeUTFBytes(writeData);
                    stream.close();
                }
            }
            
            for (var i:int = 0; i < files.length; i++)
            {
                var file:File = files[i];
                
                if (file.name.indexOf(".png") > 0 || file.name.indexOf(".jpg") > 0 || file.name.indexOf(".gif") > 0)
                {
                    var loader:Loader = new Loader();
                    var info:LoaderInfo = loader.contentLoaderInfo;
                    
                    info.addEventListener(Event.COMPLETE, loadImgComplete);
                    function loadImgComplete(e:Event):void
                    {
                        info.removeEventListener(Event.COMPLETE, loadImgComplete);
                        
                        var bitmap:Bitmap = e.target.content as Bitmap;
                        var imgDat:ByteArray = PNGEncoder.encode(bitmap.bitmapData);
                        var imgStr:String = imgDat.toString();
                        trace("SET:" + imgDat.length);
                        convertData[file.name] = Crypt.encrypt(imgStr);
                        compLoad();
                    }
                    loader.load(new URLRequest(file.nativePath));
                }
                else if (file.name.indexOf(".xml") > 0)
                {
                    file.addEventListener(Event.COMPLETE, loadComplete);
                    function loadComplete(e:Event):void
                    {
                        file.removeEventListener(Event.COMPLETE, loadComplete);
                        
                        var barrDat:ByteArray = e.target.data;
                        var strData:String = barrDat.readMultiByte(barrDat.length, Main.DATA_CODE_UTF8);
                        strData = Crypt.encrypt(strData);
                        convertData[file.name] = strData;
                        compLoad();
                    }
                    file.load();
                }
            }
        
        }
        
        
        public static function loadConvImd(files:Array, callBack:Function):void
        {
            for each (var file:File in files)
            {
                var fileAry:Array = file.name.split(".");
                var path:File = File.desktopDirectory.resolvePath(file.parent.nativePath + "/convert/data/" + fileAry[0] + ".srcdat");
                
                file.addEventListener(Event.COMPLETE, loadComplete);
                function loadComplete(e:Event):void
                {
                    file.removeEventListener(Event.COMPLETE, loadComplete);
                    var barrDat:ByteArray = e.target.data;
                    var strData:String = barrDat.readMultiByte(barrDat.length, Main.DATA_CODE_UTF8);
                    var getData:Object = JSON.parse(strData);
                    
                    for each (var data:Object in getData)
                    {
                        
                        strData = Crypt.decrypt(data as String);
                        var loader:Loader = new Loader();
                        var byte:ByteArray = new ByteArray();
                        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void
                        {
                            var bitmapData:BitmapData = new BitmapData(loader.width, loader.height);
                            bitmapData.draw(loader);
                            var bitmap:Bitmap = new Bitmap(bitmapData);
                            callBack(bitmap);
                        
                        });
                        
                        
                        trace("LOAD:" + data.length);
                        byte.writeMultiByte(strData, Main.DATA_CODE_UTF8);
                        strData = byte.readMultiByte(byte.length, "");
                        
                        loader.loadBytes(byte);
                        
                    }
                
                }
                file.load();
            }
        }
    
    }
}