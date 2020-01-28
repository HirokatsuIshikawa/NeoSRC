package scene.map.battle
{
	import common.CommonBattleMath;
	import database.master.MasterSkillData;
	import database.master.MasterWeaponData;
	import database.user.buff.SkillBuffData;
	import scene.map.battle.anime.data.BattleAnimeRecord;
	import scene.main.MainController;
	import scene.map.tip.TerrainData;
	import scene.unit.BattleUnit;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class BattleResultmanager
	{
		
		/**攻撃フラグ*/
		private var _attackFlg:Boolean = false;
		/**攻撃レコード*/
		private var _attackRecord:Vector.<BattleAnimeRecord> = null;
		
		/**攻撃順リスト*/
		private var _attackWeaponList:Vector.<AttackListItem> = null;
		
		/**反撃武器データ*/
		private var _counterWeaponData:MasterWeaponData = null;
		
		private var _moveX:int = 0;
		private var _moveY:int = 0;
		
		private var _expId:int = 0;
		private var _getExp:int = 0;
		private var _getMoney:int = 0;
		
		public function BattleResultmanager()
		{
			_attackRecord = new Vector.<BattleAnimeRecord>;
			_attackWeaponList = new Vector.<AttackListItem>;
		}
		
		/**攻撃追加*/
		public function addAttack(unit:BattleUnit, side:int, weaponData:MasterWeaponData, target:BattleUnit, counterWeapon:MasterWeaponData):void
		{
			var attack:AttackListItem = new AttackListItem();
			attack.setAttack(unit, side, weaponData, target, counterWeapon);
			_attackWeaponList.push(attack);
		}
		
		public function addSkill(unit:BattleUnit, side:int , skillData:MasterSkillData, target:BattleUnit):void
		{
			_expId = unit.battleId;
			var skill:AttackListItem = new AttackListItem();
			skill.setSkill(unit, side, skillData, target);
			_attackWeaponList.push(skill);
		}
		
		
		/**攻撃排除*/
		public function popAttack():void
		{
			_attackWeaponList.pop();
		}
		
		/**反撃追加*/
		public function addCounterAttack(unit:BattleUnit, side:int, weapon:MasterWeaponData, target:BattleUnit, counterWeapon:MasterWeaponData):void
		{
			var attack:AttackListItem = new AttackListItem();
			attack.setAttack(unit, side, weapon, target, counterWeapon);
			_attackWeaponList.push(attack);
		}
		
		/**棋譜初期化*/
		public function initAttack():void
		{
			var i:int = 0;
			for (i = 0; i < _attackWeaponList.length; )
			{
				_attackWeaponList[0] = null;
				_attackWeaponList.shift();
			}
		}
		
		public function useSkill(particleCallback:Function, endCallBack:Function):void
		{
			var i:int = 0, j:int = 0;
			for (i = 0; i < _attackWeaponList.length; i++ )
			{
				//回復
				if (_attackWeaponList[i].skill.heal > 0)
				{
					_attackWeaponList[i].target.healHP(_attackWeaponList[i].skill.heal);
				}
				//補給
				if (_attackWeaponList[i].skill.supply > 0)
				{
					_attackWeaponList[i].target.supplyFP(_attackWeaponList[i].skill.supply);
				}
				//効果
				if (_attackWeaponList[i].skill.buff != null)
				{
					var findFlg:Boolean = false;
					var buffName:String = _attackWeaponList[i].skill.buff;
					//該当バフデータを検索
					for (j = 0; j < MainController.$.model.masterBuffData.length; j++ )
					{
						if (buffName === MainController.$.model.masterBuffData[j].name)
						{
							findFlg = true;
							var addBuff:SkillBuffData = new SkillBuffData();
							addBuff.setMasterData(MainController.$.model.masterBuffData[j], _attackWeaponList[i].skill.turn, _attackWeaponList[i].skill.level);
							//ターゲットにバフを追加
							_attackWeaponList[i].target.buffAdd(addBuff);
							break;
						}
					}
					
					
					//見つからなかった場合
					if (!findFlg)
					{
						MainController.$.view.alertMessage("該当のバフが見つかりません", "BattleResultManager_Error");
					}
				}
				
				getExp += 10;
				particleCallback(_attackWeaponList[i].target.PosX, _attackWeaponList[i].target.PosY);
				
			}
			endCallBack();
			
		}
		
		
		
		/**戦闘結果作成*/
		public function makeRecord(attacker:BattleUnit, deffender:BattleUnit):void
		{
			var i:int = 0;
			var damage:int = 0;
			var hitFlg:Boolean = false;
			var effect:int = 0;
			_getExp = 0;
			_getMoney = 0;
			
			for (i = 0; i < _attackWeaponList.length; )
			{
				// 攻撃武器以外ならばレコードを作らない
				if (_attackWeaponList[i].weapon == null)
				{
					_attackWeaponList.shift();
					continue;
				}
				else if (_attackWeaponList[i].weapon.actType != MasterWeaponData.ACT_TYPE_ATK)
				{
					_attackWeaponList.shift();
					continue;
				}
				
				var rand:int = CommonBattleMath.getRandom(100, 0);
				
				var attackItem:AttackListItem = _attackWeaponList[i];
				if (attackItem.weapon != null)
				{
					damage = 0;
					// 命中算出
					if (rand <= attackItem.hit)
					{
						hitFlg = true;
						effect = BattleAnimeRecord.EFFECT_DAMAGE;
					}
					else
					{
						hitFlg = false;
						effect = BattleAnimeRecord.EFFECT_NO_HIT;
					}
					
					// 棋譜追加、ID一致と攻撃側生存時
					if (attackItem.unit.battleId == attacker.battleId && attacker.alive)
					{
						//FP消費
						if (attackItem.weapon.useFp > 0)
						{
							attacker.useFP(attackItem.weapon.useFp);
						}
						//カウント消費
						if (attackItem.weapon.maxCount > 0)
						{
							attackItem.weapon.useCount--;
						}
						
						//命中時
						if (hitFlg)
						{
							damage = CommonBattleMath.battleDamage(attackItem);
							deffender.damageSet(damage);
							
							//味方の場合経験値取得
							if (attacker.side == 0)
							{
								_expId = attacker.battleId;
								_getExp += CommonBattleMath.getExp(attacker, deffender);
								
								//撃破時資金追加
								if (!deffender.alive)
								{
									_getMoney += deffender.masterData.money;
								}
								
							}
						}
						addRecord(new BattleAnimeRecord(damage, BattleAnimeRecord.SIDE_LEFT, effect, BattleAnimeRecord.TYPE_NORMAL_ATTACK));
					}
					// 棋譜追加、ID一致と防御側生存時
					else if (attackItem.unit.battleId == deffender.battleId && deffender.alive)
					{
						
						//FP消費
						if (attackItem.weapon.useFp > 0)
						{
							deffender.useFP(attackItem.weapon.useFp);
						}
						//カウント消費
						if (attackItem.weapon.maxCount > 0)
						{
							attackItem.weapon.useCount--;
						}
						//命中時
						if (hitFlg)
						{
							damage = CommonBattleMath.battleDamage(attackItem);
							attacker.damageSet(damage);
							
							//味方の場合経験値取得
							if (deffender.side == 0)
							{
								_expId = deffender.battleId;
								_getExp += CommonBattleMath.getExp(deffender, attacker);
								
								//撃破時資金追加
								if (!attacker.alive)
								{
									_getMoney += attacker.masterData.money;
								}
							}
							
						}
						addRecord(new BattleAnimeRecord(damage, BattleAnimeRecord.SIDE_RIGHT, effect, BattleAnimeRecord.TYPE_NORMAL_ATTACK));
					}
					
				}
				// 反撃不能処理
				else
				{
					
				}
				
				//やられた時は経験値加算無し
				if ((attacker.side == 0 && !attacker.alive) || deffender.side == 0 && !deffender.alive)
				{
					_getExp = 0;
				}
				
				_attackWeaponList.shift();
			}
		}
		
		/**棋譜追加*/
		public function addRecord(record:BattleAnimeRecord):void
		{
			_attackRecord.push(record);
		}
		
		/**棋譜初期化*/
		public function initRecord():void
		{
			var i:int = 0;
			for (i = 0; i < _attackRecord.length; i++)
			{
				_attackRecord[0] = null;
				_attackRecord.shift();
			}
		}
		
		/** 反撃自動選択 */
		public function counterAutoSelect(attacker:BattleUnit, deffender:BattleUnit, counter:Boolean = false):MasterWeaponData
		{
			var lendge:int = Math.abs(_moveX - deffender.PosX) + Math.abs(_moveY - deffender.PosY);
			var terrainAtk:TerrainData = MainController.$.map.terrain[(attacker.PosX - 1) + (attacker.PosY - 1) * MainController.$.map.mapWidth];
			var terrainDef:TerrainData = MainController.$.map.terrain[(deffender.PosX - 1) + (deffender.PosY - 1) * MainController.$.map.mapWidth];
			
			var weapon:MasterWeaponData = null;
			// 反撃側武器選択
			if (counter)
			{
				weapon = deffender.autoSelectWeapon(lendge, terrainAtk, terrainDef, attacker);
			}
			// 攻撃側武器設定
			else
			{
				weapon = attacker.autoSelectWeapon(lendge, terrainAtk, terrainDef, deffender);
			}
			
			return weapon;
		}
		
		public function get attackFlg():Boolean
		{
			return _attackFlg;
		}
		
		public function set attackFlg(value:Boolean):void
		{
			_attackFlg = value;
		}
		
		public function get attackRecord():Vector.<BattleAnimeRecord>
		{
			return _attackRecord;
		}
		
		public function get moveX():int
		{
			return _moveX;
		}
		
		public function get moveY():int
		{
			return _moveY;
		}
		
		public function get attackWeaponList():Vector.<AttackListItem>
		{
			return _attackWeaponList;
		}
		
		public function get expId():int
		{
			return _expId;
		}
		
		public function get getExp():int
		{
			return _getExp;
		}
		
		public function set getExp(value:int):void
		{
			_getExp = value;
		}
		
		public function get getMoney():int
		{
			return _getMoney;
		}
		
		public function setMovePos(posX:int, posY:int):void
		{
			_moveX = posX + 1;
			_moveY = posY + 1;
		}
	}

}