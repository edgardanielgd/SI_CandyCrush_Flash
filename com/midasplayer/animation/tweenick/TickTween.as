package com.midasplayer.animation.tweenick
{
   public class TickTween
   {
       
      
      private var tweens:Object;
      
      private var runningId:int = 1;
      
      private var groups:Object;
      
      public function TickTween()
      {
         this.tweens = [];
         this.groups = [];
         super();
      }
      
      public function add(param1:TTItem) : int
      {
         this.tweens[this.runningId] = param1;
         param1.id = this.runningId;
         var _loc2_:*;
         var _loc3_:* = (_loc2_ = this).runningId + 1;
         _loc2_.runningId = _loc3_;
         return (_loc2_ = this).runningId;
      }
      
      public function remove(param1:int) : Boolean
      {
         if(this.tweens[param1] != undefined)
         {
            delete this.tweens[param1];
            return true;
         }
         if(this.groups[param1] != undefined)
         {
            delete this.groups[param1];
            return true;
         }
         return false;
      }
      
      public function addGroup(param1:TTGroup) : int
      {
         this.groups[this.runningId] = param1;
         param1.id = this.runningId;
         var _loc2_:*;
         var _loc3_:* = (_loc2_ = this).runningId + 1;
         _loc2_.runningId = _loc3_;
         return (_loc2_ = this).runningId;
      }
      
      public function tick(param1:int) : void
      {
         var _loc2_:TTItem = null;
         var _loc3_:Array = null;
         var _loc4_:TTGroup = null;
         for each(_loc2_ in this.tweens)
         {
            if(!_loc2_.done)
            {
               _loc2_.tick(param1);
            }
         }
         _loc3_ = [];
         for each(_loc4_ in this.groups)
         {
            if(Boolean(_loc4_.tick(param1)) || !_loc4_.autoRemove)
            {
               _loc3_[_loc4_.id] = _loc4_;
            }
         }
         this.groups = _loc3_;
      }
      
      public function getTTItem(param1:int) : TTItem
      {
         return this.tweens[param1];
      }
      
      public function getTTGroup(param1:int) : TTItem
      {
         return this.groups[param1];
      }
      
      public function render(param1:Number) : void
      {
         var _loc2_:TTItem = null;
         var _loc3_:TTGroup = null;
         for each(_loc2_ in this.tweens)
         {
            if(!_loc2_.done)
            {
               _loc2_.render(param1);
            }
         }
         for each(_loc3_ in this.groups)
         {
            if(!_loc3_.done)
            {
               _loc3_.render(param1);
            }
         }
      }
   }
}
