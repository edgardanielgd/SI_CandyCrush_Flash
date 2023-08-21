package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.games.candycrush.GameView;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.input.SwapInfo;
   import com.midasplayer.math.IntCoord;
   import com.midasplayer.math.Vec2;
   import com.midasplayer.sound.ManagedSoundChannel;
   import flash.display.BitmapData;
   
   public class Fx_Mix_ColorColor extends TickedSprite
   {
      
      private static const ColorBombExplosion:BitmapData = new GA_ColorBomb_Explosion();
      
      private static const ColorBombSnurran:BitmapData = new GA_ColorBomb_Snurran();
      
      private static const ColorBlastLine:BitmapData = new GA_ColorBomb_Flash();
       
      
      private var _cbls:Vector.<Item>;
      
      private var _colorBlastLines:Vector.<com.midasplayer.games.candycrush.render.BitmapSprite>;
      
      private var _blastBms:Vector.<com.midasplayer.games.candycrush.render.BitmapSprite>;
      
      private var cxs:Array;
      
      private var cys:Array;
      
      private var _doBlasts:Boolean;
      
      private var _loopSound:ManagedSoundChannel;
      
      public function Fx_Mix_ColorColor(param1:BitmapData, param2:int, param3:SwapInfo, param4:Vector.<Item>)
      {
         this._cbls = new Vector.<Item>();
         this._colorBlastLines = new Vector.<com.midasplayer.games.candycrush.render.BitmapSprite>();
         this.cxs = [0,0];
         this.cys = [0,0];
         super(param1,param2);
         var _loc5_:Item = param3.item_a;
         this.setup([param3.item_a,param3.item_b],param4);
      }
      
      private function setup(param1:Array, param2:Vector.<Item>) : void
      {
         var _loc6_:Item = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         var _loc10_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         var _loc11_:Number = NaN;
         var _loc3_:int = 0;
         while(_loc3_ < 2)
         {
            this.cxs[_loc3_] = param1[_loc3_].x;
            this.cys[_loc3_] = param1[_loc3_].y;
            param1[_loc3_].view.colorblast(param1[_loc3_].x,param1[_loc3_].y,new IntCoord(param1[_loc3_].x,param1[_loc3_].y));
            _loc3_++;
         }
         this._blastBms = new Vector.<com.midasplayer.games.candycrush.render.BitmapSprite>();
         if(SoundVars.soundOn)
         {
            this._loopSound = SoundVars.sound.manager.getFromClass(SA_LoopEffect_colorcolor).loop(SoundVars.SoundVolume,0,3);
         }
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         for each(_loc6_ in param2)
         {
            _loc7_ = Number(this.cxs[_loc5_]);
            _loc8_ = Number(this.cys[_loc5_]);
            if(++_loc5_ == 2)
            {
               _loc5_ = 0;
            }
            _loc6_.view.scaleOnRemoval = false;
            _loc9_ = new com.midasplayer.games.candycrush.render.BitmapSprite(ColorBombSnurran,9,1);
            this._blastBms.push(_loc9_);
            (_loc10_ = new com.midasplayer.games.candycrush.render.BitmapSprite(ColorBlastLine,5,1)).setRotation(Math.atan2(_loc6_.y - _loc8_,_loc6_.x - _loc7_) - 1.57);
            _loc10_.scaleSourceInsteadOfTarget = true;
            _loc10_.smoothing = true;
            _loc11_ = new Vec2(_loc6_.y - _loc8_,_loc6_.x - _loc7_).length / 7;
            _loc10_.scaleY = _loc11_;
            this._colorBlastLines.push(_loc10_);
            this._cbls.push(_loc6_);
         }
      }
      
      private function getPos(param1:int) : IntCoord
      {
         var _loc2_:Item = this._cbls[param1];
         return new IntCoord(_loc2_.x,_loc2_.y);
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
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:IntCoord = null;
         var _loc10_:IntCoord = null;
         var _loc11_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         var _loc12_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         var _loc13_:IntCoord = null;
         var _loc4_:int = int(getLivedTicks());
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         while(_loc6_ < this._colorBlastLines.length)
         {
            _loc7_ = Number(this.cxs[_loc5_]);
            _loc8_ = Number(this.cys[_loc5_]);
            if(++_loc5_ == 2)
            {
               _loc5_ = 0;
            }
            _loc9_ = this.getPos(_loc6_);
            _loc10_ = GameView.gridToStage(_loc9_.x,_loc9_.y + 0.5);
            _loc3_ = int(getWantedFrame(25,4 + _loc6_));
            if(_loc3_ >= 0 && _loc3_ < 9)
            {
               (_loc11_ = this._blastBms[_loc6_]).setFrame(_loc3_);
               _loc11_.render2(0,_loc10_.x,_loc10_.y,canvas,com.midasplayer.games.candycrush.render.BitmapSprite.ALIGN_CENTER,com.midasplayer.games.candycrush.render.BitmapSprite.VALIGN_MIDDLE);
            }
            _loc3_ = int(getWantedFrame(25,5 + _loc6_));
            if(_loc3_ >= 0 && _loc3_ < 5)
            {
               (_loc12_ = this._colorBlastLines[_loc6_]).setFrame(_loc3_);
               _loc13_ = GameView.gridToStage((_loc9_.x + _loc7_) / 2,(_loc9_.y + _loc8_ + 0.5) / 2);
               _loc12_.render2(0,_loc13_.x,_loc13_.y,canvas,com.midasplayer.games.candycrush.render.BitmapSprite.ALIGN_CENTER,com.midasplayer.games.candycrush.render.BitmapSprite.VALIGN_MIDDLE);
            }
            _loc6_++;
         }
         done = getLivedTicks() > 90;
         if(done && Boolean(this._loopSound))
         {
            this._loopSound.fadeToAndStop(0,200);
            this._loopSound = null;
         }
      }
   }
}
