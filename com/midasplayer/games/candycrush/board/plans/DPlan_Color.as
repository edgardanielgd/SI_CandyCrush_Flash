package com.midasplayer.games.candycrush.board.plans
{
   import com.midasplayer.games.candycrush.board.Board;
   import com.midasplayer.games.candycrush.board.IDestructionPlan;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.board.ItemFactory;
   
   public class DPlan_Color implements IDestructionPlan
   {
       
      
      private var _currentItem:Item;
      
      private var _board:Board;
      
      private var _x:int = 0;
      
      private var _y:int = 0;
      
      private var _forceExplodeTicks:int;
      
      private const _id:int = _loc4_ = (_loc3_ = ItemFactory).DPLAN_ID + 1;
      
      public function DPlan_Color(param1:Board, param2:Item)
      {
         _loc3_.DPLAN_ID = _loc4_;
         super();
         this._currentItem = param2;
         this._board = param1;
      }
      
      public function tick(param1:int) : void
      {
      }
      
      public function getDestructionItem() : Item
      {
         return null;
      }
      
      public function getItemsToRemove() : Vector.<Item>
      {
         var _loc5_:int = 0;
         var _loc6_:Item = null;
         var _loc1_:Vector.<Item> = new Vector.<Item>();
         var _loc2_:int = !!this._currentItem.destructionColor ? this._currentItem.destructionColor : this._board.getMostCommonColor(this._board.usedColorBombColors);
         this._board.usedColorBombColors.push(_loc2_);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this._board.height())
         {
            _loc5_ = 0;
            while(_loc5_ < this._board.width())
            {
               if((_loc6_ = this._board.getUnifiedGridItem(_loc5_,_loc4_)) != null && _loc6_.color == _loc2_ && _loc6_.isDestroyed() == false)
               {
                  _loc6_._destroyTicks = 12;
                  if(_loc6_.special > 0)
                  {
                     _loc6_.setRemovalTicks(_loc3_);
                  }
                  else
                  {
                     _loc6_.setRemovalTicks(0);
                  }
                  _loc3_ += 0;
                  _loc6_._canChangeRemovalTicks = false;
                  _loc1_.push(_loc6_);
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
         return true;
      }
      
      public function getId() : int
      {
         return this._id;
      }
   }
}
