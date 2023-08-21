package com.midasplayer.time
{
   import flash.utils.getTimer;
   
   public class SystemTimer implements ITimer
   {
       
      
      private const _startTime:int = getTimer();
      
      public function SystemTimer()
      {
         super();
      }
      
      public function getTime() : int
      {
         return getTimer() - this._startTime;
      }
   }
}
