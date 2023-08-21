package com.midasplayer.games.candycrush.board.match
{
   public class OrthoPatternMatcher
   {
       
      
      private var _m:Vector.<Vector.<int>>;
      
      private var _width:int;
      
      private var _height:int;
      
      private var _minMatch:int;
      
      private var _matchPatterns:Array;
      
      public function OrthoPatternMatcher(param1:Vector.<Vector.<int>>, param2:Array, param3:int)
      {
         super();
         this._m = param1;
         this._width = param1[0].length;
         this._height = param1.length;
         this._minMatch = param3;
         this._matchPatterns = param2;
      }
      
      private function get(param1:int, param2:int) : int
      {
         return this._m[param2][param1];
      }
      
      private function _matchXY(param1:int, param2:int) : Match
      {
         var _loc3_:int = this.get(param1,param2);
         var _loc4_:int = param1;
         var _loc5_:int = param1;
         while(--_loc4_ >= 0)
         {
            if(_loc3_ != this.get(_loc4_,param2))
            {
               break;
            }
         }
         _loc4_++;
         while(++_loc5_ < this._width)
         {
            if(_loc3_ != this.get(_loc5_,param2))
            {
               break;
            }
         }
         _loc5_--;
         var _loc6_:int = param2;
         var _loc7_:int = param2;
         while(--_loc6_ >= 0)
         {
            if(_loc3_ != this.get(param1,_loc6_))
            {
               break;
            }
         }
         _loc6_++;
         while(++_loc7_ < this._height)
         {
            if(_loc3_ != this.get(param1,_loc7_))
            {
               break;
            }
         }
         _loc7_--;
         var _loc8_:* = _loc5_ - _loc4_ + 1 >= this._minMatch;
         var _loc9_:* = _loc7_ - _loc6_ + 1 >= this._minMatch;
         if(_loc8_ || _loc9_)
         {
            return new Match(param1,param2,_loc8_ ? _loc4_ : param1,_loc8_ ? _loc5_ : param1,_loc9_ ? _loc6_ : param2,_loc9_ ? _loc7_ : param2,_loc3_);
         }
         return null;
      }
      
      public function matchXY(param1:int, param2:int) : Match
      {
         var _loc4_:MatchPattern = null;
         var _loc3_:Match = this._matchXY(param1,param2);
         if(!_loc3_)
         {
            return null;
         }
         for each(_loc4_ in this._matchPatterns)
         {
            if(_loc4_.isMatch(_loc3_))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function matchAll() : Vector.<Match>
      {
         var _loc3_:MatchPattern = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Match = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:Object = {};
         var _loc2_:Vector.<Match> = new Vector.<Match>();
         for each(_loc3_ in this._matchPatterns)
         {
            _loc4_ = 0;
            while(_loc4_ < this._height)
            {
               _loc5_ = 0;
               while(_loc5_ < this._width)
               {
                  if(!(!this.get(_loc5_,_loc4_) || Boolean(_loc1_[_loc5_ + this._width * _loc4_])))
                  {
                     if((Boolean(_loc6_ = this.matchXY(_loc5_,_loc4_))) && _loc3_.isMatch(_loc6_))
                     {
                        _loc6_.patternId = _loc3_.getId();
                        _loc2_.push(_loc6_);
                        _loc7_ = _loc6_.west;
                        while(_loc7_ <= _loc6_.east)
                        {
                           _loc1_[_loc7_ + this._width * _loc4_] = 1;
                           _loc7_++;
                        }
                        _loc8_ = _loc6_.north;
                        while(_loc8_ <= _loc6_.south)
                        {
                           _loc1_[_loc5_ + this._width * _loc8_] = 1;
                           _loc8_++;
                        }
                     }
                  }
                  _loc5_++;
               }
               _loc4_++;
            }
         }
         return _loc2_;
      }
   }
}
