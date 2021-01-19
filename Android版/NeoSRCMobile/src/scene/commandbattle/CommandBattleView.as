package scene.commandbattle 
{
	import system.custom.customSprite.CImage;
	import system.custom.customSprite.CSprite;
	import database.user.UnitCharaData;
	import starling.textures.TextureSmoothing;
	import main.MainController;
	import scene.unit.BattleUnit;
	/**
	 * ...
	 * @author ishikawa
	 */
	public class CommandBattleView extends CSprite
	{
		
		/** プレイヤーユニット */
		private var _player:Vector.<BattleUnit> = null;
		/** エネミーユニット */
		private var _enemy:Vector.<BattleUnit> = null;
		
		//-------------------------------------------------------------
		//
		// construction
		//
		//-------------------------------------------------------------
		public function CommandBattleView(player:Vector.<String>, enemy:Vector.<String>) 
		{
			var unit:UnitCharaData = null;
			var i:int = 0;
			_player = new Vector.<BattleUnit>;
			_enemy = new Vector.<BattleUnit>;
			
			for (i = 0; i < player.length; i++ )
			{
				unit = MainController.$.model.PlayerUnitDataName(player[i]);
				_player[i] = new BattleUnit(unit, i, 0);
				_player[i].unitImg.x = 120;
				_player[i].unitImg.y = 120 + 120 * i;
				_player[i].unitImg.width = 96;
				_player[i].unitImg.height = 96;
				if (_player[i].unitImg is CImage)
				{
					(CImage)(_player[i].unitImg).textureSmoothing = TextureSmoothing.NONE;
				}
				addChild(_player[i].unitImg);
			}
			
			for (i = 0; i < enemy.length; i++ )
			{
				unit = MainController.$.model.EnemyUnitDataName(enemy[i], 1);
				_enemy[i] = new BattleUnit(unit, 10 + i, 1);
				_enemy[i].unitImg.x = 480;
				_enemy[i].unitImg.y = 120 + 120 * i;
				_enemy[i].unitImg.width = 96;
				_enemy[i].unitImg.height = 96;
				if (_enemy[i].unitImg is CImage)
				{
					(CImage)(_enemy[i].unitImg).textureSmoothing = TextureSmoothing.NONE;
				}
				addChild(_enemy[i].unitImg);
			}
		}	
			
		
		//-------------------------------------------------------------
		//
		// override
		//
		//-------------------------------------------------------------
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