package com.midasplayer.games.candycrush.board.plans
{
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.board.*;
   import com.midasplayer.games.candycrush.input.*;
   
   public class DPlan_ColorColor implements IDestructionPlan
   {
       
      
      private var _isDone:Boolean = true;
      
      private var _board:Board;
      
      private var _colorItemA:Item;
      
      private var _colorItemB:Item;
      
      private var _itemIndex:int = -1;
      
      private var _itemCount:int;
      
      private var _items:Vector.<Item>;
      
      private var _toRemoveVec:Vector.<Item>;
      
      private var _ticks:int = 0;
      
      private const _id:int = _loc4_ = (_loc3_ = ItemFactory).DPLAN_ID + 1;
      
      public function DPlan_ColorColor(param1:Board, param2:SwapInfo)
      {
         this._toRemoveVec = new Vector.<Item>();
         _loc3_.DPLAN_ID = _loc4_;
         super();
         this._board = param1;
         this._colorItemA = param2.item_a;
         this._colorItemB = param2.item_b;
         this._toRemoveVec[0] = null;
      }
      
      public function getItems() : Vector.<Item>
      {
         var _loc3_:int = 0;
         var _loc4_:Item = null;
         var _loc1_:Vector.<Item> = new Vector.<Item>();
         var _loc2_:int = 0;
         while(_loc2_ < this._board.width())
         {
            _loc3_ = 0;
            while(_loc3_ < this._board.height())
            {
               if(!(!(_loc4_ = this._board.getUnifiedGridItem(_loc2_,_loc3_)) || _loc4_ == this._colorItemA || _loc4_ == this._colorItemB))
               {
                  _loc1_.push(_loc4_);
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function setup(param1:int) : void
      {
         this._items = this.getItems();
         this._itemCount = this._items.length;
      }
      
      public function tick(param1:int) : void
      {
         _loc2_._ticks = _loc3_;
         var _loc3_:*;
         var _loc2_:*;
         if((_loc3_ = (_loc2_ = this)._ticks + 1) > 5)
         {
            _loc3_ = (_loc2_ = this)._itemIndex + 1;
            _loc2_._itemIndex = _loc3_;
         }
      }
      
      public function getDestructionItem() : Item
      {
         var _loc1_:Item = new Item(this._colorItemA.column,this._colorItemA.row,0);
         _loc1_.setRemovalTicks(83);
         _loc1_.special = ItemType.COLOR;
         return _loc1_;
      }
      
      public function getItemsToRemove() : Vector.<Item>
      {
         if(this._itemIndex >= 0 && this._itemIndex < this._itemCount)
         {
            this._toRemoveVec[0] = this._items[this._itemIndex];
            return this._toRemoveVec;
         }
         return null;
      }
      
      public function isDone() : Boolean
      {
         return this._itemIndex >= this._itemCount;
      }
      
      public function scorepopPerItem() : Boolean
      {
         return true;
      }
      
      public function isImmediate() : Boolean
      {
         return false;
      }
      
      public function getId() : int
      {
         return this._id;
      }
   }
}
