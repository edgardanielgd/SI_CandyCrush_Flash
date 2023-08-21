package com.midasplayer.games.candycrush.board.match
{
   public class NoMoreMoves
   {
       
      
      public function NoMoreMoves()
      {
         super();
      }
      
      public static function linear3(param1:Vector.<Vector.<int>>) : Boolean
      {
         return new Linear3Checker(param1).hasMoreMoves();
      }
      
      public static function linear3match(param1:Vector.<Vector.<int>>) : Array
      {
         return new Linear3Checker(param1).getMove();
      }
   }
}

interface NoMoreMovesChecker
{
    
   
   function hasMoreMoves() : Boolean;
   
   function getMove() : Array;
}

import com.midasplayer.math.IntCoord;

class Linear3Checker implements NoMoreMovesChecker
{
    
   
   private var _m:Vector.<Vector.<int>>;
   
   private var _width:int;
   
   private var _height:int;
   
   public function Linear3Checker(param1:Vector.<Vector.<int>>)
   {
      super();
      this._m = param1;
      this._width = param1[0].length;
      this._height = param1.length;
   }
   
   public function hasMoreMoves() : Boolean
   {
      var _loc2_:int = 0;
      var _loc3_:int = 0;
      var _loc4_:int = 0;
      var _loc5_:int = 0;
      var _loc6_:int = 0;
      var _loc1_:int = 0;
      while(_loc1_ < this._width)
      {
         _loc2_ = 0;
         while(_loc2_ < this._height)
         {
            _loc3_ = int(this.getType(_loc1_ - 1,_loc2_));
            _loc4_ = int(this.getType(_loc1_,_loc2_ - 1));
            _loc5_ = int(this.getType(_loc1_ + 1,_loc2_));
            _loc6_ = int(this.getType(_loc1_,_loc2_ + 1));
            if(_loc3_ == _loc4_ && (this.getType(_loc1_ - 2,_loc2_) == _loc3_ || this.getType(_loc1_,_loc2_ - 2) == _loc3_))
            {
               return true;
            }
            if(_loc4_ == _loc5_ && (this.getType(_loc1_,_loc2_ - 2) == _loc4_ || this.getType(_loc1_ + 2,_loc2_) == _loc4_))
            {
               return true;
            }
            if(_loc5_ == _loc6_ && (this.getType(_loc1_ + 2,_loc2_) == _loc5_ || this.getType(_loc1_,_loc2_ + 2) == _loc5_))
            {
               return true;
            }
            if(_loc6_ == _loc3_ && (this.getType(_loc1_,_loc2_ + 2) == _loc6_ || this.getType(_loc1_ - 2,_loc2_) == _loc6_))
            {
               return true;
            }
            if(_loc3_ == _loc5_ && (_loc6_ == _loc3_ || _loc4_ == _loc3_ || this.getType(_loc1_ - 2,_loc2_) == _loc3_ || this.getType(_loc1_ + 2,_loc2_) == _loc3_))
            {
               return true;
            }
            if(_loc4_ == _loc6_ && (_loc3_ == _loc4_ || _loc5_ == _loc4_ || this.getType(_loc1_,_loc2_ - 2) == _loc4_ || this.getType(_loc1_,_loc2_ + 2) == _loc4_))
            {
               return true;
            }
            _loc2_++;
         }
         _loc1_++;
      }
      return false;
   }
   
   public function getMove() : Array
   {
      var _loc6_:int = 0;
      var _loc7_:int = 0;
      var _loc8_:int = 0;
      var _loc9_:int = 0;
      var _loc10_:int = 0;
      var _loc1_:IntCoord = new IntCoord();
      var _loc2_:IntCoord = new IntCoord();
      var _loc3_:IntCoord = new IntCoord();
      var _loc4_:IntCoord = new IntCoord();
      var _loc5_:int = 0;
      while(_loc5_ < this._width)
      {
         _loc6_ = 0;
         while(_loc6_ < this._height)
         {
            _loc1_.x = _loc5_ - 1;
            _loc1_.y = _loc6_;
            _loc7_ = int(this.getType(_loc5_ - 1,_loc6_));
            _loc2_.x = _loc5_;
            _loc2_.y = _loc6_ - 1;
            _loc8_ = int(this.getType(_loc5_,_loc6_ - 1));
            _loc3_.x = _loc5_ + 1;
            _loc3_.y = _loc6_;
            _loc9_ = int(this.getType(_loc5_ + 1,_loc6_));
            _loc4_.x = _loc5_;
            _loc4_.y = _loc6_ + 1;
            _loc10_ = int(this.getType(_loc5_,_loc6_ + 1));
            if(_loc7_ == _loc8_)
            {
               if(this.getType(_loc5_ - 2,_loc6_) == _loc7_)
               {
                  return [_loc1_,_loc2_,new IntCoord(_loc5_ - 2,_loc6_)];
               }
               if(this.getType(_loc5_,_loc6_ - 2) == _loc7_)
               {
                  return [_loc1_,_loc2_,new IntCoord(_loc5_,_loc6_ - 2)];
               }
            }
            if(_loc8_ == _loc9_)
            {
               if(this.getType(_loc5_,_loc6_ - 2) == _loc8_)
               {
                  return [_loc2_,_loc3_,new IntCoord(_loc5_,_loc6_ - 2)];
               }
               if(this.getType(_loc5_ + 2,_loc6_) == _loc8_)
               {
                  return [_loc2_,_loc3_,new IntCoord(_loc5_ + 2,_loc6_)];
               }
            }
            if(_loc9_ == _loc10_)
            {
               if(this.getType(_loc5_ + 2,_loc6_) == _loc9_)
               {
                  return [_loc3_,_loc4_,new IntCoord(_loc5_ + 2,_loc6_)];
               }
               if(this.getType(_loc5_,_loc6_ + 2) == _loc9_)
               {
                  return [_loc3_,_loc4_,new IntCoord(_loc5_,_loc6_ + 2)];
               }
            }
            if(_loc10_ == _loc7_)
            {
               if(this.getType(_loc5_,_loc6_ + 2) == _loc10_)
               {
                  return [_loc4_,_loc1_,new IntCoord(_loc5_,_loc6_ + 2)];
               }
               if(this.getType(_loc5_ - 2,_loc6_) == _loc10_)
               {
                  return [_loc4_,_loc1_,new IntCoord(_loc5_ - 2,_loc6_)];
               }
            }
            if(_loc7_ == _loc9_)
            {
               if(_loc10_ == _loc7_)
               {
                  return [_loc1_,_loc3_,_loc4_];
               }
               if(_loc8_ == _loc7_)
               {
                  return [_loc1_,_loc3_,_loc2_];
               }
               if(this.getType(_loc5_ - 2,_loc6_) == _loc7_)
               {
                  return [_loc1_,_loc3_,new IntCoord(_loc5_ - 2,_loc6_)];
               }
               if(this.getType(_loc5_ + 2,_loc6_) == _loc7_)
               {
                  return [_loc1_,_loc3_,new IntCoord(_loc5_ + 2,_loc6_)];
               }
            }
            if(_loc8_ == _loc10_)
            {
               if(_loc7_ == _loc8_)
               {
                  return [_loc2_,_loc4_,_loc1_];
               }
               if(_loc9_ == _loc8_)
               {
                  return [_loc2_,_loc4_,_loc3_];
               }
               if(this.getType(_loc5_,_loc6_ - 2) == _loc8_)
               {
                  return [_loc2_,_loc4_,new IntCoord(_loc5_,_loc6_ - 2)];
               }
               if(this.getType(_loc5_,_loc6_ + 2) == _loc8_)
               {
                  return [_loc2_,_loc4_,new IntCoord(_loc5_,_loc6_ + 2)];
               }
            }
            _loc6_++;
         }
         _loc5_++;
      }
      return null;
   }
   
   private function getType(param1:int, param2:int) : int
   {
      if(param1 < 0)
      {
         return -1;
      }
      if(param2 < 0)
      {
         return -2;
      }
      if(param1 >= this._width)
      {
         return -3;
      }
      if(param2 >= this._height)
      {
         return -4;
      }
      return this._m[param2][param1];
   }
}

class FindMoveInfo
{
    
   
   public function FindMoveInfo()
   {
      super();
   }
}
