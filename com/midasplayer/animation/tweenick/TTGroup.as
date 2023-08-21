package com.midasplayer.animation.tweenick
{
   public class TTGroup
   {
       
      
      private var _done:Boolean = true;
      
      private var tweens:Array;
      
      public var autoRemove:Boolean = true;
      
      public var id:int = 195936478;
      
      public function TTGroup()
      {
         this.tweens = [];
         super();
      }
      
      public function tick(param1:int) : Boolean
      {
         var _loc2_:TTItem = null;
         for each(_loc2_ in this.tweens)
         {
            if(!_loc2_.done)
            {
               var _loc5_:*;
               var _loc6_:* = (_loc5_ = _loc2_).delay - 1;
               _loc5_.delay = _loc6_;
               if(_loc2_.delay < 0)
               {
                  _loc2_.tick(param1);
               }
            }
         }
         this._done = true;
         for each(_loc2_ in this.tweens)
         {
            if(!_loc2_.done && _loc2_.groupImportant)
            {
               this._done = false;
            }
         }
         return !this._done;
      }
      
      public function add(param1:TTItem) : void
      {
         this.tweens.push(param1);
         this._done = this._done && param1.done;
      }
      
      public function addInTicks(param1:int, param2:TTItem, param3:Boolean = false) : void
      {
         param2.delay = param1;
         this.add(param2);
      }
      
      public function render(param1:Number) : void
      {
         var _loc2_:TTItem = null;
         for each(_loc2_ in this.tweens)
         {
            if(!_loc2_.done)
            {
               _loc2_.render(param1);
            }
         }
      }
      
      public function get done() : Boolean
      {
         return this._done;
      }
      
      public function get empty() : Boolean
      {
         return this.tweens.length == 0;
      }
      
      public function toString() : String
      {
         return "TTGroup. Done/Autoremove: " + this._done + "/" + this.autoRemove + ". Id " + this.id + " (size " + this.tweens.length + ")";
      }
   }
}
