package com.midasplayer.games.candycrush.board.items
{
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.board.TemporaryItem;
   
   public class Temp_Color extends TemporaryItem
   {
       
      
      private var _wannaDie:Boolean = false;
      
      private var _wannaDieTicks:int = 5;
      
      private var _canBeRemovedTicks:int;
      
      private var _forceExplode:Boolean;
      
      public function Temp_Color(param1:Number, param2:Number, param3:int, param4:int = -1)
      {
         super(param1,param2,0);
         this._canBeRemovedTicks = 20;
         this._wannaDieTicks = 7;
         destructionColor = param3;
         special = ItemType.COLOR;
         this._forceExplode = param4 >= 0;
         if(this._forceExplode)
         {
            this._wannaDieTicks = param4;
         }
      }
      
      override public function wannaDie() : Boolean
      {
         if(this._wannaDieTicks > 0)
         {
            if(this._forceExplode || _board.isReasonableStable())
            {
               var _loc1_:*;
               var _loc2_:* = (_loc1_ = this)._wannaDieTicks - 1;
               _loc1_._wannaDieTicks = _loc2_;
            }
         }
         return this._wannaDieTicks == 0;
      }
   }
}
