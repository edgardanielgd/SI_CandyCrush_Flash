package com.midasplayer.games.candycrush.board.items
{
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.board.TemporaryItem;
   
   public class Temp_Column extends TemporaryItem
   {
       
      
      private var _wannaDie:Boolean = false;
      
      private var _wannaDieTicks:int;
      
      private var _canBeRemovedTicks:int;
      
      public function Temp_Column(param1:Number, param2:Number, param3:int, param4:int)
      {
         super(param1,param2,param3);
         this._wannaDieTicks = param4;
         special = ItemType.COLUMN;
      }
      
      override public function wannaDie() : Boolean
      {
         if(this._wannaDieTicks > 0)
         {
            var _loc1_:*;
            var _loc2_:* = (_loc1_ = this)._wannaDieTicks - 1;
            _loc1_._wannaDieTicks = _loc2_;
         }
         return this._wannaDieTicks == 0;
      }
   }
}
