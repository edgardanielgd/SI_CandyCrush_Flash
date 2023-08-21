package com.midasplayer.animation.tweenick
{
   public class TTItem
   {
       
      
      private var fp:Function;
      
      public var item;
      
      public var arg:String;
      
      private var dstTicks:int;
      
      private var curTicks:int = -1;
      
      public var delay:int = 0;
      
      private var mode:int;
      
      public var done:Boolean;
      
      public var groupImportant:Boolean = true;
      
      public var id:int = 195936478;
      
      public var data:com.midasplayer.animation.tweenick.TTData;
      
      private var start_:Number;
      
      private var stop_:Number;
      
      public function TTItem(param1:*, param2:int, param3:String, param4:Number, param5:Object = null)
      {
         this.fp = TTEasing.Linear;
         super();
         this.item = param1;
         this.arg = param3;
         this.dstTicks = param2;
         this.start_ = param1[param3];
         this.stop_ = param4;
         var _loc6_:Number = this.start_;
         if(param5)
         {
            if(param5["mode"] != undefined)
            {
               this.mode = param5["mode"];
            }
            if(param5["easing"] != undefined)
            {
               this.fp = param5["easing"];
            }
            if(param5["start"] != undefined)
            {
               _loc6_ = Number(param5["start"]);
            }
            if(param5["groupImportant"] != undefined)
            {
               this.groupImportant = param5["groupImportant"];
            }
            if(param5["delay"] != undefined)
            {
               this.delay = param5["delay"];
            }
         }
         this.data = new com.midasplayer.animation.tweenick.TTData(this.dstTicks,_loc6_,this.stop_);
         this.done = TTMode.STOP == this.mode && param2 <= 0;
      }
      
      public function tick(param1:int) : Boolean
      {
         var _loc2_:*;
         var _loc3_:* = (_loc2_ = this).curTicks + 1;
         _loc2_.curTicks = _loc3_;
         if(this.curTicks >= this.dstTicks && (this.mode & 31) == TTMode.STOP)
         {
            if(this.mode & TTMode.RETURN_HOME)
            {
               this.item[this.arg] = this.start_;
            }
            else
            {
               this.item[this.arg] = this.stop_;
            }
            this.done = true;
         }
         return !this.done;
      }
      
      public function render(param1:Number) : void
      {
         if(this.curTicks < 0)
         {
            return;
         }
         this.data.curTicks = this.curTicks + param1;
         if(this.curTicks < this.dstTicks || this.mode == TTMode.CONTINUE)
         {
            this.item[this.arg] = this.fp(this.data);
         }
         else if(this.mode == TTMode.REPEAT)
         {
            this.data.curTicks = this.curTicks % this.dstTicks + param1;
            this.item[this.arg] = this.fp(this.data);
         }
      }
   }
}
