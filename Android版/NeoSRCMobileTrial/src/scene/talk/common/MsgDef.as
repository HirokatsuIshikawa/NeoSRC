package scene.talk.common
{
	import a24.tween.Tween24;
	import common.CommonDef;
	import starling.display.DisplayObject;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class MsgDef
	{
		public static function setTweenParam(obj:DisplayObject, param:Object, skip:Boolean):Tween24
		{
			var posX:int = 0;
			var time:Number = 0;
			var ease:Function = Tween24.ease.Linear;
			
			if (param.hasOwnProperty("time"))
			{
				if (skip)
				{
					time = 0.01;
				}
				else
				{
					time = Number(param.time);
				}
			}
			
			if (param.hasOwnProperty("ease"))
			{
				ease = Tween24.ease[param.ease];
			}
			
			var tween:Tween24 = null;
			
			if (time <= 0)
			{
				tween = Tween24.prop(obj);
			}
			else
			{
				tween = Tween24.tween(obj, time, ease);
			}
			
			
			// X座標
			if (param.hasOwnProperty("x"))
			{
				if (param.hasOwnProperty("chara"))
				{
					posX = param.x - obj.width / 2;
					tween.x(posX);
				}
				else
				{
					tween.x(Number(param.x));
				}
			}
			else if (param.hasOwnProperty("$x"))
			{
				
				if (param.hasOwnProperty("chara"))
				{
					posX = param.x - obj.width / 2;
					tween.$x(posX);
				}
				else
				{
					tween.$x(Number(param.$x));
				}
			}
			// Y座標
			if (param.hasOwnProperty("y"))
			{
				tween.y(Number(param.y));
			}
			else if (param.hasOwnProperty("$y"))
			{
				tween.$y(Number(param.$y));
			}
			// α値
			if (param.hasOwnProperty("alpha"))
			{
				tween.alpha(Number(param.alpha));
				obj.visible = true;
			}
			else if (param.hasOwnProperty("fade"))
			{
				param.alpha = 1;
				if (param.fade === "in")
				{
					tween.fadeIn();
				}
				else if (param.fade === "out")
				{
					tween.fadeOut();
				}
			}
			else
			{
				param.alpha = obj.alpha;
			}
			
			if (param.alpha > 0)
			{
				obj.visible = true;
			}
			
			return tween;
		
		}
	
	}

}