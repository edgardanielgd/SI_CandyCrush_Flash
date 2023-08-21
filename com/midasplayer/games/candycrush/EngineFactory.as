package com.midasplayer.games.candycrush
{
   import com.midasplayer.animation.tweenick.TickTween;
   import com.midasplayer.engine.Engine;
   import com.midasplayer.engine.GameDataParser;
   import com.midasplayer.engine.IEngine;
   import com.midasplayer.engine.IEngineFactory;
   import com.midasplayer.engine.comm.IGameComm;
   import com.midasplayer.engine.replay.Recorder;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.games.candycrush.render.UiButtonRenderer;
   import com.midasplayer.input.KeyboardInput;
   import com.midasplayer.input.MouseInput;
   import com.midasplayer.math.MtRandom;
   import com.midasplayer.time.ITimer;
   import flash.system.System;
   
   public class EngineFactory implements IEngineFactory
   {
       
      
      private var _comm:IGameComm;
      
      private var _timer:ITimer;
      
      public function EngineFactory(param1:IGameComm, param2:ITimer)
      {
         super();
         this._comm = param1;
         this._timer = param2;
      }
      
      public function create() : IEngine
      {
         var _loc1_:GameDataParser = null;
         var _loc2_:Boolean = false;
         var _loc3_:MouseInput = null;
         var _loc5_:Recorder = null;
         var _loc6_:MtRandom = null;
         var _loc7_:TickTween = null;
         var _loc9_:GameView = null;
         var _loc10_:Logic = null;
         _loc1_ = new GameDataParser(this._comm.getGameData());
         _loc2_ = _loc1_.getAsBool("isShortGame");
         SoundVars.soundOn = _loc1_.getAsBool("soundOn");
         SoundVars.musicOn = _loc1_.getAsBool("musicOn");
         _loc3_ = new MouseInput();
         var _loc4_:KeyboardInput = new KeyboardInput();
         _loc5_ = new Recorder(this._comm);
         _loc6_ = new MtRandom(_loc1_.getRandomSeed());
         _loc7_ = new TickTween();
         UiButtonRenderer.instance.setTweener(_loc7_);
         var _loc8_:Intro = new Intro(_loc1_,_loc7_);
         _loc9_ = new GameView(_loc1_,_loc7_,_loc2_);
         _loc10_ = new Logic(_loc3_,_loc5_,_loc6_,_loc7_,_loc9_,_loc2_,BoosterPack.fromGameData(_loc1_));
         var _loc11_:Outro = new Outro(_loc1_,_loc10_,_loc9_,_loc2_);
         Main.configTimer(this._timer);
         _loc10_.addTickable(_loc9_);
         return new Engine(_loc8_,_loc8_,_loc10_,_loc9_,_loc11_,_loc11_,this._timer,Ticks.TicksPerSecond,this._comm,_loc5_,_loc3_,_loc4_,Engine.MousePosition | Engine.MousePressed | Engine.MouseReleased | Engine.KeyboardPressed | Engine.KeyboardReleased);
      }
      
      public function runGames(param1:int, param2:int) : void
      {
         var _loc3_:GameDataParser = null;
         var _loc4_:MouseInput = null;
         var _loc6_:Recorder = null;
         var _loc7_:MtRandom = null;
         var _loc8_:TickTween = null;
         var _loc10_:Boolean = false;
         var _loc11_:GameView = null;
         var _loc16_:MtRandom = null;
         var _loc17_:Logic = null;
         var _loc18_:Vector.<Vector.<int>> = null;
         _loc3_ = new GameDataParser(this._comm.getGameData());
         _loc4_ = new MouseInput();
         var _loc5_:KeyboardInput = new KeyboardInput();
         _loc6_ = new Recorder(this._comm);
         _loc7_ = new MtRandom(_loc3_.getRandomSeed());
         _loc8_ = new TickTween();
         var _loc9_:Intro = new Intro(_loc3_,_loc8_);
         SoundVars.soundOn = _loc3_.getAsBool("soundOn");
         SoundVars.musicOn = _loc3_.getAsBool("musicOn");
         _loc10_ = _loc3_.getAsBool("isShortGame");
         _loc11_ = new GameView(_loc3_,_loc8_,_loc10_);
         var _loc12_:Logic = new Logic(_loc4_,_loc6_,_loc7_,_loc8_,_loc11_,_loc10_,BoosterPack.fromGameData(_loc3_));
         var _loc13_:BoosterPack = BoosterPack.fromGameData(_loc3_);
         var _loc14_:String = "";
         var _loc15_:int = param1;
         while(_loc15_ < param2)
         {
            _loc16_ = new MtRandom(_loc15_);
            if((_loc18_ = (_loc17_ = new Logic(_loc4_,_loc6_,_loc16_,_loc8_,_loc11_,false,_loc13_)).getBoard()._mInt)[0][0] == GameView.COLOR_RED && _loc18_[0][1] == GameView.COLOR_PURPLE && _loc18_[0][2] == GameView.COLOR_ORANGE && _loc18_[0][3] == GameView.COLOR_BLUE && _loc18_[0][4] == GameView.COLOR_GREEN && _loc18_[0][5] == GameView.COLOR_BLUE && _loc18_[0][6] == GameView.COLOR_ORANGE && _loc18_[0][7] == GameView.COLOR_PURPLE && _loc18_[0][8] == GameView.COLOR_PURPLE)
            {
               _loc14_ += "possible: " + _loc15_ + "\n";
               System.setClipboard(_loc14_);
               Main.Log.trace(_loc14_);
            }
            if((_loc15_ & 127) == 0)
            {
            }
            if((_loc15_ & 2047) == 0)
            {
               Main.Log.trace("i " + _loc15_);
            }
            _loc15_++;
         }
      }
   }
}
