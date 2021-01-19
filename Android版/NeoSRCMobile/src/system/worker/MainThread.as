package system.worker
{
	import com.mesmotronic.ane.ImmersiveMode;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.utils.ByteArray;
	import starling.core.Starling;
	import main.MainViewer;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class MainThread
	{
		//スターリン
		private var _starling:Starling;
		//バイナリーで読み込んだGIFデータ
		private var byteData:ByteArray;
		//URLローダー
		private var url_loader:URLLoader;
		
		private const STAGE_WIDTH:uint = 960;
		private const STAGE_HEIGHT:uint = 540;
		
		public function MainThread(stage:Stage)
		{
			//スターリンセット・開始
			
			CONFIG::pc
			{
				
				//_starling = new Starling(Viewer, spr.stage);
				_starling = new Starling(MainViewer, stage);
				_starling.antiAliasing = 0;
				//デバッグ情報表示
				_starling.showStats = false;
				_starling.stage.stageWidth = 960;
				_starling.stage.stageHeight = 540;
				//ディスパッチイベント
				//_starling.stage.addEventListener("loadgif", loadGifData);
				//_starling.stage.addEventListener("startBGM", startBGM);
				_starling.start();
			}
			CONFIG::phone
			{
				stage.displayState = StageDisplayState.NORMAL;
				ImmersiveMode.stage = stage;
				
				
				// フルスクリーンの際の縦横幅を取得
				var screenWidth:int = ImmersiveMode.fullScreenWidth;
				var screenHeight:int = ImmersiveMode.fullScreenHeight;
				
				// ゲーム画面が縦横比を維持しつつ、スクリーンにフィットするようにViewportの縦横幅を算出する
				var viewport:Rectangle = new Rectangle();
				var stage_aspect_ratio:Number = STAGE_HEIGHT / STAGE_WIDTH;
				var screen_aspect_ration:Number = screenHeight / screenWidth;
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				
				if (stage_aspect_ratio < screen_aspect_ration)
				{
					//ステージの縦横比に比べると縦長
					viewport.width = screenWidth;
					viewport.height = int((screenWidth / STAGE_WIDTH) * STAGE_HEIGHT);
				}
				else if (stage_aspect_ratio > screen_aspect_ration)
				{
					//ステージの縦横比に比べると横長
					viewport.height = screenHeight;
					viewport.width = int((screenHeight / STAGE_HEIGHT) * STAGE_WIDTH);
				}
				else
				{
					//ステージの縦横比と同じ
					viewport.width = screenWidth;
					viewport.height = screenHeight;
				}
				
				//ゲーム画面がセンタリングされるように位置調整
				viewport.x = int((screenWidth - viewport.width) / 2);
				viewport.y = int((screenHeight - viewport.height) / 2);
				
				//スターリンセット・開始
				//_starling = new Starling(Viewer, spr.stage);
				_starling = new Starling(MainViewer, stage, viewport);
				_starling.antiAliasing = 1;
				_starling.showStats = false;
				_starling.stage.stageWidth = STAGE_WIDTH;
				_starling.stage.stageHeight = STAGE_HEIGHT;
				//ディスパッチイベント
				//_starling.stage.addEventListener("loadgif", loadGifData);
				//_starling.stage.addEventListener("startBGM", startBGM);
				_starling.start();
			
			}
		
		}
	
	}
}