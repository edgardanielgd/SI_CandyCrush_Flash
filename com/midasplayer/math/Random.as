package com.midasplayer.math
{
   public class Random
   {
       
      
      private var _mtRandom:com.midasplayer.math.MtRandom;
      
      public function Random(param1:com.midasplayer.math.MtRandom = null)
      {
         super();
         if(param1 == null)
         {
            param1 = new com.midasplayer.math.MtRandom(new Date().getTime());
         }
         this._mtRandom = param1;
      }
      
      public static function exclude(param1:Array, param2:Array) : Array
      {
         var _loc5_:int = 0;
         var _loc3_:Array = param1.concat();
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            if((_loc5_ = int(_loc3_.indexOf(param2[_loc4_]))) >= 0)
            {
               _loc3_.splice(_loc5_,1);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function getMt() : com.midasplayer.math.MtRandom
      {
         return this._mtRandom;
      }
      
      public function getIntBetween(param1:int, param2:int) : int
      {
         var _loc3_:int = param2 - param1;
         return param1 + this._mtRandom.nextInt(_loc3_);
      }
      
      public function arrayChoice(param1:Array) : *
      {
         return param1[this._mtRandom.nextInt(param1.length)];
      }
      
      public function sample(param1:Array, param2:int) : Array
      {
         var _loc3_:Array = param1.concat();
         this.shuffle(_loc3_);
         _loc3_.splice(param2);
         return _loc3_;
      }
      
      public function choiceExclude(param1:Array, param2:Array) : *
      {
         return this.arrayChoice(exclude(param1,param2));
      }
      
      public function shuffle(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc2_:int = int(param1.length);
         while(--_loc2_ != 0)
         {
            _loc3_ = int(this._mtRandom.nextInt(_loc2_ + 1));
            _loc4_ = param1[_loc2_];
            param1[_loc2_] = param1[_loc3_];
            param1[_loc3_] = _loc4_;
         }
      }
   }
}
