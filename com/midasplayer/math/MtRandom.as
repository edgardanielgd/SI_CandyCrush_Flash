package com.midasplayer.math
{
   import flash.utils.getTimer;
   
   public class MtRandom
   {
      
      public static var N:int = 624;
      
      public static var M:int = 397;
      
      public static var MATRIX_A:uint = 2567483615;
      
      public static var UPPER_MASK:uint = 2147483648;
      
      public static var LOWER_MASK:uint = 2147483647;
      
      private static var mag01:Array = [uint(0),uint(MATRIX_A)];
       
      
      private var mt:Array;
      
      private var mti:uint;
      
      private var _seed:uint;
      
      public function MtRandom(param1:uint = 0)
      {
         this.mti = N + 1;
         super();
         if(param1 == 0)
         {
            param1 = uint(getTimer());
         }
         this.mt = new Array(N);
         this.setSeed(param1);
      }
      
      public function getSeed() : uint
      {
         return this._seed;
      }
      
      public function setSeed(param1:uint) : void
      {
         this._seed = param1;
         this.init_genrand(param1);
      }
      
      public function nextInt(param1:uint) : uint
      {
         return (this.genrand_int32() & 2147483647) % param1;
      }
      
      public function nextFloat() : Number
      {
         return this.next(24) / 16777216;
      }
      
      public function nextDouble() : Number
      {
         return this.next(24) / 16777216;
      }
      
      private function next(param1:uint) : uint
      {
         return this.genrand_int32() & (uint(1) << param1) - uint(1);
      }
      
      private function init_genrand(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.mt[0] = uint(param1);
         this.mti = 1;
         while(this.mti < N)
         {
            _loc2_ = uint(this.mt[this.mti - 1] ^ this.mt[this.mti - 1] >>> 30);
            _loc3_ = uint(uint(_loc2_ * 1289));
            _loc3_ = uint(uint(_loc3_ * 1406077));
            _loc3_ = uint(uint(_loc3_ + this.mti));
            this.mt[this.mti] = _loc3_;
            var _loc4_:*;
            var _loc5_:* = (_loc4_ = this).mti + 1;
            _loc4_.mti = _loc5_;
         }
      }
      
      private function genrand_int32() : uint
      {
         var _loc1_:Number = NaN;
         var _loc2_:uint = 0;
         if(this.mti >= N)
         {
            if(this.mti == N + 1)
            {
               this.init_genrand(5489);
            }
            _loc2_ = 0;
            while(_loc2_ < N - M)
            {
               _loc1_ = this.mt[_loc2_] & UPPER_MASK | this.mt[_loc2_ + 1] & LOWER_MASK;
               this.mt[_loc2_] = this.mt[_loc2_ + M] ^ _loc1_ >>> 1 ^ mag01[uint(_loc1_ & 1)];
               _loc2_++;
            }
            while(_loc2_ < N - 1)
            {
               _loc1_ = this.mt[_loc2_] & UPPER_MASK | this.mt[_loc2_ + 1] & LOWER_MASK;
               this.mt[_loc2_] = this.mt[_loc2_ + (M - N)] ^ _loc1_ >>> 1 ^ mag01[uint(_loc1_ & 1)];
               _loc2_++;
            }
            _loc1_ = this.mt[N - 1] & UPPER_MASK | this.mt[0] & LOWER_MASK;
            this.mt[N - 1] = this.mt[M - 1] ^ _loc1_ >>> 1 ^ mag01[uint(_loc1_ & 1)];
            this.mti = 0;
         }
         var _loc3_:*;
         var _loc4_:* = (_loc3_ = this).mti + 1;
         _loc3_.mti = _loc4_;
         _loc1_ = Number(this.mt[(_loc3_ = this).mti]);
         _loc1_ ^= _loc1_ >>> 11;
         _loc1_ ^= _loc1_ << 7 & 2636928640;
         _loc1_ ^= _loc1_ << 15 & 4022730752;
         _loc1_ ^= _loc1_ >>> 18;
         return uint(_loc1_);
      }
   }
}
