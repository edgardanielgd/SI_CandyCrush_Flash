package com.midasplayer.games.candycrush.board.plans
{
   import com.midasplayer.games.candycrush.board.Board;
   import com.midasplayer.games.candycrush.board.FallingColumn;
   import com.midasplayer.games.candycrush.board.IDestructionPlan;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.board.ItemFactory;
   
   public class DPlan_Column implements IDestructionPlan
   {
      
      private static const DelayTicks:int = 0;
       
      
      private var _done:Boolean = false;
      
      private var _ticks:int = 0;
      
      private var _board:Board;
      
      private var _currentItem:Item;
      
      private var _lastOffset:int = 0;
      
      private var _xBase:int;
      
      private var _yBase:int;
      
      private const _id:int = _loc4_ = (_loc3_ = ItemFactory).DPLAN_ID + 1;
      
      public function DPlan_Column(param1:Board, param2:Item)
      {
         _loc3_.DPLAN_ID = _loc4_;
         super();
         this._board = param1;
         this._currentItem = param2;
      }
      
      public function setup(param1:int) : void
      {
         this._xBase = this._currentItem.x;
         this._yBase = this._currentItem.y;
      }
      
      public function tick(param1:int) : void
      {
         var _loc2_:*;
         var _loc3_:* = (_loc2_ = this)._ticks + 1;
         _loc2_._ticks = _loc3_;
         this._done = this._ticks > 30;
      }
      
      public function getDestructionItem() : Item
      {
         return null;
      }
      
      public function getItemsToRemove() : Vector.<Item>
      {
         var _loc2_:int = 0;
         var _loc4_:Item = null;
         if(this._ticks < DelayTicks)
         {
            return null;
         }
         var _loc1_:Vector.<Item> = new Vector.<Item>();
         _loc2_ = this._ticks - DelayTicks;
         var _loc3_:Number = _loc2_ * 0.5;
         var _loc5_:int = this._lastOffset + 1;
         while(_loc5_ <= _loc3_)
         {
            if(_loc4_ = this._board.getUnifiedGridItem(this._xBase,this._yBase + _loc5_))
            {
               _loc1_.push(_loc4_);
            }
            if(_loc4_ = this._board.getUnifiedGridItem(this._xBase,this._yBase - _loc5_))
            {
               _loc1_.push(_loc4_);
            }
            this._lastOffset = _loc5_;
            _loc5_++;
         }
         this.Z(this._yBase + _loc3_,_loc1_);
         this.Z(Math.max(0,this._yBase - _loc3_),_loc1_);
         return _loc1_;
      }
      
      public function isDone() : Boolean
      {
         return this._done;
      }
      
      public function isImmediate() : Boolean
      {
         return false;
      }
      
      public function scorepopPerItem() : Boolean
      {
         return true;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      private function Z(param1:Number, param2:Vector.<Item>) : void
      {
         var _loc3_:FallingColumn = null;
         var _loc6_:Item = null;
         _loc3_ = this._board.getFallingColumn(this._xBase);
         var _loc4_:Vector.<Item> = _loc3_.getCloseItems(param1 + 0.5,1.5);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(!(_loc6_ = _loc4_[_loc5_]).isKillerOrParentKiller(this._currentItem))
            {
               if(param1 == 0)
               {
                  _loc6_._destroyTicks = 0;
               }
               _loc6_.killByItem(this._currentItem);
               param2.push(_loc6_);
            }
            _loc5_++;
         }
         if(param1 >= 0)
         {
            if((Boolean(_loc6_ = this._board.getUnifiedGridItem(this._xBase,param1))) && !_loc6_.isKillerOrParentKiller(this._currentItem))
            {
               _loc6_.killByItem(this._currentItem);
               param2.push(_loc6_);
            }
         }
      }
   }
}
