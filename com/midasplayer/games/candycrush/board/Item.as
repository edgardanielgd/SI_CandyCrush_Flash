package com.midasplayer.games.candycrush.board
{
   import com.midasplayer.games.candycrush.input.SwapInfo;
   import com.midasplayer.games.candycrush.render.itemview.ItemView;
   
   public class Item
   {
      
      public static const Gravity:Number = 0.0185;
      
      public static const MaxVelocity:Number = 0.4;
       
      
      private var _shieldTicks:int = -1;
      
      protected var _isTemp:Boolean = false;
      
      private var _removalTicks:int = -1;
      
      private var _toBeRemoved:Boolean = false;
      
      public var _canChangeRemovalTicks:Boolean = true;
      
      private var _hasGivenScore:Boolean = false;
      
      private var _busy:Boolean = false;
      
      private var _destructionPlan:com.midasplayer.games.candycrush.board.IDestructionPlan = null;
      
      public var destructionColor:int = 0;
      
      public var _destroyTicks:int = 4;
      
      private var _destroyed:Boolean = false;
      
      public var bounce:Number = 0;
      
      private var _moveTicks:int = 0;
      
      public var _lastTick:int = 0;
      
      protected var _board:com.midasplayer.games.candycrush.board.Board;
      
      private var _listener:com.midasplayer.games.candycrush.board.IItemListener;
      
      public var _swap:SwapInfo;
      
      private var _killer:com.midasplayer.games.candycrush.board.Item = null;
      
      public var x:Number;
      
      public var y:Number;
      
      public var lastX:Number;
      
      public var lastY:Number;
      
      public var ya:Number = 0;
      
      public var id:int;
      
      public var color:int;
      
      public var _special:int = 0;
      
      public var view:ItemView = null;
      
      public var parentDecl:ItemDecl = null;
      
      public function Item(param1:Number, param2:Number, param3:int)
      {
         super();
         this.x = param1;
         this.y = param2 + 0.5;
         this.lastX = param1;
         this.lastY = this.y;
         this.color = param3;
      }
      
      public function init(param1:com.midasplayer.games.candycrush.board.IItemListener) : void
      {
         this._listener = param1;
      }
      
      public function setBoard(param1:com.midasplayer.games.candycrush.board.Board) : void
      {
         this._board = param1;
      }
      
      public function setShieldTicks(param1:int) : void
      {
         this._shieldTicks = param1;
      }
      
      public function hasShield() : Boolean
      {
         return this._shieldTicks > 0;
      }
      
      public function isTemp() : Boolean
      {
         return this._isTemp;
      }
      
      public function setRemovalTicks(param1:int) : void
      {
         if(!this._canChangeRemovalTicks)
         {
            return;
         }
         this._removalTicks = param1;
         this._toBeRemoved = true;
      }
      
      public function hasItemGivenScore() : Boolean
      {
         return this._hasGivenScore;
      }
      
      public function markScoreGiven() : void
      {
         this._hasGivenScore = true;
      }
      
      public function isBusy() : Boolean
      {
         return this._busy || this._removalTicks > 0;
      }
      
      public function canBeMatched() : Boolean
      {
         return this.isBusy() == false && !this._toBeRemoved && !this._destroyed;
      }
      
      public function isLocked() : Boolean
      {
         return !this.canBeMatched();
      }
      
      public function isToBeRemoved() : Boolean
      {
         return this._toBeRemoved;
      }
      
      public function hasDestructionItem() : Boolean
      {
         return Boolean(this._destructionPlan) && this._destructionPlan.getDestructionItem() != null;
      }
      
      public function setDestructionPlan(param1:com.midasplayer.games.candycrush.board.IDestructionPlan) : void
      {
         this._destructionPlan = param1;
      }
      
      public function getDestructionPlan() : com.midasplayer.games.candycrush.board.IDestructionPlan
      {
         return this._destructionPlan;
      }
      
      public function wannaDie() : Boolean
      {
         return this._removalTicks == 0;
      }
      
      public function destroy() : Boolean
      {
         if(this.hasShield())
         {
            return false;
         }
         this._destroyed = true;
         return true;
      }
      
      public function isDestroyed() : Boolean
      {
         return this._destroyed;
      }
      
      public function canRemove() : Boolean
      {
         return this._destroyTicks == 0;
      }
      
      public function savePos() : void
      {
         this.lastY = this.y;
      }
      
      public function snap() : void
      {
      }
      
      public function doBounce(param1:Number, param2:Boolean) : void
      {
         if(this._listener)
         {
            this._listener.bounced(param2);
         }
         this.ya = this.ya * (-this.bounce * param1);
      }
      
      public function doMove() : void
      {
         this.lastY = this.y;
         this.y = this.y + this.ya;
         this.ya = this.ya + Gravity;
         if(this.ya > MaxVelocity)
         {
            this.ya = MaxVelocity;
         }
      }
      
      public function beginMovement(param1:Number, param2:Number, param3:int) : void
      {
         if(param3 == -1)
         {
            param1 = this._swap.x0;
            param2 = this._swap.y0;
            param3 = 10;
         }
         this._moveTicks = param3;
         this._busy = true;
         this._swap = new SwapInfo(this.column,this.row,param1,param2);
         if(this._listener)
         {
            this._listener.beginMove(this,this._lastTick + 1,param1,param2,param3);
         }
      }
      
      public function tick(param1:int) : void
      {
         this._lastTick = param1;
         if(this._moveTicks > 0)
         {
            _loc2_._moveTicks = _loc3_;
            var _loc3_:*;
            var _loc2_:*;
            if((_loc3_ = (_loc2_ = this)._moveTicks - 1) == 0)
            {
               this._busy = false;
            }
         }
         if(this._removalTicks > 0)
         {
            _loc3_ = (_loc2_ = this)._removalTicks - 1;
            _loc2_._removalTicks = _loc3_;
         }
         if(this._destroyed && this._destroyTicks > 0)
         {
            _loc3_ = (_loc2_ = this)._destroyTicks - 1;
            _loc2_._destroyTicks = _loc3_;
         }
         _loc3_ = (_loc2_ = this)._shieldTicks - 1;
         _loc2_._shieldTicks = _loc3_;
      }
      
      public function isKillerOrParentKiller(param1:com.midasplayer.games.candycrush.board.Item) : Boolean
      {
         return this._killer == param1;
      }
      
      public function killByItem(param1:com.midasplayer.games.candycrush.board.Item) : void
      {
         var _loc3_:com.midasplayer.games.candycrush.board.IDestructionPlan = null;
         var _loc2_:com.midasplayer.games.candycrush.board.Item = this;
         while(_loc2_ != null)
         {
            _loc2_._killer = param1;
            _loc3_ = _loc2_.getDestructionPlan();
            _loc2_ = !!_loc3_ ? _loc3_.getDestructionItem() : null;
         }
      }
      
      public function get row() : int
      {
         return int(this.y);
      }
      
      public function get column() : int
      {
         return int(this.x);
      }
      
      public function set special(param1:int) : void
      {
         this._special = param1;
      }
      
      public function get special() : int
      {
         return this._special;
      }
      
      public function setParentDecl(param1:com.midasplayer.games.candycrush.board.Item) : void
      {
         this.parentDecl = ItemDecl.fromItem(param1);
      }
   }
}

import com.midasplayer.games.candycrush.board.Item;

class ItemDecl
{
    
   
   public var color:int;
   
   public var special:int;
   
   public function ItemDecl(param1:int, param2:int)
   {
      super();
      this.color = param1;
      this.special = param2;
   }
   
   public static function fromItem(param1:Item) : ItemDecl
   {
      return new ItemDecl(param1.color,param1.special);
   }
}
