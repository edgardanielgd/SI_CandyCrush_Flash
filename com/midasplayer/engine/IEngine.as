package com.midasplayer.engine
{
   import com.midasplayer.time.ITimer;
   import flash.display.DisplayObject;
   
   public interface IEngine
   {
       
      
      function isDone() : Boolean;
      
      function update() : void;
      
      function getTimer() : ITimer;
      
      function getPlayData() : String;
      
      function stop() : void;
      
      function getDisplayObject() : DisplayObject;
   }
}
