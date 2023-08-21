package com.midasplayer.games.candycrush.board.plans
{
   import com.midasplayer.games.candycrush.board.Board;
   import com.midasplayer.games.candycrush.board.IDestructionPlan;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.board.ItemFactory;
   
   public class DPlan_Line implements IDestructionPlan
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
      
      public function DPlan_Line(param1:Board, param2:Item)
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
      
      public function scorepopPerItem() : Boolean
      {
         return true;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function getItemsToRemove() : Vector.<Item>
      {
         var _loc1_:int = 0;
         var _loc4_:Item = null;
         if(this._ticks < DelayTicks)
         {
            return null;
         }
         _loc1_ = this._ticks - DelayTicks;
         var _loc2_:Number = _loc1_ * 0.7;
         var _loc3_:Vector.<Item> = new Vector.<Item>();
         var _loc5_:int = this._lastOffset + 1;
         while(_loc5_ <= _loc2_)
         {
            if(_loc4_ = this._board.getUnifiedGridItem(this._xBase + _loc5_,this._yBase))
            {
               _loc3_.push(_loc4_);
            }
            if(_loc4_ = this._board.getUnifiedGridItem(this._xBase - _loc5_,this._yBase))
            {
               _loc3_.push(_loc4_);
            }
            this._lastOffset = _loc5_;
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function isDone() : Boolean
      {
         return this._done;
      }
      
      public function isImmediate() : Boolean
      {
         return false;
      }
   }
}
