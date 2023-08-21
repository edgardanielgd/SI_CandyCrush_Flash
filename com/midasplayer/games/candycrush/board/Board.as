package com.midasplayer.games.candycrush.board
{
   import com.midasplayer.debug.Debug;
   import com.midasplayer.games.candycrush.GameView;
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.ScoreHolder;
   import com.midasplayer.games.candycrush.Ticks;
   import com.midasplayer.games.candycrush.board.items.*;
   import com.midasplayer.games.candycrush.board.match.*;
   import com.midasplayer.games.candycrush.board.plans.DPlan_Bomb;
   import com.midasplayer.games.candycrush.board.plans.DPlan_Simple;
   import com.midasplayer.games.candycrush.input.SwapInfo;
   import com.midasplayer.math.IntCoord;
   
   public class Board
   {
      
      public static const AllMatchPatternTypes:Array = [5,2,4,3];
      
      public static const MATCH_ID_5:int = 5;
      
      public static const MATCH_ID_4:int = 4;
      
      public static const MATCH_ID_3:int = 3;
      
      private static const MatchPattern3:Array = [new MatchPattern(MATCH_ID_3,3,1,true)];
      
      public static const MATCH_ID_TorL:int = 2;
      
      private static const MatchPatterns:Array = [new MatchPattern(MATCH_ID_5,5,1,true),new MatchPattern(MATCH_ID_TorL,3,3,false),new MatchPattern(MATCH_ID_4,4,1,true),new MatchPattern(MATCH_ID_3,3,1,true)];
      
      public static const SWITCHSTATE_BEGIN:int = 0;
      
      public static const SWITCHSTATE_SUCCESS:int = 1;
      
      public static const SWITCHSTATE_FAIL:int = 2;
       
      
      private var _n_:int = 0;
      
      private var _spareIntGrid:Vector.<Vector.<int>>;
      
      private var _toRemoveIds:Object;
      
      public var usedColorBombColors:Array;
      
      private var _bad_hidden_state_bounce_in_grid:Boolean;
      
      private var _height:int;
      
      private var _width:int;
      
      public var _m:Vector.<Vector.<com.midasplayer.games.candycrush.board.Item>>;
      
      public var _mInt:Vector.<Vector.<int>>;
      
      private var _mIntIsDirty:Boolean = true;
      
      public var _unifiedGrid:Vector.<Vector.<com.midasplayer.games.candycrush.board.Item>>;
      
      private var _columns:Vector.<com.midasplayer.games.candycrush.board.FallingColumn>;
      
      private var _isStable:Boolean = false;
      
      private var _isReasonableStable:Boolean = false;
      
      private var _unstableActionThisTick:Boolean = false;
      
      public var _allItems:Vector.<com.midasplayer.games.candycrush.board.Item>;
      
      private var _byIndex:Object;
      
      private var _listener:com.midasplayer.games.candycrush.board.IBoardListener;
      
      private var _itemFactory:com.midasplayer.games.candycrush.board.ItemFactory;
      
      private var _swaps:Vector.<SwapInfo>;
      
      private var _numSwaps:int = 0;
      
      private var _lastSwap:SwapInfo = null;
      
      private var _toRemoveCoords:Vector.<IntCoord>;
      
      private var _destructionPlans:Vector.<com.midasplayer.games.candycrush.board.IDestructionPlan>;
      
      private var _checked:Object;
      
      private var _scoreHolder:ScoreHolder;
      
      public function Board(param1:int, param2:int, param3:com.midasplayer.games.candycrush.board.ItemFactory)
      {
         this._spareIntGrid = new Vector.<Vector.<int>>();
         this._toRemoveIds = {};
         this.usedColorBombColors = [];
         this._m = new Vector.<Vector.<com.midasplayer.games.candycrush.board.Item>>();
         this._mInt = new Vector.<Vector.<int>>();
         this._unifiedGrid = new Vector.<Vector.<com.midasplayer.games.candycrush.board.Item>>();
         this._columns = new Vector.<com.midasplayer.games.candycrush.board.FallingColumn>();
         this._allItems = new Vector.<com.midasplayer.games.candycrush.board.Item>();
         this._byIndex = {};
         this._listener = new EmptyBoardListener();
         this._swaps = new Vector.<SwapInfo>();
         this._toRemoveCoords = new Vector.<IntCoord>();
         this._destructionPlans = new Vector.<com.midasplayer.games.candycrush.board.IDestructionPlan>();
         this._scoreHolder = new ScoreHolder();
         super();
         this._width = param1;
         this._height = param2;
         this._itemFactory = param3;
         this._itemFactory.init(this);
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            this._m.push(new Vector.<com.midasplayer.games.candycrush.board.Item>(param1,true));
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            this._spareIntGrid.push(new Vector.<int>(param1,true));
            this._mInt.push(new Vector.<int>(param1,true));
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            this._unifiedGrid.push(new Vector.<com.midasplayer.games.candycrush.board.Item>(param1,true));
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < param1)
         {
            this._columns.push(new com.midasplayer.games.candycrush.board.FallingColumn());
            _loc5_++;
         }
         this.populate();
         this.removeMatching();
         this.ready();
      }
      
      private function ready() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this._height)
         {
            _loc2_ = 0;
            while(_loc2_ < this._width)
            {
               if(this.getGridItem(_loc2_,_loc1_))
               {
                  this._initializeAndAddItem(this.getGridItem(_loc2_,_loc1_));
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function removeMatching() : void
      {
         var _loc2_:Vector.<Match> = null;
         var _loc3_:Match = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:int = 0;
         do
         {
            _loc2_ = this.getAllMatches();
            for each(_loc3_ in _loc2_)
            {
               _loc4_ = _loc3_.north;
               while(_loc4_ <= _loc3_.south)
               {
                  this._set(_loc3_.x,_loc4_,this._itemFactory.create(_loc3_.x,_loc4_,null));
                  _loc4_++;
               }
               _loc5_ = _loc3_.west;
               while(_loc5_ <= _loc3_.east)
               {
                  this._set(_loc5_,_loc3_.y,this._itemFactory.create(_loc5_,_loc3_.y,null));
                  _loc5_++;
               }
               _loc1_ += _loc3_.size;
            }
         }
         while(_loc2_.length > 0);
         
      }
      
      public function getColumn(param1:int) : int
      {
         return param1 < 0 ? 0 : (param1 >= this._width ? this._width - 1 : param1);
      }
      
      public function getRow(param1:int) : int
      {
         return param1 < 0 ? 0 : (param1 >= this._height ? this._height - 1 : param1);
      }
      
      private function inRange(param1:int, param2:int) : Boolean
      {
         return param1 >= 0 && param1 < this._width && param2 >= 0 && param2 < this._height;
      }
      
      public function getGridItem(param1:int, param2:int) : com.midasplayer.games.candycrush.board.Item
      {
         if(!this.inRange(param1,param2))
         {
            return null;
         }
         return this._m[param2][param1];
      }
      
      public function getUnifiedGridItem(param1:int, param2:int) : com.midasplayer.games.candycrush.board.Item
      {
         if(!this.inRange(param1,param2))
         {
            return null;
         }
         return this._unifiedGrid[param2][param1];
      }
      
      public function tick(param1:int) : void
      {
         this.saveOldItemPositions();
         this.updateFallingItems(param1);
         this.updateBoardItems(param1);
         this.updateIntBoard();
         this.updateRebuildMatrix();
         this.updateSwapCheck(param1);
         this.updateMatchCheck(param1);
         this.updateWannaDies(param1);
         this.updateDestructionPlans(param1);
         this.updateRemovePendingItems(param1);
         this.updateRemoveDeadItems(param1);
         this.updateMoveItemsFromGridToFallingColumns();
         this.updateAddItemsOnTop();
         this.updateStability();
         this.reset();
         var _loc2_:*;
         var _loc3_:* = (_loc2_ = this)._n_ + 1;
         _loc2_._n_ = _loc3_;
         if((_loc2_ = this)._n_ % (2 * Ticks.TicksPerSecond) == 0)
         {
            this.secondDebugTrace();
         }
      }
      
      private function updateSuperspecials(param1:int) : void
      {
         var _loc3_:OrthoPatternMatcher = null;
         var _loc5_:Match = null;
         var _loc8_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc9_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc10_:int = 0;
         var _loc11_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._height)
         {
            _loc10_ = 0;
            while(_loc10_ < this._width)
            {
               this._spareIntGrid[_loc2_][_loc10_] = 0;
               if(this._mInt[_loc2_][_loc10_] != 0)
               {
                  if(!(!(_loc11_ = this._m[_loc2_][_loc10_]) || !ItemType.isNormalStripes(_loc11_)))
                  {
                     this._spareIntGrid[_loc2_][_loc10_] = 1;
                  }
               }
               _loc10_++;
            }
            _loc2_++;
         }
         _loc3_ = new OrthoPatternMatcher(this._spareIntGrid,[this.getMatchPattern(MATCH_ID_3)],3);
         var _loc4_:Vector.<Match>;
         if((_loc4_ = _loc3_.matchAll()).length == 0)
         {
            return;
         }
         _loc5_ = _loc4_[0];
         var _loc6_:int = 0.5 * (_loc5_.west + _loc5_.east);
         var _loc7_:int = 0.5 * (_loc5_.north + _loc5_.south);
         if(_loc5_.height >= 3)
         {
            _loc12_ = _loc5_.north;
            while(_loc12_ <= _loc5_.south)
            {
               this.getGridItem(_loc5_.x,_loc12_).setDestructionPlan(null);
               this.getGridItem(_loc5_.x,_loc12_).setRemovalTicks(10);
               _loc12_++;
            }
            _loc12_ = 0;
            while(_loc12_ < this._height)
            {
               if(_loc12_ < _loc5_.north || _loc12_ > _loc5_.south)
               {
                  if(_loc8_ = this.getGridItem(_loc6_,_loc12_))
                  {
                     _loc8_._destroyTicks = 0;
                     _loc13_ = Math.abs(_loc6_ - _loc12_);
                     _loc9_ = new Temp_Line(_loc6_,_loc12_,_loc8_.color,8 + 2.5 * _loc13_);
                     this.setPowerupAt(_loc6_,_loc12_,0,_loc8_.color,_loc9_,true);
                  }
               }
               _loc12_++;
            }
         }
         else
         {
            _loc14_ = _loc5_.west;
            while(_loc14_ <= _loc5_.east)
            {
               this.getGridItem(_loc14_,_loc5_.y).setDestructionPlan(null);
               this.getGridItem(_loc14_,_loc5_.y).setRemovalTicks(15);
               _loc14_++;
            }
            _loc14_ = 0;
            while(_loc14_ < this._width)
            {
               if(_loc14_ < _loc5_.west || _loc14_ > _loc5_.east)
               {
                  if(_loc8_ = this.getGridItem(_loc14_,_loc7_))
                  {
                     _loc8_._destroyTicks = 0;
                     _loc15_ = Math.abs(_loc6_ - _loc14_);
                     _loc9_ = new Temp_Column(_loc14_,_loc7_,_loc8_.color,8 + 2.5 * _loc15_);
                     this.setPowerupAt(_loc14_,_loc7_,0,_loc8_.color,_loc9_,true);
                  }
               }
               _loc14_++;
            }
         }
      }
      
      private function updateRemoveDeadItems(param1:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc7_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._height)
         {
            _loc5_ = 0;
            while(_loc5_ < this._width)
            {
               if((Boolean(_loc6_ = this.getGridItem(_loc5_,_loc2_))) && _loc6_.canRemove())
               {
                  this.removeItem(_loc6_);
               }
               _loc5_++;
            }
            _loc2_++;
         }
         var _loc3_:Vector.<com.midasplayer.games.candycrush.board.Item> = new Vector.<com.midasplayer.games.candycrush.board.Item>();
         var _loc4_:int = 0;
         while(_loc4_ < this._width)
         {
            for each(_loc7_ in this.getFallingColumn(_loc4_).getItems())
            {
               if(_loc7_.canRemove())
               {
                  _loc3_.push(_loc7_);
               }
            }
            _loc4_++;
         }
         for each(_loc7_ in _loc3_)
         {
            this.removeItem(_loc7_);
         }
      }
      
      private function secondDebugTrace() : void
      {
      }
      
      private function updateStability() : void
      {
         var _loc1_:Boolean = this._isStable;
         this._isReasonableStable = this.calculateReasonableStability();
         this._isStable = this._isReasonableStable ? this.calculateStability() : false;
         if(this._isStable && _loc1_ == false)
         {
            this._listener.boardStabilized(this._scoreHolder.getSequenceLength(),this._scoreHolder.getFeedbackSequenceLength());
            this._scoreHolder.resetSequences();
         }
         this._unstableActionThisTick = false;
      }
      
      private function updateAddItemsOnTop() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this._width)
         {
            _loc2_ = this._height;
            _loc3_ = 0;
            while(_loc3_ < this._height)
            {
               if(this.getGridItem(_loc1_,_loc3_))
               {
                  _loc2_--;
               }
               _loc3_++;
            }
            _loc2_ -= this._columns[_loc1_].getSize();
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               this.createNewItemOnTop(_loc1_);
               _loc4_++;
            }
            _loc1_++;
         }
      }
      
      private function updateDestructionPlans(param1:int) : void
      {
         var _loc3_:com.midasplayer.games.candycrush.board.IDestructionPlan = null;
         var _loc4_:Vector.<com.midasplayer.games.candycrush.board.Item> = null;
         var _loc5_:com.midasplayer.games.candycrush.board.Item = null;
         if(this._destructionPlans.length == 0)
         {
            return;
         }
         var _loc2_:Vector.<com.midasplayer.games.candycrush.board.IDestructionPlan> = new Vector.<com.midasplayer.games.candycrush.board.IDestructionPlan>();
         for each(_loc3_ in this._destructionPlans)
         {
            _loc3_.tick(param1);
            if((_loc4_ = this.filterScoringItems(_loc3_.getItemsToRemove())) != null)
            {
               for each(_loc5_ in _loc4_)
               {
                  this._toRemoveCoords.push(new IntCoord(_loc5_.column,_loc5_.row));
                  this._scoreHolder.removedByPowerup(1);
                  if(_loc3_.scorepopPerItem())
                  {
                     this._listener.addScore(_loc5_.x,_loc5_.y,_loc5_.color,this._scoreHolder.getLastAddedScore(),_loc5_,_loc3_);
                  }
               }
            }
            if(!_loc3_.isDone())
            {
               _loc2_.push(_loc3_);
            }
         }
         this._destructionPlans = _loc2_;
      }
      
      private function reset() : void
      {
         this._toRemoveIds = {};
         this.usedColorBombColors = [];
      }
      
      private function updateWannaDies(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._height)
         {
            _loc3_ = 0;
            while(_loc3_ < this._width)
            {
               if(Boolean(this.getUnifiedGridItem(_loc3_,_loc2_)) && this.getUnifiedGridItem(_loc3_,_loc2_).wannaDie())
               {
                  this._reallyAddForRemoval(_loc3_,_loc2_);
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      private function updateRemovePendingItems(param1:int) : void
      {
         var _loc3_:IntCoord = null;
         var _loc4_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc5_:Boolean = false;
         if(this._toRemoveCoords.length == 0)
         {
            return;
         }
         this._recursionFind(param1);
         var _loc2_:int = 0;
         while(_loc2_ < this._toRemoveCoords.length)
         {
            _loc3_ = this._toRemoveCoords[_loc2_];
            if(!((_loc4_ = this.getUnifiedGridItem(_loc3_.x,_loc3_.y)).isBusy() || _loc4_.isDestroyed()))
            {
               if(_loc5_ = _loc4_.destroy())
               {
                  this._unstableActionThisTick = true;
                  this._listener.removeItem(_loc4_,_loc4_.column,_loc4_.row);
               }
            }
            _loc2_++;
         }
         this._toRemoveCoords.length = 0;
      }
      
      private function _recursionFind(param1:int) : void
      {
         var toAdd:int;
         var thisBoard:Board;
         var out:Array = null;
         var c:IntCoord = null;
         var i:int = 0;
         var tickId:int = param1;
         var rec:Function = function(param1:int, param2:int):void
         {
            var _loc9_:int = 0;
            var _loc10_:int = 0;
            var _loc11_:int = 0;
            var _loc12_:com.midasplayer.games.candycrush.board.Item = null;
            if(!inRange(param1,param2))
            {
               return;
            }
            var _loc3_:com.midasplayer.games.candycrush.board.Item = _unifiedGrid[param2][param1];
            if(!_loc3_)
            {
               return;
            }
            if(_loc3_.isToBeRemoved() && !_loc3_.wannaDie())
            {
               return;
            }
            var _loc4_:int = 0;
            var _loc5_:int = IntCoord.uniqueVal(param1,param2);
            if(_checked[_loc5_])
            {
               return;
            }
            _checked[_loc5_] = true;
            out.push(new IntCoord(param1,param2));
            var _loc6_:Vector.<IntCoord> = new Vector.<IntCoord>();
            var _loc7_:com.midasplayer.games.candycrush.board.IDestructionPlan = _loc3_.getDestructionPlan();
            var _loc8_:Vector.<com.midasplayer.games.candycrush.board.Item> = null;
            if(_loc7_)
            {
               _loc7_.setup(tickId);
               if(_loc7_.isImmediate())
               {
                  _loc9_ = int((_loc8_ = filterScoringItems(_loc7_.getItemsToRemove())).length);
                  if(_loc7_ is DPlan_Bomb)
                  {
                     __bombWaveAt(param1,param2);
                     _loc9_ = 9;
                  }
                  if(_loc9_ == 0)
                  {
                     return;
                  }
                  _scoreHolder.removedByPowerup(_loc9_);
                  _loc11_ = (_loc10_ = _scoreHolder.getLastAddedScore()) / _loc9_;
                  if(!_loc7_.scorepopPerItem())
                  {
                     _listener.addScore(_loc3_.x,_loc3_.y,_loc3_.color,_loc10_);
                  }
                  for each(_loc12_ in _loc8_)
                  {
                     if(_loc7_.scorepopPerItem())
                     {
                        _listener.addScore(_loc12_.x,_loc12_.y,_loc12_.color,_loc11_);
                     }
                     rec(_loc12_.column,_loc12_.row);
                  }
               }
               else
               {
                  _destructionPlans.push(_loc7_);
               }
               if(_loc3_.special != 0)
               {
                  _scoreHolder.powerupExploded(_loc3_.special,_loc3_.isTemp());
                  _listener.powerupExploded(_loc3_.special,param1,param2,_loc3_,null,_loc8_);
               }
            }
         };
         this._checked = {};
         out = [];
         toAdd = 0;
         thisBoard = this;
         for each(c in this._toRemoveCoords)
         {
            rec(c.x,c.y);
         }
         this._toRemoveCoords.length = 0;
         i = 0;
         while(i < out.length)
         {
            this._toRemoveCoords.push(out[i]);
            i++;
         }
      }
      
      private function filterScoringItems(param1:Vector.<com.midasplayer.games.candycrush.board.Item>) : Vector.<com.midasplayer.games.candycrush.board.Item>
      {
         var _loc4_:com.midasplayer.games.candycrush.board.Item = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Object = {};
         var _loc3_:Vector.<com.midasplayer.games.candycrush.board.Item> = new Vector.<com.midasplayer.games.candycrush.board.Item>();
         for each(_loc4_ in param1)
         {
            if(!(_loc4_.color == 0 && _loc4_.special == 0))
            {
               if(!(_loc4_.hasItemGivenScore() || Boolean(_loc2_[_loc4_.id])))
               {
                  _loc2_[_loc4_.id] = 1;
                  _loc4_.markScoreGiven();
                  _loc3_.push(_loc4_);
               }
            }
         }
         return _loc3_;
      }
      
      private function updateMoveItemsFromGridToFallingColumns() : void
      {
         var _loc3_:int = 0;
         var _loc4_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc1_:int = this._height - 2;
         var _loc2_:int = _loc1_;
         while(_loc2_ >= 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this._width)
            {
               if((_loc4_ = this.getGridItem(_loc3_,_loc2_)) != null && this.getGridItem(_loc3_,_loc2_ + 1) == null)
               {
                  if(!_loc4_.isBusy())
                  {
                     this._m[_loc2_][_loc3_] = null;
                     this._columns[_loc3_].insertItem(_loc4_);
                  }
               }
               _loc3_++;
            }
            _loc2_--;
         }
      }
      
      public function saveOldItemPositions() : void
      {
         var _loc1_:com.midasplayer.games.candycrush.board.Item = null;
         for each(_loc1_ in this._allItems)
         {
            _loc1_.savePos();
         }
      }
      
      private function updateSwapCheck(param1:int) : Boolean
      {
         var _loc3_:SwapInfo = null;
         var _loc4_:* = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this._swaps.length == 0)
         {
            return false;
         }
         var _loc2_:Vector.<SwapInfo> = new Vector.<SwapInfo>();
         for each(_loc3_ in this._swaps)
         {
            if(_loc3_.isBusy())
            {
               _loc2_.push(_loc3_);
            }
            else
            {
               _loc4_ = _loc3_.isFailed == false;
               _loc5_ = this.isSwapReaction(_loc3_);
               _loc6_ = false;
               if(_loc4_)
               {
                  _loc7_ = _loc3_.item_a.special;
                  _loc8_ = _loc3_.item_b.special;
                  if(_loc6_ = this._itemFactory.categorizeAndHandleSwap(_loc3_,this._listener))
                  {
                     this._scoreHolder.powerupsMixed(_loc7_,_loc8_);
                  }
                  if(_loc5_ || _loc6_)
                  {
                     this._listener.switchMade(_loc3_,SWITCHSTATE_SUCCESS);
                  }
                  else
                  {
                     this._listener.switchMade(_loc3_,SWITCHSTATE_FAIL);
                     this._doSwap(_loc3_.x0,_loc3_.y0,_loc3_.x1,_loc3_.y1,true,_loc2_);
                     Main.Log.trace("failed swap and returning");
                  }
               }
            }
         }
         this._swaps = _loc2_;
         return false;
      }
      
      private function isSwapReaction(param1:SwapInfo) : Boolean
      {
         var _loc2_:OrthoPatternMatcher = new OrthoPatternMatcher(this._mInt,MatchPattern3,3);
         return Boolean(_loc2_.matchXY(param1.x0,param1.y0)) || Boolean(_loc2_.matchXY(param1.x1,param1.y1));
      }
      
      private function updateIntBoard() : void
      {
         var _loc2_:int = 0;
         var _loc3_:com.midasplayer.games.candycrush.board.Item = null;
         if(!this._mIntIsDirty)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._height)
         {
            _loc2_ = 0;
            while(_loc2_ < this._width)
            {
               _loc3_ = this.getGridItem(_loc2_,_loc1_);
               this._mInt[_loc1_][_loc2_] = _loc3_ != null && _loc3_.canBeMatched() ? _loc3_.color : 0;
               _loc2_++;
            }
            _loc1_++;
         }
         this._mIntIsDirty = true;
      }
      
      private function updateRebuildMatrix() : void
      {
         var _loc2_:int = 0;
         var _loc3_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._height)
         {
            _loc2_ = 0;
            while(_loc2_ < this._width)
            {
               _loc3_ = this._m[_loc1_][_loc2_];
               if(Boolean(_loc3_) && _loc3_.isDestroyed())
               {
                  _loc3_ = null;
               }
               this._unifiedGrid[_loc1_][_loc2_] = _loc3_;
               _loc2_++;
            }
            _loc1_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._width)
         {
            for each(_loc3_ in this._columns[_loc2_].getItems())
            {
               if(!_loc3_.isDestroyed())
               {
                  _loc1_ = _loc3_.row;
                  if(_loc3_.y >= 0 && this.inRange(_loc2_,_loc1_))
                  {
                     if(this._unifiedGrid[_loc1_][_loc2_] != null)
                     {
                     }
                     this._unifiedGrid[_loc1_][_loc2_] = _loc3_;
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public function isPossibleMovesLeft() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc4_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc5_:com.midasplayer.games.candycrush.board.Item = null;
         if(NoMoreMoves.linear3(this._mInt))
         {
            return true;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._height)
         {
            _loc2_ = 0;
            while(_loc2_ < this._width)
            {
               _loc3_ = this.getGridItem(_loc2_,_loc1_);
               if(!(_loc3_ == null || _loc3_.special == 0))
               {
                  if(ItemType.isColor(_loc3_.special))
                  {
                     return true;
                  }
                  if((Boolean(_loc4_ = this.getGridItem(_loc2_ + 1,_loc1_))) && _loc4_.special > 0)
                  {
                     return true;
                  }
                  if((Boolean(_loc5_ = this.getGridItem(_loc2_,_loc1_ + 1))) && _loc5_.special > 0)
                  {
                     return true;
                  }
               }
               _loc2_++;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function getAllMatches() : Vector.<Match>
      {
         this.updateIntBoard();
         return new OrthoPatternMatcher(this._mInt,MatchPatterns,3).matchAll();
      }
      
      private function updateMatchCheck(param1:int) : Boolean
      {
         var _loc4_:Match = null;
         var _loc5_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc6_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc7_:* = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:IntCoord = null;
         var _loc2_:Vector.<Match> = this.getAllMatches();
         var _loc3_:Vector.<Match> = new Vector.<Match>();
         if(_loc2_.length > 0)
         {
            this._unstableActionThisTick = true;
         }
         for each(_loc4_ in _loc2_)
         {
            _loc5_ = this.getGridItem(_loc4_.x,_loc4_.y);
            if((_loc6_ = this._itemFactory.createSpecial2(_loc4_,this._lastSwap)) != null)
            {
               _loc4_.creationItem = _loc6_;
               this._listener.powerupCreated(_loc6_.special,_loc6_);
               _loc3_.push(_loc4_);
            }
            _loc7_ = 0;
            _loc8_ = _loc4_.north;
            while(_loc8_ <= _loc4_.south)
            {
               _loc7_ |= this.getGridItem(_loc4_.x,_loc8_).special;
               _loc8_++;
            }
            _loc9_ = _loc4_.west;
            while(_loc9_ <= _loc4_.east)
            {
               _loc7_ |= this.getGridItem(_loc9_,_loc4_.y).special;
               _loc9_++;
            }
            _loc8_ = _loc4_.north;
            while(_loc8_ <= _loc4_.south)
            {
               this.addForRemoval(_loc4_.x,_loc8_);
               _loc8_++;
            }
            _loc9_ = _loc4_.west;
            while(_loc9_ <= _loc4_.east)
            {
               this.addForRemoval(_loc9_,_loc4_.y);
               _loc9_++;
            }
            this._scoreHolder.matched(_loc4_);
            this._listener.hasMatched(_loc4_,this._scoreHolder.getSequenceLength(),this._scoreHolder.getFeedbackSequenceLength());
            this._listener.addScore(0.5 * (_loc4_.west + _loc4_.east),0.5 * (_loc4_.north + _loc4_.south + 1),_loc4_.color,this._scoreHolder.getLastAddedScore());
         }
         for each(_loc4_ in _loc3_)
         {
            _loc10_ = [];
            _loc8_ = _loc4_.north;
            while(_loc8_ <= _loc4_.south)
            {
               _loc10_.push(new IntCoord(_loc4_.x,_loc8_));
               _loc8_++;
            }
            _loc9_ = _loc4_.west;
            while(_loc9_ <= _loc4_.east)
            {
               if(_loc9_ != _loc4_.x)
               {
                  _loc10_.push(new IntCoord(_loc9_,_loc4_.y));
               }
               _loc9_++;
            }
            if(_loc11_ = this._itemFactory.getPowerupCoord(this,_loc10_,this._lastSwap))
            {
               this.getGridItem(_loc11_.x,_loc11_.y).setDestructionPlan(new DPlan_Simple(_loc4_.creationItem));
               this.getGridItem(_loc11_.x,_loc11_.y).setRemovalTicks(0);
               this.getGridItem(_loc11_.x,_loc11_.y).view.scaleOnRemoval = false;
               this.getGridItem(_loc11_.x,_loc11_.y)._destroyTicks = 0;
            }
         }
         return _loc2_.length > 0;
      }
      
      public function addForRemoval(param1:int, param2:int, param3:int = 0) : void
      {
         var _loc4_:com.midasplayer.games.candycrush.board.Item = this.getUnifiedGridItem(param1,param2);
         if(this._toRemoveIds[_loc4_.id])
         {
            return;
         }
         _loc4_.setRemovalTicks(param3);
      }
      
      private function _reallyAddForRemoval(param1:int, param2:int) : void
      {
         var _loc3_:com.midasplayer.games.candycrush.board.Item = this.getUnifiedGridItem(param1,param2);
         this._toRemoveIds[_loc3_.id] = 1;
         this._toRemoveCoords.push(new IntCoord(param1,param2));
      }
      
      private function updateFallingItems(param1:int) : void
      {
         var _loc3_:com.midasplayer.games.candycrush.board.FallingColumn = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._width)
         {
            _loc3_ = this._columns[_loc2_];
            this.updateFallingColumn(param1,_loc3_);
            _loc2_++;
         }
      }
      
      private function updateFallingColumn(param1:int, param2:com.midasplayer.games.candycrush.board.FallingColumn) : void
      {
         var _loc5_:int = 0;
         var _loc6_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc7_:int = 0;
         var _loc3_:Vector.<com.midasplayer.games.candycrush.board.Item> = param2.getItems();
         var _loc4_:Boolean;
         if(_loc4_ = param2.isFalling())
         {
            _loc5_ = int(_loc3_.length - 1);
            while(_loc5_ >= 0)
            {
               _loc6_ = _loc3_[_loc5_];
               this.tickFallingItem(param1,param2,_loc6_);
               _loc5_--;
            }
         }
         else
         {
            _loc7_ = 0;
            while(_loc7_ < _loc3_.length)
            {
               this.tickFallingItem(param1,param2,_loc3_[_loc7_]);
               _loc7_++;
            }
         }
      }
      
      private function updateBoardItems(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._height)
         {
            _loc3_ = 0;
            while(_loc3_ < this._width)
            {
               if((_loc4_ = this.getGridItem(_loc3_,_loc2_)) != null)
               {
                  _loc4_.tick(param1);
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function trySwap(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         if(!this._isStable)
         {
            return false;
         }
         if(!(Math.abs(param1 - param3) == 0 && Math.abs(param2 - param4) == 1 || Math.abs(param2 - param4) == 0 && Math.abs(param1 - param3) == 1))
         {
            return false;
         }
         var _loc5_:com.midasplayer.games.candycrush.board.Item = this.getGridItem(param1,param2);
         var _loc6_:com.midasplayer.games.candycrush.board.Item = this.getGridItem(param3,param4);
         if(_loc5_ == null || _loc6_ == null)
         {
            return false;
         }
         if(_loc5_.isBusy() || _loc6_.isBusy())
         {
            return false;
         }
         this._doSwap(param1,param2,param3,param4,false);
         return true;
      }
      
      private function _doSwap(param1:int, param2:int, param3:int, param4:int, param5:Boolean, param6:Vector.<SwapInfo> = null) : void
      {
         var _loc7_:com.midasplayer.games.candycrush.board.Item = this.getGridItem(param1,param2);
         var _loc8_:com.midasplayer.games.candycrush.board.Item = this.getGridItem(param3,param4);
         if(_loc7_.isLocked() || _loc8_.isLocked())
         {
            return;
         }
         _loc7_.beginMovement(param3,param4,8);
         _loc8_.beginMovement(param1,param2,8);
         this._set(param1,param2,_loc8_);
         this._set(param3,param4,_loc7_);
         if(param6 == null)
         {
            param6 = this._swaps;
         }
         var _loc9_:SwapInfo;
         (_loc9_ = new SwapInfo(param1,param2,param3,param4,_loc7_,_loc8_)).isFailed = param5;
         param6.push(_loc9_);
         this._lastSwap = _loc9_;
         this._listener.switchMade(_loc9_,SWITCHSTATE_BEGIN);
         var _loc10_:*;
         var _loc11_:* = (_loc10_ = this)._numSwaps + 1;
         _loc10_._numSwaps = _loc11_;
      }
      
      private function _set(param1:int, param2:int, param3:com.midasplayer.games.candycrush.board.Item) : void
      {
         this._m[param2][param1] = param3;
         this._mIntIsDirty = true;
         param3.x = param1;
         param3.lastX = param3.x;
         param3.y = param2 + 0.5;
         param3.lastY = param3.y;
         param3.ya = 0;
      }
      
      private function populate() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this._height)
         {
            _loc2_ = 0;
            while(_loc2_ < this._width)
            {
               this._set(_loc2_,_loc1_,this._itemFactory.create(_loc2_,_loc1_,null));
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      private function tickFallingItem(param1:int, param2:com.midasplayer.games.candycrush.board.FallingColumn, param3:com.midasplayer.games.candycrush.board.Item) : void
      {
         param3.tick(param1);
         var _loc4_:Boolean;
         if(_loc4_ = this._canItemFall(param2,param3))
         {
            param3.doMove();
         }
         else
         {
            param3.doBounce(1,this._bad_hidden_state_bounce_in_grid);
            this.trySnapItem(param3);
         }
      }
      
      private function trySnapItem(param1:com.midasplayer.games.candycrush.board.Item) : void
      {
         if(param1.y < 0)
         {
            return;
         }
         if(Math.abs(param1.ya) < 0.05 && this.isItemBelowStable(param1))
         {
            this.snapTo(param1,param1.x + 0.5,param1.y);
         }
      }
      
      private function isItemBelowStable(param1:com.midasplayer.games.candycrush.board.Item) : Boolean
      {
         return param1.y + 0.51 >= this._height || this.getGridItem(param1.x,param1.y + 0.51) != null;
      }
      
      private function _canItemFall(param1:com.midasplayer.games.candycrush.board.FallingColumn, param2:com.midasplayer.games.candycrush.board.Item) : Boolean
      {
         if(!param1.isFree(param2))
         {
            this._bad_hidden_state_bounce_in_grid = false;
            return false;
         }
         if(!this.isFree(param2))
         {
            this._bad_hidden_state_bounce_in_grid = true;
            return false;
         }
         return true;
      }
      
      public function removeItem(param1:com.midasplayer.games.candycrush.board.Item) : void
      {
         var _loc3_:com.midasplayer.games.candycrush.board.IDestructionPlan = null;
         var _loc5_:* = false;
         if(param1 == null)
         {
            return;
         }
         if(param1.isBusy())
         {
            return;
         }
         this._unstableActionThisTick = true;
         Debug.assert(this._allItems.indexOf(param1) >= 0,"Item not found @ removeItem: " + param1.id);
         if(this._allItems.indexOf(param1) < 0)
         {
            return;
         }
         this._listener.destroyItem(param1);
         this._allItems.splice(this._allItems.indexOf(param1),1);
         delete this._byIndex[param1.id];
         param1.savePos();
         var _loc2_:com.midasplayer.games.candycrush.board.Item = this.getGridItem(param1.column,param1.row);
         if(param1 == _loc2_)
         {
            this._m[param1.row][param1.column] = null;
            this._mIntIsDirty = true;
         }
         else
         {
            _loc5_ = this._columns[param1.column].getItems().indexOf(param1) >= 0;
            Debug.assert(_loc5_,"Item must be in a column if it\'s not in the grid!");
            if(!_loc5_)
            {
               return;
            }
            this._columns[param1.column].remove(param1);
         }
         _loc3_ = param1.getDestructionPlan();
         var _loc4_:com.midasplayer.games.candycrush.board.Item;
         if(_loc4_ = _loc3_ == null ? null : _loc3_.getDestructionItem())
         {
            _loc4_.setParentDecl(param1);
            this.__createNewItemAt(param1.x,param1.y,_loc4_);
         }
      }
      
      private function __bombWaveAt(param1:int, param2:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc9_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc3_:int = Math.max(0,param1 - 1);
         var _loc4_:int = Math.min(param1 + 1,this._width - 1);
         var _loc5_:int = _loc3_;
         while(_loc5_ <= _loc4_)
         {
            _loc6_ = param2;
            if((_loc7_ = (4 - Math.abs(param1 - _loc5_)) * 0.02) >= 0)
            {
               while(--_loc6_ >= 0)
               {
                  if(_loc9_ = this.getUnifiedGridItem(_loc5_,_loc6_))
                  {
                     _loc9_.ya = _loc9_.ya - _loc7_;
                  }
               }
               if((Boolean(_loc8_ = this._m[param2][param1])) && !_loc8_.isBusy())
               {
                  this._columns[param1].insertItem(_loc8_);
                  this._m[param2][param1] = null;
               }
            }
            _loc5_++;
         }
      }
      
      private function isFree(param1:com.midasplayer.games.candycrush.board.Item) : Boolean
      {
         if(param1.y + param1.ya + 0.5 >= this._height)
         {
            param1.y = this._height - 0.5;
            return false;
         }
         var _loc2_:int = param1.column;
         var _loc3_:int = int(int(param1.y + param1.ya + 0.5));
         if(this.getGridItem(_loc2_,_loc3_) != null)
         {
            param1.y = _loc3_ - 0.5;
            return false;
         }
         return true;
      }
      
      public function setListener(param1:com.midasplayer.games.candycrush.board.IBoardListener) : void
      {
         this._listener = param1 as GameView;
      }
      
      private function snapTo(param1:com.midasplayer.games.candycrush.board.Item, param2:int, param3:int) : void
      {
         param1.lastX = param1.x;
         param1.x = param2;
         param1.y = param3 + 0.5;
         param1.ya = 0;
         this._columns[param2].remove(param1);
         this._m[param3][param2] = param1;
         this._mIntIsDirty = true;
         param1.snap();
      }
      
      public function isReasonableStable() : Boolean
      {
         return this._isReasonableStable;
      }
      
      private function calculateReasonableStability() : Boolean
      {
         if(this._swaps.length > 0)
         {
            return false;
         }
         if(this._unstableActionThisTick)
         {
            return false;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._width)
         {
            if(!this._columns[_loc1_].isEmpty())
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function isStable() : Boolean
      {
         return this._isStable;
      }
      
      private function calculateStability() : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._height)
         {
            _loc2_ = 0;
            while(_loc2_ < this._width)
            {
               _loc3_ = this.getUnifiedGridItem(_loc2_,_loc1_);
               if(Boolean(_loc3_) && (_loc3_.isBusy() || _loc3_.isDestroyed() || _loc3_.isToBeRemoved()))
               {
                  return false;
               }
               _loc3_ = this.getGridItem(_loc2_,_loc1_);
               if(Boolean(_loc3_) && (_loc3_.isBusy() || _loc3_.isDestroyed() || _loc3_.isToBeRemoved()))
               {
                  return false;
               }
               _loc2_++;
            }
            _loc1_++;
         }
         return true;
      }
      
      private function __createNewItemAt(param1:Number, param2:Number, param3:com.midasplayer.games.candycrush.board.Item) : void
      {
         param3.x = param3.lastX = param1;
         param3.y = param3.lastY = param2;
         this._columns[int(param1)].insertItem(param3);
         this._initializeAndAddItem(param3);
      }
      
      private function createNewItemOnTop(param1:int) : void
      {
         var _loc3_:com.midasplayer.games.candycrush.board.FallingColumn = null;
         var _loc2_:com.midasplayer.games.candycrush.board.Item = this._itemFactory.create(param1,-1,null);
         _loc3_ = this._columns[param1];
         var _loc4_:Number = _loc3_.getLowestInsertionPoint();
         _loc2_.y = _loc2_.lastY = _loc4_;
         _loc3_.insertItem(_loc2_);
         this._initializeAndAddItem(_loc2_);
      }
      
      private function _initializeAndAddItem(param1:com.midasplayer.games.candycrush.board.Item) : void
      {
         this._allItems.push(param1);
         this._byIndex[param1.id] = param1;
         param1.setBoard(this);
         this._listener.addItem(param1,param1.x,param1.y);
      }
      
      public function getColorHistogram() : Vector.<int>
      {
         var _loc3_:int = 0;
         var _loc4_:com.midasplayer.games.candycrush.board.Item = null;
         var _loc1_:Vector.<int> = new Vector.<int>();
         var _loc2_:int = 0;
         while(_loc2_ < this._height)
         {
            _loc3_ = 0;
            while(_loc3_ < this._width)
            {
               if(_loc4_ = this.getGridItem(_loc3_,_loc2_))
               {
                  if(_loc4_.color >= _loc1_.length)
                  {
                     _loc1_.length = _loc4_.color + 1;
                  }
                  var _loc5_:*;
                  var _loc6_:*;
                  var _loc7_:* = (_loc5_ = _loc1_)[_loc6_ = _loc4_.color] + 1;
                  _loc5_[_loc6_] = _loc7_;
               }
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getMostCommonColor(param1:Array = null) : int
      {
         if(param1 == null)
         {
            param1 = [];
         }
         var _loc2_:Vector.<int> = this.getColorHistogram();
         var _loc3_:int = -1;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            if(_loc2_[_loc5_] > _loc4_ && param1.indexOf(_loc5_) == -1)
            {
               _loc3_ = _loc5_;
               _loc4_ = _loc2_[_loc5_];
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function transform(param1:int, param2:int, param3:int, param4:int = -1) : void
      {
         var _loc5_:com.midasplayer.games.candycrush.board.Item = this.getGridItem(param1,param2);
         Debug.assert(_loc5_ != null,"Transformed Item can\'t be null");
         if(!_loc5_)
         {
            return;
         }
         _loc5_.special = param3;
         this._itemFactory.addDestructionPlan(_loc5_);
         if(param4 >= 0)
         {
            _loc5_.color = param4;
         }
      }
      
      public function setPowerupAt(param1:int, param2:int, param3:int, param4:int = 0, param5:com.midasplayer.games.candycrush.board.Item = null, param6:Boolean = false) : void
      {
         var _loc7_:com.midasplayer.games.candycrush.board.Item;
         if((_loc7_ = param5 == null ? new com.midasplayer.games.candycrush.board.Item(param1,param2,param4) : param5).hasDestructionItem())
         {
            return;
         }
         _loc7_.special = param5 == null ? param3 : param5.special;
         _loc7_.color = param5 == null ? param4 : param5.color;
         _loc7_.id = this._itemFactory.getNextItemId();
         if(param6)
         {
            this._itemFactory.addDestructionPlan(param5);
         }
         else
         {
            _loc7_ = this._itemFactory.createSpecial(param1,param2,_loc7_.color,_loc7_.special);
         }
         this.getGridItem(param1,param2).setDestructionPlan(new DPlan_Simple(_loc7_));
         this.getGridItem(param1,param2).special = 0;
         this.removeItem(this.getGridItem(param1,param2));
      }
      
      public function width() : int
      {
         return this._width;
      }
      
      public function height() : int
      {
         return this._height;
      }
      
      public function setScoreHolder(param1:ScoreHolder) : void
      {
         this._scoreHolder = param1;
         param1.resetSequences();
      }
      
      public function getFallingColumn(param1:int) : com.midasplayer.games.candycrush.board.FallingColumn
      {
         return this._columns[param1];
      }
      
      private function getMatchPattern(param1:int) : MatchPattern
      {
         if(param1 < MATCH_ID_TorL || param1 > MATCH_ID_5)
         {
            return null;
         }
         return MatchPatterns[[1,3,2,0][param1 - 2]];
      }
      
      public function getHint() : Array
      {
         return NoMoreMoves.linear3match(this._mInt);
      }
      
      public function getSpecificHint(param1:Array) : Match
      {
         var _loc3_:int = 0;
         var _loc4_:MatchPattern = null;
         var _loc5_:OrthoPatternMatcher = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Match = null;
         for each(_loc3_ in param1)
         {
            _loc4_ = this.getMatchPattern(_loc3_);
            _loc5_ = new OrthoPatternMatcher(this._mInt,[_loc4_],3);
            _loc6_ = 0;
            while(_loc6_ < this._height)
            {
               _loc7_ = 0;
               while(_loc7_ < this._width)
               {
                  _loc2_ = this.__checkMatchIfSwapped(_loc5_,_loc7_,_loc6_,_loc7_ + 1,_loc6_);
                  if(_loc2_)
                  {
                     return _loc2_;
                  }
                  _loc2_ = this.__checkMatchIfSwapped(_loc5_,_loc7_,_loc6_,_loc7_,_loc6_ + 1);
                  if(_loc2_)
                  {
                     return _loc2_;
                  }
                  _loc7_++;
               }
               _loc6_++;
            }
         }
         return null;
      }
      
      private function __checkMatchIfSwapped(param1:OrthoPatternMatcher, param2:int, param3:int, param4:int, param5:int) : Match
      {
         if(!this.inRange(param2,param3) || !this.inRange(param4,param5))
         {
            return null;
         }
         var _loc6_:int = this._mInt[param3][param2];
         var _loc7_:int = this._mInt[param5][param4];
         this._mInt[param3][param2] = _loc7_;
         this._mInt[param5][param4] = _loc6_;
         var _loc8_:Match;
         if(_loc8_ = param1.matchXY(param2,param3))
         {
            _loc8_.associatedSwap = new SwapInfo(param4,param5,param2,param3);
         }
         else if(_loc8_ = param1.matchXY(param4,param5))
         {
            _loc8_.associatedSwap = new SwapInfo(param2,param3,param4,param5);
         }
         this._mInt[param3][param2] = _loc6_;
         this._mInt[param5][param4] = _loc7_;
         return _loc8_;
      }
   }
}

import com.midasplayer.games.candycrush.board.IBoardListener;
import com.midasplayer.games.candycrush.board.IDestructionPlan;
import com.midasplayer.games.candycrush.board.Item;
import com.midasplayer.games.candycrush.board.match.Match;
import com.midasplayer.games.candycrush.input.SwapInfo;
import com.midasplayer.math.IntCoord;

class EmptyBoardListener implements IBoardListener
{
    
   
   public function EmptyBoardListener()
   {
      super();
   }
   
   public function addItem(param1:Item, param2:int, param3:int) : void
   {
   }
   
   public function removeItem(param1:Item, param2:int, param3:int) : void
   {
   }
   
   public function destroyItem(param1:Item) : void
   {
   }
   
   public function switchMade(param1:SwapInfo, param2:int) : void
   {
   }
   
   public function addScore(param1:Number, param2:Number, param3:int, param4:int, param5:Item = null, param6:IDestructionPlan = null) : void
   {
   }
   
   public function hasMatched(param1:Match, param2:int, param3:int) : void
   {
   }
   
   public function boardStabilized(param1:int, param2:int) : void
   {
   }
   
   public function powerupCreated(param1:int, param2:Item) : void
   {
   }
   
   public function powerupExploded(param1:int, param2:int, param3:int, param4:Item, param5:Vector.<IntCoord> = null, param6:Vector.<Item> = null) : void
   {
   }
   
   public function specialMixed(param1:int, param2:SwapInfo, param3:Vector.<Item> = null, param4:IntCoord = null) : void
   {
   }
}
