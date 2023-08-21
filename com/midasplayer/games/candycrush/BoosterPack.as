package com.midasplayer.games.candycrush
{
   import com.midasplayer.engine.GameDataParser;
   
   public class BoosterPack
   {
       
      
      public var numSecondsToAdd:int;
      
      public var isHintActive:Boolean;
      
      public var numColorBombs:int;
      
      public var startAtLevel:int;
      
      public var numWrappedStripe:int;
      
      public function BoosterPack(param1:int = 0, param2:Boolean = false, param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.numSecondsToAdd = param1;
         this.isHintActive = param2;
         this.numColorBombs = param3;
         this.startAtLevel = param4;
         this.numWrappedStripe = param5;
      }
      
      public static function fromGameData(param1:GameDataParser) : BoosterPack
      {
         return new BoosterPack(param1.getAsBool("booster_1") ? 10 : 0,param1.getAsBool("booster_2"),param1.getAsBool("booster_3") ? 1 : 0,param1.getAsBool("booster_4") ? 2 : 0,param1.getAsBool("booster_5") ? 1 : 0);
      }
   }
}
