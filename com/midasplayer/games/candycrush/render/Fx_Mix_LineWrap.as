package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.animation.tweenick.TTData;
   import com.midasplayer.animation.tweenick.TTEasing;
   import com.midasplayer.games.candycrush.GameView;
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.input.SwapInfo;
   import com.midasplayer.games.candycrush.render.itemview.ItemView;
   import com.midasplayer.games.candycrush.render.particles.PSystem;
   import com.midasplayer.math.IntCoord;
   import com.midasplayer.sound.ManagedSoundChannel;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   public class Fx_Mix_LineWrap extends TickedSprite
   {
       
      
      private var _source:Item;
      
      private var _sourcePos:IntCoord;
      
      private var _line:BlastInfo;
      
      private var _column:BlastInfo;
      
      private var _views:Array;
      
      private var _viewsPos:Array;
      
      private var _ticks:int = 0;
      
      private var _shownColumn:Boolean = false;
      
      private var _playedLineSound:Boolean = false;
      
      private var _playedLineSound2:Boolean = false;
      
      private var _playedColumnSound:Boolean = false;
      
      private var _psystemL:PSystem;
      
      private var _psystemC:PSystem;
      
      public function Fx_Mix_LineWrap(param1:BitmapData, param2:int, param3:SwapInfo, param4:Vector.<Item>)
      {
         this._views = [];
         this._viewsPos = [];
         super(param1,param2);
         this._source = param3.item_a;
         this._sourcePos = GameView.gridToStage(this._source.x,this._source.y);
         this.setup(this._source,param4);
      }
      
      public static function getBigBlastMc(param1:Number, param2:Number, param3:int, param4:int) : MovieClip
      {
         var _loc5_:MovieClip = null;
         var _loc6_:IntCoord = GameView.gridToStage(param1,param2 + 0.5);
         if(param3 == ItemType.LINE)
         {
            if(param4 == GameView.COLOR_BLUE || param4 == GameView.COLOR_NONE)
            {
               _loc5_ = new blue_horisontal_lineblast_big();
            }
            else if(param4 == GameView.COLOR_GREEN)
            {
               _loc5_ = new green_horisontal_lineblast_big();
            }
            else if(param4 == GameView.COLOR_ORANGE)
            {
               _loc5_ = new orange_horisontal_lineblast_big();
            }
            else if(param4 == GameView.COLOR_PURPLE)
            {
               _loc5_ = new purple_horisontal_lineblast_big();
            }
            else if(param4 == GameView.COLOR_RED)
            {
               _loc5_ = new red_horisontal_lineblast_big();
            }
            else if(param4 == GameView.COLOR_YELLOW)
            {
               _loc5_ = new yellow_horisontal_lineblast_big();
            }
         }
         if(param3 == ItemType.COLUMN)
         {
            if(param4 == GameView.COLOR_BLUE || param4 == GameView.COLOR_NONE)
            {
               _loc5_ = new blue_vertical_lineblast_big();
            }
            else if(param4 == GameView.COLOR_GREEN)
            {
               _loc5_ = new green_vertical_lineblast_big();
            }
            else if(param4 == GameView.COLOR_ORANGE)
            {
               _loc5_ = new orange_vertical_lineblast_big();
            }
            else if(param4 == GameView.COLOR_PURPLE)
            {
               _loc5_ = new purple_vertical_lineblast_big();
            }
            else if(param4 == GameView.COLOR_RED)
            {
               _loc5_ = new red_vertical_lineblast_big();
            }
            else if(param4 == GameView.COLOR_YELLOW)
            {
               _loc5_ = new yellow_vertical_lineblast_big();
            }
         }
         if(_loc5_)
         {
            _loc5_.x = _loc6_.x;
            _loc5_.y = _loc6_.y;
            _loc5_.gotoAndStop(1);
         }
         return _loc5_;
      }
      
      private function setup(param1:Item, param2:Vector.<Item>) : void
      {
         this._line = new BlastInfo(getBigBlastMc(param1.x,param1.row,ItemType.LINE,param1.color),0);
         this._column = new BlastInfo(getBigBlastMc(param1.x,param1.row,ItemType.COLUMN,param1.color),0);
         frontsprite.addChild(this._column.clip);
         this._column.onStage = true;
         this._column.clip.scaleY = this._column.clip.scaleY = 0;
         frontsprite.addChild(this._line.clip);
         this._line.onStage = true;
         this._line.clip.scaleY = this._line.clip.scaleY = 0;
         var _loc3_:IntCoord = GameView.gridToStage(param1.column,param1.row + 0.5);
         this._psystemL = new StripeWrapPSystem(canvas,param1.color,false,_loc3_.x,_loc3_.y);
         this._psystemC = new StripeWrapPSystem(canvas,param1.color,true,_loc3_.x,_loc3_.y);
         this._psystemC.perTick = this._psystemL.perTick = 7;
         this._psystemC.WaitTicks = this._psystemL.WaitTicks = 100000;
         for each(param1 in param2)
         {
            this._views.push(param1.view);
            this._viewsPos.push(GameView.gridToStage(param1.x,param1.y));
            param1.view.autoHandleRender = false;
         }
      }
      
      override public function tick(param1:int) : void
      {
         var _loc2_:*;
         var _loc3_:* = (_loc2_ = this)._ticks + 1;
         _loc2_._ticks = _loc3_;
         this._psystemL.tick(param1);
         this._psystemC.tick(param1);
      }
      
      override protected function renderFront(param1:int, param2:Number) : void
      {
         var _loc6_:int = 0;
         var _loc7_:ItemView = null;
         var _loc8_:IntCoord = null;
         var _loc9_:Number = NaN;
         var _loc10_:ManagedSoundChannel = null;
         var _loc11_:ManagedSoundChannel = null;
         var _loc3_:Number = Number(getLivedTicks());
         if(_loc3_ > 20 && !this._shownColumn)
         {
            this._column.clip.alpha = 1;
            this._column.clip.scaleX = this._column.clip.scaleY = 0.33;
            this._shownColumn = true;
         }
         if(_loc3_ < 12)
         {
            _loc6_ = 0;
            while(_loc6_ < this._views.length)
            {
               _loc7_ = this._views[_loc6_];
               _loc8_ = this._viewsPos[_loc6_];
               _loc9_ = _loc3_ * 0.083333;
               _loc7_.renderXy(this.ease(_loc8_.x,this._sourcePos.x,_loc9_),this.ease(_loc8_.y,this._sourcePos.y,_loc9_),canvas);
               this._line.clip.alpha = _loc9_;
               this._line.clip.scaleX = this._line.clip.scaleY = this.ease(0,1,_loc9_);
               _loc6_++;
            }
         }
         else if(_loc3_ >= 36 && _loc3_ < 46)
         {
            _loc9_ = (_loc3_ - 36) * 0.1;
            this._column.clip.alpha = 1;
            this._column.clip.scaleX = this._column.clip.scaleY = this.ease(0.33,1,_loc9_);
         }
         var _loc4_:int;
         if((_loc4_ = int(getWantedFrame(24,16,this._line.startFrame))) > this._line.clip.totalFrames)
         {
            if(this._line.onStage)
            {
               frontsprite.removeChild(this._line.clip);
               this._line.onStage = false;
            }
         }
         else if(_loc4_ >= 0)
         {
            if(!this._playedLineSound2 && this._playedLineSound)
            {
               if(_loc10_ = SoundVars.sound.play(SA_Swoosh_ut_2,0.9,this._sourcePos.x))
               {
                  _loc10_.panTo(1,800);
               }
               this._playedLineSound2 = true;
            }
            if(!this._playedLineSound)
            {
               if(_loc11_ = SoundVars.sound.play(SA_Swoosh_in_2,0.9,this._sourcePos.x))
               {
                  _loc11_.panTo(-1,800);
               }
               this._playedLineSound = true;
               this._psystemL.WaitTicks = this._ticks + 10;
            }
            this._line.renderFrame(_loc4_);
         }
         var _loc5_:int;
         if((_loc5_ = int(getWantedFrame(24,48,this._column.startFrame))) > this._column.clip.totalFrames + 15)
         {
            done = true;
         }
         else if(_loc5_ >= 0)
         {
            if(!this._playedColumnSound)
            {
               SoundVars.sound.play(SA_Swoosh_ut_2,1,this._sourcePos.x);
               this._playedColumnSound = true;
               this._psystemC.WaitTicks = this._ticks + 10;
            }
            this._column.renderFrame(_loc5_);
         }
         this._psystemL.render(param1,param2);
         this._psystemC.render(param1,param2);
      }
      
      override public function addAndRemoveMe() : Boolean
      {
         return true;
      }
      
      override public function addAtFront() : Boolean
      {
         return true;
      }
      
      protected function ease(param1:Number, param2:Number, param3:Number) : Number
      {
         return TTEasing.QuadraticIn(new TTData(1,param1,param2,param3));
      }
   }
}

import flash.display.MovieClip;

class BlastInfo
{
    
   
   public var clip:MovieClip;
   
   public var startFrame:int;
   
   public var onStage:Boolean = false;
   
   private var _lastFrame:int = -1;
   
   public function BlastInfo(param1:MovieClip, param2:int)
   {
      super();
      this.clip = param1;
      this.clip.gotoAndStop(1);
      this.startFrame = param2;
   }
   
   public function renderFrame(param1:int) : void
   {
      if(param1 != this._lastFrame)
      {
         this.clip.gotoAndStop(param1);
         this._lastFrame = param1;
      }
   }
}

import com.midasplayer.games.candycrush.render.particles.PSystem;
import com.midasplayer.games.candycrush.render.particles.Particle;
import flash.display.BitmapData;

class StripeWrapPSystem extends PSystem
{
    
   
   public function StripeWrapPSystem(param1:BitmapData, param2:int, param3:Boolean, param4:int, param5:int)
   {
      super(param1,param2,param3,param4,param5);
   }
   
   override public function addParticle(param1:Particle) : void
   {
      if(Math.abs(param1.vx) > Math.abs(param1.vy))
      {
         param1.vx = param1.vx * 2;
         param1.vy = 10 * PSystem.rsigned();
      }
      else
      {
         param1.vy = param1.vy * 2;
         param1.vx = 10 * PSystem.rsigned();
      }
      super.addParticle(param1);
   }
}
