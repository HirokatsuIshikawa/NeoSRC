package texttex
{
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import starling.textures.Texture;
    
    /**
     * ...
     * @author ishikawa
     */
    public class TextTex
    {
        
        private static var _texList:Vector.<Texture>;
        private static var _texNameList:Vector.<String>;
        
        public static function init():void
        {
            _texList = new Vector.<Texture>;
            _texNameList = new Vector.<String>;
        }
        
        public static function getTextTex(str:String, width:int = 0, height:int = 0, size:int = 0, color:uint = 0, align:String = TextFormatAlign.CENTER):Object
        {
            var url:String = str + "_" + width + "_" + height + "_" + size + "_" + color + "_" + align;
            var data:Object = new Object();
            var i:int = 0;
            var findFlg:Boolean = false;
            // 既存検索
            for (i = 0; i < _texNameList.length; i++)
            {
                if (url === _texNameList[i])
                {
                    findFlg = true;
                    break;
                }
            }
            
            if (findFlg)
            {
                data.tex = _texList[i];
                data.url = _texNameList[i];
                return data;
            }
            
            var format:TextFormat = new TextFormat();
            format.align = align;           // 整列
            format.font = "Font Bold";      // フォント名
            format.size = size;               // 文字のポイントサイズ
            format.color = color;    // 文字の色
            
            var text:TextField = new TextField();
            text.defaultTextFormat = format;
            text.text = str;
            text.width = width;
            text.height = height;
            
            var tex:Texture;
            var spr:Sprite = new Sprite();
            var bmd:BitmapData = new BitmapData(width, height, true, 0x0);
            spr.addChild(text);
            bmd.draw(spr);
            tex = Texture.fromBitmapData(bmd);
            _texList.push(tex);
            _texNameList.push(url);
            
            data.tex = tex;
            data.url = url;
            
            return data;
        }
    
    }

}