package com.midasplayer.games.candycrush
{
   public class Ticks
   {
      
      public static const TicksPerSecond:int = 30;
      
      public static const SecondsPerTick:Number = 1 / TicksPerSecond;
       
      
      public function Ticks()
      {
         super();
      }
      
      public static function sec2Ticks(param1:Number) : int
      {
         return int(param1 * TicksPerSecond);
      }
      
      public static function ticks2Sec(param1:Number) : Number
      {
         return param1 / TicksPerSecond;
      }
   }
}
