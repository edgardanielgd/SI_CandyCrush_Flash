package com.midasplayer.engine.replay
{
   import com.midasplayer.debug.Debug;
   import com.midasplayer.engine.IEngine;
   import com.midasplayer.engine.IGameLogic;
   import com.midasplayer.engine.comm.IGameComm;
   import com.midasplayer.engine.playdata.IPlayData;
   import com.midasplayer.engine.playdata.PlayDataFactory;
   import com.midasplayer.engine.playdata.PlayDataParser;
   import com.midasplayer.engine.render.IRenderableRoot;
   import com.midasplayer.engine.tick.ITicker;
   import com.midasplayer.engine.tick.Ticker;
   import com.midasplayer.input.KeyboardInput;
   import com.midasplayer.input.MouseInput;
   import com.midasplayer.time.ITimer;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ReplayEngine extends Sprite implements IEngine
   {
       
      
      private var _timer:ITimer;
      
      private var _gameLogic:IGameLogic;
      
      private var _recorder:com.midasplayer.engine.replay.IRecorder;
      
      private var _gameView:IRenderableRoot;
      
      private var _gameComm:IGameComm;
      
      private var _ticker:ITicker;
      
      private var _replayer:com.midasplayer.engine.replay.IReplayer;
      
      private var _isDone:Boolean = false;
      
      private var _first:Boolean = true;
      
      private var _last:Boolean = false;
      
      private var _stop:Boolean = false;
      
      public function ReplayEngine(param1:String, param2:ITimer, param3:int, param4:IGameLogic, param5:MouseInput, param6:KeyboardInput, param7:IGameComm, param8:com.midasplayer.engine.replay.IRecorder, param9:IRenderableRoot = null)
      {
         super();
         Debug.assert(null != param1,"PlayData must not be null.");
         Debug.assert(null != param2,"Timer must not be null.");
         Debug.assert(null != param4,"GameLogic must not be null.");
         Debug.assert(null != param5,"PlayData must not be null.");
         Debug.assert(null != param6,"PlayData must not be null.");
         Debug.assert(null != param8,"Recorder must not be null.");
         this._timer = param2;
         this._gameLogic = param4;
         this._recorder = param8;
         this._gameComm = param7;
         this._gameView = param9;
         var _loc10_:Vector.<IPlayData> = new PlayDataParser(param1,new PlayDataFactory(param5,param6)).getEntries();
         this._ticker = new Ticker(param2,param4,param3,50);
         this._replayer = new Replayer(param4,this._ticker,_loc10_);
      }
      
      public function getPlayData() : String
      {
         return this._recorder.toPlayDataXml(this._gameLogic.getFinalScore());
      }
      
      public function getTimer() : ITimer
      {
         return this._timer;
      }
      
      public function isDone() : Boolean
      {
         return this._isDone;
      }
      
      public function stop() : void
      {
         this._stop = true;
         while(!this._last)
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
         if(this._first)
         {
            this._gameComm.gameStart();
            if(this._gameView)
            {
               addChild(this._gameView.getDisplayObject());
            }
            this._first = false;
         }
         this._replayer.update();
         if(this._gameView)
         {
            this._gameView.render(this._ticker.getTick(),this._ticker.getAlpha());
         }
         if(!this._last && (Boolean(this._gameLogic.isDone()) || this._stop))
         {
            this._gameComm.gameEnd(this._gameLogic.getFinalScore());
            if(this._gameView)
            {
               removeChild(this._gameView.getDisplayObject());
            }
            this._last = true;
         }
      }
   }
}
