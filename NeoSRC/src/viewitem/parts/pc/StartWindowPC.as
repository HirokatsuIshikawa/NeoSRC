package viewitem.parts.pc
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CImgButton;
	import system.custom.customSprite.CSprite;
	import system.custom.customSprite.CTextArea;
	import starling.events.Event;
	import starling.textures.Texture;
	import system.file.DataLoad;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class StartWindowPC extends CSprite
	{
		private var _backImg:CImage = null;
		private var _compFunc:Function = null;
		
		private var _loadBtn:CImgButton = null;
		private var _loadTex:Texture = null;
		
		
		private var _allBtn:CImgButton = null;
		private var _allTex:Texture = null;
		
		private var _bgmBtn:CImgButton = null;
		private var _bgmTex:Texture = null;
		private var _bgmPathText:CTextArea = null;
		
		private var _seBtn:CImgButton = null;
		private var _seTex:Texture = null;
		private var _sePathText:CTextArea = null;
		/*
		private var _imgBtn:CImgButton = null;
		private var _imgTex:Texture = null;
		private var _imgPathText:CTextArea = null;
		
		private var _pexBtn:CImgButton = null;
		private var _pexTex:Texture = null;
		private var _pexPathText:CTextArea = null;
		*/
		public function StartWindowPC(func:Function)
		{
			CommonSystem.initInfo();
			_backImg = new CImage(CommonDef.BACK_TEX);
			_backImg.width = CommonDef.WINDOW_W;
			_backImg.height = CommonDef.WINDOW_H;
			addChild(_backImg);
			_compFunc = func;
			
			
			_loadTex = Texture.fromBitmap(new CommonDef.StartBtnImg());
			_loadBtn = new CImgButton(_loadTex);
			_loadBtn.addEventListener(Event.TRIGGERED, readScenario);
			_loadBtn.y = CommonDef.WINDOW_H - 96;
			_loadBtn.x = (CommonDef.WINDOW_W - 96) / 2;
			addChild(_loadBtn);
			
			
			
			
			_allTex = Texture.fromBitmap(new CommonDef.AllBtnImg());
			_allBtn = new CImgButton(_allTex);
			_allBtn.addEventListener(Event.TRIGGERED, setCommonAll);
			_allBtn.y = 220;
			_allBtn.x = 20;
			addChild(_allBtn);
			
			
			/*
			_imgTex = Texture.fromBitmap(new CommonDef.ImgBtnImg());
			_imgBtn = new CImgButton(_imgTex);
			_imgBtn.addEventListener(Event.TRIGGERED, setCommonImg);
			_imgBtn.y = 100;
			_imgBtn.x = 120;
			addChild(_imgBtn);
			
			
			_pexTex = Texture.fromBitmap(new CommonDef.PexBtnImg());
			_pexBtn = new CImgButton(_pexTex);
			_pexBtn.addEventListener(Event.TRIGGERED, setCommonPex);
			_pexBtn.y = 180;
			_pexBtn.x = 120;
			addChild(_pexBtn);
			*/
			
			_bgmTex = Texture.fromBitmap(new CommonDef.BgmBtnImg());
			_bgmBtn = new CImgButton(_bgmTex);
			_bgmBtn.addEventListener(Event.TRIGGERED, setCommonBgm);
			_bgmBtn.y = 260;
			_bgmBtn.x = 120;
			addChild(_bgmBtn);
			
			
			
			_seTex = Texture.fromBitmap(new CommonDef.SeBtnImg());
			_seBtn = new CImgButton(_seTex);
			_seBtn.addEventListener(Event.TRIGGERED, setCommonSe);
			_seBtn.y = 340;
			_seBtn.x = 120;
			addChild(_seBtn);
			/*
			_imgPathText = new CTextArea(12);
			_imgPathText.text = CommonSystem.COMMON_IMG_PATH;
			_imgPathText.x = 200;
			_imgPathText.y = 120;
			_imgPathText.width = 700;
			_imgPathText.height = 24;
			addChild(_imgPathText);
			
			_pexPathText = new CTextArea(12);
			_pexPathText.text = CommonSystem.COMMON_PEX_PATH;
			_pexPathText.x = 200;
			_pexPathText.y = 200;
			_pexPathText.width = 700;
			_pexPathText.height = 24;
			addChild(_pexPathText);
			*/
			_bgmPathText = new CTextArea(12);
			_bgmPathText.text = CommonSystem.COMMON_BGM_PATH;
			_bgmPathText.x = 200;
			_bgmPathText.y = 280;
			_bgmPathText.width = 700;
			_bgmPathText.height = 24;
			addChild(_bgmPathText);
			
			_sePathText = new CTextArea(12);
			_sePathText.text = CommonSystem.COMMON_SE_PATH;
			_sePathText.x = 200;
			_sePathText.y = 360;
			_sePathText.width = 700;
			_sePathText.height = 24;
			addChild(_sePathText);
			
		}
		
		
		
		/** 読み込み完了 */
		private function compLoad(data:Object):void
		{
			_compFunc(data);
			dispose();
		}
		
		
		private function readScenario(event:Event):void
		{
			DataLoad.Load("新型SRCキャラデータ", "*.srcsys;*.srctxt", compLoad);
		}
		
		
		private function setCommonAll(event:Event):void
		{
			DataLoad.LoadFolderPath(compAllPath);
		}
		
		
		/** 読み込み完了 */
		private function compAllPath(path:String):void
		{
			CommonSystem.setCommonBgmPath(path + "\\BGM");
			CommonSystem.setCommonSePath(path + "\\SE");
			/*
			CommonSystem.setCommonPexPath(path + "\\PEX");
			CommonSystem.setCommonImgPath(path + "\\IMG");
			_imgPathText.text = CommonSystem.COMMON_IMG_PATH;
			_pexPathText.text = CommonSystem.COMMON_PEX_PATH;
			*/
			_bgmPathText.text = CommonSystem.COMMON_BGM_PATH;
			_sePathText.text = CommonSystem.COMMON_SE_PATH;
		}
		
		
		private function setCommonBgm(event:Event):void
		{
			DataLoad.LoadFolderPath(compBgmPath);
		}
		
		/** 読み込み完了 */
		private function compBgmPath(path:String):void
		{
			CommonSystem.setCommonBgmPath(path);
			_bgmPathText.text = CommonSystem.COMMON_BGM_PATH;
		}
		
		private function setCommonSe(event:Event):void
		{
			DataLoad.LoadFolderPath(compSePath);
		}
		
		/** 読み込み完了 */
		private function compSePath(path:String):void
		{
			CommonSystem.setCommonSePath(path);
			_sePathText.text = CommonSystem.COMMON_SE_PATH;
		}
		
		/*
		private function setCommonImg(event:Event):void
		{
			DataLoad.LoadFolderPath(compImgPath);
		}
		
		private function compImgPath(path:String):void
		{
			CommonSystem.setCommonImgPath(path);
			_imgPathText.text = CommonSystem.COMMON_IMG_PATH;
		}
		
		private function setCommonPex(event:Event):void
		{
			DataLoad.LoadFolderPath(compPexPath);
		}
		
		private function compPexPath(path:String):void
		{
			CommonSystem.setCommonPexPath(path);
			_pexPathText.text = CommonSystem.COMMON_PEX_PATH;
		}
		*/
		
		override public function dispose():void
		{
			/*
			_imgPathText.dispose();
			_imgPathText = null;
			_pexPathText.dispose();
			_pexPathText = null;
			*/
			_bgmPathText.dispose();
			_bgmPathText = null;
			_sePathText.dispose();
			_sePathText = null;
			
			
			_allBtn.removeEventListener(Event.TRIGGERED, setCommonAll);
			_loadBtn.removeEventListener(Event.TRIGGERED, readScenario);
			_bgmBtn.removeEventListener(Event.TRIGGERED, setCommonBgm);
			_seBtn.removeEventListener(Event.TRIGGERED, setCommonSe);
			/*
			_imgBtn.removeEventListener(Event.TRIGGERED, setCommonImg);
			_pexBtn.removeEventListener(Event.TRIGGERED, setCommonPex);
			*/
			_backImg.dispose();
			_loadTex.dispose();
			_loadBtn.dispose();
			
			_allBtn.dispose();
			_bgmTex.dispose();
			_bgmBtn.dispose();
			_seBtn.dispose();
			_seTex.dispose();
			/*
			_imgBtn.dispose();
			_imgTex.dispose();
			_pexBtn.dispose();
			_pexTex.dispose();
			*/
			_backImg = null;
			
			_loadTex = null;
			_loadBtn = null;
			
			_bgmTex = null;
			_bgmBtn = null;
			
			_seTex = null;
			_seBtn = null;
			
			/*
			_imgTex = null;
			_imgBtn = null;
			
			_pexTex = null;
			_pexBtn = null;
			*/
			this.parent.removeChild(this);
			super.dispose();
		}
	
	}

}