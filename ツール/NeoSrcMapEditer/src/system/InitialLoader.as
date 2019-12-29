package system 
{
	/**
	 * ...
	 * @author ...
	 */
	public class InitialLoader 
	{
		
		/**マネージャー*/
		private static var _manager:InitialLoader = new InitialLoader();
		/**instance getter
		 *
		 * @return UserImageインスタンス
		 * */
		public static function get $():UserImage
		{
			return _manager;
		}
		
		/**コンストラクタ*/
		public function InitialLoader()
		{
			if (_manager)
			{
				throw new ArgumentError("UserImage is singleton class");
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	}

}