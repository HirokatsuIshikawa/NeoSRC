package dataloader
{
	import flash.filesystem.File;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import system.UserImage;
	import view.MainController;
	import view.MainViewer;
	
	/**
	 * ...
	 * @author
	 */
	public class TipLoader
	{
		
		//パレットタイプ
		private var m_palletType:String = "";
		/**チップ種類一覧*/
		private var m_tipList:Vector.<String> = null;
		//オートで使う番号（ファイル名は数値＋１で4桁）
		private const autoObjAry:Array = [0, 1, 10, 11, 18, 19, 24, 25, 26, 27, 32, 33, 36, 40, 41, 44, 47];
		
		public function TipLoader()
		{
		
		}
		
		/**読み込み開始*/
		public function loadStart(fileName:String, type:String):void
		{
			MainController.$.view.pallet.reset();
			trace("全ファイルの読み込みが完了しました。");
			if (type === "tile" || type === "autotile")
			{
				setTileList(fileName);
			}
			else
			{
				setObjList(fileName);
			}
			
			MainController.$.view.pallet.pushComp();
		}
		
		/**読み込み開始*/
		public function filterloadStart(type:String, filter:String):void
		{
			if (type === "tile")
			{
				MainController.$.view.pallet.reset();
				setTileList(filter, true);
				MainController.$.view.pallet.pushComp();
			}
		
		}
		
		private function setTileList(fileName:String, tileFlg:Boolean = false):void
		{
			var i:int = 0;
			//テクスチャ名
			var texNameList:Vector.<String> = UserImage.$.tileAssetList.getTextureNames(fileName);
			var urlList:Vector.<String> = UserImage.$.tileAssetList.getTextureAtlasNames();
			var beforeUrl:String = "";
			var beforeX:int = 0;
			var beforeY:int = 0;
			for (i = 0; i < texNameList.length; i++)
			{
				if (tileFlg)
				{
					if (texNameList[i].indexOf("autotile") == 0 || texNameList[i].indexOf("autoobj") == 0)
					{
						continue;
					}
				}
				
				
				var url:String = UserImage.$.checkUrl(texNameList[i], urlList);
				var tex:Texture = UserImage.$.tileAssetList.getTexture(texNameList[i]);
				//テクスチャ
				MainController.$.view.pallet.pushTip(tex, texNameList[i], url);
			}
		}
		
		private function setObjList(fileName:String):void
		{
			var i:int = 0;
			//テクスチャ名
			var texNameList:Vector.<String> = UserImage.$.tileAssetList.getTextureNames(fileName);
			var urlList:Vector.<String> = UserImage.$.tileAssetList.getTextureAtlasNames();
			var beforeUrl:String = "";
			var beforeX:int = 0;
			var beforeY:int = 0;
			for (i = 0; i < texNameList.length; i++)
			{
				if (autoObjAry.indexOf(i) < 0)
				{
					continue;
				}
				var url:String = UserImage.$.checkUrl(texNameList[i], urlList);
				var tex:Texture = UserImage.$.tileAssetList.getTexture(texNameList[i]);
				//テクスチャ
				MainController.$.view.pallet.pushTip(tex, texNameList[i], url);
			}
		}
		
		/**チップ一覧セット*/
		public function tipListSet(type:int):void
		{
			UserImage.$.assetSelectNum = type;
			
			// フォルダ内のすべてのファイルとフォルダを取得
			// 配列の中身を列挙
			var typeStr:String = "";
			switch (type)
			{
			case 0: 
				m_tipList = UserImage.$.tileNameList;
				typeStr = "tile";
				break;
			case 1: 
				m_tipList = UserImage.$.autoTileNameList;
				typeStr = "autotile";
				break;
			case 2: 
				m_tipList = UserImage.$.autoObjNameList;
				typeStr = "autoobj";
				break;
			}
			
			MainController.$.view.pallet.selecter.setList(typeStr, m_tipList, loadStart);
			loadStart(m_tipList[0], typeStr);
		}
		
		/**チップ一覧セット*/
		public function tipListFilterSet(type:int, filter:String):void
		{
			
			//タイルの時に処理は行わない
			if (type == 0)
			{
				return;
			}
			
			UserImage.$.assetSelectNum = type;
			
			// フォルダ内のすべてのファイルとフォルダを取得
			// 配列の中身を列挙
			var typeStr:String = "";
			switch (type)
			{
			case 0: 
				//タイルの時に処理は行わない
				return;
			case 1: 
				typeStr = "autotile";
				
				break;
			case 2: 
				typeStr = "autoobj";
				
				break;
			}
			
			m_tipList = UserImage.$.tileAssetList.getTextureAtlasNames(typeStr + "_" + filter);
			if (m_tipList.length <= 0)
			{
				MainController.$.view.pallet.selecter.resetList();
				return;
			}
			
			MainController.$.view.pallet.selecter.setList(typeStr, m_tipList, loadStart);
			loadStart(m_tipList[0], typeStr);
		}
	
	}
}