package com.midasplayer.games.candycrush.board.match
{
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.input.SwapInfo;
   
   public class Match
   {
       
      
      public var x:int;
      
      public var y:int;
      
      public var west:int;
      
      public var east:int;
      
      public var north:int;
      
      public var south:int;
      
      public var creationItem:Item = null;
      
      public var associatedSwap:SwapInfo = null;
      
      public var patternId:int = -1;
      
      public var color:int;
      
      public function Match(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int = -1)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.west = param3;
         this.east = param4;
         this.north = param5;
         this.south = param6;
         this.color = param7;
      }
      
      public function get width() : int
      {
         return this.east - this.west + 1;
      }
      
      public function get height() : int
      {
         return this.south - this.north + 1;
      }
      
      public function get size() : int
      {
         return this.east + this.south - this.west - this.north + 1;
      }
   }
}
