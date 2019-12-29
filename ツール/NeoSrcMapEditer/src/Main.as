package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.system.Worker;
	import system.worker.MainThread;
	
	/**
	 * ...
	 * @author
	 */
	[SWF(width="1280",height="800",frameRate="60",backgroundColor="#cccccc")]
	
	public class Main extends Sprite
	{
		
		//メインスレッド
		private var _mainThread:MainThread;
		
		public function Main():void
		{
			//メインスレッド
			//if (Worker.current.isPrimordial)
			//{
			_mainThread = new MainThread(this);
			//BGMスレッド初期化、行わないと別スレッドで音が鳴らない
			//BgmThread.initBGM();
			//}
			
			addEventListener(Event.RESIZE, resizeFunc);
			
			
		
		}
		
		
		public function resizeFunc(e:Event):void
		{
			
			
			
			
		}
		
	
	}

}