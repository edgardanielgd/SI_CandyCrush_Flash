package com.midasplayer.games.candycrush.input
{
   import com.midasplayer.games.candycrush.GameView;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import com.midasplayer.math.IntCoord;
   
   public class Swapper
   {
       
      
      private var _switchClickN:int = 0;
      
      private var _swapState:int = 0;
      
      private var _marked:Boolean = false;
      
      private var _mx:int;
      
      private var _my:int;
      
      private var _tempSelected:Boolean = false;
      
      private var _tx:int;
      
      private var _ty:int;
      
      private var _swap:com.midasplayer.games.candycrush.input.SwapInfo;
      
      public function Swapper()
      {
         super();
      }
      
      private static function iabs(param1:int, param2:int) : int
      {
         return param1 > param2 ? param1 - param2 : param2 - param1;
      }
      
      public function reset() : void
      {
         this._marked = false;
         this._tempSelected = false;
         this._swap = null;
      }
      
      public function mouseDownAt(param1:int, param2:int) : void
      {
         if(param1 < 0 || param2 < 0)
         {
            return;
         }
         if(this._marked && this.nextTo(this._mx,this._my,param1,param2))
         {
            this._swap = new com.midasplayer.games.candycrush.input.SwapInfo(this._mx,this._my,param1,param2);
         }
         else
         {
            this._marked = false;
            this._tempSelected = true;
            this._tx = param1;
            this._ty = param2;
         }
      }
      
      public function mouseMoveTo(param1:int, param2:int) : void
      {
         if(this._tempSelected && this.nextTo(this._tx,this._ty,param1,param2))
         {
            this._swap = new com.midasplayer.games.candycrush.input.SwapInfo(this._tx,this._ty,param1,param2);
         }
      }
      
      private function nextTo(param1:int, param2:int, param3:int, param4:int) : Boolean
      {
         return iabs(param1,param3) == 1 && param2 == param4 || iabs(param2,param4) == 1 && param1 == param3;
      }
      
      public function mouseUpAt(param1:int, param2:int) : void
      {
         if(this._tempSelected && (this._tx == param1 && this._ty == param2))
         {
            SoundVars.sound.play(SA_Switch_mark1,0.4,GameView.gridToStageX(param1));
            this._marked = true;
            this._mx = param1;
            this._my = param2;
         }
         this._tempSelected = false;
      }
      
      public function shouldSwap() : Boolean
      {
         return this._swap != null;
      }
      
      public function getSwap() : com.midasplayer.games.candycrush.input.SwapInfo
      {
         return this._swap;
      }
      
      public function isMarked() : Boolean
      {
         return this._marked || this._tempSelected;
      }
      
      public function getMarkedPos() : IntCoord
      {
         if(this._tempSelected)
         {
            return new IntCoord(this._tx,this._ty);
         }
         return new IntCoord(this._mx,this._my);
      }
   }
}
