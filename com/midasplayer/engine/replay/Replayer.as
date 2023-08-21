package com.midasplayer.engine.replay
{
   import com.midasplayer.debug.Debug;
   import com.midasplayer.engine.IPart;
   import com.midasplayer.engine.playdata.IExecutablePlayData;
   import com.midasplayer.engine.playdata.IPlayData;
   import com.midasplayer.engine.tick.ITicker;
   import com.midasplayer.engine.tick.ITickerHook;
   
   public class Replayer implements IReplayer, ITickerHook
   {
       
      
      private var _part:IPart;
      
      private var _ticker:ITicker;
      
      private var _playDatas:Vector.<IPlayData>;
      
      private var _playDataIndex:int = 0;
      
      private var _started:Boolean = false;
      
      public function Replayer(param1:IPart, param2:ITicker, param3:Vector.<IPlayData>)
      {
         super();
         this._part = param1;
         this._ticker = param2;
         this._playDatas = param3;
         this._ticker.setHook(this);
      }
      
      public function update() : Boolean
      {
         if(this._part.isDone())
         {
            return true;
         }
         if(!this._started)
         {
            this._part.start();
            this._started = true;
         }
         this._ticker.update();
         if(this._part.isDone())
         {
            this._part.stop();
            return true;
         }
         return false;
      }
      
      public function preTick(param1:int) : void
      {
         this._tryExecutePlayDatas(param1);
      }
      
      public function postTick(param1:int) : void
      {
      }
      
      private function _tryExecutePlayDatas(param1:int) : void
      {
         var _loc2_:IExecutablePlayData = null;
         while(this._playDataIndex < this._playDatas.length)
         {
            _loc2_ = this._playDatas[this._playDataIndex] as IExecutablePlayData;
            if(_loc2_)
            {
               Debug.assert(_loc2_.getTick() >= param1,"The playdata seems to be unordered on their tick.");
               if(_loc2_.getTick() > param1)
               {
                  return;
               }
               _loc2_.execute();
            }
            var _loc3_:*;
            var _loc4_:* = (_loc3_ = this)._playDataIndex + 1;
            _loc3_._playDataIndex = _loc4_;
         }
      }
   }
}
