package com.midasplayer.games.candycrush
{
   import com.midasplayer.animation.tweenick.TickTween;
   import com.midasplayer.engine.IGameLogic;
   import com.midasplayer.engine.playdata.LastTickPlayData;
   import com.midasplayer.engine.playdata.MousePositionPlayData;
   import com.midasplayer.engine.playdata.MousePressPlayData;
   import com.midasplayer.engine.playdata.MouseReleasePlayData;
   import com.midasplayer.engine.replay.IRecorder;
   import com.midasplayer.engine.tick.ITickable;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.games.candycrush.board.Board;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.board.ItemFactory;
   import com.midasplayer.games.candycrush.input.SwapInfo;
   import com.midasplayer.games.candycrush.input.Swapper;
   import com.midasplayer.games.candycrush.render.UiButtonRenderer;
   import com.midasplayer.games.candycrush.utils.Py;
   import com.midasplayer.games.candycrush.utils.Random;
   import com.midasplayer.input.MouseInput;
   import com.midasplayer.math.IntCoord;
   import com.midasplayer.math.MtRandom;
   import com.midasplayer.math.Vec2;
   
   public class Logic implements IGameLogic
   {
      
      private static const STATE_GAME:int = 0;
      
      private static const STATE_GAME_LASTBLAST:int = 2;
      
      private static const STATE_LEVELCHANGE:int = 1;
      
      private static const STATE_END:int = 3;
      
      private static const STATE_INIT:int = 4;
      
      private static const STATE_INIT_LASTBLAST:int = 5;
      
      private static const STATE_POST_LASTBLAST:int = 6;
      
      public static var SecondsTimeLimit:int = 240;
      
      public static const PureLogic:Boolean = false;
      
      public static const IsBotActive:Boolean = Main.canBotBeActive() && false;
      
      public static const BotQuitChancePerTick:Number = 0.00002;
       
      
      private var _pressedQuit:Boolean = false;
      
      private const _tickables:Vector.<ITickable> = new Vector.<ITickable>();
      
      private var _random:MtRandom;
      
      private var _mouse:MouseInput;
      
      private var _effectiveTicksLeft:int;
      
      private var _isDone:Boolean = false;
      
      private var _listener:com.midasplayer.games.candycrush.GameView;
      
      private var _level:int = -1;
      
      private var _state:int = 4;
      
      private var _stateTicksLeft:int = -1;
      
      private var _board:Board;
      
      private var _swapper:Swapper;
      
      private var _recorder:IRecorder;
      
      private var _tweener:TickTween;
      
      private var _scoreHolder:com.midasplayer.games.candycrush.ScoreHolder;
      
      private var _lastSwapTick:int;
      
      private var _powerupShuffler:MtRandom;
      
      private var _isShortGame:Boolean;
      
      public var _levelTicks:int = 0;
      
      private var _boosterMt:MtRandom;
      
      private var _shouldHandleButtons:Boolean = false;
      
      public function Logic(param1:MouseInput, param2:IRecorder, param3:MtRandom, param4:TickTween, param5:com.midasplayer.games.candycrush.GameView, param6:Boolean, param7:BoosterPack)
      {
         super();
         this._mouse = param1;
         this._random = param3;
         this._recorder = param2;
         this._tweener = param4;
         if(!PureLogic)
         {
            this._swapper = new Swapper();
            this._scoreHolder = new com.midasplayer.games.candycrush.ScoreHolder();
            this._listener = param5;
            this._listener.init(this);
         }
         this._powerupShuffler = new MtRandom(param3.nextInt(2147483647));
         this._boosterMt = new MtRandom(param3.nextInt(2147483647));
         this._isShortGame = param6;
         var _loc8_:Array = this.handleBoosters(param7);
         this.setupNextRound(0);
         this.addPowerups(this._board,_loc8_);
         this._effectiveTicksLeft = Ticks.sec2Ticks(SecondsTimeLimit);
      }
      
      private function handleBoosters(param1:BoosterPack) : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(!param1)
         {
            return null;
         }
         var _loc2_:Array = [];
         _loc3_ = 0;
         while(_loc3_ < param1.numColorBombs)
         {
            _loc2_.push(ItemType.COLOR);
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.numWrappedStripe)
         {
            _loc4_ = this._boosterMt.nextDouble() < 0.5 ? ItemType.LINE : ItemType.COLUMN;
            _loc2_.push(_loc4_ | ItemType.WRAP);
            _loc3_++;
         }
         if(param1.startAtLevel > 0)
         {
            this._level = param1.startAtLevel - 2;
         }
         if(param1.numSecondsToAdd > 0)
         {
            SecondsTimeLimit += param1.numSecondsToAdd;
         }
         return _loc2_;
      }
      
      private function setupNextRound(param1:int) : void
      {
         var _loc3_:*;
         var _loc4_:* = (_loc3_ = this)._level + 1;
         _loc3_._level = _loc4_;
         var _loc2_:Board = this._board;
         this._board = new Board(9,9,new ItemFactory(this._random.nextInt(2147483647)));
         this.setupPersistentItems(_loc2_,this._board);
         if(!PureLogic)
         {
            this._scoreHolder.setLevel(this._level,true);
            this._board.setScoreHolder(this._scoreHolder);
            this._swapper.reset();
            this._listener.newRound(param1);
         }
         this._levelTicks = 0;
      }
      
      private function setupPersistentItems(param1:Board, param2:Board) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Item = null;
         if(!param1)
         {
            return;
         }
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.height())
         {
            _loc5_ = 0;
            while(_loc5_ < param1.width())
            {
               if((_loc6_ = param1.getUnifiedGridItem(_loc5_,_loc4_)) != null && Boolean(_loc6_.special))
               {
                  _loc3_.push(_loc6_.special);
               }
               _loc5_++;
            }
            _loc4_++;
         }
         this.addPowerups(param2,_loc3_);
      }
      
      private function addPowerups(param1:Board, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Item = null;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:Item = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:Item = null;
         if(!param2 || !param2.length)
         {
            return;
         }
         var _loc3_:Array = [];
         _loc4_ = param1.width();
         _loc5_ = param1.height();
         var _loc6_:Array = Py.range(_loc4_ * _loc5_);
         new Random(this._powerupShuffler).shuffle(_loc6_);
         var _loc7_:int = -1;
         while(++_loc7_ < param2.length)
         {
            _loc8_ = int(_loc6_[_loc7_]);
            _loc9_ = int(param2[_loc7_]);
            if((_loc10_ = ItemType.getSpecialTypes(_loc9_)).length > 1)
            {
               _loc3_.push(_loc10_);
            }
            else
            {
               _loc11_ = param1.getGridItem(_loc8_ % _loc4_,_loc8_ / _loc4_);
               param1.setPowerupAt(_loc8_ % _loc4_,_loc8_ / _loc4_,_loc9_,_loc11_.color);
            }
         }
         _loc7_ = 0;
         while(_loc7_ < _loc3_.length)
         {
            _loc12_ = 100;
            while(--_loc12_ >= 0)
            {
               _loc14_ = (_loc13_ = int(this._boosterMt.nextInt(81))) % _loc4_;
               _loc15_ = _loc13_ / _loc4_;
               if(!(!(_loc16_ = this._board.getGridItem(_loc14_,_loc15_)) || _loc16_.special > 0))
               {
                  _loc18_ = (_loc17_ = int(this._boosterMt.nextInt(1))) == 0 ? 1 : 0;
                  _loc19_ = _loc14_ + _loc17_;
                  _loc20_ = _loc15_ + _loc18_;
                  if((Boolean(_loc21_ = this._board.getGridItem(_loc19_,_loc20_))) && _loc21_.special == 0)
                  {
                     param1.setPowerupAt(_loc14_,_loc15_,_loc3_[_loc7_][0],_loc16_.color);
                     param1.setPowerupAt(_loc19_,_loc20_,_loc3_[_loc7_][1],_loc21_.color);
                     break;
                  }
                  _loc19_ = _loc14_ + _loc18_;
                  _loc20_ = _loc15_ + _loc17_;
                  if((Boolean(_loc21_ = this._board.getGridItem(_loc19_,_loc20_))) && _loc21_.special == 0)
                  {
                     param1.setPowerupAt(_loc14_,_loc15_,_loc3_[_loc7_][0],_loc16_.color);
                     param1.setPowerupAt(_loc19_,_loc20_,_loc3_[_loc7_][1],_loc21_.color);
                     break;
                  }
               }
            }
            _loc7_++;
         }
      }
      
      public function setPowerupAt(param1:int, param2:int, param3:int, param4:int = 0) : void
      {
         if(this._board.getGridItem(param1,param2) != null)
         {
            this._board.setPowerupAt(param1,param2,param3,param4);
         }
      }
      
      public function tick(param1:int) : void
      {
         var _loc2_:ITickable = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(this._shouldHandleButtons)
         {
            this.handleButtons(param1);
            if(this._pressedQuit)
            {
               this._board.saveOldItemPositions();
               this._state = STATE_END;
               this._isDone = true;
               this.emitPlaydata();
               return;
            }
         }
         else if(param1 >= 35)
         {
            this._shouldHandleButtons = true;
         }
         if(this._state == STATE_INIT)
         {
            _loc6_._stateTicksLeft = _loc7_;
            var _loc7_:*;
            var _loc6_:*;
            if((_loc7_ = (_loc6_ = this)._stateTicksLeft - 1) == 0)
            {
               this._state = STATE_GAME;
            }
         }
         else if(this._state == STATE_INIT_LASTBLAST)
         {
            _loc6_._stateTicksLeft = _loc7_;
            if((_loc7_ = (_loc6_ = this)._stateTicksLeft - 1) == 0)
            {
               this._state = STATE_GAME_LASTBLAST;
            }
         }
         else if(this._state == STATE_GAME)
         {
            this.tickInput(param1);
            this._board.tick(param1);
            _loc7_ = (_loc6_ = this)._levelTicks + 1;
            _loc6_._levelTicks = _loc7_;
            _loc7_ = (_loc6_ = this)._effectiveTicksLeft - 1;
            _loc6_._effectiveTicksLeft = _loc7_;
            if(this._isShortGame && this._level > 0 && this._levelTicks == Ticks.sec2Ticks(3))
            {
               this._board.saveOldItemPositions();
               this._isDone = true;
            }
            _loc3_ = com.midasplayer.games.candycrush.ScoreHolder.getLevelItemLimit(this._level);
            _loc4_ = this._scoreHolder.getLevelRemoveItemCount() / _loc3_;
            this._listener.setRemovalShare(_loc4_);
            if(this._board.isStable())
            {
               _loc5_ = 0;
               if(this._effectiveTicksLeft <= 0 && this._board.isStable())
               {
                  this._board.saveOldItemPositions();
                  this._state = STATE_INIT_LASTBLAST;
                  this._stateTicksLeft = 40;
                  this._listener.lastBlast();
               }
               else if(_loc4_ >= 1)
               {
                  this._state = STATE_LEVELCHANGE;
               }
               else if(!this._board.isPossibleMovesLeft())
               {
                  this._listener.noMoreMoves();
                  this._state = STATE_LEVELCHANGE;
                  _loc5_ = 30;
               }
               if(this._state == STATE_LEVELCHANGE)
               {
                  this._board.saveOldItemPositions();
                  this._stateTicksLeft = Ticks.sec2Ticks(3);
                  this._listener.changeLevel(this._stateTicksLeft - 45,45,_loc5_);
                  this._stateTicksLeft = this._stateTicksLeft + _loc5_;
               }
            }
         }
         else if(this._state == STATE_LEVELCHANGE)
         {
            _loc7_ = (_loc6_ = this)._stateTicksLeft - 1;
            _loc6_._stateTicksLeft = _loc7_;
            if(this._stateTicksLeft <= 0)
            {
               this._state = STATE_GAME;
            }
            else if(this._stateTicksLeft == Ticks.sec2Ticks(1.5))
            {
               this.setupNextRound(param1);
            }
         }
         if(this._state == STATE_GAME_LASTBLAST)
         {
            this._board.tick(param1);
            if(!this.tickLastBlast())
            {
               this.emitPlaydata();
               this._board.saveOldItemPositions();
               this._state = STATE_POST_LASTBLAST;
               this._stateTicksLeft = 30;
            }
         }
         else if(this._state == STATE_POST_LASTBLAST)
         {
            _loc6_._stateTicksLeft = _loc7_;
            if((_loc7_ = (_loc6_ = this)._stateTicksLeft - 1) <= 0)
            {
               this._state = STATE_END;
               this._isDone = true;
            }
         }
         for each(_loc2_ in this._tickables)
         {
            _loc2_.tick(param1);
         }
      }
      
      private function handleButtons(param1:int) : void
      {
         if(IsBotActive && Math.random() < BotQuitChancePerTick)
         {
            this._recorder.add(new MousePressPlayData(param1,20,580,this._mouse));
            this._pressedQuit = true;
            return;
         }
         if(!this._mouse.isPressed())
         {
            return;
         }
         var _loc2_:Vec2 = this._mouse.getPressPosition();
         var _loc3_:int = 32;
         if(_loc2_.y < 600 - _loc3_ - 1)
         {
            return;
         }
         if(_loc2_.x >= 1 && _loc2_.x <= _loc3_)
         {
            this._recorder.add(new MousePressPlayData(param1,_loc2_.x,_loc2_.y,this._mouse));
            this._pressedQuit = true;
         }
         UiButtonRenderer.instance.hitTest(_loc2_.x,_loc2_.y);
      }
      
      public function tickLastBlast() : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Item = null;
         if(!this._board.isStable())
         {
            return true;
         }
         var _loc1_:Array = [ItemType.WRAP,ItemType.COLUMN | ItemType.LINE,ItemType.COLOR];
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = int(_loc1_[_loc2_]);
            _loc4_ = 0;
            while(_loc4_ < this._board.height())
            {
               _loc5_ = 0;
               while(_loc5_ < this._board.width())
               {
                  if((_loc6_ = this._board.getGridItem(_loc5_,_loc4_)) != null && (_loc6_.special & _loc3_) != 0)
                  {
                     this._board.addForRemoval(_loc5_,_loc4_,0);
                     return true;
                  }
                  _loc5_++;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function tickDebugInput(param1:int) : void
      {
         if(param1 == 50)
         {
            this._board.trySwap(5,5,5,6);
         }
         if(param1 == 250)
         {
            this._board.trySwap(2,5,2,6);
         }
      }
      
      private function tickInput(param1:int) : void
      {
         var _loc2_:IntCoord = null;
         var _loc3_:Vec2 = null;
         var _loc4_:SwapInfo = null;
         if(this._isShortGame && this._level > 0)
         {
            return;
         }
         if(this._mouse.isPressed())
         {
            _loc3_ = this._mouse.getPressPosition();
            this._recorder.add(new MousePressPlayData(param1,_loc3_.x,_loc3_.y,this._mouse));
            _loc2_ = com.midasplayer.games.candycrush.GameView.stageToGrid(_loc3_.x,_loc3_.y);
            if(this._board.isStable())
            {
               this._swapper.mouseDownAt(_loc2_.x,_loc2_.y);
            }
         }
         if(this._mouse.isReleased())
         {
            _loc3_ = this._mouse.getReleasePosition();
            this._recorder.add(new MouseReleasePlayData(param1,_loc3_.x,_loc3_.y,this._mouse));
            _loc2_ = com.midasplayer.games.candycrush.GameView.stageToGrid(_loc3_.x,_loc3_.y);
            if(this._board.isStable())
            {
               this._swapper.mouseUpAt(_loc2_.x,_loc2_.y);
            }
         }
         if(this._mouse.isDown())
         {
            _loc3_ = this._mouse.getPosition();
            _loc2_ = com.midasplayer.games.candycrush.GameView.stageToGrid(_loc3_.x,_loc3_.y);
            this._recorder.add(new MousePositionPlayData(param1,_loc3_.x,_loc3_.y,this._mouse));
            this._swapper.mouseMoveTo(_loc2_.x,_loc2_.y);
         }
         if(this._swapper.shouldSwap() && !this.isPaused())
         {
            _loc4_ = this._swapper.getSwap();
            this._board.trySwap(_loc4_.x0,_loc4_.y0,_loc4_.x1,_loc4_.y1);
            this._lastSwapTick = param1;
            this._swapper.reset();
         }
         this._mouse.reset();
      }
      
      public function isPaused() : Boolean
      {
         return this._state != STATE_GAME;
      }
      
      public function getBoard() : Board
      {
         return this._board;
      }
      
      public function getSwapper() : Swapper
      {
         return this._swapper;
      }
      
      public function getTicksLeft() : int
      {
         return this._effectiveTicksLeft;
      }
      
      public function isDone() : Boolean
      {
         return this._isDone;
      }
      
      public function getFinalScore() : int
      {
         return this.getScore();
      }
      
      public function getScore() : int
      {
         return this._scoreHolder.getTotalScore();
      }
      
      public function getScoreHolder() : com.midasplayer.games.candycrush.ScoreHolder
      {
         return this._scoreHolder;
      }
      
      public function getHumanReadableLevel() : int
      {
         return this._level + 1;
      }
      
      public function start() : void
      {
         this._stateTicksLeft = 26;
         this._listener.start(this._stateTicksLeft);
      }
      
      public function stop() : void
      {
         this._listener.stop();
      }
      
      private function emitPlaydata() : void
      {
         this._recorder.add(new LastTickPlayData(0,this.getFinalScore(),SoundVars.musicOn,SoundVars.soundOn,this._listener.getAverageFps()));
         Main.emitPlayData(this._random.getSeed(),this._recorder.toPlayDataXml(this.getFinalScore()));
      }
      
      public function addTickable(param1:ITickable) : void
      {
         this._tickables.push(param1);
      }
   }
}
