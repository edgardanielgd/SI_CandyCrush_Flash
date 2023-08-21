package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.games.candycrush.Ticks;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class TickedSprite
   {
       
      
      private var _curTime:Number;
      
      protected const frontsprite:Sprite;
      
      protected const backsprite:Sprite;
      
      protected var firstTick:int;
      
      protected var done:Boolean = false;
      
      protected var canvas:BitmapData;
      
      public function TickedSprite(param1:BitmapData, param2:int)
      {
         this.frontsprite = new Sprite();
         this.backsprite = new Sprite();
         super();
         this.canvas = param1;
         this.firstTick = param2;
         this._curTime = param2;
      }
      
      public static function lerp(param1:Number, param2:Number, param3:Number) : Number
      {
         return param1 + (param2 - param1) * param3;
      }
      
      protected static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public static function getWantedFrame2(param1:Number, param2:Number, param3:int = 0, param4:int = 0) : int
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         _loc5_ = param2 / Ticks.TicksPerSecond;
         _loc6_ = param1 - param3;
         return int(param4 + _loc6_ * _loc5_);
      }
      
      public function addAndRemoveMe() : Boolean
      {
         return false;
      }
      
      public function addAtFront() : Boolean
      {
         return false;
      }
      
      public function addAtBack() : Boolean
      {
         return false;
      }
      
      public function getBackDisplayObject() : DisplayObject
      {
         return this.backsprite;
      }
      
      public function getFrontDisplayObject() : DisplayObject
      {
         return this.frontsprite;
      }
      
      public function tick(param1:int) : void
      {
      }
      
      public function isDone() : Boolean
      {
         return this.done;
      }
      
      public function _renderBack(param1:int, param2:Number) : void
      {
         if(this.done)
         {
            return;
         }
         this._curTime = param1 + param2;
         this.renderBack(param1,param2);
      }
      
      public function _renderFront(param1:int, param2:Number) : void
      {
         if(this.done)
         {
            return;
         }
         this._curTime = param1 + param2;
         this.renderFront(param1,param2);
      }
      
      protected function renderFront(param1:int, param2:Number) : void
      {
      }
      
      protected function renderBack(param1:int, param2:Number) : void
      {
      }
      
      protected function getLivedTicks() : Number
      {
         return this._curTime - this.firstTick;
      }
      
      protected function getLivedShare(param1:Number) : Number
      {
         return this.getLivedTicks() / param1;
      }
      
      protected function getWantedFrame(param1:Number, param2:int = 0, param3:int = 0) : int
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _loc4_ = param1 / Ticks.TicksPerSecond;
         _loc5_ = this.getLivedTicks() - param2;
         return int(param3 + _loc5_ * _loc4_);
      }
   }
}
