package scene.unit
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CTextArea;
	import database.master.MasterWeaponData;
	import feathers.controls.TextArea;
	import scene.main.MainController;
	import viewitem.status.list.listitem.ListItemBase;
	import viewitem.parts.numbers.ImgNumber;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WeaponListItem extends ListItemBase
	{
		// 名前
		private var _name:CTextArea = null;
		// 攻撃力
		private var _AtkImg:CImage = null;
		private var _AtkValue:ImgNumber = null;
		
		// 射程
		private var _RangeImg:CImage = null;
		private var _RangeMinValue:ImgNumber = null;
		private var _RangeMaxValue:ImgNumber = null;
		private var _RangeBetween:CImage = null;
		
		// 会心値
		private var _criticalImg:CImage = null;
		private var _criticalValue:ImgNumber = null;
		
		//移動後属性
		private var _pWeapon:CImage = null;
		//格闘射撃防御
		private var _basicType:CImage = null;
		
		//消費FP
		private var _useFpMark:CImage = null;
		private var _useFp:ImgNumber = null;
		
		//使用回数
		private var _useCountMark:CImage = null;
		private var _useCount:ImgNumber = null;
		private var _CountSlashMark:CImage = null;
		private var _maxCount:ImgNumber = null;
		
		//使用TP
		private var _useTpMark:CImage = null;
		private var _useTp:ImgNumber = null;
		
		// 命中 数値＋数値％
		private var _hitImg:CImage = null;
		private var _hitRate:ImgNumber = null;
		//private var _hitrateMark:CImage = null;
		//private var _hitPlus:CImage = null;
		//private var _hitAdd:ImgNumber = null;
		// 回避 数値＋数値％
		private var _evaImg:CImage = null;
		private var _evaRate:ImgNumber = null;
		//private var _evarateMark:CImage = null;
		//private var _evaPlus:CImage = null;
		//private var _evaAdd:ImgNumber = null;
		// 防御 数値＋数値％
		private var _defImg:CImage = null;
		private var _defRate:ImgNumber = null;
		//private var _defrateMark:CImage = null;
		//private var _defPlus:CImage = null;
		//private var _defAdd:ImgNumber = null;
		// 地形
		private var _capImg:Vector.<CImage> = null;
		private var _capState:Vector.<CImage> = null;
		
		// 属性
		private var _attribute:TextArea = null;
		
		private var _data:MasterWeaponData = null;
		
        private var _enable:Boolean = false;
		//-------------------------------------------------------------
		//
		// construction
		//
		//-------------------------------------------------------------
		public function WeaponListItem(data:MasterWeaponData, unit:BattleUnit)
		{
			super(640, 140);
			var i:int = 0;
			var nextPosX:int = 0;
			var nextPosY:int = 8;
			_data = data;
			
			//武器名
			_name = new CTextArea(24, 0xFFFFFF);
			_name.styleName = "custom_text";
			_name.width = 240;
			_name.height = 32;
			_name.x = 8;
			_name.y = nextPosY;
			_name.text = data.name + "";
			addChild(_name);
			
			nextPosY = 46;
			//威力
			var atk:int = (int)(data.value * (data.atkplus + unit.param.ATK) / 10.0);
			_AtkImg = new CImage(MainController.$.imgAsset.getTexture("Wpn_Atk"));
			_AtkImg.x = 8;
			_AtkImg.y = nextPosY;
			addChild(_AtkImg);
			nextPosX = _AtkImg.x + _AtkImg.width;
			
			_AtkValue = new ImgNumber();
			if (data.value <= 0)
			{
				_AtkValue.setNone(atk);
			}
			else
			{
				_AtkValue.setNumber(atk);
			}
			_AtkValue.x = nextPosX;
			_AtkValue.y = nextPosY;
			addChild(_AtkValue);
			nextPosX = _AtkValue.x + _AtkValue.width + 32;
			
			//射程
			_RangeImg = new CImage(MainController.$.imgAsset.getTexture("Wpn_Rng"));
			_RangeImg.x = nextPosX;
			_RangeImg.y = nextPosY;
			addChild(_RangeImg);
			nextPosX = _RangeImg.x + _RangeImg.width;
			
			_RangeMinValue = new ImgNumber();
			_RangeMinValue.setNumber(data.minRange);
			_RangeMinValue.x = nextPosX;
			_RangeMinValue.y = nextPosY;
			addChild(_RangeMinValue);
			nextPosX = _RangeMinValue.x + _RangeMinValue.width;
			
			//最大射程と最少射程が異なる場合
			if (data.minRange < data.maxRange)
			{
				_RangeBetween = new CImage(MainController.$.imgAsset.getTexture("minus"));
				_RangeBetween.x = nextPosX + 8;
				_RangeBetween.y = nextPosY;
				addChild(_RangeBetween);
				nextPosX = _RangeBetween.x + _RangeBetween.width;
				
				_RangeMaxValue = new ImgNumber();
				_RangeMaxValue.setNumber(data.maxRange);
				_RangeMaxValue.x = nextPosX + 8;
				_RangeMaxValue.y = nextPosY;
				addChild(_RangeMaxValue);
				nextPosX = _RangeMaxValue.x + _RangeMaxValue.width;
			}
			
			nextPosX += 32;
			
			//会心
			_criticalImg = new CImage(MainController.$.imgAsset.getTexture("Wpn_CRT"));
			_criticalImg.x = nextPosX;
			_criticalImg.y = nextPosY;
			addChild(_criticalImg);
			nextPosX = _criticalImg.x + _criticalImg.width;
			
			_criticalValue = new ImgNumber();
			if (data.actType === MasterWeaponData.ACT_TYPE_ATK)
			{
				_criticalValue.setNumber(data.crtHit);
			}
			else
			{
				_criticalValue.setNone();
			}
			_criticalValue.x = nextPosX;
			_criticalValue.y = nextPosY;
			addChild(_criticalValue);
			
			nextPosX = _criticalValue.x + _criticalValue.width;
			
			//P武器
			if (data.pWeapon)
			{
				_pWeapon = new CImage(MainController.$.imgAsset.getTexture("WeaponP"));
				_pWeapon.x = this.width - 40;
				_pWeapon.y = nextPosY;
				addChild(_pWeapon);
			}
			
			//武器基本属性
			var basicTexStr:String = null;
			switch (data.wpnBasicType)
			{
			case MasterWeaponData.WPN_BASIC_GRAP: 
				basicTexStr = "WeaponGrap";
				break;
			case MasterWeaponData.WPN_BASIC_SHOT: 
				basicTexStr = "WeaponShot";
				break;
			case MasterWeaponData.WPN_BASIC_GUARD: 
				basicTexStr = "WeaponGuard";
				break;
				
			}
			
			_basicType = new CImage(MainController.$.imgAsset.getTexture(basicTexStr));
			_basicType.x = this.width - 72;
			_basicType.y = nextPosY;
			addChild(_basicType);
			
			///////////////////////////////////////////////2段目//////////////////////////////////////////
			nextPosX = 8;
			nextPosY = 80;
			
			//FP表示
			if (data.useFp > 0)
			{
				_useFpMark = new CImage(MainController.$.imgAsset.getTexture("Wpn_Fp"));
				_useFpMark.x = nextPosX;
				_useFpMark.y = nextPosY;
				addChild(_useFpMark);
				nextPosX = _useFpMark.x + _useFpMark.width;
				
				_useFp = new ImgNumber();
				_useFp.x = nextPosX;
				_useFp.y = nextPosY;
				_useFp.setNumber(data.useFp);
				addChild(_useFp);
				nextPosX = _useFp.x + _useFp.width;
			}
			
			//回数表示
			if (data.maxCount > 0)
			{
				_useCountMark = new CImage(MainController.$.imgAsset.getTexture("Wpn_Count"));
				_useCountMark.x = nextPosX;
				_useCountMark.y = nextPosY;
				addChild(_useCountMark);
				nextPosX = _useCountMark.x + _useCountMark.width;
				
				_useCount = new ImgNumber();
				_useCount.x = nextPosX;
				_useCount.y = nextPosY;
				_useCount.setNumber(data.useCount);
				addChild(_useCount);
				nextPosX = _useCount.x + _useCount.width;
				
				_CountSlashMark = new CImage(MainController.$.imgAsset.getTexture("slash"));
				_CountSlashMark.x = nextPosX;
				_CountSlashMark.y = nextPosY;
				addChild(_CountSlashMark);
				nextPosX = _CountSlashMark.x + _CountSlashMark.width;
				
				_maxCount = new ImgNumber();
				_maxCount.x = nextPosX;
				_maxCount.y = nextPosY;
				_maxCount.setNumber(data.maxCount);
				addChild(_maxCount);
				nextPosX = _maxCount.x + _maxCount.width;
			}
			
			//TP表示
			if (data.enableTp > 0)
			{
				_useTpMark = new CImage(MainController.$.imgAsset.getTexture("Wpn_Tp"));
				_useTpMark.x = nextPosX;
				_useTpMark.y = nextPosY;
				addChild(_useTpMark);
				nextPosX = _useTpMark.x + _useTpMark.width;
				
				_useTp = new ImgNumber();
				_useTp.x = nextPosX;
				_useTp.y = nextPosY;
				_useFp.setNumber(data.enableTp);
				addChild(_useTp);
				nextPosX = _useTp.x + _useTp.width;
			}
			
			var pointNum:int = 0;
			
			//命中
			_hitImg = new CImage(MainController.$.imgAsset.getTexture("Wpn_Hit"));
			_hitImg.x = nextPosX;
			_hitImg.y = nextPosY;
			addChild(_hitImg);
			nextPosX = _hitImg.x + _hitImg.width;
			
			pointNum = (int)(((unit.param.TEC * 3.0 + unit.param.SPD) / 2.0 + 50) * data.hitRate / 100.0 + data.hitPlus);
			
			_hitRate = new ImgNumber();
			_hitRate.x = nextPosX;
			_hitRate.y = nextPosY;
			_hitRate.setNumber(pointNum);
			addChild(_hitRate);
			nextPosX = _hitRate.x + _hitRate.width;
			
			//回避
			nextPosX += 16;
			_evaImg = new CImage(MainController.$.imgAsset.getTexture("Wpn_Eva"));
			_evaImg.x = nextPosX;
			_evaImg.y = nextPosY;
			addChild(_evaImg);
			nextPosX = _evaImg.x + _evaImg.width;
			
			pointNum = (int)((unit.param.SPD * 3.0) / 2.0 * data.avoRate / 100.0 + data.avoPlus);
			
			_evaRate = new ImgNumber();
			_evaRate.x = nextPosX;
			_evaRate.y = nextPosY;
			_evaRate.setNumber(pointNum);
			addChild(_evaRate);
			nextPosX = _evaRate.x + _evaRate.width;
			
			//防御
			nextPosX += 16;
			_defImg = new CImage(MainController.$.imgAsset.getTexture("Wpn_Grd"));
			_defImg.x = nextPosX;
			_defImg.y = nextPosY;
			addChild(_defImg);
			nextPosX = _defImg.x + _defImg.width;
			
			pointNum = (int)(unit.param.DEF * data.defRate / (100.0 * 4.0) + data.defPlus);
			
			_defRate = new ImgNumber();
			_defRate.x = nextPosX;
			_defRate.y = nextPosY;
			_defRate.setNumber(pointNum);
			addChild(_defRate);
			nextPosX = _defRate.x + _defRate.width;
			
			/*
			   //命中
			   if (data.hitRate != 100 || data.hitPlus != 0)
			   {
			   _hitImg = new CImage(MainController.$.imgAsset.getTexture("Wpn_Hit"));
			   _hitImg.x = nextPosX;
			   _hitImg.y = nextPosY;
			   addChild(_hitImg);
			   nextPosX = _hitImg.x + _hitImg.width;
			   }
			
			   //等倍以外の時
			   if (data.hitRate != 100)
			   {
			   _hitrateMark = new CImage(MainController.$.imgAsset.getTexture("kake"));
			   _hitrateMark.x = nextPosX;
			   _hitrateMark.y = nextPosY;
			   addChild(_hitrateMark);
			   nextPosX = _hitrateMark.x + _hitrateMark.width;
			
			   _hitRate = new ImgNumber();
			   _hitRate.x = nextPosX;
			   _hitRate.y = nextPosY;
			   _hitRate.setNumber(data.hitRate);
			   addChild(_hitRate);
			   nextPosX = _hitRate.x + _hitRate.width;
			   }
			
			   //プラス値が0以外の場合
			   if (data.hitPlus != 0)
			   {
			   if (data.hitPlus > 0)
			   {
			   _hitPlus = new CImage(MainController.$.imgAsset.getTexture("plus"));
			   }
			   else
			   {
			   _hitPlus = new CImage(MainController.$.imgAsset.getTexture("minus"));
			   }
			   _hitPlus.x = nextPosX;
			   _hitPlus.y = nextPosY;
			   addChild(_hitPlus);
			   nextPosX = _hitPlus.x + _hitPlus.width;
			
			   _hitAdd = new ImgNumber();
			   _hitAdd.x = nextPosX;
			   _hitAdd.y = nextPosY;
			   _hitAdd.setNumber((int)(Math.abs(data.hitPlus)));
			   _hitAdd.addMark(ImgNumber.ADD_PERCENT);
			   addChild(_hitAdd);
			   nextPosX = _hitAdd.x + _hitAdd.width;
			   }
			
			   //回避
			   if (data.avoRate != 100 || data.avoPlus != 0)
			   {
			   nextPosX += 16;
			   _evaImg = new CImage(MainController.$.imgAsset.getTexture("Wpn_Eva"));
			   _evaImg.x = nextPosX;
			   _evaImg.y = nextPosY;
			   addChild(_evaImg);
			
			   nextPosX = _evaImg.x + _evaImg.width;
			   }
			
			   if (data.avoRate != 100)
			   {
			   _evarateMark = new CImage(MainController.$.imgAsset.getTexture("kake"));
			   _evarateMark.x = nextPosX;
			   _evarateMark.y = nextPosY;
			   addChild(_evarateMark);
			   nextPosX = _evarateMark.x + _evarateMark.width;
			
			   _evaRate = new ImgNumber();
			   _evaRate.x = nextPosX;
			   _evaRate.y = nextPosY;
			   _evaRate.setNumber(data.avoRate);
			   addChild(_evaRate);
			   nextPosX = _evaRate.x + _evaRate.width;
			   }
			
			   //プラス値が0以外の場合
			   if (data.avoPlus != 0)
			   {
			   if (data.avoPlus > 0)
			   {
			   _evaPlus = new CImage(MainController.$.imgAsset.getTexture("plus"));
			   }
			   else
			   {
			   _evaPlus = new CImage(MainController.$.imgAsset.getTexture("minus"));
			   }
			   _evaPlus.x = nextPosX;
			   _evaPlus.y = nextPosY;
			   addChild(_evaPlus);
			   nextPosX = _evaPlus.x + _evaPlus.width;
			
			   _evaAdd = new ImgNumber();
			   _evaAdd.x = nextPosX;
			   _evaAdd.y = nextPosY;
			   _evaAdd.setNumber((int)(Math.abs(data.avoPlus)));
			   _evaAdd.addMark(ImgNumber.ADD_PERCENT);
			   addChild(_evaAdd);
			   nextPosX = _evaAdd.x + _evaAdd.width;
			   }
			
			   //防御
			   if (data.defRate != 100 || data.defPlus != 0)
			   {
			   nextPosX += 16;
			   _defImg = new CImage(MainController.$.imgAsset.getTexture("Wpn_Grd"));
			   _defImg.x = nextPosX;
			   _defImg.y = nextPosY;
			   addChild(_defImg);
			   nextPosX = _defImg.x + _defImg.width;
			   }
			
			   //等倍以外の時
			   if (data.defRate != 100)
			   {
			   _defrateMark = new CImage(MainController.$.imgAsset.getTexture("kake"));
			   _defrateMark.x = nextPosX;
			   _defrateMark.y = nextPosY;
			   addChild(_defrateMark);
			   nextPosX = _defrateMark.x + _defrateMark.width;
			
			   _defRate = new ImgNumber();
			   _defRate.x = nextPosX;
			   _defRate.y = nextPosY;
			   _defRate.setNumber((int)(Math.abs(data.defRate)));
			   addChild(_defRate);
			   nextPosX = _defRate.x + _defRate.width;
			   }
			
			   //プラス値が0以外の場合
			   if (data.defPlus != 0)
			   {
			   if (_data.defPlus > 0)
			   {
			   _defPlus = new CImage(MainController.$.imgAsset.getTexture("plus"));
			   }
			   else
			   {
			   _defPlus = new CImage(MainController.$.imgAsset.getTexture("minus"));
			   }
			   _defPlus.x = nextPosX;
			   _defPlus.y = nextPosY;
			   addChild(_defPlus);
			   nextPosX = _defPlus.x + _defPlus.width;
			
			   _defAdd = new ImgNumber();
			   _defAdd.x = nextPosX;
			   _defAdd.y = nextPosY;
			   _defAdd.setNumber(data.defPlus);
			   addChild(_defAdd);
			   nextPosX = _defAdd.x + _defAdd.width;
			   }
			 */
			///////////////////////////////////////////////3段目//////////////////////////////////////////
			nextPosX = 8;
			nextPosY = 112;
			
			_capImg = new Vector.<CImage>;
			_capState = new Vector.<CImage>;
			
			var stateList:Vector.<String> = new Vector.<String>;
			
			stateList[MasterWeaponData.WPN_CAP_OTHER] = "Wpn_CapOther";
			stateList[MasterWeaponData.WPN_CAP_SKY] = "Wpn_CapSky";
			stateList[MasterWeaponData.WPN_CAP_GROUND] = "Wpn_CapGround";
			stateList[MasterWeaponData.WPN_CAP_WATER] = "Wpn_CapWater";
			
			//地形対応
			for (i = 0; i < 4; i++)
			{
				_capImg[i] = new CImage(MainController.$.imgAsset.getTexture(stateList[i]));
				_capImg[i].x = nextPosX;
				_capImg[i].y = nextPosY;
				addChild(_capImg[i]);
				nextPosX = _capImg[i].x + _capImg[i].width;
				
				var state:String = null;
				
				if (data.terrain[i] < 5)
				{
					state = CommonDef.TERRAIN_IMG[data.terrain[i]];
				}
				else
				{
					state = CommonDef.TERRAIN_IMG[data.terrain[5]];
				}
				
				_capState[i] = new CImage(MainController.$.imgAsset.getTexture(state));
				_capState[i].x = nextPosX;
				_capState[i].y = nextPosY;
				addChild(_capState[i]);
				nextPosX = _capState[i].x + _capState[i].width + 12;
			}
			
			//属性
			
			if (data.attribute.length > 0)
			{
				_attribute = new CTextArea(24, 0xFFFFFF);
				_attribute.styleName = "custom_text";
				_attribute.width = 160;
				_attribute.height = 32;
				_attribute.x = nextPosX;
				_attribute.y = nextPosY - 4;
				_attribute.text = "属性:" + data.attribute;
				addChild(_attribute);
			}
		
		}
		
		override public function dispose():void
		{
			var i:int = 0;
			if (_name != null)
			{
				_name.dispose();
			}
			if (_AtkImg != null)
			{
				_AtkImg.dispose();
			}
			if (_AtkValue != null)
			{
				_AtkValue.dispose();
			}
			if (_RangeMinValue != null)
			{
				_RangeMinValue.dispose();
			}
			if (_RangeImg != null)
			{
				_RangeImg.dispose();
			}
			if (_RangeMaxValue != null)
			{
				_RangeMaxValue.dispose();
			}
			if (_RangeBetween != null)
			{
				_RangeBetween.dispose();
			}
			if (_criticalImg != null)
			{
				_criticalImg.dispose();
			}
			if (_criticalValue != null)
			{
				_criticalValue.dispose();
			}
			if (_hitImg != null)
			{
				_hitImg.dispose();
			}
			if (_hitRate != null)
			{
				_hitRate.dispose()
			}
			/*
			   if (_hitrateMark != null)
			   {
			   _hitrateMark.dispose();
			   }
			   if (_hitPlus != null)
			   {
			   _hitPlus.dispose();
			   }
			
			   if (_hitAdd != null)
			   {
			   _hitAdd.dispose();
			   }
			 */
			if (_evaImg != null)
			{
				_evaImg.dispose();
			}
			if (_evaRate != null)
			{
				_evaRate.dispose()
			}
			/*
			   if (_evaPlus != null)
			   {
			   _evaPlus.dispose();
			   }
			   if (_evaAdd != null)
			   {
			   _evaAdd.dispose();
			   }
			   if (_evarateMark != null)
			   {
			   _evarateMark.dispose();
			   }
			 */
			if (_defImg != null)
			{
				_defImg.dispose();
			}
			
			if (_defRate != null)
			{
				_defRate.dispose()
			}
			/*
			   if (_defPlus != null)
			   {
			   _defPlus.dispose();
			   }
			   if (_defAdd != null)
			   {
			   _defAdd.dispose();
			   }
			
			   if (_defrateMark != null)
			   {
			   _defrateMark.dispose();
			   }
			 */
			if (_pWeapon != null)
			{
				_pWeapon.dispose();
			}
			if (_attribute != null)
			{
				_attribute.dispose();
			}
			
			if (_useCount != null)
			{
				_useCount.dispose();
				_maxCount.dispose();
				_useCountMark.dispose();
				_CountSlashMark.dispose();
			}
			
			if (_useFp != null)
			{
				
				_useFp.dispose();
				_useFpMark.dispose();
			}
			
			if (_useTp != null)
			{
				
				_useTp.dispose();
				_useTpMark.dispose();
			}
			
			CommonDef.disposeList([_capImg, _capState]);
			
			_RangeImg = null;
			_RangeMinValue = null;
			_RangeBetween = null;
			_RangeMaxValue = null;
			
			_useFp = null;
			_useFpMark = null;
			
			_useTp = null;
			_useTpMark = null;
			
			_useCount = null;
			_maxCount = null;
			_useCountMark = null;
			_CountSlashMark = null
			
			_AtkImg = null;
			_AtkValue = null;
			_criticalImg = null;
			_criticalValue = null;
			_hitImg = null;
			_hitRate = null;
			/*
			   _hitrateMark = null;
			   _hitPlus = null;
			   _hitAdd = null;
			 */
			_evaImg = null;
			_evaRate = null;
			/*
			   _evarateMark = null;
			   _evaPlus = null;
			   _evaAdd = null;
			 */
			_defImg = null;
			_defRate = null;
			/*
			   _defrateMark = null;
			   _defPlus = null;
			   _defAdd = null;
			 */
			_pWeapon = null;
			_attribute = null;
			
			super.dispose();
		}
		
		public function get data():MasterWeaponData
		{
			return _data;
		}
        
        public function get enable():Boolean 
        {
            return _enable;
        }
        
        public function set enable(value:Boolean):void 
        {
            _enable = value;
        }
		//-------------------------------------------------------------
		//
		// component
		//
		//-------------------------------------------------------------
		//-------------------------------------------------------------
		//
		// variable
		//
		//-------------------------------------------------------------
		//-------------------------------------------------------------
		//
		// event handler
		//
		//-------------------------------------------------------------
		//-------------------------------------------------------------
		//
		// private function
		//
		//-------------------------------------------------------------
		//-------------------------------------------------------------
		//
		// public function
		//
		//-------------------------------------------------------------
	
	}

}