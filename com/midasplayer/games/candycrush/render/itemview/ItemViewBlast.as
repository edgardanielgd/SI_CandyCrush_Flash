package com.midasplayer.games.candycrush.render.itemview
{
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.render.BitmapSprite;
   
   public class ItemViewBlast
   {
       
      
      public function ItemViewBlast()
      {
         super();
      }
      
      public static function createWrapBlast(param1:Item) : BitmapSprite
      {
         var _loc2_:BitmapSprite = null;
         if(param1.isTemp())
         {
            _loc2_ = new BitmapSprite(ItemViewUtils.BombBlasts[param1.color],10,1.1);
            _loc2_.setFPS(30);
         }
         else
         {
            _loc2_ = new BitmapSprite(ItemViewUtils.WrapBlast,13,1);
            _loc2_.applyFilter(ItemViewUtils.getColorFilter(param1.color));
            _loc2_.setFPS(40);
         }
         return _loc2_;
      }
      
      public static function createColorBlast(param1:Item) : BitmapSprite
      {
         var _loc2_:BitmapSprite = null;
         if(ItemType.isColor(param1.special))
         {
            _loc2_ = new BitmapSprite(ItemViewUtils.ColorBombExplosion,9,1);
            _loc2_.setFPS(25);
            _loc2_.removeAtEnd = true;
            return _loc2_;
         }
         return null;
      }
   }
}
