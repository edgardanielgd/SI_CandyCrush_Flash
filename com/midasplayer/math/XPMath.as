package com.midasplayer.math
{
   public class XPMath
   {
       
      
      public function XPMath()
      {
         super();
      }
      
      public static function atan2(param1:Number, param2:Number) : Number
      {
         var _loc5_:Number = NaN;
         var _loc3_:Number = 3.141592653589793;
         var _loc4_:Number = 1.570796326794896;
         if(param2 == 0)
         {
            if(param1 > 0)
            {
               return _loc4_;
            }
            if(param1 == 0)
            {
               return 0;
            }
            return -_loc4_;
         }
         var _loc6_:Number = param1 / param2;
         if(Math.abs(_loc6_) < 1)
         {
            _loc5_ = _loc6_ / (1 + 0.28 * _loc6_ * _loc6_);
            if(param2 < 0)
            {
               if(param1 < 0)
               {
                  return _loc5_ - _loc3_;
               }
               return _loc5_ + _loc3_;
            }
         }
         else
         {
            _loc5_ = _loc4_ - _loc6_ / (_loc6_ * _loc6_ + 0.28);
            if(param1 < 0)
            {
               return _loc5_ - _loc3_;
            }
         }
         return _loc5_;
      }
      
      public static function cos(param1:Number) : Number
      {
         var _loc2_:int = 0;
         var _loc3_:Number = param1 > 0 ? param1 : -param1;
         var _loc4_:Number = 1.570796326794897;
         if(_loc3_ >= 12.56637061435917 + _loc4_)
         {
            _loc2_ = int(_loc3_ * 0.6366197723675814);
            if((_loc2_ & 1) != 0)
            {
               _loc2_++;
            }
            _loc3_ -= _loc2_ * _loc4_;
         }
         else if(_loc3_ >= _loc4_)
         {
            if(_loc3_ < _loc4_ + 3.141592653589793)
            {
               _loc3_ -= 3.141592653589793;
               _loc2_ = 2;
            }
            else if(_loc3_ < 6.283185307179586 + _loc4_)
            {
               _loc3_ -= 6.283185307179586;
            }
            else if(_loc3_ < 9.42477796076938 + _loc4_)
            {
               _loc3_ -= 9.42477796076938;
               _loc2_ = 2;
            }
            else
            {
               _loc3_ -= 12.56637061435917;
            }
         }
         var _loc5_:Number = _loc3_ * _loc3_;
         var _loc6_:Number = 0.9999999530275124 + _loc5_ * (-0.4999990477779212 + _loc5_ * (0.04166357316018797 + _loc5_ * (-0.0013853629536173 + _loc5_ * 0.0000231524166599385)));
         return (_loc2_ & 2) != 0 ? -_loc6_ : _loc6_;
      }
      
      public static function sin(param1:Number) : Number
      {
         param1 -= 1.570796326794897;
         var _loc2_:int = 0;
         var _loc3_:Number = param1 > 0 ? param1 : -param1;
         if(_loc3_ >= 12.56637061435917 + 1.570796326794897)
         {
            _loc2_ = int(_loc3_ * 0.6366197723675814);
            if((_loc2_ & 1) != 0)
            {
               _loc2_++;
            }
            _loc3_ -= _loc2_ * 1.570796326794897;
         }
         else if(_loc3_ >= 1.570796326794897)
         {
            if(_loc3_ < 1.570796326794897 + 3.141592653589793)
            {
               _loc3_ -= 3.141592653589793;
               _loc2_ = 2;
            }
            else if(_loc3_ < 6.283185307179586 + 1.570796326794897)
            {
               _loc3_ -= 6.283185307179586;
            }
            else if(_loc3_ < 9.42477796076938 + 1.570796326794897)
            {
               _loc3_ -= 9.42477796076938;
               _loc2_ = 2;
            }
            else
            {
               _loc3_ -= 12.56637061435917;
            }
         }
         var _loc4_:Number = _loc3_ * _loc3_;
         var _loc5_:Number = 0.9999999530275124 + _loc4_ * (-0.4999990477779212 + _loc4_ * (0.04166357316018797 + _loc4_ * (-0.0013853629536173 + _loc4_ * 0.0000231524166599385)));
         return (_loc2_ & 2) != 0 ? -_loc5_ : _loc5_;
      }
   }
}
