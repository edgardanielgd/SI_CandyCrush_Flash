package com.midasplayer.games.candycrush.utils
{
   import flash.display.MovieClip;
   
   public class CustomFrameAnimation extends MCAnimation
   {
       
      
      protected var nframe:int = -1;
      
      protected var frames:Array;
      
      protected var wrap:Boolean;
      
      protected var frameCount:int;
      
      public function CustomFrameAnimation(param1:MovieClip, param2:Array, param3:Boolean = true, param4:int = 0)
      {
         this.frames = [];
         super(param1);
         this.wrap = param3;
         this.frameCount = param2.length;
         var _loc5_:int = 0;
         while(_loc5_ < this.frameCount)
         {
            this.frames.push(param2[_loc5_] + param4);
            _loc5_++;
         }
         this.frame = 0;
      }
      
      override public function set frame(param1:int) : void
      {
         var _loc2_:int = param1;
         if(_loc2_ != this.nframe)
         {
            super.frame = this.getRawFrame(_loc2_);
            this.nframe = _loc2_;
         }
      }
      
      override public function get frame() : int
      {
         return this.nframe;
      }
      
      public function getRawFrame(param1:int = -1) : int
      {
         if(param1 >= this.frameCount)
         {
            param1 = this.wrap ? int(param1 % this.frameCount) : this.frameCount - 1;
         }
         return this.frames[param1 < 0 ? this.nframe : param1];
      }
      
      public function frameEquals(param1:int) : Boolean
      {
         return this.frames[this.nframe] == param1;
      }
      
      public function getFrameCount() : int
      {
         return this.frameCount;
      }
   }
}
