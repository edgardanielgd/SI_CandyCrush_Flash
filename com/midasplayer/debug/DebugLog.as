package com.midasplayer.debug
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class DebugLog extends Sprite
   {
       
      
      private var numLines:int;
      
      private var lines:Array;
      
      private var tf:TextField;
      
      public function DebugLog(param1:int = 10)
      {
         this.lines = [];
         this.tf = new TextField();
         super();
         this.numLines = param1;
         this.tf.defaultTextFormat = new TextFormat("courier new",12);
         this.tf.multiline = true;
         var _loc2_:int = 200;
         var _loc3_:int = int(int(param1 * 15.5));
         this.tf.width = _loc2_;
         this.tf.height = _loc3_;
         graphics.beginFill(10066329,0.75);
         graphics.drawRect(0,0,_loc2_,_loc3_);
         graphics.endFill();
         mouseEnabled = mouseChildren = false;
         addChild(this.tf);
         alpha = 0.7;
      }
      
      public function trace(param1:String, param2:Boolean = true) : void
      {
         if(this.lines.length == this.numLines)
         {
            this.lines.shift();
         }
         this.lines.push(param1);
         this.tf.text = this.toString();
      }
      
      override public function toString() : String
      {
         return this.lines.join("\n");
      }
   }
}
