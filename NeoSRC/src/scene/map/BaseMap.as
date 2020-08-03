package scene.map
{
	import common.CommonDef;
	import common.CommonMapMath;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import flash.display.BitmapData;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import scene.main.MainController;
	import scene.map.tip.MapTip;
	
	/**
	 * ...
	 * @author
	 */
	public class BaseMap extends CSprite
	{
		// const
		public static const MAP_SIZE:int = 32;
		public static const MAP_WIDTH:int = 30;
		public static const MAP_HEIGHT:int = 20;
		
		// value
		protected var _mapWidth:int = 0;
		protected var _mapHeight:int = 0;
		
		// 移動制限位置
		private var _leftLimit:int = 0;
		private var _rightLimit:int = 0;
		private var _upLimit:int = 0;
		private var _downLimit:int = 0;
		
		// component
		protected var _backImg:CImage = null;
		protected var _tileImg:CImage = null;
		protected var _canvasArea:CSprite = null;
		protected var _tipArea:Vector.<CSprite> = null;
		protected var _tip:Vector.<Vector.<MapTip>> = null;
		
		public static var _blankTex:Texture = null;
		
		/**
		
		   /**選択レイヤー番号*/
		protected var _layer:int = 0;
		
		public function BaseMap()
		{
			super();
			_mapWidth = MAP_WIDTH;
			_mapHeight = MAP_HEIGHT;
			
			//描画フィールド
			_canvasArea = new CSprite();
			_canvasArea.mask = new Quad(MAP_SIZE * MAP_WIDTH, MAP_SIZE * MAP_HEIGHT);
			addChild(_canvasArea);
			
			//背景イメージ
			//_backImg = new CImage(Texture.fromBitmapData(new BitmapData(MAP_SIZE * MAP_WIDTH, MAP_SIZE * MAP_HEIGHT, true, 0x0)));
			_backImg = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
			//_backImg.alpha = 0;
			_backImg.width = MAP_SIZE * MAP_WIDTH;
			_backImg.height = MAP_SIZE * MAP_HEIGHT;
			_canvasArea.addChild(_backImg);
			//タイルイメージ
			//_tileImg = new CImage(Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0x0)));
			_tileImg = new CImage(MainController.$.imgAsset.getTexture("tex_black"));
			_tileImg.width = MAP_SIZE;
			_tileImg.height = MAP_SIZE;
			_tileImg.x = MAP_SIZE * -2;
			_tileImg.y = MAP_SIZE * -2;
			_tileImg.visible = false;
			_tileImg.textureSmoothing = TextureSmoothing.NONE;
			//_tileImg.setSize(MAP_SIZE * (MAP_WIDTH + 4), MAP_SIZE * (MAP_HEIGHT + 4));
			_tileImg.width = MAP_SIZE * (MAP_WIDTH + 4);
			_tileImg.height = MAP_SIZE * (MAP_HEIGHT + 4);
			//_tileImg.tileGrid = new Rectangle();
			
			_canvasArea.addChild(_tileImg);
		
		}
		
		/** データ廃棄 */
		public override function dispose():void
		{
			super.dispose();
			CommonDef.disposeList([_backImg, _tileImg, _canvasArea, _tipArea, _tip, _blankTex]);
			_backImg = null;
			_tileImg = null;
			_canvasArea = null;
			_tipArea = null;
			_tip = null;
			_blankTex = null;
		}
		
		/**チップ再配置*/
		public function setTipArea(wid:int, hgt:int):void
		{
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			
			var sizeWidth:int = 0;
			var sizeHeight:int = 0;
			
			_mapWidth = wid;
			_mapHeight = hgt;
			
			if (_mapWidth > 30)
			{
				sizeWidth = 30;
			}
			else
			{
				sizeWidth = _mapWidth;
			}
			
			if (_mapHeight > 20)
			{
				sizeHeight = 20;
			}
			else
			{
				sizeHeight = _mapHeight;
			}
			
			_canvasArea.mask = new Quad(MAP_SIZE * sizeWidth, MAP_SIZE * sizeHeight);
			//やり直し時破棄
			if (_tipArea != null)
			{
				for (i = 0; i < _tip.length; )
				{
					if (_tipArea[i] != null)
					{
						_tipArea[i].removeChildren();
						for (j = 0; j < _tip[i].length; )
						{
							_tip[i][j].dispose();
							_tip[i].shift();
						}
					}
					_tip.shift();
				}
				
				_canvasArea.addChild(_tipArea[0]);
				_canvasArea.addChild(_tipArea[1]);
				_canvasArea.addChild(_tipArea[2]);
			}
			else
			{
				_tipArea = new Vector.<CSprite>;
				_tipArea[0] = new CSprite();
				_tipArea[1] = new CSprite();
				_tipArea[2] = new CSprite();
				_canvasArea.addChild(_tipArea[0]);
				_canvasArea.addChild(_tipArea[1]);
				_canvasArea.addChild(_tipArea[2]);
			}
			
			if (_blankTex == null)
			{
				_blankTex = Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0x44FF0000));
			}
			
			_tip = new Vector.<Vector.<MapTip>>;
			
			for (i = 0; i < 3; i++)
			{
				_tip[i] = new Vector.<MapTip>;
				for (j = 0; j < _mapHeight; j++)
				{
					for (k = 0; k < _mapWidth; k++)
					{
						var tip:MapTip = new MapTip(CommonDef.BLANK_TIP_TEX, CommonDef.BLANK_TIP_TEXT, CommonDef.BLANK_TIP_TEXT);
						
						tip.x = k * MAP_SIZE;
						tip.y = j * MAP_SIZE;
						
						CONFIG::phone
						{
							tip.width = MAP_SIZE + 1;
							tip.height = MAP_SIZE + 1;
						}
						_tipArea[i].addChild(tip);
						_tip[i].push(tip);
					}
				}
			}
			this.alpha = 1;
			this.visible = true;
		
		}
		
		/**背景タイルセット*/
		public function setBackTile():void
		{
		/*
		   _tileImg.texture = MainController.$.view.pallet.selectTip.texture;
		   _tileImg.visible = true;
		   _tileImg.tileGrid = new Rectangle();
		   moveTile();
		 */
		}
		
		/**タイル移動*/
		public function moveTile():void
		{
		/*
		   if (MainController.$.view.tileConfig.time <= 0)
		   {
		   return;
		   }
		   var numX:int = _tileImg.x;
		   var numY:int = _tileImg.y;
		
		   if (numX >= -32)
		   {
		   numX -= 32;
		   }
		   else if (numX < -96)
		   {
		   numX += 32;
		   }
		   if (numY >= -32)
		   {
		   numY -= 32;
		   }
		   else if (numY < -96)
		   {
		   numY += 32;
		   }
		
		   Tween24.serial( //
		   Tween24.prop(_tileImg).xy(numX, numY), //
		   Tween24.tween(_tileImg, MainController.$.view.tileConfig.time).$$xy(MainController.$.view.tileConfig.xNum, MainController.$.view.tileConfig.yNum).onUpdate(cutPos).onComplete(moveTile) //
		   ).play()
		 */
		}
		
		private function cutPos():void
		{
			_tileImg.x = Math.floor(_tileImg.x);
			_tileImg.y = Math.floor(_tileImg.y);
		}
		
		public function set layer(value:int):void
		{
			_layer = value;
			
			for (var i:int = 0; i < 3; i++)
			{
				
				if (i <= _layer)
				{
					_tipArea[i].alpha = 1;
				}
				else
				{
					_tipArea[i].alpha = 0.5;
				}
				
			}
		}
		
		public function get tip():Vector.<Vector.<MapTip>>
		{
			return _tip;
		}
		
		public function get mapWidth():int
		{
			return _mapWidth;
		}
		
		public function get mapHeight():int
		{
			return _mapHeight;
		}
		
		public function set mapWidth(value:int):void
		{
			_mapWidth = value;
		}
		
		public function set mapHeight(value:int):void
		{
			_mapHeight = value;
		}
        
        /** 余り排除 */
        protected function floorPos():void
        {
            this.x = Math.floor(this.x);
            this.y = Math.floor(this.y);
        }
        
                /**リスト複製*/
        protected function cloneList(list:Vector.<String>):Vector.<String>
        {
            var i:int = 0;
            var newList:Vector.<String> = new Vector.<String>;
            for (i = 0; i < list.length; i++)
            {
                newList.push(list[i]);
            }
            return newList;
        }
		
		/** チップをURL順に並び替え、改装を合わせる */
		public function refreshTip(layer:int):void
		{
			_tipArea[layer].sortChildren(sortTipUrl);
			
			for (var i:int = 0; i < _tip[layer].length; i++)
			{
				if (_tip[layer][i].url === CommonDef.BLANK_TIP_TEXT)
				{
					_tip[layer][i].visible = false;
				}
				else
				{
					_tip[layer][i].visible = true;
				}
			}
		}
		
		public function sortTipUrl(tip1:MapTip, tip2:MapTip):Number
		{
			var i:uint = 0;
			while (true)
			{
				var p:Number = tip1.url.charCodeAt(i) || 0;
				var n:Number = tip2.url.charCodeAt(i) || 0;
				var s:Number = p - n;
				if (s) return s;
				if (!p) break;
				i++;
			}
			return 0;
		}
		
		/** ドラッグ開始 */
		public function setDrag(flg:Boolean = true):void
		{
			this.removeEventListener(TouchEvent.TOUCH, mouseOperated);
			if (flg)
			{
				
				_leftLimit = -(this.width - CommonDef.WINDOW_W) + 64 + pivotX;
				_rightLimit = 64 + pivotX;
				_upLimit = -(this.height - CommonDef.WINDOW_H) + 64 + pivotY;
				_downLimit = 64 + pivotY;
				
				this.addEventListener(TouchEvent.TOUCH, mouseOperated);
			}
		}
		
		/** ドラッグ&ドロップハンドラー */
		protected function mouseOperated(eventObject:TouchEvent):void
		{
			var target:DisplayObject = eventObject.currentTarget as DisplayObject;
			
			var myTouch:Touch = eventObject.getTouch(target, TouchPhase.MOVED);
			
			if (myTouch)
			{
				var nMoveX:Number = myTouch.globalX - myTouch.previousGlobalX;
				var nMoveY:Number = myTouch.globalY - myTouch.previousGlobalY;
				
				target.x += nMoveX;
				target.y += nMoveY;
				
				// 横位置修正
				if (target.x < _leftLimit)
				{
					target.x = _leftLimit;
				}
				else if (target.x > _rightLimit)
				{
					target.x = _rightLimit;
				}
				
				// 縦位置修正
				if (target.y < _upLimit)
				{
					target.y = _upLimit;
				}
				else if (target.y > _downLimit)
				{
					target.y = _downLimit;
				}
				
			}
		}
		
		/**周囲のマップチップ状況取得*/
		protected function getAroundUtl(num:int, url:String):int
		{
			var base:int = 0;
			var count:int = 0;
			var ans:int = 0;
			var dbg:String = "";
			//上段
			if (num >= _mapWidth)
			{
				//左上
				if (num >= _mapWidth + 1)
				{
					if (url === _tip[_layer][num - _mapWidth - 1].url)
					{
						base = 1;
						count |= base;
						dbg += "/左上";
					}
				}
				//上
				if (url === _tip[_layer][num - _mapWidth].url)
				{
					base = 1;
					base <<= 1;
					count |= base;
					dbg += "/上";
				}
				//右上
				if (url === _tip[_layer][num - _mapWidth + 1].url)
				{
					base = 1;
					base <<= 2;
					count |= base;
					dbg += "/右上";
				}
			}
			else
			{
				//左上
				base = 1;
				count |= base;
				dbg += "/左上";
				//上
				base = 1;
				base <<= 1;
				count |= base;
				dbg += "/上";
				//右上
				base = 1;
				base <<= 2;
				count |= base;
				dbg += "/右上";
			}
			
			if (num % _mapWidth > 0 && num > 0)
			{
				//左
				if (url === _tip[_layer][num - 1].url)
				{
					base = 1;
					base <<= 3;
					count |= base;
					dbg += "/左";
					
				}
			}
			else
			{
				
				//左上
				base = 1;
				count |= base;
				dbg += "/左上";
				
				base = 1;
				base <<= 3;
				count |= base;
				dbg += "/左";
				
				//左下
				base = 1;
				base <<= 5;
				count |= base;
				dbg += "/左下";
				
			}
			
			if (num % _mapWidth < _mapWidth - 1 && num < _tip[_layer].length - 1)
			{
				
				//右
				if (url === _tip[_layer][num + 1].url)
				{
					
					base = 1;
					base <<= 4;
					count |= base;
					dbg += "/右";
				}
			}
			else
			{
				//右上
				base = 1;
				base <<= 2;
				count |= base;
				dbg += "/右上";
				//右
				base = 1;
				base <<= 4;
				count |= base;
				dbg += "/右";
				//右下
				base = 1;
				base <<= 7;
				count |= base;
				dbg += "/右下/";
			}
			
			if (num < _tip[_layer].length - _mapWidth)
			{
				//左下
				if (url === _tip[_layer][num + _mapWidth - 1].url)
				{
					base = 1;
					base <<= 5;
					count |= base;
					dbg += "/左下";
				}
				//下
				if (url === _tip[_layer][num + _mapWidth].url)
				{
					base = 1;
					base <<= 6;
					count |= base;
					dbg += "/下";
					
				}
				//右下
				if (num < _tip[_layer].length - mapWidth - 1)
				{
					if (url === _tip[_layer][num + _mapWidth + 1].url)
					{
						base = 1;
						base <<= 7;
						count |= base;
						dbg += "/右下/";
					}
				}
			}
			else
			{
				//左下
				base = 1;
				base <<= 5;
				count |= base;
				dbg += "/左下";
				//下
				base = 1;
				base <<= 6;
				count |= base;
				dbg += "/下";
				//右下
				base = 1;
				base <<= 7;
				count |= base;
				dbg += "/右下/";
			}
			
			trace(dbg + "\n");
			
			var autoTile:Boolean = false;
			//オートタイル
			if (autoTile)
			{
				ans = CommonMapMath.autoTileCount(count);
			}
			//オートオブジェ
			else if (autoTile)
			{
				ans = CommonMapMath.autoObjCount(count);
			}
			//trace(count + ":" + dbg + "【" + ans + "】");
			return ans;
		
		}
	}
}