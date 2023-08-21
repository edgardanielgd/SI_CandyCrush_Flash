package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.games.candycrush.GameView;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.math.IntCoord;
   import com.midasplayer.math.Vec2;
   import flash.display.BitmapData;
   import flash.geom.Point;
   
   public class Fx_ColorBomb extends TickedSprite
   {
      
      private static const ColorBombExplosion:BitmapData = new GA_ColorBomb_Explosion();
      
      private static const ColorBombSnurran:BitmapData = new GA_ColorBomb_Snurran();
      
      private static const ColorBlastLine:BitmapData = new GA_ColorBomb_Flash();
       
      
      private var _cbls:Vector.<Item>;
      
      private var _colorBlastLines:Vector.<com.midasplayer.games.candycrush.render.BitmapSprite>;
      
      private var _blastBms:Vector.<com.midasplayer.games.candycrush.render.BitmapSprite>;
      
      private var cy:Number;
      
      private var cx:Number;
      
      private var _doBlasts:Boolean;
      
      public function Fx_ColorBomb(param1:BitmapData, param2:int, param3:Item, param4:Vector.<Item>)
      {
         this._cbls = new Vector.<Item>();
         this._colorBlastLines = new Vector.<com.midasplayer.games.candycrush.render.BitmapSprite>();
         super(param1,param2);
         this.setup(param3,param4);
      }
      
      private function setup(param1:Item, param2:Vector.<Item>) : void
      {
         var _loc4_:Item = null;
         var _loc5_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         var _loc6_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         var _loc7_:Number = NaN;
         this.cx = param1.x;
         this.cy = param1.y;
         this._blastBms = new Vector.<com.midasplayer.games.candycrush.render.BitmapSprite>();
         param1.view.colorblast(param1.x,param1.y,new IntCoord(param1.x,param1.y));
         var _loc3_:int = 0;
         for each(_loc4_ in param2)
         {
            _loc4_.view.scaleOnRemoval = false;
            _loc5_ = new com.midasplayer.games.candycrush.render.BitmapSprite(ColorBombSnurran,9,1);
            this._blastBms.push(_loc5_);
            (_loc6_ = new com.midasplayer.games.candycrush.render.BitmapSprite(ColorBlastLine,5,1)).setRotation(Math.atan2(_loc4_.y - this.cy,_loc4_.x - this.cx) - 1.57);
            _loc6_.scaleSourceInsteadOfTarget = true;
            _loc6_.smoothing = true;
            _loc7_ = new Vec2(_loc4_.y - this.cy,_loc4_.x - this.cx).length / 7;
            _loc6_.scaleY = _loc7_;
            this._colorBlastLines.push(_loc6_);
            this._cbls.push(_loc4_);
         }
      }
      
      private function getPos(param1:int) : Point
      {
         var _loc2_:Item = this._cbls[param1];
         return new Point(_loc2_.x,_loc2_.y);
      }
      
      override public function tick(param1:int) : void
      {
         var _loc2_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         for each(_loc2_ in this._blastBms)
         {
            _loc2_.tick(param1);
         }
         for each(_loc2_ in this._colorBlastLines)
         {
            _loc2_.tick(param1);
         }
      }
      
      override protected function renderFront(param1:int, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc6_:Point = null;
         var _loc7_:IntCoord = null;
         var _loc8_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         var _loc9_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         var _loc10_:IntCoord = null;
         var _loc4_:int = int(getLivedTicks());
         var _loc5_:int = 0;
         while(_loc5_ < this._colorBlastLines.length)
         {
            _loc6_ = this.getPos(_loc5_);
            _loc7_ = GameView.gridToStage(_loc6_.x,_loc6_.y);
            _loc3_ = int(getWantedFrame(25,4));
            if(_loc3_ >= 0 && _loc3_ < 9)
            {
               (_loc8_ = this._blastBms[_loc5_]).setFrame(_loc3_);
               _loc8_.render2(0,_loc7_.x,_loc7_.y,canvas,com.midasplayer.games.candycrush.render.BitmapSprite.ALIGN_CENTER,com.midasplayer.games.candycrush.render.BitmapSprite.VALIGN_MIDDLE);
            }
            _loc3_ = int(getWantedFrame(25,5));
            if(_loc3_ >= 0 && _loc3_ < 5)
            {
               (_loc9_ = this._colorBlastLines[_loc5_]).setFrame(_loc3_);
               _loc10_ = GameView.gridToStage((_loc6_.x + this.cx) / 2,(_loc6_.y + this.cy) / 2);
               _loc9_.render2(0,_loc10_.x,_loc10_.y,canvas,com.midasplayer.games.candycrush.render.BitmapSprite.ALIGN_CENTER,com.midasplayer.games.candycrush.render.BitmapSprite.VALIGN_MIDDLE);
            }
            _loc5_++;
         }
      }
   }
}
