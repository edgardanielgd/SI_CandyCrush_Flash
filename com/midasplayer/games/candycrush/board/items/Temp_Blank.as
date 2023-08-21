package com.midasplayer.games.candycrush.board.items
{
   import com.midasplayer.games.candycrush.board.TemporaryItem;
   
   public class Temp_Blank extends TemporaryItem
   {
       
      
      public function Temp_Blank(param1:Number, param2:Number, param3:int)
      {
         super(param1,param2,0);
         _destroyTicks = param3;
         destroy();
      }
   }
}
