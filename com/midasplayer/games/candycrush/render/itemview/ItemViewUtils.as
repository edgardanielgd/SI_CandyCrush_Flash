package com.midasplayer.games.candycrush.render.itemview
{
   import com.midasplayer.games.candycrush.GameView;
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.render.BitmapSprite;
   import flash.display.BitmapData;
   import flash.filters.ColorMatrixFilter;
   
   public class ItemViewUtils
   {
      
      public static const Stripes:BitmapData = new GA_Stripes_samesize();
      
      public static const WrapBlast:BitmapData = new GA_Bomb_Wrapblast();
      
      public static const WrapSpecular:BitmapData = new GA_Effects_Wrapper_spec();
      
      public static const ColorBombExplosion:BitmapData = new GA_ColorBomb_Explosion();
      
      public static const ColorBombSnurran:BitmapData = new GA_ColorBomb_Snurran();
      
      public static const ColorBlastLine:BitmapData = new GA_ColorBomb_Flash();
      
      public static const ColorBombGrowing:BitmapData = new GA_ColorBomb_Growing();
      
      public static const ColorBombCreation:BitmapData = new GA_Creation_color();
      
      public static const ColorBombGlow:BitmapData = new GA_ColorBomb_Glow();
      
      public static const Dust:BitmapData = new GA_Dust();
      
      public static const ColorBomb:BitmapData = new GA_Color();
      
      public static const ColorBombAnim:BitmapData = new GA_ColorBomb_normal();
      
      public static const BoosterHint:BitmapData = new GA_BoostHint_background();
      
      public static const ColorBms:Array = [null,new Brick_Normal_blue(),new Brick_Normal_green(),new Brick_Normal_orange(),new Brick_Normal_purple(),new Brick_Normal_red(),new Brick_Normal_yellow()];
      
      public static const ColorWraps:Array = [null,new GA_Brick_Wrap_blue(),new GA_Brick_Wrap_green(),new GA_Brick_Wrap_orange(),new GA_Brick_Wrap_purple(),new GA_Brick_Wrap_red(),new GA_Brick_Wrap_yellow()];
      
      public static const BombBlasts:Array = [null,new GA_Bomb_blue_varannan(),new GA_Bomb_green_varannan(),new GA_Bomb_orange_varannan(),new GA_Bomb_purple_varannan(),new GA_Bomb_red_varannan(),new GA_Bomb_yellow_varannan()];
       
      
      public function ItemViewUtils()
      {
         super();
      }
      
      public static function getColorFilter(param1:int) : ColorMatrixFilter
      {
         if(param1 == GameView.COLOR_BLUE)
         {
            return fromColorTransform(0.8,0.8,1);
         }
         if(param1 == GameView.COLOR_GREEN)
         {
            return fromColorTransform(0.8,1,0.8);
         }
         if(param1 == GameView.COLOR_RED)
         {
            return fromColorTransform(1,0.8,0.8);
         }
         return fromColorTransform(1,1,1);
      }
      
      public static function getColorFilter_dust(param1:int) : ColorMatrixFilter
      {
         if(param1 == GameView.COLOR_BLUE)
         {
            return fromColorTransform(0,0,0,1,144,230,255);
         }
         if(param1 == GameView.COLOR_GREEN)
         {
            return fromColorTransform(0,0,0,1,175,248,150);
         }
         if(param1 == GameView.COLOR_ORANGE)
         {
            return fromColorTransform(0,0,0,1,255,215,143);
         }
         if(param1 == GameView.COLOR_PURPLE)
         {
            return fromColorTransform(0,0,0,1,235,150,255);
         }
         if(param1 == GameView.COLOR_RED)
         {
            return fromColorTransform(0,0,0,1,255,147,147);
         }
         if(param1 == GameView.COLOR_YELLOW)
         {
            return fromColorTransform(0,0,0,1,255,247,129);
         }
         return fromColorTransform(1,1,1);
      }
      
      public static function fromColorTransform(param1:Number, param2:Number, param3:Number, param4:Number = 1, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0) : ColorMatrixFilter
      {
         return new ColorMatrixFilter([param1,0,0,0,param5,0,param2,0,0,param6,0,0,param3,0,param7,0,0,0,param4,param8]);
      }
      
      public static function getBitmapFromItemType(param1:int, param2:int) : BitmapSprite
      {
         var _loc3_:BitmapSprite = null;
         if(param1 == GameView.COLOR_NONE && ItemType.isColor(param2))
         {
            return null;
         }
         if(param1 == GameView.COLOR_NONE)
         {
            return null;
         }
         if(ItemType.isColumn(param2))
         {
            _loc3_ = new BitmapSprite(Stripes,12,1.2);
            _loc3_.setFrame(param1 + param1 - 1);
            return _loc3_;
         }
         if(ItemType.isLine(param2))
         {
            _loc3_ = new BitmapSprite(Stripes,12,1.2);
            _loc3_.setFrame(param1 + param1 - 2);
            return _loc3_;
         }
         if(ItemType.isWrap(param2))
         {
            return new BitmapSprite(ColorWraps[param1],1,1.2);
         }
         return new BitmapSprite(ColorBms[param1],1,1);
      }
   }
}
