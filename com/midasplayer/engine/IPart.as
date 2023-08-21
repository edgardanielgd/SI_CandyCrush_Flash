package com.midasplayer.engine
{
   import com.midasplayer.engine.tick.ITickable;
   
   public interface IPart extends ITickable
   {
       
      
      function start() : void;
      
      function stop() : void;
   }
}
