package
{
    import converter.CharaDataConverter;
    import converter.ScenarioSetConverter;
    import converter.SystemDataConverter;
    import flash.desktop.Clipboard;
    import flash.desktop.ClipboardFormats;
    import flash.desktop.NativeDragManager;
    import flash.display.Bitmap;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.events.NativeDragEvent;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    import other.Crypt;
    import parts.ToggleButton;
    import system.FileSystem;
    
    /**
     * ...
     * @author ishikawa
     */
    public class Main extends Sprite
    {
        //メインスレッド
        private var _clipboard:Clipboard = new Clipboard();
        
        private var _cryptBtn:ToggleButton = null;
        
        private var _systemSpr:Vector.<Sprite> = null;
        private var _systemLabel:Vector.<TextField> = null;
        
        private const DATA_NAME_LIST:Array = ["scenario_data_set", "system", "chara"];
        private const LABEL_NAME_LIST:Array = ["シナリオデータ一式","システムデータ", "キャラデータ"];
        private const COLOR_LIST:Array = [0xFFFFFF, 0xFF4444, 0x2244FF, /*0x44FF22*/];
        
        public static const DATA_CODE_UTF8:String = "UTF-8";
        public static const DATA_CODE_UTF16:String = "unicode";
        public static const DATA_CODE_EUC:String = "euc-jp";
        public static const DATA_CODE_JIS:String = "iso-2022-jp";
        public static const DATA_CODE_SJIS:String = "shift_jis";
        
        public function Main()
        {
            
            _systemSpr = new Vector.<Sprite>;
            _systemLabel = new Vector.<TextField>;
            
            var count:int = DATA_NAME_LIST.length;
            
            /////////////////////////////////////////////システムデータ////////////////////////////////////////////////
            for (var i:int = 0; i < DATA_NAME_LIST.length; i++)
            {
                _systemSpr[i] = new Sprite;
                _systemLabel[i] = new TextField;
                
                // スプライトを作成して配置
                _systemSpr[i] = new Sprite();
                _systemSpr[i].name = DATA_NAME_LIST[i];
                addChild(_systemSpr[i]);
                
                // ステージ全体に矩形を描画
                var g:Graphics = _systemSpr[i].graphics;
                g.beginFill(COLOR_LIST[i], 0.5);
                g.drawRect(0, 0, stage.stageWidth, stage.stageHeight / count);
                g.endFill();
                
                _systemSpr[i].x = 0;
                _systemSpr[i].y = i * stage.stageHeight / count;
                
                _systemLabel[i] = new TextField();
                _systemLabel[i].text = LABEL_NAME_LIST[i];
                _systemSpr[i].addChild(_systemLabel[i]);
                _systemLabel[i].width = _systemSpr[i].width;
                _systemLabel[i].height = _systemSpr[i].height;
                
                _systemLabel[i].type = TextFieldType.DYNAMIC;
                _systemLabel[i].autoSize = TextFieldAutoSize.CENTER;
                
                _systemSpr[i].addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, nativeDragEnterHandler);
                _systemSpr[i].addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, nativeDragExitHandler);
                _systemSpr[i].addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, nativeDragDropHandler);
            }
            
            _cryptBtn = new ToggleButton("通常", "暗号化", offCrypt, onCrypt);
            addChild(_cryptBtn);
        }
        
        private function onCrypt():void
        {
            FileSystem.ENCRY = false;
        }

        private function offCrypt():void
        {
            FileSystem.ENCRY = true;
        }
        
        
        
        // ドラッグしたまま droparea の上に来たとき
        private function nativeDragEnterHandler(event:NativeDragEvent):void
        {
            var spr:Sprite = event.currentTarget as Sprite;
            
            spr.alpha = 0.6;
            
            // ドラッグしているアイテムはファイルかどうか
            var clipboard:Clipboard = event.clipboard;
            if (clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
            {
                // droparea の上でのドロップを許可する
                NativeDragManager.acceptDragDrop(spr);
            }
        }
        
        // ドラッグしたまま droparea から外れたとき
        private function nativeDragExitHandler(event:NativeDragEvent):void
        {
            var spr:Sprite = event.currentTarget as Sprite;
            spr.alpha = 1.0;
        }
        
        // ファイルをドロップしたとき
        private function nativeDragDropHandler(event:NativeDragEvent):void
        {
            var spr:Sprite = event.currentTarget as Sprite;
            spr.alpha = 1.0;
            // ドロップしたアイテムを取り出す
            var clipboard:Clipboard = event.clipboard;
            var files:Array = clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
            
            switch (spr.name)
            {
            case "scenario_data_set":
                ScenarioSetConverter.convertScenarioSet(files);
                break;
            case "system": 
                SystemDataConverter.convertSystem(files);
                break;
            case "chara": 
                CharaDataConverter.convertChara(files);
                break;
            }
        }
        
        private function setBitmap(bitmap:Bitmap):void
        {
            addChild(bitmap);
        }

    
    }
}