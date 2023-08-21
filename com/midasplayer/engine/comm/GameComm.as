package com.midasplayer.engine.comm
{
   import flash.external.ExternalInterface;
   import flash.system.fscommand;
   import flash.utils.setTimeout;
   
   public class GameComm implements IGameComm
   {
       
      
      private const _validator:com.midasplayer.engine.comm.Validator = new com.midasplayer.engine.comm.Validator();
      
      public function GameComm()
      {
         super();
      }
      
      public static function isAvailable() : Boolean
      {
         if(!ExternalInterface.available)
         {
            return false;
         }
         try
         {
            new GameComm().getGameData();
            return true;
         }
         catch(e:Error)
         {
            return false;
         }
      }
      
      public function getGameData() : String
      {
         this._validator.getGameData();
         var _loc1_:Object = ExternalInterface.call("getGameData");
         if(_loc1_ == null)
         {
            throw new Error("The getGameData external interface call returned null.");
         }
         if(_loc1_.success == false)
         {
            throw new Error("The getGameData returned object is not success.");
         }
         if(_loc1_.message == null)
         {
            throw new Error("The GameData returned object has a null message.");
         }
         return _loc1_.message;
      }
      
      public function addPlayData(param1:String) : void
      {
         this._validator.addPlayData(param1);
         ExternalInterface.call("playData",param1);
      }
      
      public function gameStart() : void
      {
         this._validator.gameStart();
         fscommand("gameStart","");
      }
      
      public function gameEnd(param1:int) : void
      {
         this._validator.gameEnd(param1);
         fscommand("gameEnd","" + param1);
      }
      
      public function gameQuit() : void
      {
         this._validator.gameQuit();
         setTimeout(this._quit,2000);
      }
      
      private function _quit() : void
      {
         fscommand("gameQuit","");
      }
   }
}
