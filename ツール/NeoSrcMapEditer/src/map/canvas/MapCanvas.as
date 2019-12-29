package map.canvas
{
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
	public class MapCanvas extends BaseMap
	{
		
		private var m_rectImg:Image = null;
		private var m_rectStart:Point = null;
		
		/**コピー配列範囲*/
		private var m_copyArea:Image = null;
		private var m_copyStart:Point = null;
		private var m_copyList:Vector.<CopyTip> = null;
		private var m_peasteView:Sprite = null;
		private var m_peastBack:Image = null;
		
		/** 地形データ */
		private var m_terrainLayer:Sprite = null;
		private var m_terrain:Vector.<TerrainTip> = null;
		private var m_terrainBackImg:Image = null;
		
		public function MapCanvas()
		{
			super();
			
			m_rectImg = new Image(Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0xFF0000FF)));
			m_rectImg.visible = false;
			
			m_copyArea = new Image(Texture.fromBitmapData(new BitmapData(MAP_SIZE, MAP_SIZE, true, 0x550000FF)));
			m_copyArea.textureSmoothing = TextureSmoothing.NONE;
			m_copyArea.visible = false;
			
			m_peasteView = new Sprite();
			//貼り付け選択範囲
			m_peastBack = new Image(Texture.fromBitmap(new Bitmap(new BitmapData(32, 32, true, 0x66FF0000))));
			m_peastBack.textureSmoothing = TextureSmoothing.NONE;
			m_peasteView.addChild(m_peastBack);
			m_peasteView.visible = false;
			//setTipArea(m_mapWidth, m_mapHeight);
			
			m_canvasArea.addChild(m_rectImg);
			m_canvasArea.addChild(m_copyArea);
			m_canvasArea.addChild(m_peasteView);
			
			m_terrainLayer = new Sprite();
			m_terrainBackImg = new Image(Texture.fromBitmapData(new BitmapData(4, 4, true, 0x88000000)));
			
			m_terrain = new Vector.<TerrainTip>;
			
			m_terrainLayer.visible = false;
			m_terrainBackImg.visible = false;
			m_terrainBackImg.touchable = false;
			m_canvasArea.addChild(m_terrainBackImg);
			m_canvasArea.addChild(m_terrainLayer);
			
			//描画フィールド
			m_canvasArea.addEventListener(TouchEvent.TOUCH, clickHandler);
			m_canvasArea.addEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
		
		}
		
		public override function setTipArea(wid:int, hgt:int):void
		{
			var i:int = 0;
			var j:int = 0;
			
			super.setTipArea(wid, hgt);
			
			if (m_terrain != null)
			{
				for (i = 0; i < m_terrain.length; )
				{
					m_terrain[0].parent.removeChild(m_terrain[0]);
					m_terrain[0].dispose();
					m_terrain[0] = null;
					m_terrain.shift();
				}
			}
			
			// 地形データ
			for (i = 0; i < m_mapHeight; i++)
			{
				for (j = 0; j < m_mapWidth; j++)
				{
					var terrain:TerrainTip = new TerrainTip();
					terrain.x = j * MAP_SIZE;
					terrain.y = i * MAP_SIZE;
					m_terrainLayer.addChild(terrain);
					m_terrain.push(terrain);
				}
			}
			m_terrainBackImg.width = m_mapWidth * MAP_SIZE;
			m_terrainBackImg.height = m_mapHeight * MAP_SIZE;
			m_terrainLayer.visible = false;
			m_terrainBackImg.visible = false;
			m_backImg.width = MAP_SIZE * m_mapWidth;
			m_backImg.height = MAP_SIZE * m_mapHeight;
			m_canvasArea.addChild(m_terrainBackImg);
			m_canvasArea.addChild(m_terrainLayer);
		}
		
		/** サイズ変更*/
		public function changeMapSize(wid:int, hgt:int):void
		{
			if (wid == m_mapWidth && hgt == m_mapHeight)
			{
				return;
			}
			
			var changeMapTip:Vector.<CanvasTip>;
			var changeTerrainTip:Vector.<TerrainTip>;
			var i:int = 0;
			var j:int = 0;
			var k:int = 0;
			m_tipArea[0].removeChildren();
			m_tipArea[1].removeChildren();
			m_tipArea[2].removeChildren();
			m_terrainLayer.removeChildren();
			
			m_backImg.width = wid * MAP_SIZE;
			m_backImg.height = hgt * MAP_SIZE;
			
			m_tileImg.width = wid * MAP_SIZE;
			m_tileImg.height = hgt * MAP_SIZE;
			
			// 新しい横幅が大きい場合
			
			for (i = 0; i < 4; i++)
			{
				if (i < 3)
				{
					changeMapTip = new Vector.<CanvasTip>;
				}
				else
				{
					changeTerrainTip = new Vector.<TerrainTip>;
				}
				
				for (j = 0; j < hgt; j++)
				{
					for (k = 0; k < wid; k++)
					{
						var nowPos:int = j * m_mapWidth + k;
						if (i < 3)
						{
							var newTip:CanvasTip;
							if (k < m_mapWidth && nowPos < m_tip[i].length)
							{
								newTip = m_tip[i][nowPos];
							}
							else
							{
								newTip = new CanvasTip(_blankTex, "blank", "blank");
							}
							newTip.x = k * MAP_SIZE;
							newTip.y = j * MAP_SIZE;
							m_tipArea[i].addChild(newTip);
							changeMapTip.push(newTip);
						}
						else
						{
							var newterrainTip:TerrainTip;
							if (k < m_mapWidth && nowPos < m_terrain.length)
							{
								newterrainTip = m_terrain[nowPos];
							}
							else
							{
								newterrainTip = new TerrainTip();
							}
							newterrainTip.x = k * MAP_SIZE;
							newterrainTip.y = j * MAP_SIZE;
							terrainLayer.addChild(newterrainTip);
							changeTerrainTip.push(newterrainTip);
						}
					}
				}
				
				if (i < 3)
				{
					for (j = 0; j < m_tip[i].length; j++)
					{
						// 載っていない物を削除
						if (m_tipArea[i].getChildIndex(m_tip[i][j]) < 0)
						{
							var lostTip:Vector.<CanvasTip> = m_tip[i].splice(j, 1);
							lostTip[0].dispose();
							lostTip[0] = null;
							j--;
						}
					}
				}
				else
				{
					for (j = 0; j < m_terrain.length; j++)
					{
						
						if (m_terrainLayer.getChildIndex(m_terrain[j]) < 0)
						{
							var lostTerrain:Vector.<TerrainTip> = m_terrain.splice(j, 1);
							lostTerrain[0].dispose();
							lostTerrain[0] = null;
							j--;
						}
					}
				}
				
				if (i < 3)
				{
					m_tip[i] = changeMapTip;
				}
				else
				{
					m_terrain = changeTerrainTip;
				}
				
			}
			
			m_mapWidth = wid;
			m_mapHeight = hgt;
			
			refreshTip(0);
			refreshTip(1);
			refreshTip(2);
			refreshTerrain();
			//m_canvasArea.mask = new Quad(MAP_SIZE * m_mapWidth, MAP_SIZE * m_mapHeight);
			m_terrainBackImg.width = MAP_SIZE * m_mapWidth;
			m_terrainBackImg.height = MAP_SIZE * m_mapHeight;
			m_backImg.width = MAP_SIZE * m_mapWidth;
			m_backImg.height = MAP_SIZE * m_mapHeight;
			MainController.$.view.setMapCenter();
		}
		
		public function refreshTerrain():void
		{
			for (var i:int = 0; i < m_terrain.length; i++)
			{
				m_terrain[i].refresh();
			}
			m_terrainLayer.sortChildren(sortTerrainName);
		}
		
		public function sortTerrainName(tip1:TerrainTip, tip2:TerrainTip):Number
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
				if (num >= 0 && num < m_tip[m_layer].length)
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
						fillAct(num, m_tip[m_layer][num].tipName);
						//一回塗ったらもどす
						MainController.$.view.pallet.palletStateSet(Pallet.PALLET_SIMPLE);
						break;
					case Pallet.PALLET_RECT: 
						if (m_rectImg.visible == false)
						{
							m_rectStart = new Point(x, y);
							
							if ((MainController.$.view.pallet.autoTile && MainController.$.view.pallet.selectNum == 0) || m_terrainLayer.visible)
							{
								m_rectImg.texture = Texture.fromBitmap(new Bitmap(new BitmapData(32, 32, true, 0x994444FF)));
							}
							else
							{
								m_rectImg.texture = MainController.$.view.pallet.selectTip.texture;
							}
							m_rectImg.x = MAP_SIZE * m_rectStart.x;
							m_rectImg.y = MAP_SIZE * m_rectStart.y;
							m_rectImg.visible = true;
							m_rectImg.alpha = 0.5;
							m_rectImg.textureSmoothing = TextureSmoothing.NONE;
							//m_rectImg.setSize(MAP_SIZE, MAP_SIZE);
							m_rectImg.width = MAP_SIZE;
							m_rectImg.height = MAP_SIZE;
							m_rectImg.tileGrid = new Rectangle();
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
							
							//m_rectImg.setSize(width, height);
							m_rectImg.width = width;
							m_rectImg.height = height;
							m_rectImg.tileGrid = new Rectangle();
						}
						break;
					case Pallet.PALLET_SPOIT: 
						MainController.$.view.pallet.selectTip.texture = m_tip[m_layer][num].texture;
						MainController.$.view.pallet.url = m_tip[m_layer][num].url;
						MainController.$.view.pallet.tipName = m_tip[m_layer][num].tipName;
						MainController.$.view.pallet.palletStateSet(Pallet.PALLET_SIMPLE);
						MainController.$.view.pallet.useSpoit = true;
						if (m_tip[m_layer][num].tipName === "blank" && m_tip[m_layer][num].url === "blank")
						{
							MainController.$.view.pallet.m_elaseFlameImg.visible = true;
						}
						else
						{
							MainController.$.view.pallet.m_elaseFlameImg.visible = false;
						}
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
					if (k < 0 || k >= m_tip[m_layer].length)
					{
						continue;
					}
					
					m_tip[m_layer][setPos].draw(m_copyList[k].url, m_copyList[k].name, m_copyList[k].auto);
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
						
						if (position >= m_tip[m_layer].length)
						{
							continue;
						}
						
						//四角形
						if (MainController.$.view.pallet.palletState == Pallet.PALLET_RECT || m_terrainLayer.visible)
						{
							
							draw(position);
								//m_tip[position].draw(m_layer, MainController.$.view.pallet.selectTip, MainController.$.view.pallet.url, MainController.$.view.pallet.name);
						}
						//コピー
						else if (MainController.$.view.pallet.palletState == Pallet.PALLET_COPY)
						{
							var copy:CopyTip = new CopyTip();
							copy.img = m_tip[m_layer][position];
							copy.name = m_tip[m_layer][position].tipName;
							copy.url = m_tip[m_layer][position].url;
							copy.posX = j - start_x;
							copy.posY = i - start_y;
							copy.img.x = copy.posX * MAP_SIZE;
							copy.img.y = copy.posY * MAP_SIZE;
							copy.auto = m_tip[m_layer][position].auto;
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
			if (num < 0 || num >= m_tip[m_layer].length || m_tip[m_layer][num].tipName != name || name === MainController.$.view.pallet.tipName)
				return;
			
			if (terrainLayer.visible)
			{
				
			}
			//オートタイル時
			else if (MainController.$.view.pallet.autoTile && MainController.$.view.pallet.selectNum == 0)
			{
				if (m_tip[m_layer][num].url === MainController.$.view.pallet.url)
				{
					return;
				}
				draw(num);
			}
			else
			{
				m_tip[m_layer][num].draw(MainController.$.view.pallet.url, MainController.$.view.pallet.tipName, MainController.$.view.pallet.autoTile);
			}
			fillAct(num + 1, name);
			fillAct(num - 1, name);
			fillAct(num + m_mapWidth, name);
			fillAct(num - m_mapWidth, name);
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
				
				if (pos.x < 0 || pos.x > m_mapWidth * MAP_SIZE - 1 || pos.y < 0 || pos.y > m_mapHeight * MAP_SIZE - 1)
				{
					return;
				}
				
				if (MainController.$.view.isLaunchWindow)
				{
					switch (touch.phase)
					{
					case TouchPhase.ENDED: 
						MainController.$.view.launchWindow.setFlame(pos.x / 32, pos.y / 32);
						break;
					}
				}
				else
				{
					//クリック上げた時
					switch (touch.phase)
					{
					case TouchPhase.ENDED: 
						endedAct(pos);
						if (m_terrainLayer.visible)
						{
							refreshTerrain();
						}
						else
						{
							refreshTip(m_layer);
						}
						MainController.$.view.header.setPosText(pos.x, pos.y);
						break;
					case TouchPhase.HOVER:
						
						if (m_terrainLayer.visible)
						{
							var num:int = 0;
							num += Math.floor(pos.x / 32);
							num += Math.floor(pos.y / 32) * m_mapWidth;
							MainController.$.view.pallet.terrainStateWindow.setState(m_terrain[num].type, m_terrain[num].cost, m_terrain[num].agiComp, m_terrain[num].defComp, m_terrain[num].eventNo, m_terrain[num].high, m_terrain[num].under,m_terrain[num].category);
						}
						MainController.$.view.header.setPosText(pos.x, pos.y);
						break;
					case TouchPhase.MOVED: 
						getPalletNo(pos);
						MainController.$.view.header.setPosText(pos.x, pos.y);
						break;
					case TouchPhase.BEGAN: 
						getPalletNo(pos);
						MainController.$.view.header.setPosText(pos.x, pos.y);
						break;
					}
					m_canvasArea.addChild(m_rectImg);
					m_canvasArea.addChild(m_copyArea);
					m_canvasArea.addChild(m_peasteView);
				}
			}
		}
		
		/**描画*/
		private function draw(num:int):void
		{
			if (terrainLayer.visible)
			{
				// 地形データ
				m_terrain[num].setType( //
				false, MainController.$.view.pallet.terrainSelecter.type, //
				MainController.$.view.pallet.terrainSelecter.cost, //
				MainController.$.view.pallet.terrainSelecter.agiComp, //
				MainController.$.view.pallet.terrainSelecter.defComp, //
				MainController.$.view.pallet.terrainSelecter.eventNo, //
				MainController.$.view.pallet.terrainSelecter.high, //
				MainController.$.view.pallet.terrainSelecter.under, //
				MainController.$.view.pallet.terrainSelecter.category //
				);
			}
			else
			{
				//オートタイル時
				if ((MainController.$.view.pallet.autoTile || MainController.$.view.pallet.autoObj) && MainController.$.view.pallet.selectNum == 0 && !MainController.$.view.pallet.useSpoit)
				{
					var drawTipBaseName:String = MainController.$.view.pallet.tipName.substr(0, MainController.$.view.pallet.tipName.lastIndexOf("_") + 1);
					var compTipBaseName:String = m_tip[m_layer][num].tipName.substr(0, m_tip[m_layer][num].tipName.lastIndexOf("_") + 1);
					var compFlg:Boolean = false;
					if (drawTipBaseName === compTipBaseName)
					{
						compFlg = true;
					}
					
					//塗りつぶし時、同じ名前の所から塗りつぶせない
					if (compFlg && MainController.$.view.pallet.palletState == Pallet.PALLET_FILL)
					{
						return;
					}
					
					var count:int = 0;
					var number:int = getAroundUtl(num, drawTipBaseName);
					var obj:Object = MainController.$.view.pallet.autoTileTip(number);
					
					m_tip[m_layer][num].draw(obj.url, obj.name, true);
					
					function addDraw(count:int):void
					{
						if (count >= 0 && count < m_tip[m_layer].length)
						{
							
							var countTipBaseName:String = m_tip[m_layer][count].tipName.substr(0, m_tip[m_layer][count].tipName.lastIndexOf("_") + 1);
							var countFlg:Boolean = false;
							if (drawTipBaseName === countTipBaseName)
							{
								countFlg = true;
							}
							
							if (countFlg)
							{
								number = getAroundUtl(count, drawTipBaseName);
								obj = MainController.$.view.pallet.autoTileTip(number);
								m_tip[m_layer][count].draw(obj.url, obj.name, true);
							}
							else
							{
								
							}
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
					m_tip[m_layer][num].draw(MainController.$.view.pallet.url, MainController.$.view.pallet.tipName, false);
				}
			}
		}
		
		public function get terrain():Vector.<TerrainTip>
		{
			return m_terrain;
		}
		
		public function get terrainLayer():Sprite
		{
			return m_terrainLayer;
		}
		
		public function set terrainLayer(value:Sprite):void
		{
			m_terrainLayer = value;
		}
		
		public function set terrain(value:Vector.<TerrainTip>):void
		{
			m_terrain = value;
		}
		
		public function get terrainBackImg():Image
		{
			return m_terrainBackImg;
		}
	
	}
}