package com.midasplayer.engine.replay
{
   import com.midasplayer.engine.playdata.IPlayData;
   
   public interface IRecorder
   {
       
      
      function add(param1:IPlayData) : void;
      
      function toPlayDataXml(param1:int) : String;
   }
}
