package com.midasplayer.input
{
   import com.midasplayer.math.Vec2;
   
   public final class MouseInput
   {
       
      
      private const _pos:Vec2 = new Vec2();
      
      private const _pressPos:Vec2 = new Vec2();
      
      private const _releasePos:Vec2 = new Vec2();
      
      private var _hasPos:Boolean = false;
      
      private var _isPressed:Boolean = false;
      
      private var _isReleased:Boolean = false;
      
      private var _isDown:Boolean = false;
      
      public function MouseInput()
      {
         super();
      }
      
      public function reset() : void
      {
         this._isPressed = false;
         this._isReleased = false;
         this._hasPos = false;
      }
      
      public function setPosition(param1:Vec2) : void
      {
         this._hasPos = true;
         this._pos.copy(param1);
      }
      
      public function setPressed(param1:Vec2) : void
      {
         this._isPressed = true;
         this._isDown = true;
         this._pressPos.copy(param1);
      }
      
      public function setReleased(param1:Vec2) : void
      {
         this._isReleased = true;
         this._isDown = false;
         this._releasePos.copy(param1);
      }
      
      public function hasPosition() : Boolean
      {
         return this._hasPos;
      }
      
      public function isPressed() : Boolean
      {
         return this._isPressed;
      }
      
      public function isReleased() : Boolean
      {
         return this._isReleased;
      }
      
      public function isDown() : Boolean
      {
         return this._isDown;
      }
      
      public function getPosition() : Vec2
      {
         return this._pos;
      }
      
      public function getPressPosition() : Vec2
      {
         return this._pressPos;
      }
      
      public function getReleasePosition() : Vec2
      {
         return this._releasePos;
      }
   }
}
