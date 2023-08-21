package com.midasplayer.games.candycrush.render.itemview
{
   import com.gskinner.geom.ColorMatrix2;
   import com.midasplayer.animation.tweenick.TTData;
   import com.midasplayer.animation.tweenick.TTEasing;
   import com.midasplayer.animation.tweenick.TTGroup;
   import com.midasplayer.animation.tweenick.TTItem;
   import com.midasplayer.animation.tweenick.TickTween;
   import com.midasplayer.games.candycrush.GameView;
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.Ticks;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.games.candycrush.board.IItemListener;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.render.BitmapSprite;
   import com.midasplayer.games.candycrush.render.TickedSprite;
   import com.midasplayer.math.IntCoord;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.getTimer;
   
   public class ItemView implements IItemListener
   {
      
      private static var _lastCandyLandTime:Number = 0;
      
      private static const CandyLandSounds:Array = [SA_CandyLand_1,SA_CandyLand_2,SA_CandyLand_3,SA_CandyLand_4];
      
      private static const CandyLandVolumes:Array = [0.9,0.8,0.55,0.65];
       
      
      private var _tick:int = 0;
      
      private var _talpha:Number = 0;
      
      private var _behindMatrix:ColorMatrix2;
      
      private var _unhidMultiball:Boolean = false;
      
      private var _item:Item;
      
      private var _bmsprite:BitmapSprite;
      
      private var _wrapSpecular:BitmapSprite;
      
      private var _wrapStartTick:int = 0;
      
      private var _pt:Point;
      
      private var _removedAtTick:int = -1;
      
      private var _isRemoved:Boolean = false;
      
      private var _blastBm:BitmapSprite;
      
      private var _tweener:TickTween;
      
      private var _bounceTicks:int = -1;
      
      private var _bounceForce:Number;
      
      private var _hintTicks:int = -1;
      
      private const HintTicks:int = 42;
      
      private var _boosterHintTicks:int = 0;
      
      private var _boosterHintMaxTicks:int = 0;
      
      private const BoosterHintTicks:int = 11;
      
      private var _boosterHintAlphaMult:Number = 0;
      
      private var _livedTicks:int = 0;
      
      private var _bmbehind:BitmapSprite;
      
      private var _bmbehind2:BitmapSprite;
      
      private var _drawItemBehind:Boolean = false;
      
      private var _drawItemBehind_behind:Boolean = true;
      
      private var _behindStars:GA_Creation_stars;
      
      private var _sprite:Sprite = null;
      
      private var _dust:BitmapSprite;
      
      private var _bmSprites:Array;
      
      public var autoHandleRender:Boolean = true;
      
      public var autoHandleRemoval:Boolean = true;
      
      public var scaleOnRemoval:Boolean = true;
      
      private var _forceDestroy:Boolean = false;
      
      private var _destroyTicks:int = 15;
      
      private var _boosterHintSprite:BitmapSprite;
      
      private var MaxDrawItemBehindTicks:int = 5;
      
      private var _autoUnhideSprite:Boolean = true;
      
      public function ItemView(param1:Item, param2:TickTween)
      {
         this._pt = new Point();
         this._bmSprites = [];
         this._boosterHintSprite = new BitmapSprite(ItemViewUtils.BoosterHint,1,1);
         super();
         this._item = param1;
         this._item.init(this);
         this._tweener = param2;
         var _loc3_:int = param1.color;
         if(this.isWrapped())
         {
            this.addCreationStars();
            this._drawItemBehind = true;
            this._drawItemBehind_behind = false;
            this._bmbehind = new BitmapSprite(ItemViewUtils.ColorBms[param1.color]);
            this._bmsprite = new BitmapSprite(ItemViewUtils.ColorWraps[param1.color]);
            this._wrapSpecular = new BitmapSprite(ItemViewUtils.WrapSpecular,30,1,true);
            this._wrapSpecular.setBlendMode(BlendMode.SCREEN);
            this._wrapSpecular.hideOnStop = true;
            this._wrapSpecular.setFPS(20 + Math.random() * 10);
            this._wrapSpecular.play(false);
            this._bmSprites.push(this._wrapSpecular);
         }
         else if(this.isLine())
         {
            if(param1.isTemp() && param1.color == 0)
            {
               _loc3_ = 1 + 6 * Math.random();
            }
            this.addCreationStars();
            this._drawItemBehind = true;
            this._bmbehind = new BitmapSprite(ItemViewUtils.ColorBms[_loc3_]);
            this._bmsprite = new BitmapSprite(ItemViewUtils.Stripes,12,1);
            this._bmsprite.alpha = 0;
            this._bmsprite.setFrame(_loc3_ + _loc3_ - 2);
         }
         else if(this.isColumn())
         {
            if(param1.isTemp() && param1.color == 0)
            {
               _loc3_ = 1 + 6 * Math.random();
            }
            this.addCreationStars();
            this._drawItemBehind = true;
            this._bmbehind = new BitmapSprite(ItemViewUtils.ColorBms[_loc3_]);
            this._bmsprite = new BitmapSprite(ItemViewUtils.Stripes,12,1);
            this._bmsprite.alpha = 0;
            this._bmsprite.setFrame(_loc3_ + _loc3_ - 1);
         }
         else if(this.isColorBomb())
         {
            if(param1.parentDecl)
            {
               this._bmbehind = ItemViewUtils.getBitmapFromItemType(param1.parentDecl.color,param1.parentDecl.special);
               if(this._bmbehind)
               {
                  this.addCreationStars();
                  this._drawItemBehind = true;
                  this._drawItemBehind_behind = false;
                  this._autoUnhideSprite = false;
                  this.MaxDrawItemBehindTicks = 11;
                  this._bmbehind2 = new BitmapSprite(ItemViewUtils.ColorBombCreation,8);
                  this._bmbehind2.setFPS(30);
                  this._bmbehind2.play(false);
               }
            }
            if(this._item.isTemp())
            {
               this._bmsprite = new BitmapSprite(ItemViewUtils.ColorBombGrowing,5,1);
            }
            else
            {
               this._bmsprite = new BitmapSprite(ItemViewUtils.ColorBombAnim,19,1);
               this._bmsprite.setFPS(20);
               this._bmsprite.setFrame(Math.random() * 18);
               this._bmsprite.play(true);
            }
         }
         else
         {
            this._bmsprite = new BitmapSprite(ItemViewUtils.ColorBms[_loc3_],1,1);
         }
         if(ItemType.isWrap(this._item.special) && this._item.isTemp())
         {
            this._bmsprite.smoothing = true;
         }
         this._bmSprites.push(this._bmsprite);
      }
      
      private function addCreationStars() : void
      {
         var _loc1_:IntCoord = GameView.gridToStage(this._item.x,this._item.y);
         this._behindStars = new GA_Creation_stars();
         this._behindStars.stop();
         this._behindStars.x = _loc1_.x - 36;
         this._behindStars.y = _loc1_.y - 26;
         this._sprite = new Sprite();
         this._sprite.addChild(this._behindStars);
      }
      
      private function isLine() : Boolean
      {
         return (this._item.special & ItemType.LINE) != 0;
      }
      
      private function isColumn() : Boolean
      {
         return (this._item.special & ItemType.COLUMN) != 0;
      }
      
      private function isColorBomb() : Boolean
      {
         return (this._item.special & ItemType.COLOR) != 0;
      }
      
      private function isWrapped() : Boolean
      {
         return (this._item.special & ItemType.WRAP) != 0 && this._item.isTemp() == false;
      }
      
      public function getItem() : Item
      {
         return this._item;
      }
      
      public function getPos(param1:Number) : IntCoord
      {
         if(this._item.isBusy() == false)
         {
            this._pt.x = this._item.lastX + (this._item.x - this._item.lastX) * param1;
            this._pt.y = this._item.lastY + (this._item.y - this._item.lastY) * param1;
         }
         return GameView.gridToStage(this._pt.x,this._pt.y);
      }
      
      public function tick(param1:int) : void
      {
         var _loc2_:BitmapSprite = null;
         if(this._wrapSpecular != null && this._livedTicks > this._wrapStartTick)
         {
            this._wrapStartTick = this._wrapStartTick + Ticks.sec2Ticks(3 + 5 * Math.random());
            this._wrapSpecular.setFrame(0);
            this._wrapSpecular.play();
         }
         if(this._bmbehind2)
         {
            this._bmbehind2.tick(param1);
         }
         this._tick = param1;
         var _loc3_:*;
         var _loc4_:* = (_loc3_ = this)._livedTicks + 1;
         _loc3_._livedTicks = _loc4_;
         _loc4_ = (_loc3_ = this)._bounceTicks - 1;
         _loc3_._bounceTicks = _loc4_;
         _loc4_ = (_loc3_ = this)._hintTicks - 1;
         _loc3_._hintTicks = _loc4_;
         _loc4_ = (_loc3_ = this)._boosterHintTicks - 1;
         _loc3_._boosterHintTicks = _loc4_;
         if(this._boosterHintTicks < 0 && this._boosterHintAlphaMult > 0.01)
         {
            this._boosterHintAlphaMult = Math.max(0,this._boosterHintAlphaMult - 0.16667);
         }
         else if(this._boosterHintTicks > 0 && this._boosterHintAlphaMult < 0.99)
         {
            this._boosterHintAlphaMult = Math.min(1,this._boosterHintAlphaMult + 0.08333);
         }
         for each(_loc2_ in this._bmSprites)
         {
            _loc2_.tick(param1);
         }
      }
      
      public function renderAt(param1:int, param2:Number, param3:BitmapData) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         this._talpha = param2;
         if(!this.autoHandleRender)
         {
            return;
         }
         var _loc4_:IntCoord = this.getPos(param2);
         var _loc5_:Number;
         if((_loc5_ = this.scaleOnRemoval ? this.getRemoveScale(param1 + param2) : 1) < 1)
         {
            this._bmsprite.scaleX = this._bmsprite.scaleY = _loc5_;
            this._bmsprite.alpha = _loc5_;
            this._dust.render2(0,_loc4_.x,_loc4_.y,param3,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
         }
         if(this._item.isTemp())
         {
            if(ItemType.isColor(this._item.special))
            {
               if((_loc6_ = 1.5 + 3 * Math.sin(getTimer() * 0.0125)) < 0)
               {
                  _loc6_ = 0;
               }
               if(_loc6_ > 4)
               {
                  _loc6_ = 4;
               }
               this._bmsprite.setFrame(_loc6_);
            }
            else if(ItemType.isWrap(this._item.special))
            {
               _loc7_ = 0.5 * (1 + Math.sin(getTimer() * 0.012));
               this._bmsprite.scaleX = this._bmsprite.scaleY = 1 + 0.1 * _loc7_;
               this._bmsprite.applyFilter(new GlowFilter(16777215,1,20,20,0.5 + 0.5 * _loc7_,1,true));
            }
         }
         this.updateRenderHint(_loc4_,param3);
         if(this._drawItemBehind_behind)
         {
            this.updateItemBehind(param3,param2);
         }
         this._bmsprite.render2(0,_loc4_.x,_loc4_.y,param3,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
         if(!this._drawItemBehind_behind)
         {
            this.updateItemBehind(param3,param2);
         }
         if(this.isWrapped())
         {
            if(_loc5_ < 1)
            {
               this._wrapSpecular.scaleX = this._wrapSpecular.scaleY = _loc5_;
            }
            this._wrapSpecular.render2(0,_loc4_.x,_loc4_.y,param3,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
         }
         if(this._blastBm != null)
         {
            this._blastBm.render2(0,_loc4_.x,this.isColorBomb() ? _loc4_.y - 2 : _loc4_.y,param3,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
         }
      }
      
      private function updateRenderHint(param1:IntCoord, param2:BitmapData) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:ColorMatrix2 = null;
         if(this._hintTicks > 0)
         {
            _loc3_ = this.HintTicks - 1 - this._hintTicks + this._talpha;
            _loc5_ = (_loc4_ = 0.5 * (1 + Math.cos(Math.PI + _loc3_ * 0.45))) * 30;
            (_loc6_ = new ColorMatrix2(ColorMatrix2.IDENTITY_MATRIX)).adjustContrast(_loc5_);
            this._bmsprite.applyFilters([new ColorMatrixFilter(_loc6_),new BlurFilter(5 * _loc4_,5 * _loc4_)]);
            this._bmsprite.scaleX = this._bmsprite.scaleY = 1 + 0.1 * _loc4_;
            this._bmsprite.smoothing = true;
         }
         else if(this._hintTicks == 0)
         {
            this._bmsprite.applyFilters([]);
            this._bmsprite.scaleX = this._bmsprite.scaleY = 1;
            this._bmsprite.smoothing = false;
         }
         if(this._boosterHintTicks > 0 || this._boosterHintAlphaMult > 0)
         {
            this._boosterHintSprite.alpha = this._boosterHintAlphaMult * (0.85 + 0.2 * Math.sin(getTimer() * 0.008));
            this._boosterHintSprite.render2(0,int(param1.x),int(param1.y) - 1,param2,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
         }
      }
      
      public function renderXy(param1:int, param2:int, param3:BitmapData) : void
      {
         this._bmsprite.render2(0,param1,param2,param3,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
      }
      
      private function updateItemBehind(param1:BitmapData, param2:Number) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc3_:Number = this._livedTicks + param2;
         if(this._item.isTemp() && (ItemType.isColumn(this._item.special) || ItemType.isLine(this._item.special)))
         {
            _loc3_ -= 20;
         }
         var _loc4_:IntCoord = this.getPos(param2);
         this.updateStarsBehind(_loc3_,_loc4_);
         if(this._drawItemBehind && _loc3_ >= this.MaxDrawItemBehindTicks)
         {
            this._drawItemBehind = false;
            this._bmsprite.alpha = 1;
            this._bmsprite.scaleX = this._bmsprite.scaleY = 1;
         }
         if(!this._drawItemBehind)
         {
            return;
         }
         if(this.isColorBomb())
         {
            this.drawColorBombCreation(param1,_loc3_,_loc4_);
            return;
         }
         if(_loc3_ < 0)
         {
            _loc5_ = 1;
            if(this.isLine() || this.isColumn())
            {
               _loc5_ = 0;
            }
            this._bmbehind.render2(0,_loc4_.x,_loc4_.y + _loc5_,param1,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
         }
         else
         {
            _loc6_ = 0.2 * _loc3_;
            _loc7_ = TTEasing.QuadraticOutReturner(new TTData(1,1.2,1,_loc6_));
            this._bmsprite.alpha = this.isWrapped() ? 1 : _loc6_;
            if(this.isWrapped())
            {
               this._bmbehind.alpha = 1 - _loc6_;
            }
            this._bmsprite.scaleX = this._bmsprite.scaleY = _loc7_;
            this._bmbehind.scaleX = this._bmbehind.scaleY = _loc7_;
            this._bmbehind.render2(0,_loc4_.x,_loc4_.y,param1,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
         }
      }
      
      private function updateStarsBehind(param1:Number, param2:IntCoord) : void
      {
         if(!this._behindStars)
         {
            return;
         }
         var _loc3_:int = TickedSprite.getWantedFrame2(param1,30,0,1);
         if(_loc3_ > 0 && _loc3_ <= 13)
         {
            this._behindStars.x = param2.x - 36;
            this._behindStars.y = param2.y - 26;
            this._behindStars.gotoAndStop(_loc3_);
         }
         else if(_loc3_ > 13)
         {
            this._sprite.removeChild(this._behindStars);
            this._behindStars = null;
         }
      }
      
      private function drawColorBombCreation(param1:BitmapData, param2:Number, param3:IntCoord) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc4_:Number = 0.1 * (param2 - 1);
         if(this._bmbehind2)
         {
            this._bmsprite.alpha = 0;
            if(_loc4_ < 0.5 && Boolean(this._bmbehind))
            {
               _loc6_ = (_loc5_ = _loc4_ * 2) * 85;
               this._behindMatrix = new ColorMatrix2(ColorMatrix2.IDENTITY_MATRIX);
               this._behindMatrix.adjustBrightness(_loc6_);
               this._behindMatrix.adjustContrast(_loc6_);
               this._bmbehind.scaleX = this._bmbehind.scaleY = 1 + 0.2 * _loc5_;
               this._bmbehind.applyFilter(new ColorMatrixFilter(this._behindMatrix));
               this._bmbehind.render2(0,param3.x,param3.y,param1,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
            }
            else
            {
               this._bmsprite.alpha = 1;
               _loc7_ = 2 * (_loc4_ - 0.5);
               if(!this._unhidMultiball)
               {
                  this._bmbehind = new BitmapSprite(ItemViewUtils.ColorBombGlow,1,1.2);
                  this._unhidMultiball = true;
               }
               this._bmbehind.scaleX = this._bmbehind.scaleY = 1.2 - _loc7_ * 0.2;
               this._bmbehind.alpha = 1 - _loc7_;
               this._bmbehind.render2(0,param3.x,param3.y + 3,param1,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
            }
            if(_loc4_ <= 0.8)
            {
               this._bmbehind2.render2(0,param3.x - 2,param3.y - 2,param1,BitmapSprite.ALIGN_CENTER,BitmapSprite.VALIGN_MIDDLE);
            }
         }
      }
      
      public function beginMove(param1:Item, param2:int, param3:Number, param4:Number, param5:int) : void
      {
         this._pt.x = this._item.x;
         this._pt.y = this._item.y;
         var _loc6_:TTGroup = new TTGroup();
         if(Math.abs(this._item.x - param3) > 0.5)
         {
            _loc6_.add(new TTItem(this._pt,param5 - 1,"x",param3,{"easing":TTEasing.PowerOut(1.15)}));
         }
         else
         {
            _loc6_.add(new TTItem(this._pt,param5 - 1,"y",param4 + 0.5,{"easing":TTEasing.PowerOut(1.15)}));
         }
         this._tweener.addGroup(_loc6_);
      }
      
      public function getRemoveScale(param1:Number) : Number
      {
         if(this._removedAtTick < 0)
         {
            return 1;
         }
         return Math.max(0,11 - (param1 - this._removedAtTick)) / 10;
      }
      
      public function remove() : void
      {
         this._isRemoved = true;
         this._removedAtTick = this._tick;
         if(this._item._destroyTicks <= 1)
         {
            this._forceDestroy = true;
         }
         this._dust = new BitmapSprite(ItemViewUtils.Dust,15,1);
         this._dust.setFPS(30);
         this._dust.play();
         this._dust.applyFilter(ItemViewUtils.getColorFilter_dust(this._item.color));
         this._bmSprites.push(this._dust);
      }
      
      public function blast() : void
      {
         this._blastBm = ItemViewBlast.createWrapBlast(this._item);
         if(this._blastBm)
         {
            this._blastBm.play();
            this._bmSprites.push(this._blastBm);
         }
      }
      
      public function colorblast(param1:Number, param2:Number, param3:IntCoord) : void
      {
         this._blastBm = ItemViewBlast.createColorBlast(this._item);
         if(this._blastBm)
         {
            this._bmSprites.push(this._blastBm);
            this._blastBm.play();
         }
      }
      
      public function bounced(param1:Boolean) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:Number = Math.abs(this._item.ya);
         if(_loc2_ < 0.1)
         {
            return;
         }
         this.playCandyLandSound(this._item.x,(_loc2_ + 0.1) * 2);
         this._bounceTicks = 15;
         this._bounceForce = this._item.ya;
      }
      
      private function playCandyLandSound(param1:Number, param2:Number) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Class = null;
         var _loc6_:Number = NaN;
         var _loc3_:int = int(getTimer());
         if(_loc3_ - _lastCandyLandTime > 50)
         {
            _loc4_ = int(int(4 * Math.random()));
            _loc5_ = CandyLandSounds[_loc4_];
            _loc6_ = CandyLandVolumes[_loc4_] * param2;
            SoundVars.sound.play(_loc5_,_loc6_,GameView.gridToStage(param1,0).x);
            _lastCandyLandTime = _loc3_;
         }
      }
      
      public function showHint() : void
      {
         this._hintTicks = this.HintTicks;
      }
      
      public function showBoosterHint(param1:int) : void
      {
         this._boosterHintTicks = param1 + 1;
         this._boosterHintMaxTicks = param1;
      }
      
      public function getSprite() : Sprite
      {
         return this._sprite;
      }
      
      public function getBmSprite() : BitmapSprite
      {
         return this._bmsprite;
      }
      
      public function destroy() : void
      {
         if(!this._isRemoved)
         {
            this._forceDestroy = true;
         }
      }
      
      public function doRemove() : Boolean
      {
         return this._forceDestroy || this._isRemoved && this._tick - this._removedAtTick >= this._destroyTicks;
      }
   }
}
