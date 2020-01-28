package scene.main
{
	import starling.utils.AssetManager;
    import scene.main.MainViewer;
	import scene.map.BaseMap;
	import scene.map.BattleMap;

	/**
	 * ...
	 * @author
	 */
	public class MainController
	{
		
		/**インスタンス*/
		private static var _instance:MainController;

		/**イベントシーンスプライト*/
		private var _view:MainViewer = null;

		/**データモデル*/
		private var _model:MainModel = null;

		
		/**アセットシステム*/
		private var _imgAsset:AssetManager = null;
		private var _mapTipAsset:AssetManager = null;
		
        /**コンストラクタ*/
		public function MainController(_v:MainViewer)
		{
			if (!_view)
			{
				_view = _v;
			}

			_model = new MainModel();

			init();
		}

		/**初期化*/
		private function init():void
		{
			//インスタンス設定
			_instance = this;
			endInit();
		}

		/**初期化終了*/
		private function endInit():void {
			_view.start();
		}

		/**
		 * インスタンスゲッタ
		 * @return インスタンス
		 */
		public static function get $():MainController
		{
			return _instance;
		}

		public function get map():BattleMap
		{
			return _view.battleMap;
		}
		
        /**メインビュー*/
		public function get view():MainViewer
		{
			return _view;
		}

        /**メインモデル*/
		public function get model():MainModel
		{
			return _model;
		}
		
		public function get imgAsset():AssetManager
		{
			return _imgAsset;
		}
		
		public function set imgAsset(value:AssetManager):void 
		{
			_imgAsset = value;
		}
		
		public function get mapTipAsset():AssetManager 
		{
			return _mapTipAsset;
		}
		
		public function set mapTipAsset(value:AssetManager):void 
		{
			_mapTipAsset = value;
		}
	}

}