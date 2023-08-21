package com.midasplayer.engine
{
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display.StageScaleMode;
   import flash.events.Event;
   
   public class GameMain extends Sprite
   {
       
      
      private var start:int = 1;
      
      protected var _engineFactory:com.midasplayer.engine.IEngineFactory;
      
      protected var _engine:com.midasplayer.engine.IEngine;
      
      public function GameMain(param1:com.midasplayer.engine.IEngineFactory)
      {
         super();
         this._engineFactory = param1;
         addEventListener(Event.ADDED_TO_STAGE,this._onInitialize);
      }
      
      protected function _onInitialize(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this._onInitialize);
         addEventListener(Event.ENTER_FRAME,this._onEnterFrame);
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.align = StageAlign.TOP_LEFT;
         stage.showDefaultContextMenu = false;
         this._engine = this._engineFactory.create();
         addChild(this._engine as Sprite);
      }
      
      protected function _onEnterFrame(param1:Event) : void
      {
         if(!this._engine.isDone())
         {
            this._engine.update();
         }
      }
   }
}
