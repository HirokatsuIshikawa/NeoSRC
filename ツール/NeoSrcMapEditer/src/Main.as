package
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.events.InvokeEvent;
	import flash.filesystem.File;
	import flash.system.Worker;
	import parts.popwindow.StartWindow;
	import system.worker.MainThread;
	
	/**
	 * ...
	 * @author
	 */
	[SWF(width = "1280", height = "800", frameRate = "60", backgroundColor = "#cccccc")]
	
	public class Main extends Sprite
	{
		
		//メインスレッド
		private var _mainThread:MainThread;
		
		public function Main():void
		{
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
		}
		
		public function onInvoke(invokeEvent:InvokeEvent):void
		{
			var file:File = null;
			if (invokeEvent.arguments.length > 0)
			{
				file = new File(invokeEvent.arguments[0].toString());
				StartWindow.invokePath = file.nativePath;
			}
			else
			{
				StartWindow.invokePath = null;
			}
			if (file != null)
			{
				StartWindow.invokePath = file.nativePath;
			}
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