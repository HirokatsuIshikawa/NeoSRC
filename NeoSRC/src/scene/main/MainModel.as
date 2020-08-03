package scene.main
{
	import common.CommonSystem;
	import common.util.CharaDataUtil;
	import database.master.MasterBattleMessage;
    import database.master.MasterCommanderData;
    import database.master.MasterSkillData;
	import database.master.MasterWeaponData;
	import database.master.base.MessageCondition;
    import database.user.CommanderData;
	import scene.unit.BattleUnit;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.ImageBoard;
	import database.dataloader.MapLoader;
	import database.master.MasterBuffData;
	import database.master.MasterCharaData;
	import database.master.MasterUnitImageData;
	import database.user.FaceData;
	import database.user.UnitCharaData;
	import flash.geom.Point;
	import starling.display.Quad;
	import scene.intermission.customdata.PlayerParam;
	
	/**
	 * ...
	 * @author ishikawa
	 */ /**メインデータモデル*/
	public class MainModel
	{
		
		/**プレイヤーパラメーター*/
		private var _playerParam:PlayerParam = null;
		
		/**マスターキャラ画像データ*/
		private var _masterCharaImageData:Vector.<FaceData> = null;
		
		private var _masterUnitImageData:MasterUnitImageData = null;
		/**マスターキャラデータ*/
		private var _masterCharaData:Vector.<MasterCharaData> = null;
		/**プレイヤーデータ*/
		private var _playerUnitData:Vector.<UnitCharaData> = null;
		/**プレイヤー軍師データ*/
		private var _playerCommanderData:Vector.<CommanderData> = null;
		/**バフデータ*/
		private var _masterBuffData:Vector.<MasterBuffData> = null;
		/**バトルメッセージデータ*/
		private var _masterBattleMessageData:Vector.<MasterBattleMessage> = null;
		
        /**軍師データ*/
        private var _masterCommanderData:Vector.<MasterCommanderData> = null;
		/** プレイヤーパーティIDリスト */
		private var _playerPartyList:Vector.<String> = null;
		
		/** プレイヤーパーティIDリスト */
		private var _enemyPartyList:Vector.<String> = null;
		
		/**マップパス*/
		private var _mapPath:String = null;
		
		/**ボードタイプ･顔*/
		public static const IMG_BOARD_FACE:int = 0;
		/**ボードタイプ・立ち絵*/
		public static const IMG_BOARD_STAND:int = 1;
		
		public function MainModel(initCallBack:Function = null)
		{
			_playerParam = new PlayerParam();
			_masterCharaImageData = new Vector.<FaceData>;
			_masterUnitImageData = new MasterUnitImageData();
			_masterCharaData = new Vector.<MasterCharaData>;
			_playerUnitData = new Vector.<UnitCharaData>;
            _playerCommanderData = new Vector.<CommanderData>;
			_playerPartyList = new Vector.<String>;
			_enemyPartyList = new Vector.<String>;
			_masterBattleMessageData = new Vector.<database.master.MasterBattleMessage>;
            _masterCommanderData = new Vector.<database.master.MasterCommanderData>;
			
			_masterBuffData = new Vector.<MasterBuffData>();
			//_imgStorage = new ImgStorage();
			
			if (initCallBack != null)
			{
				initCallBack();
			}
		}
		
		/** キャラ画像ベース取得 */
		public function getCharaBaseImg(name:String, type:int = IMG_BOARD_FACE):ImageBoard
		{
			var i:int = 0;
			var selectData:MasterCharaData = CharaDataUtil.getMasterCharaDataName(name);
			var imgData:FaceData = getCharaImgDataFromName(selectData.charaImgName);
			var addPoint:Point = null;
			var areaRect:Quad = null;
			var imgType:String = imgData.imgList[0].type;
			switch (type)
			{
			case IMG_BOARD_FACE: //顔の場合
				
				if (imgType === "icon")
				{
					addPoint = new Point(0, 0);
					areaRect = null;
				}
				else
				{
					addPoint = imgData.addPoint;
					areaRect = new Quad(160, imgData.addPoint.y);
					areaRect.x = 0;
					areaRect.y = 160 - imgData.addPoint.y;
				}
				break;
			case IMG_BOARD_STAND: //立ち絵の場合
				break;
			}
			var base:ImageBoard = new ImageBoard(addPoint, areaRect);
			base.name = name;
			for (i = 0; i < imgData.basicList.length; i++)
			{
				var faceImg:CImage = new CImage(MainController.$.imgAsset.getTexture(imgData.getFileName(imgData.basicList[i])));
				base.addImage(faceImg, imgType);
			}
			return base;
		}
		
		/**マップ読み込み*/
		public function mapLoad(str:String, callBack:Function = null):void
		{
			_mapPath = str;
			//マップ読み込み
			MapLoader.loadMapData(str, callBack);
		}
		
		public function resetUnitData():void
		{
			var i:int = 0;
			for (i = 0; i < _playerUnitData.length; )
			{
				_playerUnitData[i] = null;
				_playerUnitData.splice(i, 1);
			}
		}
        
        public function resetCommanderData():void
        {
            var i:int = 0;
            for (i = 0; i < _playerCommanderData.length; )
            {
                _playerCommanderData[i] = null;
                _playerCommanderData.splice(i, 1);
            }
        }
        
		
		public function addPlayerUnitFromName(name:String, lv:int = 0, exp:int = 0, strength:int = 0, launch:Boolean = false, customBgm:String = null):void
		{
			var i:int = 0;
			var length:int = _masterCharaData.length;
			var setId:int = _playerUnitData.length;
			var data:MasterCharaData = null;
			for (i = 0; i < length; i++)
			{
				if (_masterCharaData[i].nickName === name)
				{
					data = _masterCharaData[i];
					break;
				}
			}
			if (data == null)
			{
				for (i = 0; i < length; i++)
				{
					if (_masterCharaData[i].name === name)
					{
						data = _masterCharaData[i];
						break;
					}
				}
				
			}
			
			_playerUnitData[setId] = new UnitCharaData(setId, data, lv);
			_playerUnitData[setId].exp = exp;
			_playerUnitData[setId].customBgmPath = customBgm;
			_playerUnitData[setId].addStrength(strength);
		
		}
        /**コマンダー追加*/
        public function addPlayerCommanderFromName(name:String, lv:int = 0 ):void
        {
			var i:int = 0;
			var length:int = _masterCommanderData.length;
			var setId:int = _playerCommanderData.length;
			var data:MasterCommanderData = null;
			for (i = 0; i < length; i++)
			{
				if (_masterCommanderData[i].nickName === name)
				{
					data = _masterCommanderData[i];
					break;
				}
			}
			if (data == null)
			{
				for (i = 0; i < length; i++)
				{
					if (_masterCommanderData[i].name === name)
					{
						data = _masterCommanderData[i];
						break;
					}
				}
				
			}
			
			_playerCommanderData[_playerCommanderData.length] = new CommanderData(data, lv);
        }
        
		
		/**プレイヤーユニットデータ*/
		public function get PlayerUnitData():Vector.<UnitCharaData>
		{
			return _playerUnitData;
		}
		
		public function PlayerUnitDataName(name:String):UnitCharaData
		{
			var unit:UnitCharaData = null;
			var i:int = 0;
			for (i = 0; i < _playerUnitData.length; i++)
			{
				if (name === _playerUnitData[i].masterData.nickName || name === _playerUnitData[i].masterData.name)
				{
					unit = _playerUnitData[i];
					break;
				}
				
			}
			return unit;
		}
		
		public function EnemyUnitDataName(name:String, lv:int):UnitCharaData
		{
			var unit:UnitCharaData = null;
			var i:int = 0;
			for (i = 0; i < _masterCharaData.length; i++)
			{
				if (name === _masterCharaData[i].nickName || name === _masterCharaData[i].name)
				{
					unit = new UnitCharaData(0, _masterCharaData[i], lv);
					break;
				}
			}
			return unit;
		}
		
		/**プレイヤーユニットデータ*/
		public function set PlayerUnitData(value:Vector.<UnitCharaData>):void
		{
			_playerUnitData = value;
		}
		
		/** コマンドバトルパーティイン */
		public function partyIn(name:String):void
		{
			var i:int = 0;
			var getflg:Boolean = false;
			var length:int = _playerUnitData.length;
			
			for (i = 0; i < length; i++)
			{
				if (_playerUnitData[i].masterData.nickName === name)
				{
					_playerPartyList.push(name);
					getflg = true;
					break;
				}
			}
			if (!getflg)
			{
				for (i = 0; i < length; i++)
				{
					if (_playerUnitData[i].masterData.name === name)
					{
						_playerPartyList.push(name);
						break;
					}
				}
			}
		}
		
		/**キャラ基本データ*/
		public function get masterCharaData():Vector.<MasterCharaData>
		{
			return _masterCharaData;
		}
		
		/**キャラ基本データ*/
		public function set masterCharaData(value:Vector.<MasterCharaData>):void
		{
			_masterCharaData = value;
		}
		
		public function get playerPartyList():Vector.<String>
		{
			return _playerPartyList;
		}
		
		public function get enemyPartyList():Vector.<String>
		{
			return _enemyPartyList;
		}
		
		public function getCharaImgDataFromName(name:String):FaceData
		{
			var i:int = 0;
			var data:FaceData = null;
			for (i = 0; i < _masterCharaImageData.length; i++)
			{
				if (name === _masterCharaImageData[i].name || name === _masterCharaImageData[i].nickName)
				{
					data = _masterCharaImageData[i];
					break;
				}
				
			}
			return data;
		}
		
		public function get masterCharaImageData():Vector.<FaceData>
		{
			return _masterCharaImageData;
		}
		
		public function get masterBuffData():Vector.<MasterBuffData>
		{
			return _masterBuffData;
		}
		
		public function set masterCharaImageData(value:Vector.<FaceData>):void
		{
			_masterCharaImageData = value;
		}
		
		public function get masterUnitImageData():MasterUnitImageData
		{
			return _masterUnitImageData;
		}
		
		public function set masterUnitImageData(value:MasterUnitImageData):void
		{
			_masterUnitImageData = value;
		}
		
		public function get playerParam():PlayerParam
		{
			return _playerParam;
		}
		
		public function set playerParam(value:PlayerParam):void
		{
			_playerParam = value;
		}
		
		public function get mapPath():String
		{
			return _mapPath;
		}
		
		public function set mapPath(value:String):void
		{
			_mapPath = value;
		}
		
		public function get masterBattleMessageData():Vector.<MasterBattleMessage>
		{
			return _masterBattleMessageData;
		}
		
		public function set masterBattleMessageData(value:Vector.<MasterBattleMessage>):void
		{
			_masterBattleMessageData = value;
		}
        
        public function get masterCommanderData():Vector.<MasterCommanderData> 
        {
            return _masterCommanderData;
        }
        
        public function set masterCommanderData(value:Vector.<MasterCommanderData>):void 
        {
            _masterCommanderData = value;
        }
        
        public function get playerCommanderData():Vector.<CommanderData> 
        {
            return _playerCommanderData;
        }
        
        public function set playerCommanderData(value:Vector.<CommanderData>):void 
        {
            _playerCommanderData = value;
        }
		
		/**戦闘メッセージゲット*/
		public function getRandamBattleMessage(keyName:String, state:String, attackUnit:BattleUnit, targetUnit:BattleUnit, weapon:MasterWeaponData, skill:MasterSkillData,damage:int):Vector.<String>
		{
			var message:Vector.<String> = new Vector.<String>();
			var list:Vector.<MessageCondition> = getBattleMessageList(keyName, state, attackUnit, targetUnit, weapon,skill);
			var i:int = 0;
			
			var weaponSordFlg:Boolean = false;
			//武器名がある場合、武器名が無いものを削除
			for (i = 0; i < list.length; i++)
			{
				if (list[i].weaponName != null)
				{
					weaponSordFlg = true;
					break;
				}
			}
			//武器無しセリフ削除
			if (weaponSordFlg)
			{
				for (i = 0; i < list.length; i++)
				{
					if (list[i].weaponName == null)
					{
						list.splice(i, 1);
						i--;
					}
				}
			}
			
			//ランダム取得
			var randomNum:int = Math.random() * list.length;
			var messageItem:MessageCondition = list[randomNum];
			
			message = messageItem.message.concat();
			for (i = 0; i < message.length; i++)
			{
				message[i] = message[i].replace(/{unit}/g, attackUnit.name);
				message[i] = message[i].replace(/{target}/g, targetUnit.name);
                if (weapon != null)
                {
				    message[i] = message[i].replace(/{weapon}/g, weapon.name);
                }
                else if (skill != null)
                {                
    				message[i] = message[i].replace(/{skill}/g, skill.name);
                }
				message[i] = message[i].replace(/{damage}/g, damage + "");
			}
			return message;
		}
		
		public function isEnableMessageName(name:String):Boolean
		{
			for (var i:int = 0; i < _masterBattleMessageData.length; i++ )
			{
				if (_masterBattleMessageData[i].messageName == name)
				{
					return true;
				}
			}			
			return false;
		}
		
		
		/**戦闘メッセージリストゲット*/
		public function getBattleMessageList(keyName:String, state:String, attackUnit:BattleUnit, targetUnit:BattleUnit, weapon:MasterWeaponData, skill:MasterSkillData):Vector.<MessageCondition>
		{
			var list:Vector.<MessageCondition> = new Vector.<MessageCondition>();
			var i:int = 0;
			var j:int = 0;
			//キャラメッセージを検索
			for (i = 0; i < _masterBattleMessageData.length; i++)
			{
				if (_masterBattleMessageData[i].messageName === keyName)
				{
					for (j = 0; j < _masterBattleMessageData[i].message.length; j++)
					{
						if (_masterBattleMessageData[i].message[j].judge(state, attackUnit, targetUnit, weapon, skill))
						{
							list.push(_masterBattleMessageData[i].message[j]);
						}
					}
					break;
				}
			}
			
			//無い場合はデフォルトメッセージを検索
			if (list.length <= 0)
			{
				for (i = 0; i < _masterBattleMessageData.length; i++)
				{
					if (_masterBattleMessageData[i].messageName == "default")
					{
						for (j = 0; j < _masterBattleMessageData[i].message.length; j++)
						{
							if (_masterBattleMessageData[i].message[j].judge(state, attackUnit, targetUnit, weapon, skill))
							{
								list.push(_masterBattleMessageData[i].message[j]);
							}
						}
						break;
					}
				}
			}
			
			return list.concat();
		}
	}
}