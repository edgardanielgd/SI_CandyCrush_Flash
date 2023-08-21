package com.midasplayer.animation.tweenick
{
   public class TTFunctionCall extends TTDummy
   {
       
      
      private var func:Function;
      
      private var called:Boolean = false;
      
      public function TTFunctionCall(param1:int, param2:Function)
      {
         this.func = param2;
         super(param1);
      }
      
      override public function tick(param1:int) : Boolean
      {
         var _loc2_:Boolean = super.tick(param1);
         if(!_loc2_)
         {
            if(!this.called)
            {
               this.func();
               this.called = true;
            }
         }
         return _loc2_;
      }
   }
}
