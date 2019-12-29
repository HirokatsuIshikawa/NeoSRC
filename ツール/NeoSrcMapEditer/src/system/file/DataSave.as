package system.file {
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import code.org.coderepos.text.encoding.Jcode;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class DataSave
	{
		
		public static function Save(name:String, file:String, data:Object, func:Function = null, ary:Array = null):void
		{
			var json:String = JSON.stringify(data);
			var fr:FileReference = new FileReference();
			
			fr.addEventListener(Event.COMPLETE, onComplete);
			fr.save(json, name + file); // ダイアログを表示する
			function onComplete(e:Event):void
			{
				if (func != null)
				{
					if (ary != null)
					{
						func(ary);
					}
					else
					{
						func();
					}
				}
				trace(fr.name); // ユーザが指定したファイル名を表示
			}
		}
		
		/**テキスト書き込み*/
		public static function WriteText(name:String, file:String, text:String, func:Function = null, ary:Array = null):void {
			
			var byte:ByteArray = Jcode.to_sjis(text);
			var fr:FileReference = new FileReference();
			
			fr.addEventListener(Event.COMPLETE, onComplete);
			fr.save(text, name + file); // ダイアログを表示する
			
			function onComplete(e:Event):void
			{
				if (func != null)
				{
					if (ary != null)
					{
						func(ary);
					}
					else
					{
						func();
					}
				}
				trace(fr.name); // ユーザが指定したファイル名を表示
			}
		}
		
	
	}

}