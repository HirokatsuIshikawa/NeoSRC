package main
{
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
		
		public function MainController(_v:MainViewer)
		{
			if (!_view)
			{
				_view = _v;
			}
			init();
		}
		
		/**初期化*/
		private function init():void
		{
			//インスタンス設定
			_instance = this;
			
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
		
		public function get view():MainViewer
		{
			return _view;
		}
	
	}

}