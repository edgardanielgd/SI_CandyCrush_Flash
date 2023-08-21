package com.midasplayer.engine.playdata
{
   public interface IExecutablePlayData extends IPlayData
   {
       
      
      function getTick() : int;
      
      function execute() : void;
   }
}
