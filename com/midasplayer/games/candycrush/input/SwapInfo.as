package com.midasplayer.games.candycrush.input
{
   import com.midasplayer.games.candycrush.board.Item;
   
   public class SwapInfo
   {
       
      
      public var x0:int;
      
      public var y0:int;
      
      public var x1:int;
      
      public var y1:int;
      
      public var item_a:Item;
      
      public var item_b:Item;
      
      public var isFailed:Boolean = false;
      
      public function SwapInfo(param1:int, param2:int, param3:int, param4:int, param5:Item = null, param6:Item = null)
      {
         super();
         this.x0 = param1;
         this.y0 = param2;
         this.x1 = param3;
         this.y1 = param4;
         this.item_a = param5;
         this.item_b = param6;
      }
      
      public function hasItems() : Boolean
      {
         return Boolean(this.item_a) && Boolean(this.item_b);
      }
      
      public function isHorizontal() : Boolean
      {
         return this.y0 == this.y1;
      }
      
      public function isVertical() : Boolean
      {
         return this.x0 == this.x1;
      }
      
      public function isBusy() : Boolean
      {
         if(!this.hasItems())
         {
            return false;
         }
         return this.item_a.isBusy() || this.item_b.isBusy();
      }
   }
}
