package com.midasplayer.engine.comm
{
   import com.midasplayer.debug.IAssertHandler;
   import com.midasplayer.engine.playdata.LogPlayData;
   import com.midasplayer.engine.replay.IRecorder;
   
   public class RemoteAssertHandler implements IAssertHandler
   {
       
      
      private var _recorder:IRecorder;
      
      private var _sentAsserts:int = 0;
      
      private const _maxAsserts:int = 100;
      
      public function RemoteAssertHandler(param1:IRecorder)
      {
         super();
         this._recorder = param1;
      }
      
      public function assert(param1:String) : void
      {
         if(this._sentAsserts >= this._maxAsserts)
         {
            return;
         }
         var _loc2_:*;
         var _loc3_:* = (_loc2_ = this)._sentAsserts + 1;
         _loc2_._sentAsserts = _loc3_;
         this._recorder.add(new LogPlayData(param1));
      }
   }
}
