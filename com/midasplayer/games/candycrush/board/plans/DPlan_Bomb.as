package com.midasplayer.games.candycrush.board.plans
{
   import com.midasplayer.games.candycrush.board.Board;
   import com.midasplayer.games.candycrush.board.IDestructionPlan;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.board.ItemFactory;
   
   public class DPlan_Bomb implements IDestructionPlan
   {
       
      
      private var _currentItem:Item;
      
      private var _destructionItem:Item;
      
      private var _board:Board;
      
      private var _x:int = 0;
      
      private var _y:int = 0;
      
      private const _id:int = _loc5_ = (_loc4_ = ItemFactory).DPLAN_ID + 1;
      
      public function DPlan_Bomb(param1:Board, param2:Item, param3:Item)
      {
         _loc4_.DPLAN_ID = _loc5_;
         super();
         this._currentItem = param2;
         this._destructionItem = param3;
         this._board = param1;
      }
      
      public function tick(param1:int) : void
      {
      }
      
      public function getDestructionItem() : Item
      {
         return this._destructionItem;
      }
      
      public function getItemsToRemove() : Vector.<Item>
      {
         var _loc5_:int = 0;
         var _loc6_:Item = null;
         var _loc1_:Vector.<Item> = new Vector.<Item>();
         this._x = this._currentItem.column;
         this._y = this._currentItem.row;
         var _loc2_:int = this._board.getColumn(this._x + 1);
         var _loc3_:int = this._board.getRow(this._y + 1);
         var _loc4_:int = this._board.getRow(this._y - 1);
         while(_loc4_ <= _loc3_)
         {
            _loc5_ = this._board.getColumn(this._x - 1);
            while(_loc5_ <= _loc2_)
            {
               if(_loc5_ != this._x || _loc4_ != this._y)
               {
                  if((_loc6_ = this._board.getUnifiedGridItem(_loc5_,_loc4_)) != null)
                  {
                     _loc1_.push(_loc6_);
                  }
               }
               _loc5_++;
            }
            _loc4_++;
         }
         return _loc1_;
      }
      
      public function setup(param1:int) : void
      {
      }
      
      public function isDone() : Boolean
      {
         return true;
      }
      
      public function isImmediate() : Boolean
      {
         return true;
      }
      
      public function scorepopPerItem() : Boolean
      {
         return false;
      }
      
      public function getId() : int
      {
         return this._id;
      }
   }
}
