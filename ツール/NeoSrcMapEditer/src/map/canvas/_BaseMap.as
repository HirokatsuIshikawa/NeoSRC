package map.canvas
{
	import a24.tween.Tween24;
	import feathers.display.TiledImage;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import map.pallet.Pallet;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import view.MainController;
	
	/**
	 * ...
	 * @author
	 */
	public class BaseMap extends Sprite
	{
		private const MAP_SIZE:int = 32;
		private const MAP_WIDTH:int = 30;
		private const MAP_HEIGHT:int = 20;
		private var m_mapWidth:int = 0;
		private var m_mapHeight:int = 0;
		
		private var m_backImg:Image = null;
		private var m_tileImg:TiledImage = null;
		
		private var m_rectImg:TiledImage = null;
		private var m_rectStart:Point = null;
		
		private var m_canvasArea:Sprite = null;
		private var m_tipArea:Sprite = null;
		private var m_tip:Vector.<CanvasTip> = null;
		/**選択レイヤー番号*/
		private var m_layer:int = 0;
		
		/**コピー配列範囲*/
		private var m_copyArea:Image = null;
		private var m_copyStart:Point = null;
		private var m_copyList:Vector.<CopyTip> = null;
		private var m_peasteView:Sprite = null;
		private var m_peastBack:Image = null;
		
		public function BaseMap()
		{
			super();
			m_mapWidth = MAP_WIDTH;
			m_mapHeight = MAP_HEIGHT;
			
			//描画フィールド
			m_canvasArea = new Sprite();
			m_canvasArea.addEventListener(TouchEvent.TOUCH, clickHandler);
			m_canvasArea.addEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
			m_canvasArea.clipRect = new Rectangle(0, 0, MAP_SIZE * MAP_WIDTH, MAP_SIZE * MAP_HEIGHT);
			addChild(m_canvasArea);
			
			//背景イメージ
			m_backImg = new Image(Texture.fromBitmapData(new BitmapData(MAP_SIZE * MAP_WIDTH, MAP_SIZE * MAP_HEIGHT, true, 0xFFFFFFFF)));
			m_canvasArea.addChild(m_backImg);
			//タイルイメージ
			m_tileImg = new TiledImage(Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0xFFFFFFFF)));
			m_tileImg.x = MAP_SIZE * -2;
			m_tileImg.y = MAP_SIZE * -2;
			m_tileImg.visible = false;
			m_tileImg.smoothing = TextureSmoothing.NONE;
			m_tileImg.setSize(MAP_SIZE * (MAP_WIDTH + 4), MAP_SIZE * (MAP_HEIGHT + 4));
			m_canvasArea.addChild(m_tileImg);
			
			m_rectImg = new TiledImage(Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0xFF0000FF)));
			m_rectImg.visible = false;
			m_copyArea = new Image(Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0x550000FF)));
			m_copyArea.smoothing = TextureSmoothing.NONE;
			m_copyArea.visible = false;
			m_peasteView = new Sprite();
			//貼り付け選択範囲
			m_peastBack = Image.fromBitmap(new Bitmap(new BitmapData(32, 32, true, 0x66FF0000)));
			m_peastBack.smoothing = TextureSmoothing.NONE;
			m_peasteView.addChild(m_peastBack);
			m_peasteView.visible = false;
			setTipArea(m_mapWidth, m_mapHeight);
		}
		
		/**チップ再配置*/
		public function setTipArea(wid:int, hgt:int):void
		{
			var sizeWidth:int = 0;
			var sizeHeight:int = 0;
			
			m_mapWidth = wid;
			m_mapHeight = hgt;
			
			if (sizeWidth > 30) {
				sizeWidth = 30;
			} else {
				sizeWidth = m_mapWidth;
			}
			
			if (sizeHeight > 20) {
				sizeHeight = 20;
			} else {
				sizeHeight = m_mapHeight;
			}
			
			
			m_canvasArea.clipRect = new Rectangle(0, 0, MAP_SIZE * sizeWidth, MAP_SIZE * sizeHeight);
			//やり直し時破棄
			if (m_tipArea != null)
			{
				m_tipArea.removeChildren();
				for (var count:int = 0; i < m_tip.length; i++)
				{
					m_tip[i].dispose();
					m_tip.pop();
				}
			}
			else
			{
				m_tipArea = new Sprite();
			}
			
			m_canvasArea.addChild(m_tipArea);
			m_tip = new Vector.<CanvasTip>;
			for (var i:int = 0; i < m_mapHeight; i++)
			{
				for (var j:int = 0; j < m_mapWidth; j++)
				{
					var tip:CanvasTip = new CanvasTip(new Image(Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0x0))), "blank", "blank");
					tip.x = j * MAP_SIZE;
					tip.y = i * MAP_SIZE;
					m_tipArea.addChild(tip);
					m_tip.push(tip);
				}
			}
			m_canvasArea.addChild(m_rectImg);
			m_canvasArea.addChild(m_copyArea);
			m_canvasArea.addChild(m_peasteView);
			this.alpha = 1;
			this.visible = true;
		}
		
		/**位置からパレット取得*/
		private function getPalletNo(pos:Point):void
		{
			if (pos.x >= 0 && pos.x < m_canvasArea.width && pos.y >= 0 && pos.y < m_canvasArea.height)
			{
				var num:int = 0;
				num += Math.floor(pos.x / 32);
				num += Math.floor(pos.y / 32) * m_mapWidth;
				var x:int = Math.floor(num % m_mapWidth);
				var y:int = Math.floor(num / m_mapWidth);
				if (num >= 0 && num < m_tip.length)
				{
					switch (MainController.$.view.pallet.palletState)
					{
						case Pallet.PALLET_PEAST: 
							if (m_peasteView.visible == false)
							{
								m_peasteView.visible = true;
								m_peasteView.alpha = 0.5;
							}
							m_peasteView.x = x * MAP_SIZE;
							m_peasteView.y = y * MAP_SIZE;
							break;
						case Pallet.PALLET_SIMPLE: 
							draw(num);
							break;
						case Pallet.PALLET_FILL: 
							fillAct(num, m_tip[num].tipName[m_layer]);
							//一回塗ったらもどす
							MainController.$.view.pallet.palletStateSet(Pallet.PALLET_SIMPLE);
							break;
						case Pallet.PALLET_RECT: 
							if (m_rectImg.visible == false)
							{
								m_rectStart = new Point(x, y);
								
								if (MainController.$.view.pallet.autoTile && MainController.$.view.pallet.selectNum == 0)
								{
									m_rectImg.texture = Texture.fromBitmap(new Bitmap(new BitmapData(32, 32, true, 0x994444FF)));
									;
								}
								else
								{
									m_rectImg.texture = MainController.$.view.pallet.selectTip.texture;
								}
								m_rectImg.x = MAP_SIZE * m_rectStart.x;
								m_rectImg.y = MAP_SIZE * m_rectStart.y;
								m_rectImg.visible = true;
								m_rectImg.alpha = 0.5;
								m_rectImg.smoothing = TextureSmoothing.NONE;
								m_rectImg.setSize(MAP_SIZE, MAP_SIZE);
							}
							else
							{
								var width:int = 0;
								var height:int = 0;
								//縦幅
								if (x >= m_rectStart.x)
								{
									m_rectImg.x = MAP_SIZE * m_rectStart.x;
									width = (x - m_rectStart.x + 1) * MAP_SIZE;
								}
								else
								{
									m_rectImg.x = MAP_SIZE * x;
									width = (m_rectStart.x - x) * MAP_SIZE;
								}
								//横幅
								if (y >= m_rectStart.y)
								{
									m_rectImg.y = MAP_SIZE * m_rectStart.y;
									height = (y - m_rectStart.y + 1) * MAP_SIZE;
								}
								else
								{
									m_rectImg.y = MAP_SIZE * y;
									height = (m_rectStart.y - y) * MAP_SIZE;
								}
								
								m_rectImg.setSize(width, height);
							}
							break;
						case Pallet.PALLET_SPOIT: 
							MainController.$.view.pallet.selectTip.texture = m_tip[num].img[m_layer].texture;
							MainController.$.view.pallet.url = m_tip[num].url[m_layer];
							MainController.$.view.pallet.tipName = m_tip[num].tipName[m_layer];
							MainController.$.view.pallet.palletStateSet(Pallet.PALLET_SIMPLE);
							break;
						case Pallet.PALLET_COPY: 
							if (m_copyArea.visible == false)
							{
								m_copyStart = new Point(x, y);
								m_copyArea.x = MAP_SIZE * m_copyStart.x;
								m_copyArea.y = MAP_SIZE * m_copyStart.y;
								m_copyArea.visible = true;
								m_copyArea.width = MAP_SIZE;
								m_copyArea.height = MAP_SIZE;
							}
							else
							{
								var c_width:int = 0;
								var c_height:int = 0;
								//縦幅
								if (x >= m_copyStart.x)
								{
									m_copyArea.x = MAP_SIZE * m_copyStart.x;
									c_width = (x - m_copyStart.x + 1) * MAP_SIZE;
								}
								else
								{
									m_copyArea.x = MAP_SIZE * x;
									c_width = (m_copyStart.x - x) * MAP_SIZE;
								}
								//横幅
								if (y >= m_copyStart.y)
								{
									m_copyArea.y = MAP_SIZE * m_copyStart.y;
									c_height = (y - m_copyStart.y + 1) * MAP_SIZE;
								}
								else
								{
									m_copyArea.y = MAP_SIZE * y;
									c_height = (m_copyStart.y - y) * MAP_SIZE;
								}
								m_copyArea.width = c_width;
								m_copyArea.height = c_height;
							}
							
							break;
					}
				}
			}
		}
		
		/**四角塗りセット*/
		private function endedAct(pos:Point):void
		{
			
			//ペースト
			if (MainController.$.view.pallet.palletState == Pallet.PALLET_PEAST && m_peasteView.visible == true)
			{
				if (m_copyList == null)
				{
					m_peasteView.visible = false;
					return;
				}
				for (var k:int = 0; k < m_copyList.length; k++)
				{
					var setPos:int = Math.floor(pos.x / MAP_SIZE) + m_copyList[k].posX + (Math.floor(pos.y / MAP_SIZE) + m_copyList[k].posY) * m_mapWidth;
					if (k < 0 || k >= m_tip.length)
					{
						continue;
					}
					m_tip[setPos].draw(m_layer, m_copyList[k].img, m_copyList[k].url, m_copyList[k].name);
				}
				m_peasteView.visible = false;
			}
			//四角形以外はセットしない
			else if ((MainController.$.view.pallet.palletState == Pallet.PALLET_RECT && m_rectImg.visible == true) || (MainController.$.view.pallet.palletState == Pallet.PALLET_COPY && m_copyArea.visible == true))
			{
				var num:int = 0;
				num += Math.floor(pos.x / 32);
				num += Math.floor(pos.y / 32) * m_mapWidth;
				var pos_x:int = Math.floor(num % m_mapWidth);
				var pos_y:int = Math.floor(num / m_mapWidth);
				var start_x:int = 0;
				var start_y:int = 0;
				var end_x:int = 0;
				var end_y:int = 0;
				var posi:Point = null;
				
				m_copyList = new Vector.<CopyTip>;
				m_peasteView.removeChildren();
				
				if (MainController.$.view.pallet.palletState == Pallet.PALLET_RECT)
				{
					posi = m_rectStart;
				}
				else if (MainController.$.view.pallet.palletState == Pallet.PALLET_COPY)
				{
					posi = m_copyStart;
				}
				
				//X開始・終了地点セット
				if (posi.x <= pos_x)
				{
					start_x = posi.x;
					end_x = pos_x + 1;
				}
				else
				{
					start_x = pos_x;
					end_x = posi.x;
				}
				//Y開始・終了地点セット
				if (posi.y <= pos_y)
				{
					start_y = posi.y;
					end_y = pos_y + 1;
				}
				else
				{
					start_y = pos_y;
					end_y = posi.y;
				}
				
				for (var i:int = start_y; i < end_y; i++)
				{
					for (var j:int = start_x; j < end_x; j++)
					{
						//取得位置割り出し
						var position:int = 0;
						position = i * m_mapWidth;
						position += j;
						//四角形
						if (MainController.$.view.pallet.palletState == Pallet.PALLET_RECT)
						{
							
							draw(position);
								//m_tip[position].draw(m_layer, MainController.$.view.pallet.selectTip, MainController.$.view.pallet.url, MainController.$.view.pallet.name);
						}
						//コピー
						else if (MainController.$.view.pallet.palletState == Pallet.PALLET_COPY)
						{
							var copy:CopyTip = new CopyTip();
							copy.img = m_tip[position].img[m_layer];
							copy.name = m_tip[position].tipName[m_layer];
							copy.url = m_tip[position].url[m_layer];
							copy.posX = j - start_x;
							copy.posY = i - start_y;
							copy.img.x = copy.posX * MAP_SIZE;
							copy.img.y = copy.posY * MAP_SIZE;
							m_peasteView.addChild(copy.img)
							m_copyList.push(copy);
							
							m_peastBack.width = (j - start_x + 1) * MAP_SIZE;
							m_peastBack.height = (i - start_y + 1) * MAP_SIZE;
							m_peasteView.addChild(m_peastBack);
						}
					}
				}
				
				m_rectImg.visible = false;
				m_copyArea.visible = false;
			}
		}
		
		/**塗りつぶし*/
		private function fillAct(num:int, name:String):void
		{
			if (num < 0 || num >= m_tip.length || m_tip[num].tipName[m_layer] != name || name === MainController.$.view.pallet.tipName)
				return;
			
			//オートタイル時
			if (MainController.$.view.pallet.autoTile && MainController.$.view.pallet.selectNum == 0)
			{
				if (m_tip[num].url[m_layer] === MainController.$.view.pallet.url)
				{
					return;
				}
				draw(num);
			}
			else
			{
				m_tip[num].draw(m_layer, MainController.$.view.pallet.selectTip, MainController.$.view.pallet.url, MainController.$.view.pallet.tipName);
			}
			fillAct(num + 1, name);
			fillAct(num - 1, name);
			fillAct(num + m_mapWidth, name);
			fillAct(num - m_mapWidth, name);
		}
		
		/**背景タイルセット*/
		public function setBackTile():void
		{
			m_tileImg.texture = MainController.$.view.pallet.selectTip.texture;
			m_tileImg.visible = true;
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
				Tween24.tween(m_tileImg, MainController.$.view.tileConfig.time).$$xy(MainController.$.view.tileConfig.xNum, MainController.$.view.tileConfig.yNum).onComplete(moveTile) //
				).play()
		}
		
		private function rightClickHandler(event:MouseEvent):void
		{
			var touch:Object = event.currentTarget;
			//タッチしているか
			var pos:Point;
		}
		
		private function clickHandler(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(m_canvasArea);
			//タッチしているか
			var pos:Point;
			if (touch)
			{
				pos = m_canvasArea.globalToLocal(new Point(touch.globalX, touch.globalY));
				//クリック上げた時
				switch (touch.phase)
				{
					case TouchPhase.ENDED: 
						endedAct(pos);
						this.m_tipArea.flatten();
						break;
					case TouchPhase.HOVER: 
						break;
					case TouchPhase.MOVED: 
						getPalletNo(pos);
						this.m_tipArea.flatten();
						break;
					case TouchPhase.BEGAN: 
						getPalletNo(pos);
						this.m_tipArea.flatten();
						break;
				}
			}
		}
		
		public function set layer(value:int):void
		{
			m_layer = value;
			for (var i:int = 0; i < m_tip.length; i++)
			{
				m_tip[i].showChange(value + 1);
			}
			this.m_tipArea.flatten();
		}
		
		public function get tip():Vector.<CanvasTip>
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
		
		/**描画*/
		private function draw(num:int):void
		{
			//オートタイル時
			if ((MainController.$.view.pallet.autoTile || MainController.$.view.pallet.autoObj) && MainController.$.view.pallet.selectNum == 0)
			{
				//塗りつぶし時、同じ名前の所から塗りつぶせない
				if (m_tip[num].url[m_layer] === MainController.$.view.pallet.url && MainController.$.view.pallet.palletState == Pallet.PALLET_FILL)
				{
					return;
				}
				
				var count:int = 0;
				var number:int = getAroundUtl(num, MainController.$.view.pallet.url);
				var obj:Object = MainController.$.view.pallet.autoTileTip(number);
				m_tip[num].draw(m_layer, obj.img, obj.url, obj.name);
				
				function addDraw(count:int):void
				{
					if (count >= 0 && count < m_tip.length && m_tip[count].url[m_layer] === MainController.$.view.pallet.url)
					{
						number = getAroundUtl(count, MainController.$.view.pallet.url);
						obj = MainController.$.view.pallet.autoTileTip(number);
						m_tip[count].draw(m_layer, obj.img, obj.url, obj.name);
					}
				}
				
				//左上
				count = num - m_mapWidth - 1;
				addDraw(count);
				//上
				count = num - m_mapWidth;
				addDraw(count);
				//右上
				count = num - m_mapWidth + 1;
				addDraw(count);
				//左
				count = num - 1;
				addDraw(count);
				//右
				count = num + 1;
				addDraw(count);
				
				//左下
				count = num + m_mapWidth - 1;
				addDraw(count);
				//下
				count = num + m_mapWidth;
				addDraw(count);
				//右下
				count = num + m_mapWidth + 1;
				addDraw(count);
			}
			else
			{
				//m_tip[num].draw(m_layer, MainController.$.view.pallet.selectTip, MainController.$.view.pallet.url, MainController.$.view.pallet.name);
				m_tip[num].draw(m_layer, MainController.$.view.pallet.selectTip, MainController.$.view.pallet.url, MainController.$.view.pallet.tipName);
			}
		}
		
		/**ビット演算*/
		private function autoTileCheck(data:int, filter:int):Boolean
		{
			data &= filter;
			if (data >= filter)
			{
				return true;
			}
			return false;
		}
		
		/**周囲のマップチップ状況取得*/
		private function getAroundUtl(num:int, url:String):int
		{
			var base:int = 0;
			var count:int = 0;
			var ans:int = 0;
			var dbg:String = "";
			//上段
			if (num >= m_mapWidth)
			{
				//左上
				if (num >= m_mapWidth + 1)
				{
					if (url === m_tip[num - m_mapWidth - 1].url[m_layer])
					{
						base = 1;
						count += base;
						dbg += "/左上";
					}
				}
				//上
				if (url === m_tip[num - m_mapWidth].url[m_layer])
				{
					base = 1;
					base <<= 1;
					count += base;
					dbg += "/上";
				}
				//右上
				if (url === m_tip[num - m_mapWidth + 1].url[m_layer])
				{
					base = 1;
					base <<= 2;
					count += base;
					dbg += "/右上";
				}
			}
			if (num % m_mapWidth > 0 && num > 0)
			{
				//左
				if (url === m_tip[num - 1].url[m_layer])
				{
					base = 1;
					base <<= 3;
					count += base;
					dbg += "/左";
					
				}
			}
			if (num % m_mapWidth < m_mapWidth - 1 && num < m_tip.length - 1)
			{
				
				//右
				if (url === m_tip[num + 1].url[m_layer])
				{
					
					base = 1;
					base <<= 4;
					count += base;
					dbg += "/右";
					
				}
			}
			if (num < m_tip.length - m_mapWidth)
			{
				//左下
				if (url === m_tip[num + m_mapWidth - 1].url[m_layer])
				{
					base = 1;
					base <<= 5;
					count += base;
					dbg += "/左下";
				}
				//下
				if (url === m_tip[num + m_mapWidth].url[m_layer])
				{
					base = 1;
					base <<= 6;
					count += base;
					dbg += "/下";
					
				}
				//右下
				if (num < m_tip.length - mapWidth - 1)
				{
					if (url === m_tip[num + m_mapWidth + 1].url[m_layer])
					{
						base = 1;
						base <<= 7;
						count += base;
						dbg += "/右下/";
					}
				}
			}
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
					ans = 47;
				}
				//////////////////////////////////////７枚
				//左上以外
				else if (autoTileCheck(count, 254))
				{
					ans = 41;
				}
				//右上以外
				else if (autoTileCheck(count, 251))
				{
					ans = 42;
				}
				//左下以外
				else if (autoTileCheck(count, 223))
				{
					ans = 44;
				}
				//右下以外
				else if (autoTileCheck(count, 127))
				{
					ans = 45;
				}
				///////////////////////////////////６枚
				//左上右下以外
				else if (autoTileCheck(count, 126))
				{
					ans = 46;
				}
				//右上左下以外
				else if (autoTileCheck(count, 219))
				{
					ans = 43;
				}
				///////////////////////////////////５枚
				//左右下全部
				else if (autoTileCheck(count, 248))
				{
					ans = 33;
				}
				//上下左全部
				else if (autoTileCheck(count, 107))
				{
					ans = 35;
				}
				//左右上全部
				else if (autoTileCheck(count, 31))
				{
					ans = 37;
				}
				//上下右前部
				else if (autoTileCheck(count, 214))
				{
					ans = 39;
				}
				/////////////////////////３枚
				//右右下下
				else if (autoTileCheck(count, 208))
				{
					ans = 19;
				}
				//左左下下
				else if (autoTileCheck(count, 104))
				{
					ans = 23;
				}
				//上右上右
				else if (autoTileCheck(count, 22))
				{
					ans = 27;
				}
				//上左上左
				else if (autoTileCheck(count, 11))
				{
					ans = 31;
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