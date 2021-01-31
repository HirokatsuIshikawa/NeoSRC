package common
{
    import database.master.MasterCharaData;
    import scene.map.tip.TerrainData;
    import scene.unit.BattleUnit;
    
    /**
     * ...
     * @author ishikawa
     */
    public class CommonMapMath
    {
        /**進入地形対応チェック*/
        public static function checkMoveEnable(unit:BattleUnit, terrain:TerrainData):Boolean
        {
            var flg:Boolean = true;
            
            //侵入不可地形
            if (terrain.Type == TerrainData.TYPE_NUM[TerrainData.TERRAIN_TYPE_NONE])
            {
                flg = false;
            }
            //空中移動できない場合
            else if (terrain.Type == TerrainData.TYPE_NUM[TerrainData.TERRAIN_TYPE_SKY] && !unit.isFly)
            {
                flg = false;
            }
            else
            {
                //移動コスト取得
                var properCost:int = unit.terrain[terrain.Type];
                //適応不可
                if (properCost == -1)
                {
                    flg = false;
                }
            }
            
            return flg;
        }
        
        /**移動コスト算出*/
        public static function checkMoveCost(point:int, cost:int, proper:Vector.<int>, terrain:TerrainData, isFly:Boolean):int
        {
            var moveCost:int = cost;
            var restPoint:int = point;
            var properCost:int = -1;
            
            if (isFly)
            {
                properCost = proper[TerrainData.TERRAIN_TYPE_SKY];
            }
            else
            {
                properCost = proper[terrain.Type];
            }
            
            //S適正の場合は移動コストは必ず１
            if (properCost == 0)
            {
                moveCost = 1;
            }
            //E適性の場合は1マスのみ
            else if (properCost == 99)
            {
                restPoint = 0;
            }
            //それ以外は適正値に対応
            else
            {
                //飛行は自身の適正のみで計算
                if (isFly)
                {
                    moveCost = 1 + (properCost - 1);
                }
                else
                {
                    moveCost += (properCost - 1);
                }
            }
            
            restPoint -= moveCost;
            return restPoint;
        }
        
        /**ビット演算*/
        public static function autoTileCheck(data:int, filter:int):Boolean
        {
            data &= filter;
            if (data >= filter)
            {
                return true;
            }
            return false;
        }
        
        public static function autoTileCount(count:int):int
        {
            var ans:int = 0;
            /////////////////////////////////////////////////////全部//////////////////////////////////////////////////////
            if (autoTileCheck(count, 255))
            {
                ans = 47;
            }
            //////////////////////////////////////７枚
            //左上以外
            else if (autoTileCheck(count, 254))
            {
                ans = 32;
            }
            //右上以外
            else if (autoTileCheck(count, 251))
            {
                ans = 33;
            }
            //左下以外
            else if (autoTileCheck(count, 223))
            {
                ans = 40;
            }
            //右下以外
            else if (autoTileCheck(count, 127))
            {
                ans = 41;
            }
            //////////////////////////////////////６枚
            //左下右下以外
            else if (autoTileCheck(count, 95))
            {
                ans = 42;
            }
            
            //左上左下以外
            else if (autoTileCheck(count, 222))
            {
                ans = 43;
            }
            //左上右下以外
            else if (autoTileCheck(count, 126))
            {
                ans = 44;
            }
            //右上左上以外
            else if (autoTileCheck(count, 250))
            {
                ans = 34;
            }
            //右上右下以外
            else if (autoTileCheck(count, 123))
            {
                ans = 35;
            }
            //右上左下以外
            else if (autoTileCheck(count, 219))
            {
                ans = 36;
            }
            ///////////////////////////////////５枚
            //左右下全部
            else if (autoTileCheck(count, 248))
            {
                ans = 24;
            }
            //上下左全部
            else if (autoTileCheck(count, 107))
            {
                ans = 25;
            }
            //左右上全部
            else if (autoTileCheck(count, 31))
            {
                ans = 26;
            }
            //上下右前部
            else if (autoTileCheck(count, 214))
            {
                ans = 27;
            }
            //上下左右右上
            else if (autoTileCheck(count, 94))
            {
                ans = 45;
            }
            //上下左右左上
            else if (autoTileCheck(count, 91))
            {
                ans = 46;
            }
            //上下左右右下
            else if (autoTileCheck(count, 218))
            {
                ans = 37;
            }
            //上下左右左下
            else if (autoTileCheck(count, 122))
            {
                ans = 38;
            }
            ///////////////////////////////////４枚
            //上下左左上
            else if (autoTileCheck(count, 75))
            {
                ans = 21;
            }
            //上左右右上
            else if (autoTileCheck(count, 30))
            {
                ans = 22;
            }
            //上下右右下
            else if (autoTileCheck(count, 210))
            {
                ans = 23;
            }
            
            //左右下右下
            else if (autoTileCheck(count, 216))
            {
                ans = 28;
            }
            //上下左左下
            else if (autoTileCheck(count, 106))
            {
                ans = 29;
            }
            //左右上左上
            else if (autoTileCheck(count, 27))
            {
                ans = 30;
            }
            //上下右右上
            else if (autoTileCheck(count, 86))
            {
                ans = 31;
            }
            //上下左右
            else if (autoTileCheck(count, 90))
            {
                ans = 39;
            }
            //左右下左下
            else if (autoTileCheck(count, 120))
            {
                ans = 20;
            }
            /////////////////////////３枚
            //右右下下
            else if (autoTileCheck(count, 208))
            {
                ans = 10;
            }
            
            //左左下下
            else if (autoTileCheck(count, 104))
            {
                ans = 11;
            }
            //左右下
            else if (autoTileCheck(count, 88))
            {
                ans = 12;
            }
            //上下左
            else if (autoTileCheck(count, 74))
            {
                ans = 13;
            }
            //左右上
            else if (autoTileCheck(count, 26))
            {
                ans = 14;
            }
            //上下右
            else if (autoTileCheck(count, 82))
            {
                ans = 15;
            }
            //上右上右
            else if (autoTileCheck(count, 22))
            {
                ans = 18;
            }
            //上左上左
            else if (autoTileCheck(count, 11))
            {
                ans = 19;
            }
            
            /////////////////////////２枚
            //上下
            else if (autoTileCheck(count, 66))
            {
                ans = 6;
            }
            //左右
            else if (autoTileCheck(count, 24))
            {
                ans = 7;
            }
            //右と下
            else if (autoTileCheck(count, 80))
            {
                ans = 8;
            }
            //左と下
            else if (autoTileCheck(count, 72))
            {
                ans = 9;
            }
            //上右
            else if (autoTileCheck(count, 18))
            {
                ans = 16;
            }
            //上左
            else if (autoTileCheck(count, 10))
            {
                ans = 17;
            }
            /////////////////////////単体
            //上のみ
            else if (autoTileCheck(count, 2))
            {
                ans = 3;
            }
            //左のみ
            else if (autoTileCheck(count, 8))
            {
                ans = 5;
            }
            //右のみ
            else if (autoTileCheck(count, 16))
            {
                ans = 4;
            }
            //下のみ
            else if (autoTileCheck(count, 64))
            {
                ans = 2;
            }
            else
            {
                ans = 1;
            }
            return ans;
        }
        
        public static function autoObjCount(count:int):int
        {
            var ans:int = 0;
            
            /////////////////////////////////////////////////////全部//////////////////////////////////////////////////////
            if (autoTileCheck(count, 255))
            {
                ans = 47;
            }
            //////////////////////////////////////７枚
            //左上以外
            else if (autoTileCheck(count, 254))
            {
                ans = 41;
            }
            //右上以外
            else if (autoTileCheck(count, 251))
            {
                ans = 42;
            }
            //左下以外
            else if (autoTileCheck(count, 223))
            {
                ans = 44;
            }
            //右下以外
            else if (autoTileCheck(count, 127))
            {
                ans = 45;
            }
            ///////////////////////////////////６枚
            //左上右下以外
            else if (autoTileCheck(count, 126))
            {
                ans = 46;
            }
            //右上左下以外
            else if (autoTileCheck(count, 219))
            {
                ans = 43;
            }
            ///////////////////////////////////５枚
            //左右下全部
            else if (autoTileCheck(count, 248))
            {
                ans = 33;
            }
            //上下左全部
            else if (autoTileCheck(count, 107))
            {
                ans = 35;
            }
            //左右上全部
            else if (autoTileCheck(count, 31))
            {
                ans = 37;
            }
            //上下右前部
            else if (autoTileCheck(count, 214))
            {
                ans = 39;
            }
            /////////////////////////３枚
            //右右下下
            else if (autoTileCheck(count, 208))
            {
                ans = 19;
            }
            //左左下下
            else if (autoTileCheck(count, 104))
            {
                ans = 23;
            }
            //上右上右
            else if (autoTileCheck(count, 22))
            {
                ans = 27;
            }
            //上左上左
            else if (autoTileCheck(count, 11))
            {
                ans = 31;
            }
            else
            {
                ans = 1;
            }
            return ans;
        }
    }
}