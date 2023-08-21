package com.midasplayer.time
{
   public class AdjustableTimer implements com.midasplayer.time.ITimer
   {
       
      
      private var _timer:com.midasplayer.time.ITimer;
      
      private var _time:Number = 0;
      
      private var _lastTime:int = 0;
      
      private var _speed:Number = 1;
      
      public function AdjustableTimer(param1:com.midasplayer.time.ITimer)
      {
         super();
         this._timer = param1;
      }
      
      public function getTime() : int
      {
         var _loc1_:int = int(this._timer.getTime());
         this._time = this._time + this._speed * (_loc1_ - this._lastTime);
         this._lastTime = _loc1_;
         return this._time;
      }
      
      public function setSpeed(param1:Number) : void
      {
         this._speed = param1;
      }
      
      public function getSpeed() : Number
      {
         return this._speed;
      }
   }
}
