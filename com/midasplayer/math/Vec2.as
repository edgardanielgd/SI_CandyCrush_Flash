package com.midasplayer.math
{
   public class Vec2
   {
      
      public static const Epsilon:Number = 1e-7;
      
      public static const EpsilonSqr:Number = Epsilon * Epsilon;
      
      private static const _RadsToDeg:Number = 180 / Math.PI;
       
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public function Vec2(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.x = param1;
         this.y = param2;
      }
      
      public function equals(param1:Vec2) : Boolean
      {
         return this.x == param1.x && this.y == param1.y;
      }
      
      public function equalsXY(param1:Number, param2:Number) : Boolean
      {
         return this.x == param1 && this.y == param2;
      }
      
      public function copy(param1:Vec2) : void
      {
         this.x = param1.x;
         this.y = param1.y;
      }
      
      public function copyXY(param1:Number, param2:Number) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function add(param1:Vec2) : Vec2
      {
         return new Vec2(this.x + param1.x,this.y + param1.y);
      }
      
      public function sub(param1:Vec2) : Vec2
      {
         return new Vec2(this.x - param1.x,this.y - param1.y);
      }
      
      public function mul(param1:Vec2) : Vec2
      {
         return new Vec2(this.x * param1.x,this.y * param1.y);
      }
      
      public function div(param1:Vec2) : Vec2
      {
         return new Vec2(this.x / param1.x,this.y / param1.y);
      }
      
      public function addSelf(param1:Vec2) : void
      {
         this.x = this.x + param1.x;
         this.y = this.y + param1.y;
      }
      
      public function subSelf(param1:Vec2) : void
      {
         this.x = this.x - param1.x;
         this.y = this.y - param1.y;
      }
      
      public function mulSelf(param1:Vec2) : void
      {
         this.x = this.x * param1.x;
         this.y = this.y * param1.y;
      }
      
      public function divSelf(param1:Vec2) : void
      {
         this.x = this.x / param1.x;
         this.y = this.y / param1.y;
      }
      
      public function addXY(param1:Number, param2:Number) : Vec2
      {
         return new Vec2(this.x + param1,this.y + param2);
      }
      
      public function subXY(param1:Number, param2:Number) : Vec2
      {
         return new Vec2(this.x - param1,this.y - param2);
      }
      
      public function addXYSelf(param1:Number, param2:Number) : void
      {
         this.x = this.x + param1;
         this.y = this.y + param2;
      }
      
      public function subXYSelf(param1:Number, param2:Number) : void
      {
         this.x = this.x - param1;
         this.y = this.y - param2;
      }
      
      public function dot(param1:Vec2) : Number
      {
         return this.x * param1.x + this.y * param1.y;
      }
      
      public function dotXY(param1:Number, param2:Number) : Number
      {
         return this.x * param1 + this.y * param2;
      }
      
      public function scale(param1:Number) : Vec2
      {
         return new Vec2(this.x * param1,this.y * param1);
      }
      
      public function scaleSelf(param1:Number) : void
      {
         this.x = this.x * param1;
         this.y = this.y * param1;
      }
      
      public function get length() : Number
      {
         return Math.sqrt(this.x * this.x + this.y * this.y);
      }
      
      public function get lengthSqr() : Number
      {
         return this.x * this.x + this.y * this.y;
      }
      
      public function distance(param1:Vec2) : Number
      {
         var _loc2_:Number = this.x - param1.x;
         var _loc3_:Number = this.y - param1.y;
         return Math.sqrt(_loc2_ * _loc2_ + _loc3_ * _loc3_);
      }
      
      public function distanceSqr(param1:Vec2) : Number
      {
         var _loc2_:Number = this.x - param1.x;
         var _loc3_:Number = this.y - param1.y;
         return _loc2_ * _loc2_ + _loc3_ * _loc3_;
      }
      
      public function normalize() : Vec2
      {
         var _loc1_:Number = 1 / Math.sqrt(this.x * this.x + this.y * this.y);
         return new Vec2(this.x * _loc1_,this.y * _loc1_);
      }
      
      public function normalizeSelf() : void
      {
         var _loc1_:Number = 1 / Math.sqrt(this.x * this.x + this.y * this.y);
         this.x = this.x * _loc1_;
         this.y = this.y * _loc1_;
      }
      
      public function isNormalized() : Boolean
      {
         return Math.abs(1 - (this.x * this.x + this.y * this.y)) < Vec2.EpsilonSqr;
      }
      
      public function isValid() : Boolean
      {
         return this.x != Infinity && this.x != -Infinity && this.y != Infinity && this.y != -Infinity && !isNaN(this.x) && !isNaN(this.y);
      }
      
      public function isNear(param1:Vec2) : Boolean
      {
         return this.distanceSqr(param1) < EpsilonSqr;
      }
      
      public function clone() : Vec2
      {
         return new Vec2(this.x,this.y);
      }
      
      public function normalRight() : Vec2
      {
         return new Vec2(-this.y,this.x);
      }
      
      public function normalLeft() : Vec2
      {
         return new Vec2(this.y,-this.x);
      }
      
      public function normalRightSelf() : void
      {
         var _loc1_:Number = this.x;
         this.x = -this.y;
         this.y = _loc1_;
      }
      
      public function normalLeftSelf() : void
      {
         var _loc1_:Number = this.x;
         this.x = this.y;
         this.y = -_loc1_;
      }
      
      public function negate() : Vec2
      {
         return new Vec2(-this.x,-this.y);
      }
      
      public function negateSelf() : void
      {
         this.x = -this.x;
         this.y = -this.y;
      }
      
      public function crossDet(param1:Vec2) : Number
      {
         return this.x * param1.y - param1.x * this.y;
      }
      
      public function crossDetXY(param1:Number, param2:Number) : Number
      {
         return this.x * param2 - param1 * this.y;
      }
      
      public function rotate(param1:Number) : Vec2
      {
         var _loc2_:Number = XPMath.cos(param1);
         var _loc3_:Number = XPMath.sin(param1);
         return new Vec2(_loc2_ * this.x - _loc3_ * this.y,_loc3_ * this.x + _loc2_ * this.y);
      }
      
      public function rotateSelf(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         _loc2_ = XPMath.cos(param1);
         _loc3_ = XPMath.sin(param1);
         var _loc4_:Number = _loc2_ * this.x - _loc3_ * this.y;
         this.y = _loc3_ * this.x + _loc2_ * this.y;
         this.x = _loc4_;
      }
      
      public function rotateComplex(param1:Vec2) : Vec2
      {
         return new Vec2(this.x * param1.x - this.y * param1.y,this.x * param1.y + this.y * param1.x);
      }
      
      public function rotateComplexSelf(param1:Vec2) : void
      {
         var _loc2_:Number = this.x * param1.x - this.y * param1.y;
         this.y = this.x * param1.y + this.y * param1.x;
         this.x = _loc2_;
      }
      
      public function reflect(param1:Vec2) : Vec2
      {
         var _loc2_:Vec2 = null;
         _loc2_ = param1.normalize();
         var _loc3_:Number = this.dot(_loc2_);
         return _loc2_.scale(2 * _loc3_).sub(this);
      }
      
      public function lerp(param1:Vec2, param2:Number) : Vec2
      {
         return new Vec2(this.x + (param1.x - this.x) * param2,this.y + (param1.y - this.y) * param2);
      }
      
      public function slerp(param1:Vec2, param2:Number) : Vec2
      {
         var _loc4_:Number = NaN;
         var _loc3_:Number = this.dot(param1);
         if(_loc3_ > 1 - Epsilon)
         {
            return param1.clone();
         }
         if(_loc3_ < -1 + Epsilon)
         {
            return this.lerp(param1,param2);
         }
         _loc4_ = Math.abs(Math.acos(_loc3_));
         var _loc5_:Number = XPMath.sin(_loc4_);
         var _loc6_:Number = XPMath.sin(_loc4_ * param2);
         var _loc7_:Number = XPMath.sin((1 - param2) * _loc4_);
         return new Vec2((this.x * _loc7_ + param1.x * _loc6_) / _loc5_,(this.y * _loc7_ + param1.y * _loc6_) / _loc5_);
      }
      
      public function cwDegreesBetween(param1:Vec2) : Number
      {
         return this.cwRadiansBetween(param1) * _RadsToDeg;
      }
      
      public function cwRadiansBetween(param1:Vec2) : Number
      {
         var _loc2_:Number = XPMath.atan2(this.crossDet(param1),this.dot(param1));
         return _loc2_ >= 0 ? _loc2_ : 2 * Math.PI + _loc2_;
      }
      
      public function toString() : String
      {
         return "(" + this.x + ", " + this.y + ")";
      }
   }
}
