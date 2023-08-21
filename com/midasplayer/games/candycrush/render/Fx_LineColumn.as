package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.games.candycrush.GameView;
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.render.particles.PSystem;
   import com.midasplayer.math.IntCoord;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   public class Fx_LineColumn extends TickedSprite
   {
       
      
      private var _line:MovieClip;
      
      private var _x:int;
      
      private var _y:int;
      
      private var _color:int;
      
      private var _startFrame:int = 1;
      
      private var _lastFrame:int = 0;
      
      private var _addedParticles:Boolean = false;
      
      private var _stars:GA_Stars_GroupAnimated;
      
      private var _stars2:GA_Stars_GroupAnimated;
      
      private var _starsStartTick:int;
      
      private var _starsLastFrame:int = -1;
      
      private var _isVertical:Boolean;
      
      private var _removedLine:Boolean = false;
      
      private var _psystem:PSystem;
      
      public function Fx_LineColumn(param1:BitmapData, param2:int, param3:Item)
      {
         super(param1,param2);
         this._isVertical = ItemType.isColumn(param3.special);
         this._line = getBlastMc(param3.column,param3.row,param3.special,param3.color);
         this._color = param3.color;
         this._x = this._line.x;
         this._y = this._line.y;
         var _loc4_:IntCoord = GameView.gridToStage(param3.x,param3.row + 0.5);
         this._psystem = new PSystem(param1,this._color,this._isVertical,_loc4_.x,_loc4_.y);
         frontsprite.addChild(this._line);
      }
      
      private static function getBlastMc(param1:Number, param2:Number, param3:int, param4:int) : MovieClip
      {
         var _loc5_:MovieClip = null;
         var _loc6_:IntCoord = GameView.gridToStage(param1,param2);
         if(param3 == ItemType.LINE)
         {
            if(param4 == GameView.COLOR_BLUE || param4 == GameView.COLOR_NONE)
            {
               (_loc5_ = new blue_horisontal_lineblast()).x = _loc6_.x - 28;
               _loc5_.y = _loc6_.y + 6;
            }
            else if(param4 == GameView.COLOR_GREEN)
            {
               (_loc5_ = new green_horisontal_lineblast()).x = _loc6_.x - 26;
               _loc5_.y = _loc6_.y + 4;
            }
            else if(param4 == GameView.COLOR_ORANGE)
            {
               (_loc5_ = new orange_horisontal_lineblast()).x = _loc6_.x - 20;
               _loc5_.y = _loc6_.y + 3;
            }
            else if(param4 == GameView.COLOR_PURPLE)
            {
               (_loc5_ = new purple_horisontal_lineblast()).x = _loc6_.x - 28;
               _loc5_.y = _loc6_.y + 5;
            }
            else if(param4 == GameView.COLOR_RED)
            {
               (_loc5_ = new red_horisontal_lineblast()).x = _loc6_.x - 26;
               _loc5_.y = _loc6_.y + 5;
            }
            else if(param4 == GameView.COLOR_YELLOW)
            {
               (_loc5_ = new yellow_horisontal_lineblast()).x = _loc6_.x - 22;
               _loc5_.y = _loc6_.y + 3;
            }
         }
         if(param3 == ItemType.COLUMN)
         {
            if(param4 == GameView.COLOR_BLUE || param4 == GameView.COLOR_NONE)
            {
               (_loc5_ = new blue_vertical_lineblast()).x = _loc6_.x - 28;
               _loc5_.y = _loc6_.y + 6;
            }
            else if(param4 == GameView.COLOR_GREEN)
            {
               (_loc5_ = new green_vertical_lineblast()).x = _loc6_.x - 26;
               _loc5_.y = _loc6_.y + 4;
            }
            else if(param4 == GameView.COLOR_ORANGE)
            {
               (_loc5_ = new orange_vertical_lineblast()).x = _loc6_.x - 20;
               _loc5_.y = _loc6_.y + 3;
            }
            else if(param4 == GameView.COLOR_PURPLE)
            {
               (_loc5_ = new purple_vertical_lineblast()).x = _loc6_.x - 27;
               _loc5_.y = _loc6_.y + 6;
            }
            else if(param4 == GameView.COLOR_RED)
            {
               (_loc5_ = new red_vertical_lineblast()).x = _loc6_.x - 26;
               _loc5_.y = _loc6_.y + 5;
            }
            else if(param4 == GameView.COLOR_YELLOW)
            {
               (_loc5_ = new yellow_vertical_lineblast()).x = _loc6_.x - 22;
               _loc5_.y = _loc6_.y + 4;
            }
         }
         return _loc5_;
      }
      
      override protected function renderFront(param1:int, param2:Number) : void
      {
         var _loc3_:int = int(getWantedFrame(24,0,this._startFrame));
         if(_loc3_ != this._lastFrame)
         {
            this._line.gotoAndStop(_loc3_);
            this._lastFrame = _loc3_;
         }
         this._psystem.render(param1,param2);
         if(!this._removedLine && _loc3_ > this._line.totalFrames)
         {
            frontsprite.removeChild(this._line);
            this._removedLine = true;
         }
         if(_loc3_ > this._line.totalFrames + 15)
         {
            done = true;
         }
      }
      
      private function getColor() : uint
      {
         if(this._color == GameView.COLOR_BLUE)
         {
            return 39423;
         }
         if(this._color == GameView.COLOR_GREEN)
         {
            return 52224;
         }
         if(this._color == GameView.COLOR_ORANGE)
         {
            return 13395456;
         }
         if(this._color == GameView.COLOR_PURPLE)
         {
            return 10027263;
         }
         if(this._color == GameView.COLOR_RED)
         {
            return 13369344;
         }
         if(this._color == GameView.COLOR_YELLOW)
         {
            return 16763904;
         }
         return 39423;
      }
      
      override public function tick(param1:int) : void
      {
         this._psystem.tick(param1);
      }
      
      override public function addAndRemoveMe() : Boolean
      {
         return true;
      }
      
      override public function addAtFront() : Boolean
      {
         return true;
      }
   }
}
