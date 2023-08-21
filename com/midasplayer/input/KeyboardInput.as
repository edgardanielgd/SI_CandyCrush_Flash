package com.midasplayer.input
{
   import com.midasplayer.debug.Debug;
   
   public class KeyboardInput
   {
       
      
      private const _keysPressed:Vector.<int> = new Vector.<int>();
      
      private const _keysReleased:Vector.<int> = new Vector.<int>();
      
      public function KeyboardInput()
      {
         super();
      }
      
      public function reset() : void
      {
         this._keysPressed.length = 0;
         this._keysReleased.length = 0;
      }
      
      public function setPressed(param1:int) : void
      {
         Debug.assert(param1 > 0,"Expected a positive key code press.");
         this._keysPressed.push(param1);
      }
      
      public function setReleased(param1:int) : void
      {
         Debug.assert(param1 > 0,"Expected a positive key code release.");
         this._keysReleased.push(param1);
      }
      
      public function isReleased(param1:int) : Boolean
      {
         return this._keysReleased.indexOf(param1) != -1;
      }
      
      public function isPressed(param1:int) : Boolean
      {
         return this._keysPressed.indexOf(param1) != -1;
      }
   }
}
