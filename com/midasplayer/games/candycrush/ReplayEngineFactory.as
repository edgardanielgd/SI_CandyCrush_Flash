package com.midasplayer.games.candycrush
{
   import com.midasplayer.animation.tweenick.TickTween;
   import com.midasplayer.engine.GameDataParser;
   import com.midasplayer.engine.IEngine;
   import com.midasplayer.engine.comm.DebugGameComm;
   import com.midasplayer.engine.replay.IReplayEngineFactory;
   import com.midasplayer.engine.replay.Recorder;
   import com.midasplayer.engine.replay.ReplayEngine;
   import com.midasplayer.input.KeyboardInput;
   import com.midasplayer.input.MouseInput;
   import com.midasplayer.math.MtRandom;
   import com.midasplayer.time.AdjustableTimer;
   import com.midasplayer.time.SystemTimer;
   
   public class ReplayEngineFactory implements IReplayEngineFactory
   {
       
      
      public function ReplayEngineFactory()
      {
         super();
      }
      
      public function create(param1:String, param2:String) : IEngine
      {
         var _loc4_:DebugGameComm = null;
         var _loc5_:GameDataParser = null;
         var _loc6_:MouseInput = null;
         var _loc8_:Recorder = null;
         var _loc9_:TickTween = null;
         var _loc10_:MtRandom = null;
         var _loc11_:Boolean = false;
         var _loc12_:GameView = null;
         var _loc3_:AdjustableTimer = new AdjustableTimer(new SystemTimer());
         _loc4_ = new DebugGameComm(param1);
         _loc5_ = new GameDataParser(param1);
         _loc6_ = new MouseInput();
         var _loc7_:KeyboardInput = new KeyboardInput();
         _loc8_ = new Recorder(_loc4_);
         _loc9_ = new TickTween();
         _loc10_ = new MtRandom(_loc5_.getRandomSeed());
         _loc11_ = _loc5_.getAsBool("isShortGame");
         _loc12_ = new GameView(_loc5_,_loc9_,_loc11_);
         var _loc13_:Logic;
         (_loc13_ = new Logic(_loc6_,_loc8_,_loc10_,_loc9_,_loc12_,_loc11_,BoosterPack.fromGameData(_loc5_))).addTickable(_loc12_);
         return new ReplayEngine(param2,_loc3_,Ticks.TicksPerSecond,_loc13_,_loc6_,_loc7_,_loc4_,_loc8_,_loc12_);
      }
   }
}
