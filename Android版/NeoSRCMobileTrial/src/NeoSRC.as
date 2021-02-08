package
{
    import bgm.SingleMusic;
    import common.SystemController;
    import flash.desktop.NativeApplication;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.InvokeEvent;
    import flash.events.LocationChangeEvent;
    import flash.filesystem.File;
    import flash.media.StageWebView;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.text.TextField;
    import main.MainController;
    import system.worker.MainThread;
    import viewitem.parts.pc.StartWindowPC;
    
    /**
     * ...
     * @author
     */
    //[SWF(width="640",height="512",frameRate="60",backgroundColor="#cccccc")]
    [SWF(width = "960", height = "540", frameRate = "60", backgroundColor = "#000000")]
    
    public class NeoSRC extends Sprite
    {
        
        [Embed(source = "../asset/afistr.txt", mimeType = "application/octet-stream")]
        public static const afiTxt:Class;
        
        /**コントローラー*/
        private var _manager:common.SystemController = null;
        //メインスレッド
        private var _mainThread:MainThread;
        /**広告URL*/
        private var _webView:StageWebView = null;
        
        //private var _url:String = "http://www48.atpages.jp/syougun/newSRC/NewSRCAfi.html";
        
        public function NeoSRC():void
        {
            NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
            //広告
            showWebView();
        }
        
        public function onInvoke(invokeEvent:InvokeEvent):void
        {
            
            if (invokeEvent.arguments.length > 0)
            {
                /*
                   var bitmap:Bitmap = new Bitmap(new BitmapData(600, 128, false, 0xFFFFFFFF));
                   addChild(bitmap);
                   var text:TextField = new TextField();
                   text.width = 540;
                   text.height = 128;
                   addChild(text);
                 */
                var file:File = new File(invokeEvent.arguments[0].toString());
                //text.text = file.nativePath;
                
                if (file.name.indexOf(".srctxt") >= 0 || file.name.indexOf(".srcsys") >= 0)
                {
                    
                    StartWindowPC.invokePath = file.nativePath;
                }
                else
                {
                    StartWindowPC.invokePath = null;
                    
                }
                
            }
            else
            {
                StartWindowPC.invokePath = null;
            }
            _manager = new common.SystemController(this);
            addEventListener(Event.DEACTIVATE, pauseBGM);
            addEventListener(Event.ACTIVATE, startBGM);
            //var path:String = invokeEvent.currentDirectory.nativePath;
            //DataLoad.loadInvokePath(path, InitialLoader.$.loadAssetStart);
        }
        
        protected function pauseBGM(e:Event):void
        {
            SingleMusic.pauseBGM();
        }
        
        protected function startBGM(e:Event):void
        {
            SingleMusic.restartBGM();
        }
        
        public function changeTitleName(name:String):void
        {
            stage.nativeWindow.title = name;
        }
        
        public function showWebView():void
        {
            if (_webView != null)
            {
                removeWebView();
            }
        /*
           if (url == null)
           {
           url = _url;
           }
         */
        /*
           _webView = new StageWebView();
           _webView.stage = this.stage;
           //_webView.viewPort = new Rectangle(0, stage.stageHeight - 96, stage.stageWidth + 15, 96);
           _webView.viewPort = new Rectangle(0, 0, stage.stageWidth + 15, 96);
           //_webView.loadURL(url);
           var str:String = new afiTxt();
        
           _webView.loadString(str);
           //_webView.addEventListener(Event.COMPLETE, onComplete);
         */
        }
        
        public function start():void
        {
            //メインスレッド
            //if (Worker.current.isPrimordial)
            //{
            _mainThread = new MainThread(stage);
            //BGMスレッド初期化、行わないと別スレッドで音が鳴らない
            //BgmThread.initBGM();
            //}
        }
        
        /**広告読み込み完了*/
        protected function onComplete(event:Event):void
        {
            _webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, update);
            _webView.removeEventListener(Event.COMPLETE, onComplete);
        }
        
        /**広告アップデート*/
        protected function update(event:LocationChangeEvent):void
        {
            //if (_webView.location != this._url)
            {
                event.preventDefault();
                navigateToURL(new URLRequest(event.location));
                showWebView();
            }
        }
        
        public function removeWebView():void
        {
            if (_webView != null)
            {
                _webView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE, update);
                _webView.stage = null;
                _webView.dispose();
                _webView = null;
            }
        }
    
    }

}