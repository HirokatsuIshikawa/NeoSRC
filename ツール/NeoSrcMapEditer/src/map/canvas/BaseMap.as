package map.canvas
{
	import a24.tween.Tween24;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import system.CommonDef;
	import main.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class BaseMap extends Sprite
	{
		// const
		public static const MAP_SIZE:int = 32;
		public static const MAP_WIDTH:int = 30;
		public static const MAP_HEIGHT:int = 20;
		
		// value
		protected var m_mapWidth:int = 0;
		protected var m_mapHeight:int = 0;
		
		// component
		protected var m_backImg:Image = null;
		protected var m_tileImg:Image = null;
		protected var m_canvasArea:Sprite = null;
		protected var m_tipArea:Vector.<Sprite> = null;
		protected var m_tip:Vector.<Vector.<CanvasTip>> = null;
		
		public static var _blankTex:Texture = null;
		
		/**
		
		   /**選択レイヤー番号*/
		protected var m_layer:int = 0;
		
		public function BaseMap()
		{
			super();
			m_mapWidth = MAP_WIDTH;
			m_mapHeight = MAP_HEIGHT;
			
			//描画フィールド
			m_canvasArea = new Sprite();
			//m_canvasArea.mask = new Quad(MAP_SIZE * MAP_WIDTH, MAP_SIZE * MAP_HEIGHT);
			addChild(m_canvasArea);
			
			//背景イメージ
			m_backImg = new Image(Texture.fromBitmapData(new BitmapData(MAP_SIZE * MAP_WIDTH, MAP_SIZE * MAP_HEIGHT, true, 0xFFFFFFFF)));
			m_canvasArea.addChild(m_backImg);
			//タイルイメージ
			m_tileImg = new Image(Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0xFFFFFFFF)));
			m_tileImg.x = MAP_SIZE * -2;
			m_tileImg.y = MAP_SIZE * -2;
			m_tileImg.visible = false;
			m_tileImg.textureSmoothing = TextureSmoothing.NONE;
			//m_tileImg.setSize(MAP_SIZE * (MAP_WIDTH + 4), MAP_SIZE * (MAP_HEIGHT + 4));
			m_tileImg.width = MAP_SIZE * (MAP_WIDTH + 4);
			m_tileImg.height = MAP_SIZE * (MAP_HEIGHT + 4);
			//m_tileImg.tileGrid = new Rectangle();
			
			m_canvasArea.addChild(m_tileImg);
		
		}
		
		/** データ廃棄 */
		public override function dispose():void
		{
			super.dispose();
			CommonDef.disposeList([m_backImg, m_tileImg, m_canvasArea, m_tipArea, m_tip, _blankTex]);
			m_backImg = null;
			m_tileImg = null;
			m_canvasArea = null;
			m_tipArea = null;
			m_tip = null;
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
			
			m_mapWidth = wid;
			m_mapHeight = hgt;
			
			if (sizeWidth > 30)
			{
				sizeWidth = 30;
			}
			else
			{
				sizeWidth = m_mapWidth;
			}
			
			if (sizeHeight > 20)
			{
				sizeHeight = 20;
			}
			else
			{
				sizeHeight = m_mapHeight;
			}
			
			//m_canvasArea.mask = new Quad(MAP_SIZE * sizeWidth, MAP_SIZE * sizeHeight);
			//やり直し時破棄
			if (m_tipArea != null)
			{
				for (i = 0; i < m_tip.length; )
				{
					if (m_tipArea[i] != null)
					{
						m_tipArea[i].removeChildren();
						for (j = 0; j < m_tip[i].length; )
						{
							m_tip[i][j].dispose();
							m_tip[i].shift();
						}
					}
					m_tip.shift();
				}
				
				m_canvasArea.addChild(m_tipArea[0]);
				m_canvasArea.addChild(m_tipArea[1]);
				m_canvasArea.addChild(m_tipArea[2]);
			}
			else
			{
				m_tipArea = new Vector.<Sprite>;
				m_tipArea[0] = new Sprite();
				m_tipArea[1] = new Sprite();
				m_tipArea[2] = new Sprite();
				m_canvasArea.addChild(m_tipArea[0]);
				m_canvasArea.addChild(m_tipArea[1]);
				m_canvasArea.addChild(m_tipArea[2]);
			}
			
			if (_blankTex == null)
			{
				_blankTex = Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0x0));
			}
			
			m_tip = new Vector.<Vector.<CanvasTip>>;
			
			for (i = 0; i < 3; i++)
			{
				m_tip[i] = new Vector.<CanvasTip>;
				for (j = 0; j < m_mapHeight; j++)
				{
					for (k = 0; k < m_mapWidth; k++)
					{
						var tip:CanvasTip = new CanvasTip(_blankTex, "blank", "blank");
						
						tip.x = k * MAP_SIZE;
						tip.y = j * MAP_SIZE;
						m_tipArea[i].addChild(tip);
						m_tip[i].push(tip);
					}
				}
			}
			this.alpha = 1;
			this.visible = true;
		
		}
		
		/**背景タイルセット*/
		public function setBackTile():void
		{
			m_tileImg.texture = MainController.$.view.pallet.selectTip.texture;
			m_tileImg.visible = true;
			m_tileImg.tileGrid = new Rectangle();
			moveTile();
		}
		
		/**タイル移動*/
		public function moveTile():void
		{
			if (MainController.$.view.tileConfig.time <= 0)
			{
				return;
			}
			var numX:int = m_tileImg.x;
			var numY:int = m_tileImg.y;
			
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
			Tween24.prop(m_tileImg).xy(numX, numY), //
			Tween24.tween(m_tileImg, MainController.$.view.tileConfig.time).$$xy(MainController.$.view.tileConfig.xNum, MainController.$.view.tileConfig.yNum).onUpdate(cutPos).onComplete(moveTile) //
			).play()
		}
		
		private function cutPos():void
		{
			m_tileImg.x = Math.floor(m_tileImg.x);
			m_tileImg.y = Math.floor(m_tileImg.y);
		}
		
		public function set layer(value:int):void
		{
			m_layer = value;
			
			for (var i:int = 0; i < 3; i++)
			{
				
				if (i <= m_layer)
				{
					m_tipArea[i].alpha = 1;
				}
				else
				{
					m_tipArea[i].alpha = 0.5;
				}
				
			}
		}
		
		public function get tip():Vector.<Vector.<CanvasTip>>
		{
			return m_tip;
		}
		
		public function get mapWidth():int
		{
			return m_mapWidth;
		}
		
		public function get mapHeight():int
		{
			return m_mapHeight;
		}
		
		public function set mapWidth(value:int):void
		{
			m_mapWidth = value;
		}
		
		public function set mapHeight(value:int):void
		{
			m_mapHeight = value;
		}
		
		/**ビット演算*/
		protected function autoTileCheck(data:int, filter:int):Boolean
		{
			data &= filter;
			if (data >= filter)
			{
				return true;
			}
			return false;
		}
		
		/** チップをURL順に並び替え、改装を合わせる */
		public function refreshTip(layer:int):void
		{
			m_tipArea[layer].sortChildren(sortTipUrl);
		}
		
		public function sortTipUrl(tip1:CanvasTip, tip2:CanvasTip):Number
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
		
		/**周囲のマップチップ状況取得*/
		protected function getAroundUtl(num:int, baseName:String):int
		{
			var base:int = 0;
			var count:int = 0;
			var ans:int = 0;
			var dbg:String = "";
			var tipStr:String = "";
			var compStr:String = "";
			var compFlg:Boolean = false;
			//上段
			if (num >= m_mapWidth)
			{
				//左上
				if (num >= m_mapWidth + 1)
				{
					tipStr = m_tip[m_layer][num - m_mapWidth - 1].tipName;
					compStr = tipStr.substr(0, tipStr.lastIndexOf("_") + 1);
					compFlg = baseName === compStr ? true : false;
					if (compFlg)
					{
						base = 1;
						count |= base;
						dbg += "/左上";
					}
				}
				//上
				tipStr = m_tip[m_layer][num - m_mapWidth].tipName;
				compStr = tipStr.substr(0, tipStr.lastIndexOf("_") + 1);
				compFlg = baseName === compStr ? true : false;
				if (compFlg)
				{
					base = 1;
					base <<= 1;
					count |= base;
					dbg += "/上";
				}
				//右上
				
				tipStr = m_tip[m_layer][num - m_mapWidth + 1].tipName;
				compStr = tipStr.substr(0, tipStr.lastIndexOf("_") + 1);
				compFlg = baseName === compStr ? true : false;
				if (compFlg)
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
			
			if (num % m_mapWidth > 0 && num > 0)
			{
				//左				
				tipStr = m_tip[m_layer][num - 1].tipName;
				compStr = tipStr.substr(0, tipStr.lastIndexOf("_") + 1);
				compFlg = baseName === compStr ? true : false;
				if (compFlg)
					
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
			
			if (num % m_mapWidth < m_mapWidth - 1 && num < m_tip[m_layer].length - 1)
			{
				
				//右				
				tipStr = m_tip[m_layer][num + 1].tipName;
				compStr = tipStr.substr(0, tipStr.lastIndexOf("_") + 1);
				compFlg = baseName === compStr ? true : false;
				if (compFlg)
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
			
			if (num < m_tip[m_layer].length - m_mapWidth)
			{
				//左下
				
				tipStr = m_tip[m_layer][num + m_mapWidth - 1].tipName;
				compStr = tipStr.substr(0, tipStr.lastIndexOf("_") + 1);
				compFlg = baseName === compStr ? true : false;
				if (compFlg)
					
				{
					base = 1;
					base <<= 5;
					count |= base;
					dbg += "/左下";
				}
				//下
				
				tipStr = m_tip[m_layer][num + m_mapWidth].tipName;
				compStr = tipStr.substr(0, tipStr.lastIndexOf("_") + 1);
				compFlg = baseName === compStr ? true : false;
				if (compFlg)
				{
					base = 1;
					base <<= 6;
					count |= base;
					dbg += "/下";
					
				}
				//右下
				if (num < m_tip[m_layer].length - mapWidth - 1)
				{
					
					tipStr = m_tip[m_layer][num + m_mapWidth + 1].tipName;
					compStr = tipStr.substr(0, tipStr.lastIndexOf("_") + 1);
					compFlg = baseName === compStr ? true : false;
					if (compFlg)
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
			
			//オートタイル
			if (MainController.$.view.pallet.autoTile)
			{
				
				/////////////////////////////////////////////////////全部//////////////////////////////////////////////////////
				if (autoTileCheck(count, 255))
				{
					ans = 47;
				}
				//////////////////////////////////////７枚
				//左上以外
				else if (autoTileCheck(count, 254))
				{
					ans = 32;
				}
				//右上以外
				else if (autoTileCheck(count, 251))
				{
					ans = 33;
				}
				//左下以外
				else if (autoTileCheck(count, 223))
				{
					ans = 40;
				}
				//右下以外
				else if (autoTileCheck(count, 127))
				{
					ans = 41;
				}
				//////////////////////////////////////６枚
				//左下右下以外
				else if (autoTileCheck(count, 95))
				{
					ans = 42;
				}
				
				//左上左下以外
				else if (autoTileCheck(count, 222))
				{
					ans = 43;
				}
				//左上右下以外
				else if (autoTileCheck(count, 126))
				{
					ans = 44;
				}
				//右上左上以外
				else if (autoTileCheck(count, 250))
				{
					ans = 34;
				}
				//右上右下以外
				else if (autoTileCheck(count, 123))
				{
					ans = 35;
				}
				//右上左下以外
				else if (autoTileCheck(count, 219))
				{
					ans = 36;
				}
				///////////////////////////////////５枚
				//左右下全部
				else if (autoTileCheck(count, 248))
				{
					ans = 24;
				}
				//上下左全部
				else if (autoTileCheck(count, 107))
				{
					ans = 25;
				}
				//左右上全部
				else if (autoTileCheck(count, 31))
				{
					ans = 26;
				}
				//上下右前部
				else if (autoTileCheck(count, 214))
				{
					ans = 27;
				}
				//上下左右右上
				else if (autoTileCheck(count, 94))
				{
					ans = 45;
				}
				//上下左右左上
				else if (autoTileCheck(count, 91))
				{
					ans = 46;
				}
				//上下左右右下
				else if (autoTileCheck(count, 218))
				{
					ans = 37;
				}
				//上下左右左下
				else if (autoTileCheck(count, 122))
				{
					ans = 38;
				}
				///////////////////////////////////４枚
				//上下左左上
				else if (autoTileCheck(count, 75))
				{
					ans = 21;
				}
				//上左右右上
				else if (autoTileCheck(count, 30))
				{
					ans = 22;
				}
				//上下右右下
				else if (autoTileCheck(count, 210))
				{
					ans = 23;
				}
				
				//左右下右下
				else if (autoTileCheck(count, 216))
				{
					ans = 28;
				}
				//上下左左下
				else if (autoTileCheck(count, 106))
				{
					ans = 29;
				}
				//左右上左上
				else if (autoTileCheck(count, 27))
				{
					ans = 30;
				}
				//上下右右上
				else if (autoTileCheck(count, 86))
				{
					ans = 31;
				}
				//上下左右
				else if (autoTileCheck(count, 90))
				{
					ans = 39;
				}
				//左右下左下
				else if (autoTileCheck(count, 120))
				{
					ans = 20;
				}
				/////////////////////////３枚
				//右右下下
				else if (autoTileCheck(count, 208))
				{
					ans = 10;
				}
				
				//左左下下
				else if (autoTileCheck(count, 104))
				{
					ans = 11;
				}
				//左右下
				else if (autoTileCheck(count, 88))
				{
					ans = 12;
				}
				//上下左
				else if (autoTileCheck(count, 74))
				{
					ans = 13;
				}
				//左右上
				else if (autoTileCheck(count, 26))
				{
					ans = 14;
				}
				//上下右
				else if (autoTileCheck(count, 82))
				{
					ans = 15;
				}
				//上右上右
				else if (autoTileCheck(count, 22))
				{
					ans = 18;
				}
				//上左上左
				else if (autoTileCheck(count, 11))
				{
					ans = 19;
				}
				
				/////////////////////////２枚
				//上下
				else if (autoTileCheck(count, 66))
				{
					ans = 6;
				}
				//左右
				else if (autoTileCheck(count, 24))
				{
					ans = 7;
				}
				//右と下
				else if (autoTileCheck(count, 80))
				{
					ans = 8;
				}
				//左と下
				else if (autoTileCheck(count, 72))
				{
					ans = 9;
				}
				//上右
				else if (autoTileCheck(count, 18))
				{
					ans = 16;
				}
				//上左
				else if (autoTileCheck(count, 10))
				{
					ans = 17;
				}
				/////////////////////////単体
				//上のみ
				else if (autoTileCheck(count, 2))
				{
					ans = 3;
				}
				//左のみ
				else if (autoTileCheck(count, 8))
				{
					ans = 5;
				}
				//右のみ
				else if (autoTileCheck(count, 16))
				{
					ans = 4;
				}
				//下のみ
				else if (autoTileCheck(count, 64))
				{
					ans = 2;
				}
				else
				{
					ans = 1;
				}
			}
			//オートオブジェ
			else if (MainController.$.view.pallet.autoObj)
			{
				
				/////////////////////////////////////////////////////全部//////////////////////////////////////////////////////
				if (autoTileCheck(count, 255))
				{
					ans = 16;
				}
				//////////////////////////////////////７枚
				//左上以外
				else if (autoTileCheck(count, 254))
				{
					ans = 10;
				}
				//右上以外
				else if (autoTileCheck(count, 251))
				{
					ans = 11;
				}
				//左下以外
				else if (autoTileCheck(count, 223))
				{
					ans = 13;
				}
				//右下以外
				else if (autoTileCheck(count, 127))
				{
					ans = 14;
				}
				///////////////////////////////////６枚
				//左上右下以外
				else if (autoTileCheck(count, 126))
				{
					ans = 15;
				}
				//右上左下以外
				else if (autoTileCheck(count, 219))
				{
					ans = 12;
				}
				///////////////////////////////////５枚
				//左右下全部
				else if (autoTileCheck(count, 248))
				{
					ans = 6;
				}
				//上下左全部
				else if (autoTileCheck(count, 107))
				{
					ans = 7;
				}
				//左右上全部
				else if (autoTileCheck(count, 31))
				{
					ans = 8;
				}
				//上下右前部
				else if (autoTileCheck(count, 214))
				{
					ans = 9;
				}
				/////////////////////////３枚
				//右右下下
				else if (autoTileCheck(count, 208))
				{
					ans = 2;
				}
				//左左下下
				else if (autoTileCheck(count, 104))
				{
					ans = 3;
				}
				//上右上右
				else if (autoTileCheck(count, 22))
				{
					ans = 4;
				}
				//上左上左
				else if (autoTileCheck(count, 11))
				{
					ans = 5;
				}
				else
				{
					ans = 1;
				}
			}
			//trace(count + ":" + dbg + "【" + ans + "】");
			return ans;
		
		}
	}
}