package com.midasplayer.games.candycrush.board
{
   public class TemporaryItem extends Item
   {
       
      
      public function TemporaryItem(param1:Number, param2:Number, param3:int)
      {
         super(param1,param2,param3);
         _isTemp = true;
      }
      
      override public function isToBeRemoved() : Boolean
      {
         return true;
      }
   }
}
