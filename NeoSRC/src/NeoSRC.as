package
{
	import bgm.SingleMusic;
	import common.SystemController;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import system.worker.MainThread;
	import scene.main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	//[SWF(width="640",height="512",frameRate="60",backgroundColor="#cccccc")]
	[SWF(width = "960", height = "540", frameRate = "60", backgroundColor = "#000000")]
	
	public class NeoSRC extends Sprite
	{
		
		[Embed(source = "../asset/afistr.txt",mimeType="application/octet-stream")]
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
			_manager = new common.SystemController(this);
			
			addEventListener(Event.DEACTIVATE, pauseBGM);
			addEventListener(Event.ACTIVATE, startBGM);
			
			
			//広告
			showWebView();
		}
		
		
		protected function pauseBGM(e:Event):void
		{
			SingleMusic.pauseBGM();
		}
		
		protected function startBGM(e:Event):void
		{
			SingleMusic.restartBGM();
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