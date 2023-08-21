package com.midasplayer.games.candycrush.board
{
   public interface IItemListener
   {
       
      
      function beginMove(param1:Item, param2:int, param3:Number, param4:Number, param5:int) : void;
      
      function bounced(param1:Boolean) : void;
   }
}
