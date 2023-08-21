package com.midasplayer.games.candycrush.board
{
   public interface IDestructionPlan
   {
       
      
      function setup(param1:int) : void;
      
      function tick(param1:int) : void;
      
      function getDestructionItem() : Item;
      
      function getItemsToRemove() : Vector.<Item>;
      
      function isDone() : Boolean;
      
      function scorepopPerItem() : Boolean;
      
      function isImmediate() : Boolean;
      
      function getId() : int;
   }
}
