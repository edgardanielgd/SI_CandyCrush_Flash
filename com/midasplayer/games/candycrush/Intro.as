package com.midasplayer.games.candycrush
{
   import com.midasplayer.animation.tweenick.TickTween;
   import com.midasplayer.engine.GameDataParser;
   import com.midasplayer.engine.IPart;
   import com.midasplayer.engine.render.IRenderableRoot;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.games.candycrush.render.UiButtonRenderer;
   import com.midasplayer.games.candycrush.render.particles.Particle;
   import com.midasplayer.games.candycrush.utils.CustomFrameAnimation;
   import com.midasplayer.games.candycrush.utils.Py;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.getTimer;
   
   public class Intro extends Sprite implements IPart, IRenderableRoot
   {
       
      
      private var _endTicks:int = 10;
      
      private var _stoppedBones:Boolean = false;
      
      private var _cfaDraperi:CustomFrameAnimation;
      
      private var _cfaIntro:CustomFrameAnimation;
      
      private const _introText:TextField = new TextField();
      
      private var _gameDataParser:GameDataParser;
      
      private var _isDone:Boolean = false;
      
      private var _draperi:GA_Draperi;
      
      private var _oldFrameRate:Number;
      
      private var _frameOffset:int = 0;
      
      private var _frameTick:int = 0;
      
      private var _tickOffset:int = 0;
      
      private var _tick:int = 0;
      
      private var _hasSkipped:Boolean = false;
      
      private var _introFramesIndex:int = 0;
      
      private var IntroFrames:Array;
      
      private var EndInitFrame:int;
      
      private var MaxTick:int;
      
      private var _tweener:TickTween;
      
      public function Intro(param1:GameDataParser, param2:TickTween)
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         this._draperi = new GA_Draperi();
         this.MaxTick = Ticks.sec2Ticks(9);
         super();
         this._gameDataParser = param1;
         this._tweener = param2;
         _loc3_ = Py.multValue(1,12);
         _loc4_ = Py.range(1,55 + 1);
         _loc5_ = Py.multValue(55,this.secondsToFrames(17));
         this.EndInitFrame = _loc4_.length + _loc5_.length;
         _loc6_ = Py.multValue(56,20);
         _loc7_ = Py.range(56,69 + 1);
         var _loc8_:Array = Py.addLists(_loc3_,_loc4_,_loc5_,_loc6_,_loc7_);
         this._cfaDraperi = new CustomFrameAnimation(this._draperi,_loc8_,false);
         var _loc9_:Array = Py.range(1,43 + 1);
         var _loc10_:Array = Py.multValue(43,this.secondsToFrames(8.5));
         var _loc11_:Array = Py.range(43,68 + 1);
         this.IntroFrames = Py.addLists(_loc9_,_loc10_,_loc11_);
         this.MaxTick = Ticks.sec2Ticks(this.framesToSeconds(_loc8_.length));
      }
      
      private function secondsToFrames(param1:Number) : int
      {
         return param1 * 25;
      }
      
      private function framesToSeconds(param1:Number) : int
      {
         return param1 / 25;
      }
      
      public function getDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function tick(param1:int) : void
      {
         if(this._draperi.currentFrame == 69)
         {
            _loc2_._endTicks = _loc3_;
            var _loc3_:*;
            var _loc2_:*;
            if((_loc3_ = (_loc2_ = this)._endTicks - 1) == 0)
            {
               this._isDone = true;
            }
         }
         if(Ticks.ticks2Sec(param1) >= 30)
         {
            this._isDone = true;
         }
         _loc3_ = (_loc2_ = this)._tick + 1;
         _loc2_._tick = _loc3_;
         this._tweener.tick(param1);
      }
      
      public function start() : void
      {
         var _loc1_:int = int(getTimer());
         Particle.initParticleBitmaps();
         Main.Log.trace("Particle time taken: " + (getTimer() - _loc1_) + " ms");
         SoundVars.music.play(SA_Music_intro2);
         this._oldFrameRate = stage.frameRate;
         stage.frameRate = 25;
         graphics.beginBitmapFill(GameView.BackgroundBmd);
         graphics.drawRect(0,0,755,600);
         graphics.endFill();
         UiButtonRenderer.instance.changeParentTo(this);
         this._draperi.x = 377;
         this._draperi.y = -10;
         this._draperi.gotoAndStop(1);
         this.setDraperiFrame(1,false);
         addChild(this._draperi);
         stage.addEventListener(MouseEvent.CLICK,this._onClick);
      }
      
      private function getCandyStripe(param1:int) : MovieClip
      {
         return this._draperi["s_" + param1];
      }
      
      private function setDraperiFrame(param1:int, param2:Boolean) : void
      {
         var i:int = 0;
         var frame:int = param1;
         var doPlay:Boolean = param2;
         try
         {
            i = 0;
            while(i < 16)
            {
               if(doPlay)
               {
                  this.getCandyStripe(i).gotoAndPlay(frame);
               }
               else
               {
                  this.getCandyStripe(i).gotoAndStop(frame);
               }
               i++;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function stop() : void
      {
         stage.removeEventListener(MouseEvent.CLICK,this._onClick);
         stage.frameRate = this._oldFrameRate;
      }
      
      public function isDone() : Boolean
      {
         return this._isDone;
      }
      
      public function render(param1:int, param2:Number) : void
      {
         SoundVars.update();
         if(this._cfaDraperi.frame == 15)
         {
            this.setDraperiFrame(1,true);
         }
         if(this._draperi.currentFrame >= 32 && !this._stoppedBones)
         {
            this._stoppedBones = true;
            this.setDraperiFrame(32,false);
         }
         var _loc3_:*;
         var _loc4_:* = (_loc3_ = this._cfaDraperi).frame + 1;
         _loc3_.frame = _loc4_;
         this._tweener.render(param2);
         this.updateIntroWithTexts(param1 + param2);
      }
      
      private function updateIntroWithTexts(param1:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc2_:GA_Intro = this._draperi.intro;
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.gotoAndStop(this.IntroFrames[this._introFramesIndex]);
         if(this._introFramesIndex < this.IntroFrames.length - 1)
         {
            var _loc5_:*;
            var _loc6_:* = (_loc5_ = this)._introFramesIndex + 1;
            _loc5_._introFramesIndex = _loc6_;
         }
         if(_loc2_.time)
         {
            _loc3_ = Math.max(0,Ticks.ticks2Sec(this.MaxTick - (this._tick + this._tickOffset)) + 1);
            _loc4_ = String(this._gameDataParser.getText("intro.time").replace("{0}",_loc3_));
            _loc2_.time.text = _loc4_;
         }
         if(Boolean(_loc2_.title1) && Boolean(_loc2_.title1.text))
         {
            _loc2_.title1.text.text = this._gameDataParser.getText("intro.title");
         }
         if(Boolean(_loc2_.info1) && Boolean(_loc2_.info1.text))
         {
            _loc2_.info1.text.text = this._gameDataParser.getText("intro.info1");
         }
         if(Boolean(_loc2_.info2) && Boolean(_loc2_.info2.text))
         {
            _loc2_.info2.text.text = this._gameDataParser.getText("intro.info2");
         }
      }
      
      private function _onClick(param1:MouseEvent) : void
      {
         if(UiButtonRenderer.instance.hitTest(param1.stageX,param1.stageY))
         {
            return;
         }
         if(!this._hasSkipped && this._tick > 80)
         {
            this._hasSkipped = true;
            this._cfaDraperi.frame = this.EndInitFrame;
            this._tickOffset = this.MaxTick - 30;
            this._tick = 0;
         }
      }
   }
}
