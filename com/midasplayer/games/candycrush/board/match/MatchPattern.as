package com.midasplayer.games.candycrush.board.match
{
   public class MatchPattern
   {
       
      
      private var _w:int;
      
      private var _h:int;
      
      private var _transposable:Boolean;
      
      private var _id:int;
      
      public function MatchPattern(param1:int, param2:int, param3:int, param4:Boolean)
      {
         super();
         this._w = param2;
         this._h = param3;
         this._transposable = param4;
         this._id = param1;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function isMatch(param1:Match) : Boolean
      {
         return param1.width >= this._w && param1.height >= this._h || this._transposable && param1.height >= this._w && param1.width >= this._h;
      }
   }
}
