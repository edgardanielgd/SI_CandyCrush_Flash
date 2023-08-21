package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.animation.tweenick.TTEasing;
   import com.midasplayer.animation.tweenick.TTGroup;
   import com.midasplayer.animation.tweenick.TTItem;
   import com.midasplayer.animation.tweenick.TickTween;
   import com.midasplayer.games.candycrush.Logic;
   import com.midasplayer.games.candycrush.Ticks;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.sound.ManagedSoundChannel;
   import flash.display.BitmapData;
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   
   public class Ui extends TickedSprite
   {
      
      private static const ProgressionBaseX:int = 10;
      
      private static const ProgressionBaseY:int = 128;
       
      
      private var _logic:Logic;
      
      private var _lastScore:int = -1;
      
      private var _lastSecondsLeft:int = -1;
      
      private var _timeWarningChannel:ManagedSoundChannel;
      
      private var _playingTimeWarning:Boolean = false;
      
      private var _timeColor:int = 2;
      
      private const MaxTweenTicks:Number = 20;
      
      private var _labelTop:GA_Ui_labelTop;
      
      private var _cane:Cane;
      
      private var _tweener:TickTween;
      
      public function Ui(param1:BitmapData, param2:int, param3:Logic, param4:TickTween)
      {
         super(param1,param2);
         this._logic = param3;
         this._tweener = param4;
         this._labelTop = new GA_Ui_labelTop();
         this._labelTop.x = 52;
         this._labelTop.y = -200;
         this._labelTop.score.text = "";
         this._labelTop.time.text = "4:00";
         backsprite.addChild(this._labelTop);
         this._cane = new Cane(param4);
         this._cane.getBackDisplayObject().x = ProgressionBaseX;
         this._cane.getBackDisplayObject().y = ProgressionBaseY;
         backsprite.addChild(this._cane.getBackDisplayObject());
      }
      
      public function show() : void
      {
         var _loc1_:TTGroup = new TTGroup();
         _loc1_.add(new TTItem(this._labelTop,this.MaxTweenTicks,"y",18,{"easing":TTEasing.QuadraticOut}));
         this._tweener.addGroup(_loc1_);
         this._cane.setupCaneTween();
         UiButtonRenderer.instance.changeParentTo(backsprite);
         UiButtonRenderer.instance.moveIn();
      }
      
      public function hide() : void
      {
         var _loc1_:TTGroup = new TTGroup();
         _loc1_.add(new TTItem(this._labelTop,40,"y",-200));
         _loc1_.add(new TTItem(this._cane.getBackDisplayObject(),40,"x",-100));
         this._tweener.addGroup(_loc1_);
      }
      
      public function setRemovalShare(param1:Number) : void
      {
         this._cane.setRemovalShare(param1);
      }
      
      public function lastBlast() : void
      {
         SoundVars.sound.manager.getFromClass(SA_Other_timewarning).fadeToAndStop(0,200);
      }
      
      override public function addAndRemoveMe() : Boolean
      {
         return true;
      }
      
      override public function addAtBack() : Boolean
      {
         return true;
      }
      
      override public function tick(param1:int) : void
      {
         this.tickLabels(param1);
         this._cane.tick(param1);
      }
      
      public function setLevel(param1:int) : void
      {
         this._cane.setLevelLabel(param1);
      }
      
      public function levelComplete(param1:int) : void
      {
         var newLevelTicks:int = param1;
         if(this._playingTimeWarning)
         {
            SoundVars.sound.manager.getFromClass(SA_Other_timewarning).fadeToAndStop(0,500);
            setTimeout(function():void
            {
               SoundVars.sound.manager.getFromClass(SA_Other_timewarning).play(SoundVars.SoundVolume * 0.75);
            },1000 * Ticks.ticks2Sec(newLevelTicks));
         }
         this._cane.levelComplete();
      }
      
      private function tickLabels(param1:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = this._logic.getScore();
         if(_loc2_ != this._lastScore)
         {
            this._labelTop.score.text = "" + _loc2_;
            this._lastScore = _loc2_;
         }
         var _loc3_:int = Math.max(0,Ticks.ticks2Sec(this._logic.getTicksLeft() - 2) + 1);
         if(_loc3_ != this._lastSecondsLeft)
         {
            _loc4_ = _loc3_ / 60;
            _loc5_ = _loc3_ - _loc4_ * 60;
            this._labelTop.time.text = "" + _loc4_ + (_loc5_ < 10 ? ":0" : ":") + _loc5_;
            this._lastSecondsLeft = _loc3_;
         }
      }
      
      override protected function renderBack(param1:int, param2:Number) : void
      {
         var _loc3_:Number = param1 + param2;
         this.renderTimeWarning(param1,param2);
         this._cane._renderBack(param1,param2);
         UiButtonRenderer.instance.update();
      }
      
      private function renderTimeWarning(param1:int, param2:Number) : void
      {
         var _loc5_:TextFormat = null;
         var _loc3_:int = this._logic.getTicksLeft();
         if(_loc3_ > Ticks.sec2Ticks(5) + 10)
         {
            return;
         }
         if(!this._playingTimeWarning)
         {
            this._timeWarningChannel = SoundVars.sound.manager.getFromClass(SA_Other_timewarning).play(SoundVars.SoundVolume * 0.75);
            this._playingTimeWarning = true;
         }
         if(this._timeColor == 2)
         {
            (_loc5_ = this._labelTop.time.defaultTextFormat).color = 12264265;
            this._labelTop.time.defaultTextFormat = _loc5_;
            this._timeColor = 1;
         }
         var _loc4_:int = this._timeColor;
         this._timeColor = param1 / 5 % 3;
         if(this._timeColor != _loc4_)
         {
            this._labelTop.time.visible = this._timeColor != 2;
         }
      }
   }
}

import com.midasplayer.animation.tweenick.TTFunctionCall;
import com.midasplayer.animation.tweenick.TTGroup;
import com.midasplayer.animation.tweenick.TTItem;
import com.midasplayer.animation.tweenick.TickTween;
import com.midasplayer.games.candycrush.render.TickedSprite;
import com.midasplayer.games.candycrush.utils.MCAnimation;
import flash.display.MovieClip;

class Cane extends TickedSprite
{
   
   private static const ProgressionLines:int = 11;
   
   private static const ProgressionDelay:int = 16;
   
   private static const ProgressionDrawTime:int = 10;
   
   private static const ProgressionBaseX:int = 4;
   
   private static const ProgressionBaseY:int = 136;
   
   private static const ProgressionEndY:int = 232;
   
   private static const ProgressionJumpY:int = 22;
    
   
   private var _startGlowTick:int = -1;
   
   private var _lastTick:int = 0;
   
   private const _cane:GA_Anim_CaneIn = new GA_Anim_CaneIn();
   
   private const _stripes:Vector.<MovieClip> = new Vector.<MovieClip>();
   
   private var _removalShare:Number = 0;
   
   private var _currentProgressionLine:int = 0;
   
   private var _lastProgressionUp:int = -999999;
   
   private var _tweener:TickTween;
   
   private var _glow:MovieClip = null;
   
   private var _levelLabelAnim:MCAnimation;
   
   private var _level:int = 0;
   
   public function Cane(param1:TickTween)
   {
      var _loc3_:MovieClip = null;
      super(null,0);
      this._tweener = param1;
      this._cane.x = 370;
      this._cane.y = -155;
      backsprite.addChild(this._cane);
      var _loc2_:int = 0;
      while(_loc2_ < ProgressionLines)
      {
         _loc3_ = new GA_Ui_Mc_SugarCane_Stripe();
         _loc3_.y = ProgressionEndY - ProgressionJumpY * _loc2_;
         backsprite.addChild(_loc3_);
         this._stripes.push(_loc3_);
         _loc2_++;
      }
      this.resetProgression();
      this.setLevelLabel(1);
   }
   
   public function setupCaneTween() : void
   {
      this._cane.gotoAndStop(1);
      this._cane.levelLabel.gotoAndStop(1);
      var _loc1_:MCAnimation = new MCAnimation(this._cane);
      var _loc2_:TTGroup = new TTGroup();
      _loc2_.add(new TTItem(_loc1_,12,"frame",11));
      this._tweener.addGroup(_loc2_);
   }
   
   public function setLevelLabel(param1:int) : void
   {
      var _loc2_:GA_Ui_Mc_labelNewLevel = this._cane.levelLabel;
      if(!_loc2_)
      {
         return;
      }
      this._level = param1;
      if(_loc2_.s0 && _loc2_.s0.text && _loc2_.s0.text.text != "" + param1)
      {
         _loc2_.s0.text.text = "" + param1;
      }
      if(_loc2_.s2 && _loc2_.s2.text && _loc2_.s2.text.text != "" + param1)
      {
         _loc2_.s2.text.text = "" + param1;
      }
   }
   
   private function resetProgression() : void
   {
      var _loc1_:MovieClip = null;
      this._removalShare = 0;
      this._currentProgressionLine = 0;
      this._lastProgressionUp = -999999;
      for each(_loc1_ in this._stripes)
      {
         _loc1_.alpha = 1;
         _loc1_.gotoAndStop(1);
      }
   }
   
   public function setRemovalShare(param1:Number) : void
   {
      this._removalShare = param1;
   }
   
   override public function tick(param1:int) : void
   {
      this._lastTick = param1;
      var _loc2_:int = this._removalShare * ProgressionLines;
      if(_loc2_ > this._currentProgressionLine && this.sinceLastUp(param1) >= ProgressionDelay)
      {
         if(this._currentProgressionLine < ProgressionLines)
         {
            this._lastProgressionUp = param1;
            var _loc3_:*;
            var _loc4_:* = (_loc3_ = this)._currentProgressionLine + 1;
            _loc3_._currentProgressionLine = _loc4_;
         }
      }
   }
   
   public function levelComplete() : void
   {
      var ttg:TTGroup;
      var inTicks:Number;
      var i:int;
      var labelAnim:MCAnimation = null;
      this._glow = new GA_Ui_Progression_glow();
      this._glow.x = -3;
      this._startGlowTick = this._lastTick;
      ttg = new TTGroup();
      inTicks = 15;
      i = 0;
      while(i < ProgressionLines)
      {
         inTicks += 1.25;
         ttg.addInTicks(int(inTicks),new TTItem(this._stripes[i],4,"alpha",0));
         i++;
      }
      labelAnim = new MCAnimation(this._cane.levelLabel);
      ttg.addInTicks(inTicks + 10,new TTFunctionCall(50,this.resetProgression));
      ttg.addInTicks(10,new TTItem(labelAnim,20,"frame",15));
      ttg.addInTicks(10,new TTFunctionCall(20,function():void
      {
         var _loc1_:*;
         var _loc2_:* = (_loc1_ = §§findproperty(_level))._level + 1;
         _loc1_._level = _loc2_;
      }));
      ttg.addInTicks(30,new TTItem(labelAnim,20,"frame",30,{"start":15}));
      ttg.addInTicks(30,new TTFunctionCall(20,function():void
      {
         labelAnim.frame = 1;
         setLevelLabel(_level);
      }));
      this._tweener.addGroup(ttg);
      backsprite.addChild(this._glow);
   }
   
   override protected function renderBack(param1:int, param2:Number) : void
   {
      var _loc3_:Number = param1 + param2;
      this.setLevelLabel(this._level);
      this.renderProgression(_loc3_);
      this.renderLevelCompletedGlow(_loc3_);
   }
   
   private function renderLevelNumber() : void
   {
      this.setLevelLabel(this._level);
   }
   
   private function renderLevelCompletedGlow(param1:Number) : void
   {
      if(this._startGlowTick < 0)
      {
         return;
      }
      var _loc2_:int = int(getWantedFrame2(param1,15,this._startGlowTick,1));
      if(_loc2_ >= 1 && _loc2_ <= 25)
      {
         this._glow.gotoAndStop(_loc2_);
      }
      else
      {
         backsprite.removeChild(this._glow);
         this._startGlowTick = -1;
         this._glow = null;
      }
   }
   
   private function renderProgression(param1:Number) : void
   {
      var _loc3_:int = 0;
      if(this._currentProgressionLine == 0)
      {
         return;
      }
      var _loc2_:int = int(clamp(this._currentProgressionLine - 1,0,ProgressionLines - 1));
      _loc3_ = 0;
      while(_loc3_ < _loc2_)
      {
         if(this._stripes[_loc3_].currentFrame != 9)
         {
            this._stripes[_loc3_].gotoAndStop(9);
         }
         _loc3_++;
      }
      var _loc4_:Number = this.sinceLastUp(param1) / ProgressionDrawTime;
      var _loc5_:int;
      if((_loc5_ = 1 + _loc4_ * 9) >= 1)
      {
         _loc5_ = int(clamp(_loc5_,1,9));
         if(this._stripes[this._currentProgressionLine - 1].currentFrame != _loc5_)
         {
            this._stripes[this._currentProgressionLine - 1].gotoAndStop(_loc5_);
         }
      }
   }
   
   private function sinceLastUp(param1:Number) : Number
   {
      return param1 - this._lastProgressionUp;
   }
}
