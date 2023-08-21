package com.midasplayer.games.candycrush
{
   import com.midasplayer.games.candycrush.board.Item;
   
   public class ItemType
   {
      
      public static const NONE:int = 0;
      
      public static const COLOR:int = 32;
      
      public static const LINE:int = 16;
      
      public static const WRAP:int = 8;
      
      public static const COLUMN:int = 128;
      
      public static const MIX_COLOR_LINE:int = 555;
      
      public static const MIX_LINE_WRAP:int = 777;
      
      public static const MIX_COLOR_COLOR:int = 888;
      
      public static const MIX_COLOR_WRAP:int = 999;
       
      
      public function ItemType()
      {
         super();
      }
      
      public static function isWrap(param1:int) : Boolean
      {
         return param1 == WRAP;
      }
      
      public static function isColor(param1:int) : Boolean
      {
         return param1 == COLOR;
      }
      
      public static function isLine(param1:int) : Boolean
      {
         return param1 == LINE;
      }
      
      public static function isColumn(param1:int) : Boolean
      {
         return param1 == COLUMN;
      }
      
      public static function isStripes(param1:int) : Boolean
      {
         return param1 == LINE || param1 == COLUMN;
      }
      
      public static function isNormalWrap(param1:Item) : Boolean
      {
         return !param1.isTemp() && Boolean(isWrap(param1.special));
      }
      
      public static function isNormalColor(param1:Item) : Boolean
      {
         return !param1.isTemp() && Boolean(isColor(param1.special));
      }
      
      public static function isNormalStripes(param1:Item) : Boolean
      {
         return !param1.isTemp() && Boolean(isStripes(param1.special));
      }
      
      public static function isColorLineMix(param1:int) : Boolean
      {
         return param1 == MIX_COLOR_LINE;
      }
      
      public static function isLineWrapMix(param1:int) : Boolean
      {
         return param1 == MIX_LINE_WRAP;
      }
      
      public static function isColorColorMix(param1:int) : Boolean
      {
         return param1 == MIX_COLOR_COLOR;
      }
      
      public static function isColorWrapMix(param1:int) : Boolean
      {
         return param1 == MIX_COLOR_WRAP;
      }
      
      public static function getSpecialTypes(param1:int) : Array
      {
         var _loc2_:Array = [];
         if(param1 & ItemType.WRAP)
         {
            _loc2_.push(ItemType.WRAP);
         }
         if(param1 & ItemType.LINE)
         {
            _loc2_.push(ItemType.LINE);
         }
         if(param1 & ItemType.COLUMN)
         {
            _loc2_.push(ItemType.COLUMN);
         }
         if(param1 & ItemType.COLOR)
         {
            _loc2_.push(ItemType.COLOR);
         }
         return _loc2_;
      }
      
      public static function getAsString(param1:int) : String
      {
         if(param1 == COLOR)
         {
            return "COLOR";
         }
         if(param1 == LINE)
         {
            return "LINE";
         }
         if(param1 == WRAP)
         {
            return "WRAP";
         }
         if(param1 == COLUMN)
         {
            return "COLUMN";
         }
         return "NONE";
      }
   }
}
