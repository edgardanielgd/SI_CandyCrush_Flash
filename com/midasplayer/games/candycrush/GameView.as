package com.midasplayer.games.candycrush
{
   import com.midasplayer.animation.tweenick.*;
   import com.midasplayer.engine.GameDataParser;
   import com.midasplayer.engine.render.IRenderableRoot;
   import com.midasplayer.engine.tick.ITickable;
   import com.midasplayer.games.candycrush.audio.AudioPlayer;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.games.candycrush.board.Board;
   import com.midasplayer.games.candycrush.board.IBoardListener;
   import com.midasplayer.games.candycrush.board.IDestructionPlan;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.board.match.Match;
   import com.midasplayer.games.candycrush.input.SwapInfo;
   import com.midasplayer.games.candycrush.render.*;
   import com.midasplayer.games.candycrush.render.itemview.ItemView;
   import com.midasplayer.games.candycrush.utils.MCAnimation;
   import com.midasplayer.math.IntCoord;
   import com.midasplayer.sound.ManagedSound;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   
   public class GameView extends Sprite implements IRenderableRoot, IBoardListener, ITickable
   {
      
      private static var _sLastStripesBlastTime:int = -99999;
      
      public static const COLOR_NONE:int = 0;
      
      public static const COLOR_BLUE:int = 1;
      
      public static const COLOR_GREEN:int = 2;
      
      public static const COLOR_ORANGE:int = 3;
      
      public static const COLOR_PURPLE:int = 4;
      
      public static const COLOR_RED:int = 5;
      
      public static const COLOR_YELLOW:int = 6;
      
      public static const BackgroundBmd:BitmapData = new GA_Background_base();
      
      private static var MarkerBackground:BitmapData = new GA_Select_background();
      
      private static var MarkerForeground:BitmapData = new GA_Select_foreground();
       
      
      private var _firstGame:Boolean = true;
      
      private var _lastMs:int = -100000;
      
      private var _fps:int = 0;
      
      private var _fpsMeasures:int = 0;
      
      private var _fpsTotals:int = 0;
      
      private var _lastTick:int = 0;
      
      private const HintPatternIds:Array = [Board.MATCH_ID_5,Board.MATCH_ID_TorL,Board.MATCH_ID_4];
      
      private var _hintItems:Vector.<Item>;
      
      private var _sa_comboSounds:Array;
      
      private var _lastScoreAddedX:Number;
      
      private var _lastScoreAddedY:Number;
      
      private var _z:int = 0;
      
      private var _lastWrapBlastTime:int = -99999;
      
      private var _lastColorBlastTime:int = -99999;
      
      private var _itemViews:Vector.<ItemView>;
      
      private var _logic:com.midasplayer.games.candycrush.Logic;
      
      private var _canvas:BitmapData;
      
      private var _canvasBitmap:Bitmap;
      
      private var _backgroundGlass:BitmapData;
      
      private var _tweener:TickTween;
      
      private var _sprites:Vector.<TickedSprite>;
      
      private var _baseHintTicks:int = 0;
      
      private var _baseBoosterHintTicks:int = 0;
      
      private var _ui:Ui;
      
      private var _changeLevelTicks:int = -1;
      
      private var _maxChangeLevelTicks:int;
      
      private var _bgBitmap:Bitmap;
      
      private var _canvasBitmapHolder:Sprite;
      
      private var _fadeoutTick:int = -1;
      
      private var _fadeCoverBitmap:Bitmap;
      
      private var _isShortGame:Boolean;
      
      private var _noMoreMovesPaper:GA_Paper_noMoreMoves;
      
      private var _gameDataParser:GameDataParser;
      
      private var _hintBoosterActive:Boolean = false;
      
      private const TicksPerBoosterHintStart:int = Ticks.sec2Ticks(0.2);
      
      public function GameView(param1:GameDataParser, param2:TickTween, param3:Boolean)
      {
         this._hintItems = new Vector.<Item>();
         this._sa_comboSounds = [SA_Combo_1,SA_Combo_2,SA_Combo_3,SA_Combo_4,SA_Combo_5,SA_Combo_6,SA_Combo_7,SA_Combo_8,SA_Combo_9,SA_Combo_10,SA_Combo_11,SA_Combo_12];
         this._lastScoreAddedX = x;
         this._lastScoreAddedY = y;
         this._backgroundGlass = new GA_Background_glass();
         super();
         this._tweener = param2;
         this._isShortGame = param3;
         this._gameDataParser = param1;
         this._hintBoosterActive = BoosterPack.fromGameData(param1).isHintActive;
         this._bgBitmap = new Bitmap(BackgroundBmd);
         addChild(this._bgBitmap);
         this._canvas = new BitmapData(755,600,true);
         this._canvas.copyPixels(this._backgroundGlass,new Rectangle(0,0,this._backgroundGlass.width,this._backgroundGlass.height),new Point(96,7),null,null,false);
         this._canvasBitmap = new Bitmap(this._canvas);
         this._canvasBitmapHolder = new Sprite();
         this._canvasBitmapHolder.addChild(this._canvasBitmap);
         addChild(this._canvasBitmapHolder);
      }
      
      public static function stageToGrid(param1:int, param2:int) : IntCoord
      {
         return new IntCoord(Math.floor((param1 - 104 - 36) / 71 + 0.5),Math.floor((param2 - 17) / 63));
      }
      
      public static function gridToStageX(param1:Number) : Number
      {
         return 140 + 71 * param1;
      }
      
      public static function gridToStage(param1:Number, param2:Number) : IntCoord
      {
         return new IntCoord(104 + 36 + 71 * param1,17 + 63 * param2);
      }
      
      public static function playStripeSound(param1:Number, param2:Number = 1) : void
      {
         var _loc3_:int = int(getTimer());
         if(_loc3_ - _sLastStripesBlastTime > 200)
         {
            SoundVars.sound.play(SA_Explosion_stripes2,0.8 * param2,param1);
            _sLastStripesBlastTime = _loc3_;
         }
      }
      
      public function init(param1:com.midasplayer.games.candycrush.Logic) : void
      {
         this._logic = param1;
         this._ui = new Ui(this._canvas,0,this._logic,this._tweener);
         addChild(this._ui.getBackDisplayObject());
      }
      
      public function start(param1:int) : void
      {
         SoundVars.music.fadeCurrentMusic(0,2000,true);
         var _loc2_:ManagedSound = SoundVars.music.manager.getFromClass(SA_Music_loopwav2);
         _loc2_.loop(SoundVars.MusicVolume * 0.9);
         SoundVars.music.setCurrentMusic(_loc2_);
         SoundVars.sound.play(SA_State_cleared);
         var _loc3_:Bitmap = new Bitmap(this._backgroundGlass);
         _loc3_.x = 96;
         _loc3_.y = 7;
         this._canvasBitmapHolder.x = 755;
         this._canvasBitmapHolder.addChildAt(_loc3_,0);
         var _loc4_:int = 0;
         var _loc5_:TTGroup;
         (_loc5_ = new TTGroup()).add(new TTItem(this._canvasBitmapHolder,21,"x",_loc4_));
         _loc5_.addInTicks(param1 - 5,new TTItem(this._canvasBitmapHolder,3,"x",_loc4_,{
            "start":_loc4_ - 4,
            "easing":TTEasing.QuadraticOutReturner
         }));
         _loc5_.addInTicks(param1 - 2,new TTItem(this._canvasBitmapHolder,2,"x",_loc4_,{
            "start":_loc4_ + 2,
            "easing":TTEasing.QuadraticOutReturner
         }));
         this._tweener.addGroup(_loc5_);
         this._ui.setLevel(this._logic.getHumanReadableLevel());
         this._ui.show();
      }
      
      public function newRound(param1:int) : void
      {
         var _loc2_:Item = null;
         if(this._firstGame)
         {
            this._firstGame = false;
         }
         while(numChildren > 3)
         {
            removeChildAt(3);
         }
         this._sprites = new Vector.<TickedSprite>();
         this._itemViews = new Vector.<ItemView>();
         this._logic.getBoard().setListener(this);
         for each(_loc2_ in this._logic.getBoard()._allItems)
         {
            this.addItem(_loc2_,_loc2_.x,_loc2_.y);
         }
         this._ui.setLevel(this._logic.getHumanReadableLevel());
      }
      
      public function getDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function renderFromOutro(param1:int, param2:Number) : void
      {
         this.render(this._lastTick,param2);
      }
      
      public function render(param1:int, param2:Number) : void
      {
         var _loc3_:ItemView = null;
         var _loc4_:Item = null;
         var _loc5_:int = 0;
         SoundVars.update();
         this._tweener.render(param2);
         this.updateFps();
         this.updateViews(param1 + param2);
         this._canvas.lock();
         this._canvas.fillRect(new Rectangle(0,0,755,600),0);
         this.drawMarkerBackground();
         this.sprites_render_back(param1,param2);
         for each(_loc3_ in this._itemViews)
         {
            _loc5_ = (_loc4_ = _loc3_.getItem()).color;
            _loc3_.renderAt(param1,param2,this._canvas);
         }
         this.drawMarkerForeground();
         this.sprites_render_front(param1,param2);
         this._ui._renderBack(param1,param2);
         this._canvas.unlock();
         if(this._noMoreMovesPaper && this._noMoreMovesPaper.parent && Boolean(this._noMoreMovesPaper.sprite))
         {
            this._noMoreMovesPaper.sprite.text.text = this._gameDataParser.getText("game.nomoves");
         }
      }
      
      private function sprites_add(param1:TickedSprite) : void
      {
         this._sprites.push(param1);
         if(param1.addAndRemoveMe())
         {
            if(param1.addAtFront())
            {
               addChild(param1.getFrontDisplayObject());
            }
            if(param1.addAtBack())
            {
               addChildAt(param1.getBackDisplayObject(),getChildIndex(this._canvasBitmapHolder));
            }
         }
      }
      
      private function sprites_tick(param1:int) : void
      {
         var _loc3_:TickedSprite = null;
         var _loc2_:Vector.<TickedSprite> = new Vector.<TickedSprite>();
         for each(_loc3_ in this._sprites)
         {
            _loc3_.tick(param1);
            if(!_loc3_.isDone())
            {
               _loc2_.push(_loc3_);
            }
            else
            {
               if(_loc3_.addAtFront())
               {
                  removeChild(_loc3_.getFrontDisplayObject());
               }
               if(_loc3_.addAtBack())
               {
                  removeChild(_loc3_.getBackDisplayObject());
               }
            }
         }
         this._sprites = _loc2_;
      }
      
      private function sprites_render_front(param1:int, param2:Number) : void
      {
         var _loc3_:TickedSprite = null;
         for each(_loc3_ in this._sprites)
         {
            _loc3_._renderFront(param1,param2);
         }
      }
      
      private function sprites_render_back(param1:int, param2:Number) : void
      {
         var _loc3_:TickedSprite = null;
         for each(_loc3_ in this._sprites)
         {
            _loc3_._renderBack(param1,param2);
         }
      }
      
      private function drawMarkerBackground() : void
      {
         var _loc1_:IntCoord = null;
         var _loc2_:Item = null;
         var _loc3_:IntCoord = null;
         if(this._logic.getSwapper().isMarked() && this._logic.getBoard().isStable())
         {
            _loc1_ = this._logic.getSwapper().getMarkedPos();
            _loc2_ = this._logic.getBoard().getGridItem(_loc1_.x,_loc1_.y);
            if(!_loc2_ || _loc2_.isDestroyed())
            {
               return;
            }
            _loc3_ = GameView.gridToStage(_loc1_.x,_loc1_.y);
            this._canvas.copyPixels(MarkerBackground,new Rectangle(0,0,73,65),new Point(_loc3_.x - 36,_loc3_.y),null,null,true);
         }
      }
      
      private function drawMarkerForeground() : void
      {
         var _loc1_:IntCoord = null;
         var _loc2_:Item = null;
         var _loc3_:IntCoord = null;
         if(this._logic.getSwapper().isMarked() && this._logic.getBoard().isStable())
         {
            _loc1_ = this._logic.getSwapper().getMarkedPos();
            _loc2_ = this._logic.getBoard().getGridItem(_loc1_.x,_loc1_.y);
            if(!_loc2_ || _loc2_.isDestroyed())
            {
               return;
            }
            _loc3_ = GameView.gridToStage(_loc1_.x,_loc1_.y);
            this._canvas.copyPixels(MarkerForeground,new Rectangle(0,0,81,73),new Point(_loc3_.x - 41,_loc3_.y - 5),null,null,true);
         }
      }
      
      private function updateFps() : void
      {
         var _loc2_:*;
         var _loc3_:* = (_loc2_ = this)._fps + 1;
         _loc2_._fps = _loc3_;
         var _loc1_:int = int(getTimer());
         if(_loc1_ - this._lastMs >= 1000)
         {
            Main.Log.trace("Current Fps: " + this._fps);
            this._fpsTotals += this._fps;
            _loc3_ = (_loc2_ = this)._fpsMeasures + 1;
            _loc2_._fpsMeasures = _loc3_;
            this._fps = 0;
            this._lastMs = _loc1_;
            Main.Log.trace("Average Fps: " + this.getAverageFps());
         }
      }
      
      public function addItem(param1:Item, param2:int, param3:int) : void
      {
         var _loc5_:int = 0;
         if(param1.special == 0 && param1.color == COLOR_NONE)
         {
            return;
         }
         var _loc4_:ItemView = new ItemView(param1,this._tweener);
         param1.view = _loc4_;
         this._itemViews.push(_loc4_);
         if(param1.view.getSprite())
         {
            _loc5_ = this._canvasBitmapHolder.getChildIndex(this._canvasBitmap);
            this._canvasBitmapHolder.addChildAt(param1.view.getSprite(),_loc5_);
         }
      }
      
      public function removeItem(param1:Item, param2:int, param3:int) : void
      {
         var _loc4_:ItemView = null;
         for each(_loc4_ in this._itemViews)
         {
            if(_loc4_.getItem() == param1)
            {
               _loc4_.remove();
            }
         }
      }
      
      public function destroyItem(param1:Item) : void
      {
         if(param1.view)
         {
            param1.view.destroy();
         }
      }
      
      private function removeItemFromScene(param1:Item) : void
      {
         var _loc2_:int = int(this._itemViews.indexOf(param1));
         if(_loc2_ >= 0)
         {
            this.removeItemIndexFromScene(_loc2_);
         }
      }
      
      private function removeItemIndexFromScene(param1:int) : void
      {
         var _loc2_:Sprite = this._itemViews.splice(param1,1)[0].getSprite();
         if(_loc2_)
         {
            this._canvasBitmapHolder.removeChild(_loc2_);
         }
      }
      
      public function updateViews(param1:Number) : void
      {
         var _loc2_:int = int(this._itemViews.length - 1);
         while(_loc2_ >= 0)
         {
            if(this._itemViews[_loc2_].doRemove())
            {
               this.removeItemIndexFromScene(_loc2_);
            }
            _loc2_--;
         }
      }
      
      public function tickFromOutro(param1:int) : void
      {
         this.tick(this._lastTick + 1);
      }
      
      public function tick(param1:int) : void
      {
         var _loc2_:ItemView = null;
         this._lastTick = param1;
         this._tweener.tick(param1);
         this.tickHint(param1);
         this._ui.tick(param1);
         if(this._changeLevelTicks > 0)
         {
            var _loc3_:*;
            var _loc4_:* = (_loc3_ = this)._changeLevelTicks - 1;
            _loc3_._changeLevelTicks = _loc4_;
            if(this._changeLevelTicks == 0)
            {
               this.x = 0;
               this.y = 0;
            }
         }
         for each(_loc2_ in this._itemViews)
         {
            _loc2_.tick(param1);
         }
         this.sprites_tick(param1);
      }
      
      private function tickHint(param1:int) : void
      {
         var _loc3_:Match = null;
         var _loc4_:Array = null;
         var _loc5_:IntCoord = null;
         if(!this._logic.getBoard().isStable())
         {
            return;
         }
         if(this._logic.getTicksLeft() <= 0)
         {
            return;
         }
         if(this._changeLevelTicks > 0)
         {
            return;
         }
         var _loc2_:Boolean = true;
         if(this._hintBoosterActive && (param1 >= this._baseBoosterHintTicks && (param1 - this._baseBoosterHintTicks) % 6 == 0))
         {
            _loc3_ = this._logic.getBoard().getSpecificHint(this.HintPatternIds);
            if(_loc3_)
            {
               this.showHintForMatch(_loc3_);
               _loc2_ = false;
            }
         }
         if(_loc2_ && (param1 + 1 - this._baseHintTicks) % Ticks.sec2Ticks(4) == 0)
         {
            if(_loc4_ = this._logic.getBoard().getHint())
            {
               for each(_loc5_ in _loc4_)
               {
                  this._logic.getBoard().getGridItem(_loc5_.x,_loc5_.y).view.showHint();
               }
            }
         }
      }
      
      private function showHintForMatch(param1:Match) : void
      {
         if(!param1 || !param1.associatedSwap)
         {
            return;
         }
         var _loc2_:Board = this._logic.getBoard();
         var _loc3_:SwapInfo = param1.associatedSwap;
         var _loc4_:int = 6;
         var _loc5_:Boolean = false;
         var _loc6_:int = param1.west;
         while(_loc6_ <= param1.east)
         {
            if(_loc3_.x0 == _loc6_ && _loc3_.y0 == param1.y)
            {
               _loc5_ = true;
            }
            else if(!(_loc3_.x1 == _loc6_ && _loc3_.y1 == param1.y))
            {
               _loc2_.getGridItem(_loc6_,param1.y).view.showBoosterHint(_loc4_);
            }
            _loc6_++;
         }
         var _loc7_:int = param1.north;
         while(_loc7_ <= param1.south)
         {
            if(_loc3_.x0 == param1.x && _loc3_.y0 == _loc7_)
            {
               _loc5_ = true;
            }
            else if(!(_loc3_.x1 == param1.x && _loc3_.y1 == _loc7_))
            {
               _loc2_.getGridItem(param1.x,_loc7_).view.showBoosterHint(_loc4_);
            }
            _loc7_++;
         }
         if(_loc5_)
         {
            _loc2_.getGridItem(_loc3_.x0,_loc3_.y0).view.showBoosterHint(_loc4_);
         }
         else
         {
            _loc2_.getGridItem(_loc3_.x1,_loc3_.y1).view.showBoosterHint(_loc4_);
         }
      }
      
      public function isDone() : Boolean
      {
         return false;
      }
      
      public function hasMatched(param1:Match, param2:int, param3:int) : void
      {
         this.playComboSound(param2,gridToStageX(param1.x));
      }
      
      private function playFeedbackWord(param1:int) : void
      {
         if(param1 == 4)
         {
            SoundVars.sound.play(SA_Word_sweet_m9);
         }
         if(param1 == 6)
         {
            SoundVars.sound.play(SA_Word_tasty_m9);
         }
         if(param1 == 9)
         {
            SoundVars.sound.play(SA_Word_delicious_m10);
         }
         if(param1 == 12)
         {
            SoundVars.sound.play(SA_Word_divine_m10);
         }
      }
      
      private function playComboSound(param1:int, param2:Number) : void
      {
         if(param1 < 1)
         {
            return;
         }
         var _loc3_:Class = this._sa_comboSounds[int(Math.min(param1 - 1,this._sa_comboSounds.length - 1))];
         SoundVars.sound.play(_loc3_,1,param2);
      }
      
      public function addScore(param1:Number, param2:Number, param3:int, param4:int, param5:Item = null, param6:IDestructionPlan = null) : void
      {
         if(param2 < 0)
         {
            return;
         }
         if(Math.abs(param1 - this._lastScoreAddedX) < 0.2 && Math.abs(param2 - this._lastScoreAddedY) < 0.2)
         {
            param1 += param1 > this._lastScoreAddedX ? 0.5 : -0.5;
            param2 += param2 > this._lastScoreAddedY ? 0.5 : -0.5;
         }
         var _loc7_:IntCoord = gridToStage(param1,param2);
         this.sprites_add(new Fx_ScorePop(this._lastTick,_loc7_.x,_loc7_.y,param3,param4));
         this._lastScoreAddedX = param1;
         this._lastScoreAddedY = param2;
      }
      
      public function boardStabilized(param1:int, param2:int) : void
      {
         var _loc6_:int = 0;
         this._baseHintTicks = this._lastTick;
         this._baseBoosterHintTicks = this._lastTick + this.TicksPerBoosterHintStart;
         var _loc3_:int = param2;
         var _loc4_:String = "";
         var _loc5_:int = -1;
         if(_loc3_ >= 12)
         {
            _loc5_ = 3;
            _loc6_ = 12;
            _loc4_ = "Divine";
         }
         else if(_loc3_ >= 9)
         {
            _loc5_ = 2;
            _loc6_ = 9;
            _loc4_ = "Delicious";
         }
         else if(_loc3_ >= 6)
         {
            _loc5_ = 1;
            _loc6_ = 6;
            _loc4_ = "Tasty";
         }
         else if(_loc3_ >= 4)
         {
            _loc5_ = 0;
            _loc6_ = 4;
            _loc4_ = "Sweet";
         }
         if(_loc4_ != "")
         {
            this.playFeedbackWord(_loc6_);
            this.sprites_add(new Fx_SequenceWord(this._canvas,this._lastTick,this._tweener,_loc5_));
         }
      }
      
      public function powerupExploded(param1:int, param2:int, param3:int, param4:Item, param5:Vector.<IntCoord> = null, param6:Vector.<Item> = null) : void
      {
         var _loc7_:Boolean = param4.isTemp() && (param1 == ItemType.COLUMN || param1 == ItemType.LINE);
         var _loc8_:int = int(getTimer());
         if(ItemType.isColor(param1))
         {
            if(_loc8_ - this._lastColorBlastTime > 200)
            {
               SoundVars.sound.play(SA_Explosion_color2,1,gridToStageX(param4.x));
               this._lastColorBlastTime = _loc8_;
            }
         }
         if(ItemType.isStripes(param1))
         {
            playStripeSound(gridToStageX(param4.x),_loc7_ ? 0.7 : 1);
         }
         if(ItemType.isWrap(param1))
         {
            if(_loc8_ - this._lastWrapBlastTime > 200)
            {
               SoundVars.sound.play(SA_Explosion_bomb2,1.2,gridToStageX(param4.x));
               this._lastWrapBlastTime = _loc8_;
            }
         }
         if(param1 == ItemType.WRAP)
         {
            param4.view.blast();
         }
         if(param1 == ItemType.COLOR)
         {
            this.sprites_add(new Fx_ColorBomb(this._canvas,this._lastTick,param4,param6));
         }
         if(param1 == ItemType.LINE)
         {
            this.sprites_add(new Fx_LineColumn(this._canvas,this._lastTick,param4));
         }
         if(param1 == ItemType.COLUMN)
         {
            this.sprites_add(new Fx_LineColumn(this._canvas,this._lastTick,param4));
         }
      }
      
      public function specialMixed(param1:int, param2:SwapInfo, param3:Vector.<Item> = null, param4:IntCoord = null) : void
      {
         if(ItemType.isColorLineMix(param1))
         {
            this.sprites_add(new Fx_Mix_ColorLine(this._canvas,this._lastTick,param2,param3));
            SoundVars.sound.play(SA_Mix_colorLine1,1,AudioPlayer.PAN_CENTER);
         }
         if(ItemType.isLineWrapMix(param1))
         {
            this.sprites_add(new Fx_Mix_LineWrap(this._canvas,this._lastTick,param2,param3));
            SoundVars.sound.play(SA_Mix_wrapLine1);
            SoundVars.sound.play(SA_Other_specialcandy2);
         }
         if(ItemType.isColorColorMix(param1))
         {
            this.sprites_add(new Fx_Mix_ColorColor(this._canvas,this._lastTick,param2,param3));
         }
      }
      
      public function lastBlast() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Item = null;
         this._ui.lastBlast();
         var _loc1_:Board = this._logic.getBoard();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.height())
         {
            _loc3_ = 0;
            while(_loc3_ < _loc1_.width())
            {
               if(Boolean(_loc4_ = _loc1_.getGridItem(_loc3_,_loc2_)) && _loc4_.special > 0)
               {
                  SoundVars.sound.play(SA_Word_sugarcrush_m6,1.1);
                  this.sprites_add(new Fx_SequenceWord(this._canvas,this._lastTick,this._tweener,Fx_SequenceWord.LEVEL_LASTBLAST));
                  return;
               }
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public function setRemovalShare(param1:Number) : void
      {
         this._ui.setRemovalShare(param1);
      }
      
      public function changeLevel(param1:int, param2:int, param3:int = 0) : void
      {
         this._maxChangeLevelTicks = param1 + param2 + param3;
         this._changeLevelTicks = param1 + param2 + param3;
         this._ui.levelComplete(this._maxChangeLevelTicks);
         var _loc4_:TTGroup;
         (_loc4_ = new TTGroup()).addInTicks(param3,new TTItem(this._canvasBitmapHolder,param1 - 5,"x",800,{"easing":TTEasing.QuadraticIn}));
         _loc4_.addInTicks(param3 + param1 + 10,new TTItem(this._canvasBitmapHolder,param2 - 5,"x",0,{
            "easing":TTEasing.QuadraticOut,
            "start":800
         }));
         this._tweener.addGroup(_loc4_);
         SoundVars.sound.play(SA_State_cleared);
      }
      
      public function fadeOutBoard() : void
      {
         if(this._isShortGame || this._fadeoutTick >= 0)
         {
            return;
         }
         this._fadeoutTick = this._lastTick;
         this._fadeCoverBitmap = new Bitmap(BackgroundBmd);
         this._fadeCoverBitmap.alpha = 0;
         var _loc1_:TTGroup = new TTGroup();
         _loc1_.addInTicks(10,new TTItem(this._fadeCoverBitmap,35,"alpha",1));
         this._tweener.addGroup(_loc1_);
         addChild(this._fadeCoverBitmap);
         this._ui.hide();
      }
      
      public function getAverageFps() : int
      {
         if(this._fpsMeasures == 0)
         {
            return 1;
         }
         return this._fpsTotals / this._fpsMeasures;
      }
      
      public function noMoreMoves() : void
      {
         var anim:MCAnimation;
         var ttg:TTGroup;
         this._noMoreMovesPaper = new GA_Paper_noMoreMoves();
         this._noMoreMovesPaper.x = 248;
         this._noMoreMovesPaper.y = 194;
         this._noMoreMovesPaper.gotoAndStop(1);
         addChild(this._noMoreMovesPaper);
         anim = new MCAnimation(this._noMoreMovesPaper,false);
         ttg = new TTGroup();
         ttg.add(new TTItem(anim,56,"frame",47));
         ttg.add(new TTFunctionCall(57,function():void
         {
            if(Boolean(_noMoreMovesPaper) && Boolean(_noMoreMovesPaper.parent))
            {
               _noMoreMovesPaper.parent.removeChild(_noMoreMovesPaper);
               _noMoreMovesPaper = null;
            }
         }));
         this._tweener.addGroup(ttg);
         SoundVars.sound.play(SA_State_nomoves);
      }
      
      public function stop() : void
      {
         this.fadeOutBoard();
      }
      
      public function getTweener() : TickTween
      {
         return this._tweener;
      }
      
      public function powerupCreated(param1:int, param2:Item) : void
      {
         if(ItemType.isWrap(param1))
         {
            SoundVars.sound.play(SA_Creation_wrap,0.7);
         }
         if(ItemType.isColor(param1))
         {
            SoundVars.sound.play(SA_Creation_color,0.7);
         }
         if(ItemType.isLine(param1) || ItemType.isColumn(param1))
         {
            SoundVars.sound.play(SA_Creation_stripes,0.7);
         }
      }
      
      public function switchMade(param1:SwapInfo, param2:int) : void
      {
         if(param2 == Board.SWITCHSTATE_BEGIN)
         {
            SoundVars.sound.play(SA_Switch_sound);
         }
         if(param2 == Board.SWITCHSTATE_FAIL)
         {
            SoundVars.sound.play(SA_Switch_negative);
         }
      }
   }
}
