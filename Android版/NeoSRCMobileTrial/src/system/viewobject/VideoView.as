package system.viewobject
{
	import flash.display3D.Context3D;
	import flash.display3D.textures.VideoTexture;
	import flash.events.VideoTextureEvent;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.ConcreteTexture;
	import common.CommonSystem;
 
	/**
	 * Starling root Class
	 * @author SzRaPnEL
	 */
	public class VideoView extends Sprite
	{
		private var vidClient:Object;
		private var cTexture:ConcreteTexture;
		private var vTexture:VideoTexture;
		private var nc:NetConnection;
		private var ns:NetStream;
		private var image:Image;
		private var context3D:Context3D;
 
		public function VideoView()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
 
		private function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
 
			core();
		}
 
		private function core():void
		{
			context3D = Starling.context;
 
			vidClient = new Object();
			vidClient.onMetaData = onMetaData;
 
			nc = new NetConnection();
			nc.connect(null);
 
			ns = new NetStream(nc);
			ns.client = vidClient;
			ns.play(CommonSystem.SCENARIO_PATH + "movie/testmovie.mp4");
 
			vTexture = context3D.createVideoTexture();
			vTexture.attachNetStream(ns);
			vTexture.addEventListener(VideoTextureEvent.RENDER_STATE, renderFrame);

			cTexture = new ConcreteTexture(vTexture, "bgra", 640, 480, false, true, true);
 
			image = new Image(cTexture);
			addChild(image);
		}
 
		private function renderFrame(e:VideoTextureEvent):void
		{
			//
		}
 
		private function onMetaData(metadata:Object):void
		{
			//
		}
	}
}