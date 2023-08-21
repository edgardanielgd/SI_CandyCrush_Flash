package com.midasplayer.games.candycrush.utils
{
   public class Py
   {
       
      
      public function Py()
      {
         super();
      }
      
      public static function range(param1:int, param2:* = null, param3:int = 1, param4:int = 0) : Array
      {
         var _loc7_:int = 0;
         var _loc5_:Array = [];
         if(param2 == null)
         {
            param2 = param1;
            param1 = 0;
         }
         var _loc6_:int = -1;
         if(param3 > 0)
         {
            _loc7_ = param1;
            while(_loc7_ < param2)
            {
               var _loc8_:*;
               _loc5_[_loc8_ = ++_loc6_] = _loc7_ + param4;
               _loc7_ += param3;
            }
         }
         else
         {
            _loc7_ = param1;
            while(_loc7_ > param2)
            {
               _loc5_[_loc8_ = ++_loc6_] = _loc7_ + param4;
               _loc7_ += param3;
            }
         }
         return _loc5_;
      }
      
      public static function getSlice(param1:*, param2:int, param3:* = null, param4:int = 1) : Array
      {
         var _loc7_:int = 0;
         if(param2 < 0 || param3 < 0)
         {
            throw new Error("Negative Indexes in getSlice@Py is not implemented yet");
         }
         var _loc5_:Array = range(param2,param3,param4);
         var _loc6_:Array = [];
         for each(_loc7_ in _loc5_)
         {
            _loc6_.push(param1[_loc7_]);
         }
         return _loc6_;
      }
      
      public static function multValue(param1:*, param2:int) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            _loc3_.push(param1);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function addLists(... rest) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < rest.length)
         {
            _loc5_ = int((_loc4_ = rest[_loc3_]).length);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               _loc2_.push(_loc4_[_loc6_]);
               _loc6_++;
            }
            _loc3_++;
         }
         return _loc2_;
      }
   }
}
