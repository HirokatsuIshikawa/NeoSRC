package scene.battleanime.battleback 
{
	import a24.tween.Tween24;
	import common.CommonDef;
	import flash.geom.Rectangle;
	import scene.main.MainController;
	import starling.display.Quad;
	import starling.textures.Texture;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	/**
	 * ...
	 * @author ...
	 */
	public class BattleBack extends CSprite
	{
		private var _topBackImg:CImage = null;		
		private var _topTex:Texture = null;
		private var _topImgTween:Tween24 = null;
		
		private var _bottomBackImg:CImage = null;		
		private var _bottomTex:Texture = null;
		private var _bottomImgTween:Tween24 = null;
		
		public function BattleBack(topTexName:String, bottomTexName:String,scrollSide:int) 
		{
			super();
			//上部イメージ
			_topTex = MainController.$.imgAsset.getTexture(topTexName);
			_topBackImg = new CImage(_topTex);
			_topBackImg.width = CommonDef.WINDOW_W * 3;
			_topBackImg.height = 96;
			_topBackImg.tileGrid = new Rectangle();
			
			//下部イメージ
			_bottomTex = MainController.$.imgAsset.getTexture(bottomTexName);
			_bottomBackImg = new CImage(_bottomTex);
			_bottomBackImg.width = CommonDef.WINDOW_W * 3;
			_bottomBackImg.height = 48;
			_bottomBackImg.tileGrid = new Rectangle();
			_bottomBackImg.y = 320;
			this.mask = new Quad(CommonDef.WINDOW_W / 2 - 4, CommonDef.WINDOW_H);

			addChild(_topBackImg);
			addChild(_bottomBackImg);
			//上ループ
			_topImgTween = Tween24.loop(0,Tween24.prop(_topBackImg).x(-CommonDef.WINDOW_W),Tween24.tween(_topBackImg, 3).$$x(CommonDef.WINDOW_W * scrollSide));
			_topImgTween.play();
			//下ループ
			_bottomImgTween = Tween24.loop(0,Tween24.prop(_bottomBackImg).x(-CommonDef.WINDOW_W),Tween24.tween(_bottomBackImg, 3).$$x(CommonDef.WINDOW_W * scrollSide));
			_bottomImgTween.play();
		}
		
		/**廃棄*/
		override public function dispose():void
		{
			_topImgTween.stop();
			_bottomImgTween.stop();
			if (_topBackImg != null)
			{
				_topBackImg.dispose();
				_topBackImg = null;
			}
			
			if (_topTex != null)
			{
				_topTex.dispose();
				_topTex = null;
			}
			if (_bottomBackImg != null)
			{
				_bottomBackImg.dispose();
				_bottomBackImg = null;
			}
			
			if (_bottomTex != null)
			{
				_bottomTex.dispose();
				_bottomTex = null;
			}
			_topImgTween = null;
			_bottomImgTween = null;
			
			super.dispose();
		}
		
		
	}

}