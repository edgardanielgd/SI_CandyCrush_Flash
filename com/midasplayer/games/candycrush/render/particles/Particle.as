package com.midasplayer.games.candycrush.render.particles
{
   import com.midasplayer.animation.tweenick.TTData;
   import com.midasplayer.animation.tweenick.TTEasing;
   import com.midasplayer.games.candycrush.render.BitmapSprite;
   import com.midasplayer.games.candycrush.render.TickedSprite;
   import flash.display.BitmapData;
   
   public class Particle extends TickedSprite
   {
      
      private static var Texture:BitmapData = new GA_Particles();
      
      private static var _textureList:Vector.<BitmapData> = new Vector.<BitmapData>();
      
      private static var _inited:Boolean = false;
      
      private static const NumFramesPerAnimation:int = 30;
      
      private static const NumAnimsPerColor:int = 4;
       
      
      public var px:Number;
      
      public var py:Number;
      
      public var vx:Number = 0;
      
      public var vy:Number = 0;
      
      private var _b:BitmapSprite;
      
      private var _lifeTime:Number;
      
      public function Particle(param1:BitmapData, param2:int, param3:int, param4:Object)
      {
         super(param1,param2);
         if(!_inited)
         {
            initParticleBitmaps();
         }
         this._b = new BitmapSprite(getTextureAnim(param3),NumFramesPerAnimation,1);
         this._lifeTime = 14 + 2 * Math.random();
         this.px = param4.px;
         this.py = param4.py;
         if(param4.vx)
         {
            this.vx = param4.vx;
         }
         if(param4.vy)
         {
            this.vy = param4.vy;
         }
      }
      
      private static function getTextureAnim(param1:int) : BitmapData
      {
         if(param1 == 0)
         {
            param1 = 1 + Math.random() * 6;
         }
         var _loc2_:int = (param1 - 1 + Math.random()) * NumAnimsPerColor;
         return _textureList[_loc2_];
      }
      
      public static function initParticleBitmaps() : void
      {
         var _loc1_:BitmapSprite = null;
         var _loc2_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:BitmapData = null;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         _loc1_ = new BitmapSprite(Texture,12,1);
         _loc2_ = _loc1_.width();
         var _loc3_:Number = _loc2_ / 2;
         var _loc4_:Number = _loc1_.height() / 2;
         var _loc5_:int = 0;
         while(_loc5_ < 12)
         {
            _loc1_.setFrame(_loc5_);
            _loc6_ = (_loc5_ & 1) == 0 ? 3 : 1;
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = 2 * Math.PI * Math.random();
               _loc9_ = Math.random() < 0.5 ? 1 : -1;
               _loc10_ = 0.75 + 0.25 * Math.random();
               _loc11_ = new BitmapData(_loc2_ * NumFramesPerAnimation,_loc1_.height(),true,0);
               _loc12_ = 0;
               while(_loc12_ < NumFramesPerAnimation)
               {
                  _loc13_ = _loc12_ / (NumFramesPerAnimation - 1);
                  _loc14_ = TTEasing.QuadraticOutReturner(new TTData(1,1,0.25,_loc13_));
                  _loc1_.alpha = _loc14_;
                  _loc15_ = _loc10_ * TTEasing.QuadraticOutReturner(new TTData(0.9,1,0.3,_loc13_));
                  _loc1_.scaleX = _loc15_;
                  _loc1_.scaleY = _loc15_;
                  _loc1_.setRotation(_loc8_ + _loc13_ * _loc9_);
                  _loc1_.render2(0,_loc12_ * _loc2_ + _loc3_,_loc4_,_loc11_,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
                  _loc12_++;
               }
               _textureList.push(_loc11_);
               _loc7_++;
            }
            _loc5_++;
         }
         _inited = true;
      }
      
      override public function tick(param1:int) : void
      {
         this.px = this.px + this.vx;
         this.py = this.py + this.vy;
      }
      
      override protected function renderFront(param1:int, param2:Number) : void
      {
         var _loc3_:Number = Number(getLivedShare(this._lifeTime));
         if(_loc3_ >= 1)
         {
            done = true;
         }
         this._b.setFrame(_loc3_ * NumFramesPerAnimation);
         this._b.render2(0,this.px + this.vx * param2,this.py + this.vy * param2,canvas,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
      }
   }
}
