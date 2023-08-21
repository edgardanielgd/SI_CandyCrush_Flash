package com.midasplayer.engine.comm
{
   public class DebugGameComm implements IGameComm
   {
       
      
      private var _gameData:String;
      
      private const _playDatas:Vector.<String> = new Vector.<String>();
      
      private const _validator:com.midasplayer.engine.comm.Validator = new com.midasplayer.engine.comm.Validator();
      
      public function DebugGameComm(param1:String)
      {
         super();
         this._gameData = param1;
      }
      
      public function getGameData() : String
      {
         this._validator.getGameData();
         return this._gameData;
      }
      
      public function addPlayData(param1:String) : void
      {
         this._validator.addPlayData(param1);
         this._playDatas.push(param1);
      }
      
      public function gameStart() : void
      {
         this._validator.gameStart();
      }
      
      public function gameEnd(param1:int) : void
      {
         this._validator.gameEnd(param1);
      }
      
      public function gameQuit() : void
      {
         this._validator.gameQuit();
      }
      
      public function getPlayDatas() : Vector.<String>
      {
         return this._playDatas;
      }
      
      public function getValidatorState() : int
      {
         return this._validator.getState();
      }
   }
}
