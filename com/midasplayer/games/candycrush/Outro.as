package com.midasplayer.games.candycrush
{
   import com.midasplayer.animation.tweenick.TickTween;
   import com.midasplayer.engine.GameDataParser;
   import com.midasplayer.engine.IPart;
   import com.midasplayer.engine.render.IRenderableRoot;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.games.candycrush.render.UiButtonRenderer;
   import com.midasplayer.games.candycrush.utils.Random;
   import com.midasplayer.math.MtRandom;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.net.*;
   import flash.utils.*;
   
   public class Outro extends Sprite implements IPart, IRenderableRoot
   {
       
      
      private var _trophySoundIndex:int = -1;
      
      private var _trophySoundArray:Array;
      
      private var _oldFrameFrame:int;
      
      private var _outro:GA_GameOver;
      
      private var _gameDataParser:GameDataParser;
      
      private var _isDone:Boolean = false;
      
      private var _canQuit:Boolean = false;
      
      private var _stoppedIntro:Boolean = false;
      
      private var _logic:com.midasplayer.games.candycrush.Logic;
      
      private var _gameView:com.midasplayer.games.candycrush.GameView;
      
      private var _score:com.midasplayer.games.candycrush.ScoreHolder;
      
      private var _trophies:Vector.<TrophyInfo>;
      
      private var _handledTrophies:Boolean = false;
      
      private var MaxTick:int;
      
      private var _removedBoard:Boolean = false;
      
      private var _trophyHoverText:GA_Trophy_Hover_text;
      
      private var _tweener:TickTween;
      
      private var _bestScoreEver:int = -1;
      
      private var _bestLevelEver:int = -1;
      
      private var _bestCrushedEver:int = -1;
      
      private var _bestSequenceEver:int = -1;
      
      private var _isShortGame:Boolean;
      
      private var _openGamePaper:GA_Paper_opengame;
      
      public function Outro(param1:GameDataParser, param2:com.midasplayer.games.candycrush.Logic, param3:com.midasplayer.games.candycrush.GameView, param4:Boolean)
      {
         this._trophySoundArray = [SA_Other_Trophy_bounce1,SA_Other_Trophy_bounce2,SA_Other_Trophy_bounce3];
         this._trophies = new Vector.<TrophyInfo>();
         this._trophyHoverText = new GA_Trophy_Hover_text();
         super();
         this._gameDataParser = param1;
         this._logic = param2;
         this._score = param2.getScoreHolder();
         this._gameView = param3;
         this._tweener = param3.getTweener();
         this._isShortGame = param4;
         this.MaxTick = Ticks.sec2Ticks(param4 ? 2.6 : 20);
         new Random(new MtRandom()).shuffle(this._trophySoundArray);
      }
      
      public function getDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function tick(param1:int) : void
      {
         var _loc2_:Number = Ticks.ticks2Sec(param1);
         if(_loc2_ > 4)
         {
            this._canQuit = true;
         }
         if(param1 > this.MaxTick)
         {
            this._isDone = true;
         }
         if(!this._handledTrophies)
         {
            this.tick_addTrophiesToScene(param1);
         }
         this._gameView.tickFromOutro(param1);
      }
      
      private function tick_addTrophiesToScene(param1:int) : void
      {
         var _loc2_:TrophyInfo = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         var _loc5_:int = 0;
         this._handledTrophies = true;
         for each(_loc2_ in this._trophies)
         {
            if(_loc2_.inTicks == param1)
            {
               if(_loc2_.collectedTrophyNow)
               {
                  SoundVars.sound.play(SA_Other_trophy);
               }
               _loc3_ = new _loc2_.cls();
               _loc3_.x = _loc2_.x;
               _loc3_.y = _loc2_.y;
               _loc4_ = new GA_Trophy_Mask();
               _loc3_.mask = _loc4_;
               _loc4_.x = 78;
               _loc4_.y = 146;
               _loc5_ = int(getChildIndex(this._outro));
               addChildAt(_loc3_,_loc5_);
               addChildAt(_loc4_,_loc5_);
               _loc2_.trophyMc = _loc3_;
            }
            if(_loc2_.inTicks + 10 == param1)
            {
               _loc2_.handled = true;
               _loc2_.soundClass = this.getTrophySoundClass();
               SoundVars.sound.play(_loc2_.soundClass,0.5,_loc2_.trophyMc.x + 20);
            }
            if(!_loc2_.handled)
            {
               this._handledTrophies = false;
            }
         }
      }
      
      private function getTrophySoundClass() : Class
      {
         _loc1_._trophySoundIndex = _loc2_;
         var _loc2_:*;
         var _loc1_:*;
         if((_loc2_ = (_loc1_ = this)._trophySoundIndex + 1) > 2)
         {
            this._trophySoundIndex = 2;
         }
         return this._trophySoundArray[this._trophySoundIndex];
      }
      
      public function isDone() : Boolean
      {
         return this._isDone;
      }
      
      public function start() : void
      {
         this._oldFrameFrame = stage.frameRate;
         stage.frameRate = 25;
         this._outro = new GA_GameOver();
         this._outro.x = 377;
         addChild(this._gameView);
         if(this._isShortGame)
         {
            this._openGamePaper = new GA_Paper_opengame();
            this._openGamePaper.x = 248;
            this._openGamePaper.y = 194;
            this._openGamePaper.gotoAndPlay(1);
            addChild(this._openGamePaper);
            return;
         }
         SoundVars.music.fadeCurrentMusic(0,2000,true);
         SoundVars.music.play(SA_Music_outro);
         this.setupStats();
         UiButtonRenderer.instance.changeParentTo(this);
         UiButtonRenderer.instance.moveOut();
         addChild(this._outro);
         stage.addEventListener(MouseEvent.CLICK,this._onClick);
         this.setupTrophies();
      }
      
      private function setupStats() : void
      {
         this._bestScoreEver = com.midasplayer.games.candycrush.ScoreHolder.imax(this._score.getTotalScore(),this._gameDataParser.getAsInt("bestScore"));
         this._bestLevelEver = com.midasplayer.games.candycrush.ScoreHolder.imax(this._score.getLevel() + 1,this._gameDataParser.getAsInt("bestLevel") + 1);
         this._bestCrushedEver = com.midasplayer.games.candycrush.ScoreHolder.imax(this._score.getTotalRemoveItemCount(),this._gameDataParser.getAsInt("bestCrushed"));
         this._bestSequenceEver = com.midasplayer.games.candycrush.ScoreHolder.imax(this._score.getLongestSequence(),this._gameDataParser.getAsInt("bestChain"));
      }
      
      private function setupTrophies() : void
      {
         var _loc4_:* = false;
         var _loc1_:int = 120;
         var _loc2_:String = "";
         var _loc3_:int = 15;
         var _loc5_:int = 1000;
         if(this._bestCrushedEver >= _loc5_)
         {
            _loc4_ = this._gameDataParser.getAsInt("bestCrushed") < _loc5_;
            _loc2_ = String(this._gameDataParser.getText("outro.trophy.one").replace("{0}",_loc5_));
            this._trophies.push(new TrophyInfo(GA_Trophy_Bear,_loc4_,_loc1_,160,448,_loc2_));
            _loc1_ += _loc3_;
         }
         var _loc6_:int = 50000;
         if(this._bestScoreEver >= _loc6_)
         {
            _loc4_ = this._gameDataParser.getAsInt("bestScore") < _loc6_;
            _loc2_ = String(this._gameDataParser.getText("outro.trophy.two").replace("{0}",_loc6_));
            this._trophies.push(new TrophyInfo(GA_Trophy_Bunny,_loc4_,_loc1_,250,442,_loc2_));
            _loc1_ += _loc3_;
         }
         var _loc7_:int = 5;
         var _loc8_:int;
         if((_loc8_ = com.midasplayer.games.candycrush.ScoreHolder.imax(this._score.getPowerupsMixedCount(),this._gameDataParser.getAsInt("bestMixed"))) >= _loc7_)
         {
            _loc4_ = this._gameDataParser.getAsInt("bestMixed") < _loc7_;
            _loc2_ = String(this._gameDataParser.getText("outro.trophy.three").replace("{0}",_loc7_));
            this._trophies.push(new TrophyInfo(GA_Trophy_Penguin,_loc4_,_loc1_,343,445,_loc2_,-16));
            _loc1_ += _loc3_;
         }
         this._trophyHoverText.visible = false;
         this._trophyHoverText.text.text = "";
         this._trophyHoverText.y = 260;
         addChild(this._trophyHoverText);
      }
      
      public function stop() : void
      {
         trace("Thunder_one Scores Here!!: = " + this._score.getTotalScore());
         urlRequest = new URLRequest("index.php?act=Arcade&do=newscore");
         urlVars = new URLVariables();
         urlVars.gname = "candyCrushAS3v2Th";
         urlVars.gscore = _score.getTotalScore();
         urlRequest.method = URLRequestMethod.POST;
         urlRequest.data = urlVars;
         navigateToURL(urlRequest,"_self");
      }
      
      public function render(param1:int, param2:Number) : void
      {
         if(!this._removedBoard && this._outro.currentFrame >= 26)
         {
            this._removedBoard = true;
            this._gameView.fadeOutBoard();
         }
         if(!this._stoppedIntro && this._outro.currentFrame >= 85)
         {
            this._outro.stop();
            this._stoppedIntro = true;
         }
         this.updateTexts(param1 + param2);
         this._gameView.renderFromOutro(param1,param2);
      }
      
      public function updateTexts(param1:Number) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:TrophyInfo = null;
         if(this._isShortGame && this._openGamePaper && Boolean(this._openGamePaper.sprite))
         {
            this._openGamePaper.sprite.text.text = this._gameDataParser.getText("outro.opengame");
            return;
         }
         var _loc2_:GA_ScoreBoard = this._outro.scoreboard;
         if(!_loc2_)
         {
            return;
         }
         _loc2_.title.text = this._gameDataParser.getText("outro.title");
         _loc2_.now.text = this._gameDataParser.getText("outro.now");
         _loc2_.bestever.text = this._gameDataParser.getText("outro.bestever");
         _loc2_.score.text = this._gameDataParser.getText("outro.score") + ":";
         _loc2_.chain.text = this._gameDataParser.getText("outro.chain") + ":";
         _loc2_.level.text = this._gameDataParser.getText("outro.level") + ":";
         _loc2_.crushed.text = this._gameDataParser.getText("outro.crushed") + ":";
         _loc2_.score_now.text = "" + (_loc3_ = this._score.getTotalScore());
         _loc2_.score_best.text = "" + this._bestScoreEver;
         _loc2_.score_star.visible = _loc3_ == this._bestScoreEver;
         _loc2_.chain_now.text = "" + (_loc3_ = this._score.getLongestSequence());
         _loc2_.chain_best.text = "" + this._bestSequenceEver;
         _loc2_.chain_star.visible = _loc3_ == this._bestSequenceEver;
         _loc2_.level_now.text = "" + (_loc3_ = this._score.getLevel() + 1);
         _loc2_.level_best.text = "" + this._bestLevelEver;
         _loc2_.level_star.visible = _loc3_ == this._bestLevelEver;
         _loc2_.crushed_now.text = "" + (_loc3_ = this._score.getTotalRemoveItemCount());
         _loc2_.crushed_best.text = "" + this._bestCrushedEver;
         _loc2_.crushed_star.visible = _loc3_ == this._bestCrushedEver;
         _loc2_.combo_wrapper_line_text.text = "" + this._score.getMixedWrapWithLineOrColumn();
         _loc2_.combo_color_color_text.text = "" + this._score.getMixedColorWithColor();
         _loc2_.combo_color_line_text.text = "" + this._score.getMixedColorWithLineOrColumn();
         _loc2_.combo_color_wrapper_text.text = "" + this._score.getMixedColorWithWrapper();
         if(_loc2_.time)
         {
            _loc5_ = Math.max(0,Ticks.ticks2Sec(this.MaxTick - param1) + 1);
            _loc6_ = String(this._gameDataParser.getText("outro.time").replace("{0}",_loc5_));
            _loc2_.time.text = _loc6_;
         }
         this._trophyHoverText.visible = false;
         if(this._handledTrophies)
         {
            for each(_loc7_ in this._trophies)
            {
               if(_loc7_.trophyMc.hitTestPoint(mouseX,mouseY))
               {
                  this._trophyHoverText.text.text = _loc7_.description;
                  this._trophyHoverText.x = _loc7_.x - 50 + _loc7_.descriptionOffsetX;
                  this._trophyHoverText.visible = true;
                  if(_loc7_.trophyMc.currentFrame == 38)
                  {
                     _loc7_.trophyMc.gotoAndPlay(10);
                     SoundVars.sound.play(_loc7_.soundClass,0.4,mouseX,10);
                  }
                  break;
               }
            }
         }
         if(_loc2_.combo_wrapper_line.hitTestPoint(mouseX,mouseY))
         {
            _loc2_.combo_hover_text.text = this._gameDataParser.getText("outro.combo_wrapper_line");
            _loc2_.combo_hover_text.x = _loc2_.combo_wrapper_line.x + _loc2_.combo_wrapper_line.width * 0.5 - _loc2_.combo_hover_text.width * 0.5;
         }
         else if(_loc2_.combo_color_color.hitTestPoint(mouseX,mouseY))
         {
            _loc2_.combo_hover_text.text = this._gameDataParser.getText("outro.combo_color_color");
            _loc2_.combo_hover_text.x = _loc2_.combo_color_color.x + _loc2_.combo_color_color.width * 0.5 - _loc2_.combo_hover_text.width * 0.5;
         }
         else if(_loc2_.combo_color_line.hitTestPoint(mouseX,mouseY))
         {
            _loc2_.combo_hover_text.text = this._gameDataParser.getText("outro.combo_color_line");
            _loc2_.combo_hover_text.x = _loc2_.combo_color_line.x + _loc2_.combo_color_line.width * 0.5 - _loc2_.combo_hover_text.width * 0.5;
         }
         else if(_loc2_.combo_color_wrapper.hitTestPoint(mouseX,mouseY))
         {
            _loc2_.combo_hover_text.text = this._gameDataParser.getText("outro.combo_color_wrapper");
            _loc2_.combo_hover_text.x = _loc2_.combo_color_wrapper.x + _loc2_.combo_color_wrapper.width * 0.5 - _loc2_.combo_hover_text.width * 0.5;
         }
         else
         {
            _loc2_.combo_hover_text.text = "";
         }
         var _loc4_:Point;
         if((_loc4_ = _loc2_.localToGlobal(new Point(_loc2_.combo_hover_text.x + _loc2_.combo_hover_text.width * 0.5 + _loc2_.combo_hover_text.textWidth * 0.5,0))).x > 755)
         {
            _loc2_.combo_hover_text.x = _loc2_.combo_hover_text.x - (_loc4_.x - 755);
         }
      }
      
      private function _onClick(param1:MouseEvent) : void
      {
         if(UiButtonRenderer.instance.hitTest(param1.stageX,param1.stageY))
         {
            return;
         }
         if(this._canQuit)
         {
            this._isDone = true;
         }
      }
   }
}

import flash.display.MovieClip;

class TrophyInfo
{
    
   
   public var cls:Class;
   
   public var inTicks:int;
   
   public var x:int;
   
   public var y:int;
   
   public var description:String;
   
   public var descriptionOffsetX:int;
   
   public var collectedTrophyNow:Boolean = false;
   
   public var isMouseOver:Boolean = false;
   
   public var soundClass:Class;
   
   public var handled:Boolean = false;
   
   public var trophyMc:MovieClip;
   
   public function TrophyInfo(param1:Class, param2:Boolean, param3:int, param4:int, param5:int, param6:String, param7:int = 0)
   {
      super();
      this.cls = param1;
      this.inTicks = param3;
      this.x = param4;
      this.y = param5;
      this.description = param6;
      this.descriptionOffsetX = param7;
      this.collectedTrophyNow = param2;
   }
}
