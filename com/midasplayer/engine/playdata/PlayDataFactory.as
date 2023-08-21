package com.midasplayer.engine.playdata
{
   import com.midasplayer.debug.Debug;
   import com.midasplayer.input.KeyboardInput;
   import com.midasplayer.input.MouseInput;
   
   public class PlayDataFactory implements IPlayDataFactory
   {
       
      
      private var _mouseInput:MouseInput;
      
      private var _keyboardInput:KeyboardInput;
      
      public function PlayDataFactory(param1:MouseInput, param2:KeyboardInput)
      {
         super();
         this._mouseInput = param1;
         this._keyboardInput = param2;
      }
      
      public function create(param1:String) : IPlayData
      {
         var _loc2_:Array = null;
         _loc2_ = param1.split("|");
         Debug.assert(_loc2_.length > 0,"Found no arguments in a playdata.");
         var _loc3_:int = this._toInt(_loc2_[0]);
         if(_loc3_ == PlayDataConstants.MousePosition)
         {
            Debug.assert(_loc2_.length == 4,"Expected 4 parameters in mouse position playdata.");
            return new MousePositionPlayData(this._toInt(_loc2_[1]),this._toInt(_loc2_[2]),this._toInt(_loc2_[3]),this._mouseInput);
         }
         if(_loc3_ == PlayDataConstants.MousePressed)
         {
            Debug.assert(_loc2_.length == 4,"Expected 4 parameters in mouse press playdata.");
            return new MousePressPlayData(this._toInt(_loc2_[1]),this._toInt(_loc2_[2]),this._toInt(_loc2_[3]),this._mouseInput);
         }
         if(_loc3_ == PlayDataConstants.MouseReleased)
         {
            Debug.assert(_loc2_.length == 4,"Expected 4 parameters in mouse release playdata.");
            return new MouseReleasePlayData(this._toInt(_loc2_[1]),this._toInt(_loc2_[2]),this._toInt(_loc2_[3]),this._mouseInput);
         }
         if(_loc3_ == PlayDataConstants.KeyPressed)
         {
            Debug.assert(_loc2_.length == 3,"Expected 3 parameters for key pressed playdata.");
            return new KeyPressedPlayData(this._toInt(_loc2_[1]),this._toInt(_loc2_[2]),this._keyboardInput);
         }
         if(_loc3_ == PlayDataConstants.KeyReleased)
         {
            Debug.assert(_loc2_.length == 3,"Expected 3 parameters for key released playdata.");
            return new KeyReleasedPlayData(this._toInt(_loc2_[1]),this._toInt(_loc2_[2]),this._keyboardInput);
         }
         if(_loc3_ == PlayDataConstants.LastTick)
         {
            Debug.assert(_loc2_.length == 6,"Expected 6 parameters in last tick playdata.");
            return new LastTickPlayData(this._toInt(_loc2_[1]),this._toInt(_loc2_[2]),_loc2_[3] == "1",_loc2_[4] == "1",_loc2_[5]);
         }
         if(_loc3_ == PlayDataConstants.Log)
         {
            Debug.assert(_loc2_.length == 2,"Expected 2 parameters for log playdata.");
            return new LogPlayData(_loc2_[1]);
         }
         Debug.assert(false,"Unknown play data string (" + param1 + ")");
         return null;
      }
      
      private function _toInt(param1:String) : int
      {
         var _loc2_:Number = NaN;
         _loc2_ = Number(parseInt(param1));
         Debug.assert(!isNaN(_loc2_),"Could not parse a play data argument as int \'" + _loc2_ + "\'");
         var _loc3_:int = int(int(_loc2_));
         Debug.assert(_loc2_ == _loc3_,"Trying to parse a play data argument from a number with decimals to int \'" + _loc2_ + "\'");
         return _loc3_;
      }
   }
}
