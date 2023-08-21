package com.midasplayer.games.candycrush.render
{
   import flash.display.Sprite;
   
   public class Fx_ScorePop extends TickedSprite
   {
       
      
      private var ybase:Number;
      
      private var s:Sprite;
      
      public function Fx_ScorePop(param1:int, param2:Number, param3:Number, param4:int, param5:int)
      {
         super(null,param1);
         this.s = getColorScorepop(param4);
         this.s.x = param2;
         this.s.y = param3;
         this.ybase = param3;
         this.s["text"].text = "" + param5;
         frontsprite.addChild(this.s);
      }
      
      private static function getColorScorepop(param1:int) : Sprite
      {
         if(param1 < 1 || param1 > 6)
         {
            param1 = 1;
         }
         return new [GA_Scorepop_blue,GA_Scorepop_green,GA_Scorepop_orange,GA_Scorepop_purple,GA_Scorepop_red,GA_Scorepop_yellow][param1 - 1]();
      }
      
      override public function tick(param1:int) : void
      {
         done = getLivedTicks() > 30;
      }
      
      override protected function renderFront(param1:int, param2:Number) : void
      {
         this.s.y = this.ybase - getLivedTicks();
         var _loc3_:Number = Math.min(1,0.1 + getLivedShare(10));
         this.s.scaleX = this.s.scaleY = _loc3_;
         if(_loc3_ > 5 || _loc3_ < -5)
         {
         }
         if(getLivedTicks() > 20)
         {
            this.s.alpha = (30 - getLivedTicks()) * 0.1;
         }
      }
      
      override public function addAndRemoveMe() : Boolean
      {
         return true;
      }
      
      override public function addAtFront() : Boolean
      {
         return true;
      }
   }
}
