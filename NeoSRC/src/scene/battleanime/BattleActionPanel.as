package scene.battleanime
{
	import a24.tween.Tween24;
	import common.CommonDef;
	import common.CommonSystem;
	import flash.geom.Rectangle;
	import scene.battleanime.battleback.BattleBack;
	import scene.unit.BattleUnit;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import database.user.UnitCharaData;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import scene.battleanime.data.BattleAnimeRecord;
	import scene.main.MainController;
	import viewitem.parts.numbers.ImgNumber;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class BattleActionPanel extends CSprite
	{
		
		/** ユニット */
		private var _leftUnitImg:CImage = null;
		private var _rightUnitImg:CImage = null;
		/**背景*/
		private var _backImg:CImage = null;
		private var _tex:Texture = null;
		
		/**ループ背景*/
		private var _battleBack:Vector.<BattleBack> = null;
		
		/**ユニットデータ*/
		private var _leftUnitData:BattleUnit = null;
		private var _rightUnitData:BattleUnit = null;
		
		private var _tween:Tween24 = null;
		/**アニメ再生カウント*/
		private var _animeCount:int = 0;
		/**アニメ棋譜*/
		private var _recordAnime:Vector.<BattleAnimeRecord> = null;
		/**終了コールバック*/
		private var _endCallBack:Function = null;
		
		/**ダメージ値*/
		private var _damageNum:ImgNumber = null;
		
		/**コンストラクタ*/
		public function BattleActionPanel()
		{
			super();
			_tex = MainController.$.imgAsset.getTexture("tex_black");
			_backImg = new CImage(_tex);
			_backImg.width = CommonDef.WINDOW_W;
			_backImg.height = CommonDef.WINDOW_H;
			_backImg.textureSmoothing = TextureSmoothing.NONE;
			addChild(_backImg);
			_battleBack = new Vector.<BattleBack>();
			
			for (var i:int = 0; i < 2; i++ )
			{
				var battleBack:BattleBack;
				var scrollSide:int = i % 2 == 1 ? 1 : -1;
				
				battleBack = new BattleBack("battleback_top", "battleback_bottom",scrollSide);
				
				battleBack.x = (i % 2) * (CommonDef.WINDOW_W / 2 + 4);
				battleBack.y = 0;
				addChild(battleBack);
				_battleBack.push(battleBack);
			}
			this.alpha = 0;
			_damageNum = new ImgNumber();
		}
		
		/**廃棄*/
		override public function dispose():void
		{
			if (_backImg != null)
			{
				_backImg.dispose();
				_backImg = null;
			}
			
			if (_tex != null)
			{
				_tex.dispose();
				_tex = null;
			}
			
			if (_leftUnitImg != null)
			{
				_leftUnitImg.dispose();
				_leftUnitImg = null;
			}
			
			if (_rightUnitImg != null)
			{
				_rightUnitImg.dispose();
				_rightUnitImg = null;
			}
			
			super.dispose();
		}
		
		/**ユニットセット*/
		public function setUnit(attakerUnitData:BattleUnit, targetUnitData:BattleUnit):void
		{
			if (_leftUnitImg != null)
			{
				_leftUnitImg.dispose();
				_leftUnitImg = null;
			}
			
			if (_rightUnitImg != null)
			{
				_rightUnitImg.dispose();
				_rightUnitImg = null;
			}
			
			if (attakerUnitData.side <= targetUnitData.side)
			{
				_leftUnitData = targetUnitData;
				_rightUnitData = attakerUnitData;
			}
			else
			{
				
				_leftUnitData = attakerUnitData;
				_rightUnitData = targetUnitData;
			}
			
			//_leftUnitImg = new CImage(TextureManager.loadTexture(_leftUnitData.masterData.unitImgUrl, _leftUnitData.masterData.unitImgName, TextureManager.TYPE_UNIT));
			//_rightUnitImg = new CImage(TextureManager.loadTexture(_rightUnitData.masterData.unitImgUrl, _rightUnitData.masterData.unitImgName, TextureManager.TYPE_UNIT));
			_leftUnitImg = new CImage(MainController.$.imgAsset.getTexture(_leftUnitData.masterData.unitsImgName));
			
			_leftUnitImg.width = 128;
			_leftUnitImg.height = 128;
			_leftUnitImg.scaleX = -4;
			_leftUnitImg.textureSmoothing = TextureSmoothing.NONE;
			
			_leftUnitImg.x = 128 + 128;
			_leftUnitImg.y = 160;
			
			_rightUnitImg = new CImage(MainController.$.imgAsset.getTexture(_rightUnitData.masterData.unitsImgName));
			_rightUnitImg.width = 128;
			_rightUnitImg.height = 128;
			_rightUnitImg.textureSmoothing = TextureSmoothing.NONE;
			
			_rightUnitImg.x = CommonDef.WINDOW_W - 256;
			_rightUnitImg.y = 160;
			
			addChild(_leftUnitImg);
			addChild(_rightUnitImg);
		}
		
		/**アニメ開始*/
		public function startBattleAnime(data:Vector.<BattleAnimeRecord>, callBack:Function):void
		{
			_endCallBack = callBack;
			_recordAnime = data;
			_animeCount = 0;
			
			Tween24.tween(this, 0.4).fadeIn().onComplete(readyFunc).play();
			function readyFunc():void
			{
				readyAction();
			}
		
		}
		
		private function readyAction():void
		{
			if (_animeCount == _recordAnime.length)
			{
				disposeRecord();
				_endCallBack();
			}
			else
			{
				startAction(_recordAnime[_animeCount]);
				_animeCount++;
			}
		}
		
		public function disposeRecord():void
		{
			var i:int = 0;
			if (_recordAnime != null)
			{
				for (i = 0; i < _recordAnime.length; )
				{
					_recordAnime[0] = null;
					_recordAnime.shift();
				}
				_recordAnime = null;
			}
		}
		
		private function startAction(data:BattleAnimeRecord):void
		{
			// アクション作成
			_tween = makeAction(data)
			// 終了時アクション
			_tween.onComplete(readyAction);
			// ついーん開始
			_tween.play();
		}
		
		/** アクション作成 */
		private function makeAction(data:BattleAnimeRecord):Tween24
		{
			var act:Array = new Array();
			var atkImg:CImage = null;
			var defImg:CImage = null;
			
			switch (data.side)
			{
			case BattleAnimeRecord.SIDE_LEFT: 
				atkImg = _leftUnitImg;
				defImg = _rightUnitImg;
				break;
			case BattleAnimeRecord.SIDE_RIGHT:
				
				atkImg = _rightUnitImg;
				defImg = _leftUnitImg;
				break;
			}
			
			waitAction(act, 0.6);
			setAttackEffect(act, data, atkImg, defImg);
			waitAction(act, 0.6);
			resetPosition(act, atkImg, defImg, 0.3);
			waitAction(act, 0.3);
			
			var tween:Tween24 = Tween24.serial(act);
			
			return tween;
		}
		
		/**アニメエフェクト設定*/
		private function setAttackEffect(act:Array, data:BattleAnimeRecord, atkImg:CImage, defImg:CImage):void
		{
			
			switch (data.effect)
			{
			case BattleAnimeRecord.EFFECT_DAMAGE: 
				normalAttack(act, data, atkImg, defImg);
				break;
			case BattleAnimeRecord.EFFECT_NO_HIT: 
				attackMiss(act, data, atkImg, defImg);
				break;
			}
		}
		
		/** 通常攻撃アクション */
		private function normalAttack(act:Array, data:BattleAnimeRecord, atkImg:CImage, defImg:CImage):void
		{
			act.push(Tween24.tween(atkImg, 0.3).$x(100 * data.side));
			act.push(Tween24.tween(defImg, 0.3).$x(20 * data.side).onPlay(showDamage, data.damage, 0xFF0000, data.side));
		}
		
		/** 回避アクション */
		private function attackMiss(act:Array, data:BattleAnimeRecord, atkImg:CImage, defImg:CImage):void
		{
			act.push(Tween24.tween(atkImg, 0.3).$x(100 * data.side));
			act.push(Tween24.tween(defImg, 0.3).$xy(20 * data.side, -60));
		}
		
		/**ウェイト作成*/
		private function waitAction(act:Array, time:Number):void
		{
			act.push(Tween24.wait(time));
		}
		
		/**ポジション初期化*/
		private function resetPosition(act:Array, atkImg:CImage, defImg:CImage, time:Number):void
		{
			var tween:Tween24 = Tween24.parallel(Tween24.tween(atkImg, time).$xy(0, 0), Tween24.tween(defImg, time).$xy(0, 0));
			act.push(tween);
		}
		
		/** ダメージ表示 */
		private function showDamage(value:int, color:uint, side:int):void
		{
			_damageNum.setNumber(value, "", color);
			_damageNum.alpha = 0;
			_damageNum.visible = true;
			addChild(_damageNum);
			if (side == BattleAnimeRecord.SIDE_LEFT)
			{
				_damageNum.x = _rightUnitImg.x;
				_damageNum.y = _rightUnitImg.y;
			}
			else if (side == BattleAnimeRecord.SIDE_RIGHT)
			{
				_damageNum.x = _leftUnitImg.x;
				_damageNum.y = _leftUnitImg.y;
			}
			
			Tween24.serial(Tween24.tween(_damageNum, 0.3).fadeIn().$xy(0, -60), //
			Tween24.tween(_damageNum, 0.3).$xy(0, 0), //
			Tween24.tween(_damageNum, 0.3).fadeOut() //
			).play();
		
		}
	}

}