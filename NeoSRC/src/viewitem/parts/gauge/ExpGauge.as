package viewitem.parts.gauge
{
	import a24.tween.Tween24;
	import viewitem.base.GaugeBase;
	
	/**
	 * ...
	 * @author ishikawa
	 */
	public class ExpGauge extends GaugeBase
	{
		/**取得レベルアップ値*/
		private var _getLvUp:int = 0;
		
		/**レベルアップカウント*/
		private var _lvUpCount:int = 0;
		/**余りカウント*/
		private var _lvUpMod:int = 0;
		
		private var _maxCallBack:Function = null;
		
		public function ExpGauge(setWidth:int, setHeight:int, maxPoint:int)
		{
			super(setWidth, setHeight, maxPoint);
		}
		
		override public function dispose():void
		{
			_maxCallBack = null;
			super.dispose();
		}
		
		
		public function addPoint(point:int, callBack:Function, time:Number = 1.0):void
		{
			if (_maxPoint <= 0) return;
			_lvUpCount = (point + nowPoint) / _maxPoint;
			_getLvUp　 = _lvUpCount;
			_lvUpMod = (point + nowPoint) % _maxPoint;
			var upTime:Number = 0;
			Tween24.wait(0.3).onComplete(lvUpAction).play();
			
			function lvUpAction():void
			{
				var setWidth:int = 0;
				//レベルアップ時
				if (_lvUpCount > 0)
				{
					upTime = time * (_maxPoint - _nowPoint) / _maxPoint;
					setWidth = _backImg.width;
					
					Tween24.tween(_gaugeImg, upTime).width(setWidth).onComplete(lvUpComp).play();
				}
				//上昇だけ
				else
				{
					upTime = time * _lvUpMod / _maxPoint;
					_nowPoint = _lvUpMod;
					setWidth = (int)(_backImg.width * _lvUpMod / _maxPoint * 1.0);
					var ary:Array = new Array();
					Tween24.tween(_gaugeImg, upTime).width(setWidth).onComplete(lvUpEnd).play();
				}
			}
			
			function lvUpComp():void
			{
				if (_maxCallBack != null)
				{
					_maxCallBack();
				}
				
				_lvUpCount--;
				_nowPoint = 0;
				_gaugeImg.width = 0;
				lvUpAction();
			}
			
			function lvUpEnd():void
			{
				if (callBack != null)
				{
					Tween24.wait(1.0).onComplete(callBack).play();
				}
				else
				{
					Tween24.wait(1.0).play();
				}
			}
		}
		
		public function get getLvUp　():int
		{
			return _getLvUp　;
		}
		
		public function get lvUpMod():int
		{
			return _lvUpMod;
		}
		
		public function set maxCallBack(value:Function):void 
		{
			_maxCallBack = value;
		}
	}

}