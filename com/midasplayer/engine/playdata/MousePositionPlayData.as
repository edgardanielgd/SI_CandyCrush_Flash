package com.midasplayer.engine.playdata
{
   import com.midasplayer.input.MouseInput;
   import com.midasplayer.math.Vec2;
   
   public class MousePositionPlayData implements IExecutablePlayData
   {
       
      
      private var _x:int;
      
      private var _y:int;
      
      private var _tick:int;
      
      private var _input:MouseInput;
      
      public function MousePositionPlayData(param1:int, param2:int, param3:int, param4:MouseInput)
      {
         super();
         this._tick = param1;
         this._x = param2;
         this._y = param3;
         this._input = param4;
      }
      
      public function getTick() : int
      {
         return this._tick;
      }
      
      public function execute() : void
      {
         this._input.setPosition(new Vec2(this._x,this._y));
      }
      
      public function toPlayData() : String
      {
         return PlayDataConstants.MousePosition + "|" + this._tick + "|" + this._x + "|" + this._y;
      }
   }
}
