package com.midasplayer.engine
{
   import com.midasplayer.debug.Debug;
   import com.midasplayer.engine.comm.GameComm;
   import com.midasplayer.engine.comm.IGameComm;
   import com.midasplayer.engine.comm.RemoteAssertHandler;
   import com.midasplayer.engine.render.IRenderableRoot;
   import com.midasplayer.engine.replay.IRecorder;
   import com.midasplayer.engine.tick.ITicker;
   import com.midasplayer.engine.tick.Ticker;
   import com.midasplayer.input.KeyboardInput;
   import com.midasplayer.input.MouseInput;
   import com.midasplayer.math.Vec2;
   import com.midasplayer.time.ITimer;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class Engine extends Sprite implements IEngine
   {
      
      public static const NotStartedState:int = 0;
      
      public static const IntroState:int = 1;
      
      public static const GameState:int = 2;
      
      public static const OutroState:int = 3;
      
      public static const DoneState:int = 4;
      
      public static const MousePressed:int = 1;
      
      public static const MouseReleased:int = 2;
      
      public static const MousePosition:int = 4;
      
      public static const KeyboardPressed:int = 8;
      
      public static const KeyboardReleased:int = 16;
       
      
      private var _intro:com.midasplayer.engine.IPart;
      
      private var _introView:IRenderableRoot;
      
      private var _game:com.midasplayer.engine.IGameLogic;
      
      private var _gameView:IRenderableRoot;
      
      private var _outro:com.midasplayer.engine.IPart;
      
      private var _outroView:IRenderableRoot;
      
      private var _introTicker:ITicker;
      
      private var _gameTicker:ITicker;
      
      private var _outroTicker:ITicker;
      
      private var _timer:ITimer;
      
      private var _gameCommunicator:IGameComm;
      
      private var _mouseInput:MouseInput;
      
      private var _keyboardInput:KeyboardInput;
      
      private var _inputListeners:int;
      
      private var _recorder:IRecorder;
      
      private var _stop:Boolean = false;
      
      private var _state:int = 0;
      
      public function Engine(param1:com.midasplayer.engine.IPart, param2:IRenderableRoot, param3:com.midasplayer.engine.IGameLogic, param4:IRenderableRoot, param5:com.midasplayer.engine.IPart, param6:IRenderableRoot, param7:ITimer, param8:int, param9:IGameComm, param10:IRecorder, param11:MouseInput, param12:KeyboardInput, param13:int)
      {
         super();
         Debug.assert(param1 != null,"The intro is null.");
         Debug.assert(param2 != null,"The intro game view is null.");
         Debug.assert(param3 != null,"The game is null.");
         Debug.assert(param4 != null,"The game view is null.");
         Debug.assert(param5 != null,"The game over is null.");
         Debug.assert(param6 != null,"The game over view is null.");
         Debug.assert(param9 != null,"The game communicator is null.");
         this._intro = param1;
         this._introView = param2;
         this._game = param3;
         this._gameView = param4;
         this._outro = param5;
         this._outroView = param6;
         this._timer = param7;
         this._gameCommunicator = param9;
         this._recorder = param10;
         this._mouseInput = param11;
         this._keyboardInput = param12;
         this._inputListeners = param13;
         this._introTicker = new Ticker(param7,this._intro,param8,50);
         this._gameTicker = new Ticker(param7,this._game,param8,50);
         this._outroTicker = new Ticker(param7,this._outro,param8,50);
         if(this._gameCommunicator is GameComm)
         {
            Debug.setAssertHandler(new RemoteAssertHandler(this._recorder));
         }
      }
      
      public function getTimer() : ITimer
      {
         return this._timer;
      }
      
      public function getState() : int
      {
         return this._state;
      }
      
      public function isDone() : Boolean
      {
         return this._state == DoneState;
      }
      
      public function getPlayData() : String
      {
         return this._recorder.toPlayDataXml(this._game.getFinalScore());
      }
      
      public function stop() : void
      {
         this._stop = true;
         while(this._state != DoneState)
         {
            this.update();
         }
      }
      
      public function getDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function update() : void
      {
         Debug.assert(this._state != DoneState,"Running the engine after it is done.");
         this._updateStates();
         if(this._state == DoneState)
         {
            this._onStopEngine();
            return;
         }
         if(this._state == IntroState)
         {
            this._onRunIntro();
         }
         else if(this._state == GameState)
         {
            this._onRunGame();
         }
         else if(this._state == OutroState)
         {
            this._onRunOutro();
         }
         else
         {
            Debug.assert(false,"Encountered an unknown game state.");
         }
      }
      
      private function _onStartEngine() : void
      {
         if(this._inputListeners & MousePressed)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this._onMouseDown);
         }
         if(this._inputListeners & MouseReleased)
         {
            stage.addEventListener(MouseEvent.MOUSE_UP,this._onMouseUp);
         }
         if(this._inputListeners & KeyboardPressed)
         {
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this._onKeyDown);
         }
         if(this._inputListeners & KeyboardReleased)
         {
            stage.addEventListener(KeyboardEvent.KEY_UP,this._onKeyUp);
         }
      }
      
      private function _onStopEngine() : void
      {
         this._gameCommunicator.gameQuit();
         if(this._inputListeners & MousePressed)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this._onMouseDown);
         }
         if(this._inputListeners & MouseReleased)
         {
            stage.removeEventListener(MouseEvent.MOUSE_UP,this._onMouseUp);
         }
         if(this._inputListeners & KeyboardPressed)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this._onKeyDown);
         }
         if(this._inputListeners & KeyboardReleased)
         {
            stage.removeEventListener(KeyboardEvent.KEY_UP,this._onKeyUp);
         }
      }
      
      private function _onStartIntro() : void
      {
         addChild(this._introView.getDisplayObject());
         this._intro.start();
      }
      
      private function _onRunIntro() : void
      {
         this._introTicker.update();
         this._introView.render(this._introTicker.getTick(),this._introTicker.getAlpha());
      }
      
      private function _onStopIntro() : void
      {
         this._intro.stop();
         removeChild(this._introView.getDisplayObject());
      }
      
      private function _onStartGame() : void
      {
         this._mouseInput.reset();
         this._keyboardInput.reset();
         this._gameCommunicator.gameStart();
         addChild(this._gameView.getDisplayObject());
         this._game.start();
      }
      
      private function _onRunGame() : void
      {
         if(this._inputListeners & MousePosition)
         {
            this._mouseInput.setPosition(new Vec2(stage.mouseX,stage.mouseY));
         }
         this._gameTicker.update();
         this._gameView.render(this._gameTicker.getTick(),this._gameTicker.getAlpha());
      }
      
      private function _onStopGame() : void
      {
         this._game.stop();
         removeChild(this._gameView.getDisplayObject());
         this._gameCommunicator.gameEnd(this._game.getFinalScore());
      }
      
      private function _onStartOutro() : void
      {
         addChild(this._outroView.getDisplayObject());
         this._outro.start();
      }
      
      private function _onRunOutro() : void
      {
         this._outroTicker.update();
         this._outroView.render(this._outroTicker.getTick(),this._outroTicker.getAlpha());
      }
      
      private function _onStopOutro() : void
      {
         this._outro.stop();
         removeChild(this._outroView.getDisplayObject());
      }
      
      private function _updateStates() : void
      {
         if(this._state == NotStartedState)
         {
            this._onStartEngine();
            this._onStartIntro();
            this._state = IntroState;
         }
         else if(this._state == IntroState && (Boolean(this._intro.isDone()) || this._stop))
         {
            this._onStopIntro();
            this._onStartGame();
            this._state = GameState;
         }
         else if(this._state == GameState && (Boolean(this._game.isDone()) || this._stop))
         {
            this._onStopGame();
            this._onStartOutro();
            this._state = OutroState;
         }
         else if(this._state == OutroState && (Boolean(this._outro.isDone()) || this._stop))
         {
            this._onStopOutro();
            this._state = DoneState;
         }
      }
      
      private function _onMouseDown(param1:Event) : void
      {
         this._mouseInput.setPressed(new Vec2(int(mouseX),int(mouseY)));
      }
      
      private function _onMouseUp(param1:Event) : void
      {
         this._mouseInput.setReleased(new Vec2(int(mouseX),int(mouseY)));
      }
      
      private function _onKeyDown(param1:KeyboardEvent) : void
      {
         this._keyboardInput.setPressed(param1.charCode);
      }
      
      private function _onKeyUp(param1:KeyboardEvent) : void
      {
         this._keyboardInput.setReleased(param1.charCode);
      }
   }
}
