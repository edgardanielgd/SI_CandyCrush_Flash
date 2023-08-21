package com.midasplayer.engine.playdata
{
   public class LogPlayData implements IPlayData
   {
       
      
      private var _message:String;
      
      public function LogPlayData(param1:String)
      {
         super();
         this._message = param1.replace(/\|//g,"_");
      }
      
      public function getMessage() : String
      {
         return this._message;
      }
      
      public function toPlayData() : String
      {
         return PlayDataConstants.Log + "|" + this._message;
      }
   }
}
