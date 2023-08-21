package com.midasplayer.engine.replay
{
   import com.midasplayer.engine.IEngine;
   
   public interface IReplayEngineFactory
   {
       
      
      function create(param1:String, param2:String) : IEngine;
   }
}
