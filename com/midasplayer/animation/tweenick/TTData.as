package com.midasplayer.animation.tweenick
{
   public class TTData
   {
       
      
      public var start:Number;
      
      public var stop:Number;
      
      public var delta:Number;
      
      public var deltaPerTick:Number;
      
      public var dstTicks:Number;
      
      public var curTicks:Number;
      
      public function TTData(param1:Number, param2:Number, param3:Number, param4:Number = 0)
      {
         super();
         this.dstTicks = param1;
         this.start = param2;
         this.stop = param3;
         this.delta = param3 - param2;
         this.deltaPerTick = this.delta / param1;
         this.curTicks = param4;
      }
   }
}
