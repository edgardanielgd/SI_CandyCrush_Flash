package com.midasplayer.engine.comm
{
   import com.midasplayer.debug.Debug;
   
   public class Validator
   {
      
      public static const NotStarted:int = 0;
      
      public static const Started:int = 1;
      
      public static const Ended:int = 2;
      
      public static const Quited:int = 3;
       
      
      private var _state:int = 0;
      
      public function Validator()
      {
         super();
      }
      
      public function getGameData() : void
      {
         Debug.assert(this._state == NotStarted,"Trying to get game data after the game has sent \'gameStart\'.");
      }
      
      public function addPlayData(param1:String) : void
      {
         Debug.assert(this._state == Started,"Trying to add playdata before the game has been started.");
         Debug.assert(param1 != null,"Trying to add a playdata that is null.");
         Debug.assert(param1.length > 0,"Trying to add an empty playdata string.");
      }
      
      public function gameStart() : void
      {
         Debug.assert(this._state == NotStarted,"Trying to start the game when it\'s already started.");
         this._state = Started;
      }
      
      public function gameEnd(param1:int) : void
      {
         Debug.assert(this._state == Started,"Trying to end a game that is not in the started state.");
         Debug.assert(param1 >= 0,"Ending game with a negative score, is this really correct?");
         this._state = Ended;
      }
      
      public function gameQuit() : void
      {
         Debug.assert(this._state == Ended,"Trying to quit the game before it has been ended.");
         this._state = Quited;
      }
      
      public function getState() : int
      {
         return this._state;
      }
   }
}
