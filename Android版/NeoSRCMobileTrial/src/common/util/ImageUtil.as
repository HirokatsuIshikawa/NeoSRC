package common.util 
{
	/**
     * ...
     * @author ...
     */
    public class ImageUtil 
    {
                // 出撃パーティクル
    /*
       public function launchParticle(posX:int, posY:int):Tween24
       {
       var tex:Texture = MainController.$.imgAsset.getTexture("pex_fire");
       var particles:ParticleSystem;
       particles = new PDParticleSystem(CommonDef.LAUNCH_XML, tex);
       particles.start();
       particles.emitterX = posX * MAP_SIZE - MAP_SIZE / 2;
       particles.emitterY = posY * MAP_SIZE - MAP_SIZE / 2;
       Starling.juggler.add(particles);
       particles.visible = true;
       particles.alpha = 1;
       _frameArea.addChild(particles);
       return Tween24.tween(particles, 0.3, Tween24.ease.CubicOut).fadeOut().onComplete(endParticle);
    
       function endParticle():void
       {
       _frameArea.removeChild(particles);
       Starling.juggler.remove(particles);
       }
       }
     */
    

        /** ユニット配置エリアソート（軽量化用） */
        public static function sortUnitArea(obj1:DisplayObject, obj2:DisplayObject):Number
        {
            var objUrl1:String = "";
            var objUrl2:String = "";
            var adv1:int = 0;
            var adv2:int = 0;
            var unit1Url:String = MainController.$.model.masterUnitImageData.getUnitImgName((obj1.parent as BattleUnit).masterData.unitsImgName);
            var unit1Ur2:String = MainController.$.model.masterUnitImageData.getUnitImgName((obj2.parent as BattleUnit).masterData.unitsImgName);
            
            if (obj1.parent is BattleUnit)
            {
                objUrl1 = unit1Url;
                adv1 = 100;
            }
            else
            {
                objUrl1 = "";
            }
            
            if (obj2.parent is BattleUnit)
            {
                objUrl2 = unit1Ur2;
                adv2 = 100;
            }
            else
            {
                objUrl2 = "";
            }
            
            if (adv1 == 0 && adv2 == 0)
            {
                return 0;
            }
            else if (adv1 != adv2)
            {
                return adv2 - adv1;
            }
            else
            {
                var i:uint = 0;
                while (true)
                {
                    var p:Number = objUrl1.charCodeAt(i) || 0;
                    var n:Number = objUrl2.charCodeAt(i) || 0;
                    p += adv1;
                    n += adv2;
                    
                    var s:Number = p - n;
                    if (s) return s;
                    if (!p) break;
                    i++;
                }
            }
            return 0;
        }
        
    }

}