package common.util 
{
    import a24.tween.Tween24;
    import common.CommonDef;
    import starling.display.DisplayObject;
	/**
     * ...
     * @author ...
     */
    public class BattleAnimeUtil 
    {
        /**攻撃アニメ*/
        public static function attackAnime(target:DisplayObject, time:Number, side:int):Tween24
        {
            var tween:Tween24 = Tween24.tween(target, time, Tween24.ease.BackIn);
            tween.$x(100 * side);
            return tween;
        }
        
     
        /**回避アニメ*/
        public static function avoidanceAnime(target:DisplayObject, time:Number, side:int):Tween24
        {
            var tween:Tween24 = Tween24.tween(target, time, Tween24.ease.BackIn);
            tween.$xy(20 * side, -60);
            return tween;
        }
        
        /**ダメージアニメ*/
        public static function damageAnime(target:DisplayObject, time:Number, side:int):Tween24
        {
            var tween:Tween24 = Tween24.tween(target, time, Tween24.ease.BackIn);
            tween.$x(20 * side);
            return tween;
        }
     
        /**やられアニメ*/
        public static function defeatAnime(target:DisplayObject, time:Number, side:int):Tween24
        {
            var tween1:Tween24 = Tween24.tween(target, time / 2.0);
            var tween2:Tween24 = Tween24.tween(target, time / 2.0);
            
            
            tween1.$x(60 * side);
            tween1.$y(-120);

            tween2.$x(60 * side);
            tween2.y(CommonDef.WINDOW_H + 128);
            
            
            var tweenList:Tween24 = Tween24.serial(tween1, tween2);
            return tweenList;
        }
        
        
        
    }

}