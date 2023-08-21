package com.midasplayer.games.candycrush.board
{
   import com.midasplayer.debug.Debug;
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.board.items.*;
   import com.midasplayer.games.candycrush.board.match.Match;
   import com.midasplayer.games.candycrush.board.plans.*;
   import com.midasplayer.games.candycrush.input.SwapInfo;
   import com.midasplayer.math.IntCoord;
   import com.midasplayer.math.MtRandom;
   import com.midasplayer.math.Random;
   
   public class ItemFactory
   {
      
      public static var DPLAN_ID:int = 0;
       
      
      private var _board:com.midasplayer.games.candycrush.board.Board;
      
      private var _runningId:int = 0;
      
      private var _rnd:MtRandom;
      
      private var _shuffler:Random;
      
      private const NumColors:int = 6;
      
      public function ItemFactory(param1:int)
      {
         super();
         this._rnd = new MtRandom(param1);
         this._shuffler = new Random(this._rnd);
      }
      
      public static function isSwapOfTypes(param1:SwapInfo, param2:int, param3:int, param4:Boolean = true) : Boolean
      {
         if(param4)
         {
            return (param1.item_a.special & param2) != 0 && Boolean(param1.item_b.special & param3) || Boolean(param1.item_a.special & param3) && Boolean(param1.item_b.special & param2);
         }
         return param1.item_a.special == param2 && param1.item_b.special == param3 || param1.item_a.special == param3 && param1.item_b.special == param2;
      }
      
      public function init(param1:com.midasplayer.games.candycrush.board.Board) : void
      {
         this._board = param1;
      }
      
      public function getNextItemId() : int
      {
         _loc1_._runningId = _loc2_;
         var _loc1_:*;
         return (_loc1_ = this)._runningId + 1;
      }
      
      public function create(param1:int, param2:int, param3:Item) : Item
      {
         var _loc4_:int = 0;
         _loc4_ = 1 + this._rnd.nextInt(this.NumColors);
         var _loc5_:Item;
         (_loc5_ = new Item(param1,param2,_loc4_)).id = this.getNextItemId();
         return _loc5_;
      }
      
      public function createSpecial(param1:int, param2:int, param3:int, param4:int) : Item
      {
         if(ItemType.isWrap(param4))
         {
            return this.createWrap(param1,param2,param3);
         }
         if(ItemType.isLine(param4))
         {
            return this.createLine(param1,param2,param3);
         }
         if(ItemType.isColumn(param4))
         {
            return this.createColumn(param1,param2,param3);
         }
         if(ItemType.isColor(param4))
         {
            return this.createColor(param1,param2,param3);
         }
         return null;
      }
      
      public function createSpecial2(param1:Match, param2:SwapInfo) : Item
      {
         var _loc3_:Item = null;
         if(param1.patternId == com.midasplayer.games.candycrush.board.Board.MATCH_ID_5)
         {
            _loc3_ = this.createColor(param1.x,0,param1.color);
         }
         else if(param1.patternId == com.midasplayer.games.candycrush.board.Board.MATCH_ID_4)
         {
            _loc3_ = new Item(param1.x,param1.y,param1.color);
            _loc3_.id = this.getNextItemId();
            if(Boolean(param2) && param2.isHorizontal())
            {
               _loc3_ = this.createLine(param1.x,0,param1.color);
            }
            else
            {
               _loc3_ = this.createColumn(param1.x,0,param1.color);
            }
         }
         else if(param1.patternId == com.midasplayer.games.candycrush.board.Board.MATCH_ID_TorL)
         {
            _loc3_ = this.createWrap(param1.x,0,param1.color);
         }
         if(_loc3_ == null)
         {
            return null;
         }
         return _loc3_;
      }
      
      public function createWrap(param1:Number, param2:Number, param3:int) : Item
      {
         var _loc4_:Item;
         (_loc4_ = new Item(param1,param2,param3)).id = this.getNextItemId();
         _loc4_.special = ItemType.WRAP;
         this.addDestructionPlan(_loc4_);
         return _loc4_;
      }
      
      public function createLine(param1:int, param2:int, param3:int) : Item
      {
         var _loc4_:Item;
         (_loc4_ = new Item(param1,param2,param3)).id = this.getNextItemId();
         _loc4_.special = ItemType.LINE;
         this.addDestructionPlan(_loc4_);
         return _loc4_;
      }
      
      public function createColumn(param1:int, param2:int, param3:int) : Item
      {
         var _loc4_:Item;
         (_loc4_ = new Item(param1,param2,param3)).id = this.getNextItemId();
         _loc4_.special = ItemType.COLUMN;
         this.addDestructionPlan(_loc4_);
         return _loc4_;
      }
      
      public function createColor(param1:int, param2:int, param3:int) : Item
      {
         var _loc4_:Item;
         (_loc4_ = new Item(param1,param2,0)).id = this.getNextItemId();
         _loc4_.special = ItemType.COLOR;
         this.addDestructionPlan(_loc4_);
         return _loc4_;
      }
      
      public function getPowerupCoord(param1:com.midasplayer.games.candycrush.board.Board, param2:Array, param3:SwapInfo) : IntCoord
      {
         var _loc6_:IntCoord = null;
         var _loc7_:IntCoord = null;
         var _loc8_:Item = null;
         var _loc9_:IntCoord = null;
         if(param3 != null)
         {
            _loc6_ = new IntCoord(param3.x0,param3.y0);
            _loc7_ = new IntCoord(param3.x1,param3.y1);
            for each(_loc9_ in param2)
            {
               _loc8_ = param1.getGridItem(_loc9_.x,_loc9_.y);
               Debug.assert(_loc8_ != null,"Item in the match can\'t be null! (@getPowerupCoord)");
               if(!(Boolean(_loc8_) && (_loc8_.hasDestructionItem() || _loc8_.special != 0)))
               {
                  if(_loc9_.x == _loc7_.x && _loc9_.y == _loc7_.y || _loc9_.x == _loc6_.x && _loc9_.y == _loc6_.y)
                  {
                     return _loc9_;
                  }
               }
            }
         }
         var _loc4_:Array = param2.concat();
         this._shuffler.shuffle(_loc4_);
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc9_ = _loc4_[_loc5_];
            if((Boolean(_loc8_ = param1.getGridItem(_loc9_.x,_loc9_.y))) && (!_loc8_.hasDestructionItem() && _loc8_.special == 0))
            {
               return _loc9_;
            }
            _loc5_++;
         }
         return null;
      }
      
      public function addDestructionPlan(param1:Item) : void
      {
         var _loc2_:Item = null;
         if(ItemType.isColor(param1.special))
         {
            param1.setDestructionPlan(new DPlan_Color(this._board,param1));
         }
         if(ItemType.isColumn(param1.special))
         {
            param1.setDestructionPlan(new DPlan_Column(this._board,param1));
         }
         if(ItemType.isLine(param1.special))
         {
            param1.setDestructionPlan(new DPlan_Line(this._board,param1));
         }
         if(ItemType.isWrap(param1.special))
         {
            _loc2_ = new Temp_Wrapped(param1.column,0,param1.color);
            _loc2_.id = this.getNextItemId();
            param1.setDestructionPlan(new DPlan_Bomb(this._board,param1,_loc2_));
            _loc2_.setDestructionPlan(new DPlan_Bomb(this._board,_loc2_,null));
         }
      }
      
      public function categorizeAndHandleSwap(param1:SwapInfo, param2:IBoardListener) : Boolean
      {
         var _loc4_:Vector.<Item> = null;
         var _loc5_:DPlan_ColorColor = null;
         var _loc6_:Item = null;
         var _loc7_:Boolean = false;
         var _loc8_:Item = null;
         var _loc9_:Item = null;
         var _loc10_:int = 0;
         var _loc11_:Item = null;
         var _loc12_:Item = null;
         var _loc13_:* = false;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:Item = null;
         var _loc18_:Item = null;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:Item = null;
         var _loc26_:Item = null;
         var _loc3_:Boolean = false;
         if(isSwapOfTypes(param1,ItemType.COLOR,ItemType.COLOR))
         {
            _loc5_ = new DPlan_ColorColor(this._board,param1);
            param1.item_a.setDestructionPlan(_loc5_);
            param1.item_b.setDestructionPlan(null);
            this._board.addForRemoval(param1.x0,param1.y0,86);
            this._board.addForRemoval(param1.x1,param1.y1,0);
            if(param2)
            {
               param2.specialMixed(ItemType.MIX_COLOR_COLOR,param1,_loc5_.getItems());
            }
            _loc3_ = true;
         }
         else if(isSwapOfTypes(param1,ItemType.WRAP,ItemType.COLOR))
         {
            if(param1.item_a.special & ItemType.WRAP)
            {
               param1.item_b.destructionColor = param1.item_a.color;
               this._board.addForRemoval(param1.x0,param1.y0);
               _loc6_ = new Temp_Color(param1.x1,param1.y1,0);
               param1.item_a.color = 0;
               this._board.setPowerupAt(param1.x1,param1.y1,_loc6_.special,0,_loc6_,true);
            }
            else
            {
               param1.item_a.destructionColor = param1.item_b.color;
               this._board.addForRemoval(param1.x1,param1.y1);
               _loc6_ = new Temp_Color(param1.x0,param1.y0,0);
               param1.item_b.color = 0;
               this._board.setPowerupAt(param1.x0,param1.y0,_loc6_.special,0,_loc6_,true);
            }
            if(param2)
            {
               param2.specialMixed(ItemType.MIX_COLOR_WRAP,param1);
            }
            _loc3_ = true;
         }
         else if(Boolean(isSwapOfTypes(param1,ItemType.LINE,ItemType.COLOR)) || Boolean(isSwapOfTypes(param1,ItemType.COLUMN,ItemType.COLOR)))
         {
            _loc7_ = Boolean(isSwapOfTypes(param1,ItemType.LINE,ItemType.COLOR));
            _loc10_ = (_loc9_ = (_loc8_ = ItemType.isColor(param1.item_a.special) ? param1.item_a : param1.item_b) == param1.item_a ? param1.item_b : param1.item_a).color;
            _loc11_ = new Temp_Blank(_loc8_.x,_loc8_.y,20 + 28);
            _loc8_.setDestructionPlan(new DPlan_Simple(_loc11_));
            _loc8_._destroyTicks = 5;
            _loc8_.destroy();
            _loc12_ = new Temp_Blank(_loc9_.x,_loc9_.y,20 + 28);
            _loc9_.setDestructionPlan(new DPlan_Simple(_loc12_));
            _loc9_._destroyTicks = 5;
            _loc9_.destroy();
            _loc4_ = new Vector.<Item>();
            _loc13_ = true;
            _loc14_ = 15 + 12;
            _loc15_ = 0;
            while(_loc15_ < this._board.height())
            {
               _loc16_ = 0;
               while(_loc16_ < this._board.width())
               {
                  if(!(!(_loc17_ = this._board.getGridItem(_loc16_,_loc15_)) || _loc17_.color != _loc10_ || _loc17_ == _loc9_))
                  {
                     if(ItemType.isLine(_loc17_.special) || ItemType.isColumn(_loc17_.special))
                     {
                        _loc17_.setRemovalTicks(_loc14_);
                     }
                     else
                     {
                        if(_loc13_)
                        {
                           _loc18_ = new Temp_Line(_loc16_,_loc15_,_loc10_,_loc14_);
                        }
                        else
                        {
                           _loc18_ = new Temp_Column(_loc16_,_loc15_,_loc10_,_loc14_);
                        }
                        this._board.setPowerupAt(_loc16_,_loc15_,0,_loc10_,_loc18_,true);
                        _loc4_.push(_loc18_);
                        _loc13_ = !_loc13_;
                     }
                     _loc14_ += 8;
                  }
                  _loc16_++;
               }
               _loc15_++;
            }
            if(param2)
            {
               param2.specialMixed(ItemType.MIX_COLOR_LINE,param1,_loc4_);
            }
            _loc3_ = true;
         }
         else if(Boolean(isSwapOfTypes(param1,ItemType.LINE,ItemType.WRAP)) || Boolean(isSwapOfTypes(param1,ItemType.COLUMN,ItemType.WRAP)))
         {
            _loc19_ = param1.y1;
            _loc20_ = this._board.getRow(_loc19_ - 1);
            _loc21_ = this._board.getRow(_loc19_ + 1);
            _loc22_ = param1.x1;
            _loc23_ = this._board.getColumn(_loc22_ - 1);
            _loc24_ = this._board.getColumn(_loc22_ + 1);
            _loc4_ = new Vector.<Item>();
            _loc15_ = _loc20_;
            while(_loc15_ <= _loc21_)
            {
               _loc16_ = _loc23_;
               while(_loc16_ <= _loc24_)
               {
                  if(_loc25_ = this._board.getUnifiedGridItem(_loc16_,_loc15_))
                  {
                     _loc26_ = new Temp_Blank(_loc16_,_loc15_,40);
                     if(_loc16_ == _loc22_ && _loc15_ == _loc19_)
                     {
                        _loc25_.setDestructionPlan(new DPlan_3x3(this._board,_loc25_,_loc26_));
                        _loc25_.special = 0;
                     }
                     else if(ItemType.isColor(_loc25_.special))
                     {
                        _loc25_.setDestructionPlan(new DPlan_Color(this._board,_loc25_));
                     }
                     else
                     {
                        _loc25_.setDestructionPlan(new DPlan_Simple(_loc26_));
                        _loc25_.special = 0;
                     }
                     _loc25_._destroyTicks = 0;
                     this._board.addForRemoval(_loc16_,_loc15_,20);
                     _loc4_.push(_loc25_);
                  }
                  _loc16_++;
               }
               _loc15_++;
            }
            if(param2)
            {
               param2.specialMixed(ItemType.MIX_LINE_WRAP,param1,_loc4_);
            }
            _loc3_ = true;
         }
         else if(isSwapOfTypes(param1,ItemType.LINE,ItemType.COLUMN))
         {
            this._board.addForRemoval(param1.x0,param1.y0);
            this._board.addForRemoval(param1.x1,param1.y1);
            _loc3_ = true;
         }
         else if(Boolean(isSwapOfTypes(param1,ItemType.LINE,ItemType.LINE)) || Boolean(isSwapOfTypes(param1,ItemType.COLUMN,ItemType.COLUMN)))
         {
            if(ItemType.isLine(param1.item_a.special))
            {
               this._board.transform(param1.x1,param1.y1,ItemType.COLUMN);
            }
            else
            {
               this._board.transform(param1.x1,param1.y1,ItemType.LINE);
            }
            this._board.addForRemoval(param1.x0,param1.y0);
            this._board.addForRemoval(param1.x1,param1.y1);
            _loc3_ = true;
         }
         else if(isSwapOfTypes(param1,ItemType.WRAP,ItemType.WRAP))
         {
            this._board.addForRemoval(param1.x0,param1.y0);
            this._board.addForRemoval(param1.x1,param1.y1);
            _loc3_ = true;
         }
         else if(param1.item_a.special & ItemType.COLOR)
         {
            param1.item_a.destructionColor = param1.item_b.color;
            this._board.addForRemoval(param1.x1,param1.y1);
            _loc3_ = true;
         }
         else if(param1.item_b.special & ItemType.COLOR)
         {
            param1.item_b.destructionColor = param1.item_a.color;
            this._board.addForRemoval(param1.x0,param1.y0);
            _loc3_ = true;
         }
         return _loc3_;
      }
   }
}
