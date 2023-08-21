package com.midasplayer.engine.playdata
{
   public class LastTickPlayData implements IPlayData
   {
       
      
      private var _tick:int;
      
      private var _finalScore:int;
      
      private var _musicOn:Boolean = true;
      
      private var _soundOn:Boolean = true;
      
      private var _fps:int;
      
      public function LastTickPlayData(param1:int, param2:int, param3:Boolean, param4:Boolean, param5:int)
      {
         super();
         this._tick = param1;
         this._finalScore = param2;
         this._musicOn = param3;
         this._soundOn = param4;
         this._fps = param5;
      }
      
      public function toPlayData() : String
      {
         return PlayDataConstants.LastTick + "|" + this._tick + "|" + this._finalScore + "|" + int(this._musicOn) + "|" + int(this._soundOn) + "|" + this._fps;
      }
      
      public function getTick() : int
      {
         return this._tick;
      }
      
      public function getFinalScore() : int
      {
         return this._finalScore;
      }
      
      public function getMusicOn() : Boolean
      {
         return this._musicOn;
      }
      
      public function getSoundOn() : Boolean
      {
         return this._soundOn;
      }
      
      public function getFps() : int
      {
         return this._fps;
      }
   }
}
