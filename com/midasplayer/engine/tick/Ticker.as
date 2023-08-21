package com.midasplayer.engine.tick
{
   import com.midasplayer.debug.Debug;
   import com.midasplayer.time.ITimer;
   
   public class Ticker implements ITicker
   {
       
      
      private var _timer:ITimer;
      
      private var _tickable:com.midasplayer.engine.tick.ITickable;
      
      private var _tick:int = 0;
      
      private var _alpha:Number = 1;
      
      private var _tickInterval:int = 0;
      
      private var _startTime:int = -1;
      
      private var _maxTicks:int = 0;
      
      private var _hasStarted:Boolean = false;
      
      private var _hook:com.midasplayer.engine.tick.ITickerHook;
      
      public function Ticker(param1:ITimer, param2:com.midasplayer.engine.tick.ITickable, param3:int, param4:int)
      {
         super();
         this._timer = param1;
         this._tickable = param2;
         this._tickInterval = int(1000 / param3);
         this._maxTicks = param4;
      }
      
      public function getTick() : int
      {
         return this._tick - 1;
      }
      
      public function getAlpha() : Number
      {
         return this._alpha;
      }
      
      public function setHook(param1:com.midasplayer.engine.tick.ITickerHook) : void
      {
         Debug.assert(this._hook == null,"A hook is already set.");
         this._hook = param1;
      }
      
      public function update() : void
      {
         var _loc1_:int = int(this._timer.getTime());
         if(!this._hasStarted)
         {
            this._startTime = _loc1_ - this._tickInterval;
            this._hasStarted = true;
         }
         var _loc2_:int = _loc1_ - this._startTime;
         var _loc3_:int = this._tick * this._tickInterval;
         if(_loc2_ < _loc3_)
         {
            Debug.assert(false,"The time has decreased since last step call: " + _loc2_ + " < " + _loc3_);
         }
         var _loc4_:int;
         if((_loc4_ = _loc2_ - _loc3_) >= this._tickInterval)
         {
            this._step(_loc4_);
         }
         this._alpha = Math.min(_loc2_ / this._tickInterval - this._tick,1);
      }
      
      private function _step(param1:int) : void
      {
         var _loc2_:int = this._tick + this._maxTicks;
         while(param1 >= this._tickInterval && this._tick < _loc2_)
         {
            if(this._tickable.isDone())
            {
               break;
            }
            param1 -= this._tickInterval;
            if(this._hook != null)
            {
               this._hook.preTick(this._tick);
            }
            this._tickable.tick(this._tick);
            if(this._hook != null)
            {
               this._hook.postTick(this._tick);
            }
            var _loc3_:*;
            var _loc4_:* = (_loc3_ = this)._tick + 1;
            _loc3_._tick = _loc4_;
         }
      }
   }
}
