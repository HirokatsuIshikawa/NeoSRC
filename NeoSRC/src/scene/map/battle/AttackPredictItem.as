package scene.map.battle
{
	import common.CommonDef;
	import common.CommonSystem;
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import system.custom.customSprite.CTextArea;
	import feathers.controls.TextArea;
	import flash.geom.Rectangle;
	import starling.textures.TextureSmoothing;
	import scene.main.MainController;
	import scene.map.BattleMap;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class AttackPredictItem extends CSprite
	{
		private var _backImg:CImage = null;
		// 名前
		private var _name:CTextArea = null;
		// 値
		private var _value:CTextArea = null;
		// 命中
		private var _hit:CTextArea = null;
		
		public function AttackPredictItem()
		{
			super();
		}
		
		public function setState(data:AttackListItem):void
		{
			_backImg = new CImage(MainController.$.imgAsset.getTexture("backimg"));
			_backImg.scale9Grid = new Rectangle(1, 1, 2, 2);
			_backImg.width = 360;
			_backImg.height = 120;
			_backImg.textureSmoothing = TextureSmoothing.NONE;
			addChild(_backImg);
			
			_name = new CTextArea(24, 0xFFFFFF);
			_name.styleName = "custom_text";
			_name.width = 320;
			_name.height = 32;
			_name.x = 8;
			_name.y = 8;
			addChild(_name);
			
			_value = new CTextArea(24, 0xFFFFFF);
			_value.styleName = "custom_text";
			_value.width = 160;
			_value.height = 32;
			_value.x = 8;
			_value.y = 40;
			addChild(_value);
			
			_hit = new CTextArea(24, 0xFFFFFF);
			_hit.styleName = "custom_text";
			_hit.width = 160;
			_hit.height = 32;
			_hit.x = 120;
			_hit.y = 72;
			addChild(_hit);
			if (data.type == BattleMap.ACT_TYPE_ATK)
			{
				if (data.weapon != null)
				{
					_name.text = data.weapon.name + "";
					_value.text = "攻撃力：" + (int)(data.weapon.value * data.unit.param.ATK / 10.0);
					_hit.text = "命中率：" + data.hit;
				}
				else
				{
					_name.text = "反撃不能";
					_value.text = "---";
					_hit.text = "---";
				}
			}
			else if (data.type == BattleMap.ACT_TYPE_SKILL)
			{
				_name.text = data.skill.name + "";
				_value.text = "";
				
				if (data.skill.heal > 0)
				{
					_value.text += "回復：" + data.skill.heal * data.unit.param.MND + "　";
				}
				
				if (data.skill.supply > 0)
				{
					_value.text += "補給：" + data.skill.supply * data.unit.param.MND + "　";
				}
				
				_hit.text = "";
				
			}
		}
	
	}

}