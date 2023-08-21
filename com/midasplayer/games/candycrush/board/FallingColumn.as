package com.midasplayer.games.candycrush.board
{
   import com.midasplayer.debug.Debug;
   
   public class FallingColumn
   {
       
      
      private var _items:Vector.<com.midasplayer.games.candycrush.board.Item>;
      
      public function FallingColumn()
      {
         this._items = new Vector.<com.midasplayer.games.candycrush.board.Item>();
         super();
      }
      
      public function isEmpty() : Boolean
      {
         return this._items.length == 0;
      }
      
      public function getItems() : Vector.<com.midasplayer.games.candycrush.board.Item>
      {
         return this._items;
      }
      
      public function getSize() : int
      {
         return this._items.length;
      }
      
      public function insertItem(param1:com.midasplayer.games.candycrush.board.Item) : void
      {
         var _loc2_:int = int(this._items.length);
         var _loc3_:int = _loc2_;
         while(_loc3_ > 0)
         {
            if(param1.y > this._items[_loc3_ - 1].y)
            {
               break;
            }
            _loc3_--;
         }
         this._items.splice(_loc3_,0,param1);
      }
      
      public function getLowestInsertionPoint() : Number
      {
         if(this.isEmpty() || this._items[0].y >= 0.5)
         {
            return -0.51;
         }
         return this._items[0].y - 1.01;
      }
      
      public function getCloseItems(param1:Number, param2:Number) : Vector.<com.midasplayer.games.candycrush.board.Item>
      {
         var _loc3_:Vector.<com.midasplayer.games.candycrush.board.Item> = new Vector.<com.midasplayer.games.candycrush.board.Item>();
         var _loc4_:int = 0;
         while(_loc4_ < this._items.length)
         {
            if(Math.abs(param1 - this._items[_loc4_].y) <= param2)
            {
               _loc3_.push(this._items[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function remove(param1:com.midasplayer.games.candycrush.board.Item) : void
      {
         var _loc2_:int = int(this._items.indexOf(param1));
         Debug.assert(_loc2_ >= 0,"Column::remove, trying to remove an item not in list: " + param1.id);
         this._items.splice(_loc2_,1);
      }
      
      public function isFree(param1:com.midasplayer.games.candycrush.board.Item) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         var _loc7_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc2_:int = int(this._items.indexOf(param1));
         Debug.assert(_loc2_ >= 0,"item not found in column!");
         if(param1.ya >= 0)
         {
            _loc3_ = _loc2_ + 1;
            if(_loc3_ == this._items.length)
            {
               return true;
            }
            _loc4_ = this._items[_loc3_];
            return param1.y + param1.ya + 0.999 <= _loc4_.y;
         }
         if((_loc6_ = _loc2_ - 1) < 0)
         {
            return true;
         }
         _loc7_ = this._items[_loc6_];
         return param1.y + param1.ya - 0.999 > _loc7_.y;
      }
      
      public function isFalling() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._items.length)
         {
            if(this._items[_loc1_].ya > 0)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function fits(param1:com.midasplayer.games.candycrush.board.Item) : Boolean
      {
         var _loc2_:com.midasplayer.games.candycrush.board.Item = null;
         for each(_loc2_ in this._items)
         {
            if(Math.abs(param1.y - _loc2_.y) < 1)
            {
               return false;
            }
         }
         return true;
      }
   }
}
