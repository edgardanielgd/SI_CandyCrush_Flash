package com.midasplayer.math
{
   public class IntCoord
   {
       
      
      public var x:int;
      
      public var y:int;
      
      public function IntCoord(param1:int = 0, param2:int = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
      
      public static function fromUnique(param1:int) : IntCoord
      {
         var _loc2_:int = param1 / 65536;
         return new IntCoord(param1 - _loc2_ * 65536,_loc2_);
      }
      
      public static function uniqueVal(param1:int, param2:int) : int
      {
         return param2 * 65536 + param1;
      }
      
      public static function center(param1:*) : IntCoord
      {
         var _loc4_:IntCoord = null;
         var _loc2_:IntCoord = new IntCoord();
         var _loc3_:int = 0;
         for each(_loc4_ in param1)
         {
            _loc2_.x = _loc2_.x + _loc4_.x;
            _loc2_.y = _loc2_.y + _loc4_.y;
            _loc3_++;
         }
         return new IntCoord(_loc2_.x / _loc3_,_loc2_.y / _loc3_);
      }
      
      public function unique(param1:* = null, param2:* = null) : int
      {
         if(param1 == null)
         {
            param1 = this.x;
         }
         if(param2 == null)
         {
            param2 = this.y;
         }
         return IntCoord.uniqueVal(param1,param2);
      }
      
      public function toString(param1:int = 0, param2:int = 0) : String
      {
         return "(" + (this.x + param1) + "," + (this.y + param2) + ")";
      }
   }
}
