package com.midasplayer.animation.tweenick
{
   public class TTEasing
   {
       
      
      public function TTEasing()
      {
         super();
      }
      
      public static function Linear(param1:TTData) : Number
      {
         var _loc2_:Number = param1.curTicks / param1.dstTicks;
         return param1.start + _loc2_ * param1.delta;
      }
      
      public static function QuadraticIn(param1:TTData) : Number
      {
         var _loc2_:Number = param1.curTicks / param1.dstTicks;
         return param1.delta * (_loc2_ * _loc2_) + param1.start;
      }
      
      public static function QuadraticOut(param1:TTData) : Number
      {
         var _loc2_:Number = param1.curTicks / param1.dstTicks;
         return -param1.delta * _loc2_ * (_loc2_ - 2) + param1.start;
      }
      
      public static function PowerIn(param1:Number) : Function
      {
         var exp:Number = param1;
         return function(param1:TTData):Number
         {
            var _loc2_:* = param1.curTicks / param1.dstTicks;
            return param1.delta * Math.pow(_loc2_,exp) + param1.start;
         };
      }
      
      public static function PowerOut(param1:Number) : Function
      {
         var exp:Number = param1;
         return function(param1:TTData):Number
         {
            var _loc2_:* = param1.curTicks / param1.dstTicks;
            return param1.stop - param1.delta * Math.pow(1 - _loc2_,exp);
         };
      }
      
      public static function CubicIn(param1:TTData) : Number
      {
         var _loc2_:Number = param1.curTicks / param1.dstTicks;
         return param1.delta * (_loc2_ * _loc2_ * _loc2_) + param1.start;
      }
      
      public static function CubicOut(param1:TTData) : Number
      {
         var _loc2_:Number = param1.curTicks / param1.dstTicks;
         return param1.stop + param1.delta * (_loc2_ - 1) * (_loc2_ - 1) * (_loc2_ - 1);
      }
      
      public static function QuadraticOutReturner(param1:TTData) : Number
      {
         var _loc2_:Number = param1.curTicks / param1.dstTicks;
         return param1.stop - 4 * param1.delta * (-_loc2_ * _loc2_ + _loc2_);
      }
      
      public static function QuadraticOutReturner2(param1:TTData) : Number
      {
         var _loc2_:Number = param1.curTicks / param1.dstTicks;
         return param1.start - 4 * param1.delta * (-_loc2_ * _loc2_ + _loc2_);
      }
      
      public static function OffsetSine(param1:TTData) : Number
      {
         var _loc2_:Number = param1.curTicks / param1.dstTicks;
         return param1.start + param1.stop * Math.sin(2 * Math.PI * _loc2_);
      }
   }
}
