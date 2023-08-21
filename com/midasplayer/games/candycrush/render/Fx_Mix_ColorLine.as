package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.games.candycrush.GameView;
   import com.midasplayer.games.candycrush.ItemType;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.input.SwapInfo;
   import com.midasplayer.games.candycrush.render.itemview.ItemView;
   import com.midasplayer.math.IntCoord;
   import com.midasplayer.math.Vec2;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   public class Fx_Mix_ColorLine extends TickedSprite
   {
      
      private static const ColorBombExplosion:BitmapData = new GA_ColorBomb_Explosion();
      
      private static const ColorBombSnurran:BitmapData = new GA_ColorBomb_Snurran();
      
      private static const ColorBlastLine:BitmapData = new GA_ColorBomb_Flash();
      
      private static const BlackHole:BitmapData = new GA_Mix_ColorLine();
       
      
      private var _cbls:Vector.<Item>;
      
      private var _lastMove:Number = 0;
      
      private var cy:Number;
      
      private var cx:Number;
      
      private var _doBlasts:Boolean;
      
      private var _source:Item;
      
      private var _blackHolePos:IntCoord;
      
      private var _flashFrames:Array;
      
      private var _flashes:Array;
      
      private var _blackHole:com.midasplayer.games.candycrush.render.BitmapSprite;
      
      private var _isVertical:Boolean;
      
      private var _views:Array;
      
      private var _viewsPos:Array;
      
      private var _viewsPosOrg:Array;
      
      private var _needToRotateStripedCandy:Boolean = false;
      
      public function Fx_Mix_ColorLine(param1:BitmapData, param2:int, param3:SwapInfo, param4:Vector.<Item>)
      {
         this._cbls = new Vector.<Item>();
         this._flashFrames = [1,2,3,4,4,4,5,6,7,8,9];
         this._flashes = [];
         this._views = [];
         this._viewsPos = [];
         this._viewsPosOrg = [];
         super(param1,param2);
         this._source = ItemType.isColor(param3.item_a.special) ? param3.item_a : param3.item_b;
         this.setup(param3,this._source,param4);
      }
      
      override public function addAndRemoveMe() : Boolean
      {
         return true;
      }
      
      override public function addAtFront() : Boolean
      {
         return true;
      }
      
      override public function addAtBack() : Boolean
      {
         return false;
      }
      
      private function setup(param1:SwapInfo, param2:Item, param3:Vector.<Item>) : void
      {
         var _loc9_:Item = null;
         var _loc10_:Item = null;
         var _loc11_:ItemView = null;
         var _loc12_:MovieClip = null;
         var _loc13_:IntCoord = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         this.cx = param2.x;
         this.cy = param2.y;
         var _loc4_:Item = param2 != param1.item_a ? param1.item_a : param1.item_b;
         this._blackHole = new com.midasplayer.games.candycrush.render.BitmapSprite(BlackHole,11,1);
         this._blackHolePos = GameView.gridToStage(0.5 * (param1.x0 + param1.x1),0.5 * (1 + param1.y0 + param1.y1));
         this.cx = 0.5 * (param1.x0 + param1.x1);
         this.cy = 0.5 * (1 + param1.y0 + param1.y1);
         var _loc5_:IntCoord = GameView.gridToStage(this.cx,this.cy);
         var _loc6_:Array = [param1.item_a,param1.item_b];
         var _loc7_:int = 0;
         while(_loc7_ < 2)
         {
            _loc11_ = (_loc10_ = _loc6_[_loc7_]).view;
            this._views[_loc7_] = _loc11_;
            this._views[_loc7_].autoHandleRender = false;
            this._viewsPos[_loc7_] = GameView.gridToStage(_loc10_.x,_loc10_.y);
            this._viewsPosOrg[_loc7_] = GameView.gridToStage(_loc10_.x,_loc10_.y);
            _loc7_++;
         }
         if(param1.isVertical())
         {
            this._needToRotateStripedCandy = ItemType.isLine(_loc4_.special);
            if(_loc4_.y < param2.y)
            {
               this._blackHolePos.x = this._blackHolePos.x - 8;
               this._blackHole.setRotation(1.5 * Math.PI);
            }
            else
            {
               this._blackHolePos.x = this._blackHolePos.x + 8;
               this._blackHole.setRotation(0.5 * Math.PI);
            }
         }
         else
         {
            this._needToRotateStripedCandy = ItemType.isColumn(_loc4_.special);
            if(_loc4_.x < param2.x)
            {
               this._blackHolePos.y = this._blackHolePos.y + 8;
               this._blackHole.setRotation(Math.PI);
            }
            else
            {
               this._blackHolePos.y = this._blackHolePos.y - 8;
            }
         }
         var _loc8_:int = 0;
         for each(_loc9_ in param3)
         {
            (_loc12_ = new GA_Flash()).gotoAndStop(1);
            _loc12_.visible = false;
            frontsprite.addChild(_loc12_);
            _loc13_ = GameView.gridToStage(_loc9_.x,_loc9_.y);
            _loc14_ = Math.atan2(_loc13_.y - _loc5_.y,_loc13_.x - _loc5_.x) - 1.5707963267948966;
            _loc15_ = new Vec2(_loc9_.x - this.cx,_loc9_.y - this.cy).length / 3.9;
            _loc12_.rotation = _loc14_ * 57.29577951308232;
            _loc12_.scaleY = _loc15_;
            _loc12_.x = _loc5_.x;
            _loc12_.y = _loc5_.y;
            this._flashes.push(_loc12_);
            this._cbls.push(_loc9_);
         }
      }
      
      private function getPos(param1:int) : IntCoord
      {
         var _loc2_:Item = this._cbls[param1];
         return new IntCoord(_loc2_.x,_loc2_.y);
      }
      
      override public function tick(param1:int) : void
      {
      }
      
      override protected function renderFront(param1:int, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ItemView = null;
         var _loc5_:int = 0;
         var _loc8_:Number = NaN;
         var _loc9_:com.midasplayer.games.candycrush.render.BitmapSprite = null;
         var _loc10_:IntCoord = null;
         var _loc11_:IntCoord = null;
         var _loc12_:MovieClip = null;
         var _loc6_:IntCoord = GameView.gridToStage(this._source.x,this._source.y);
         if(getLivedTicks() < 5)
         {
            _loc8_ = getLivedTicks() * 0.2;
            _loc5_ = 0;
            while(_loc5_ < this._views.length)
            {
               _loc4_ = this._views[_loc5_];
               if(this._needToRotateStripedCandy && this._views[_loc5_] != this._source.view)
               {
                  _loc4_.getBmSprite().setRotation(_loc8_ * 0.5 * Math.PI);
               }
               _loc4_.renderXy(this._viewsPos[_loc5_].x,this._viewsPos[_loc5_].y,canvas);
               _loc5_++;
            }
         }
         else if(getLivedTicks() < 11)
         {
            _loc8_ = (getLivedTicks() - 5) * 0.1667;
            _loc8_ *= _loc8_;
            _loc5_ = 0;
            while(_loc5_ < this._views.length)
            {
               _loc9_ = (_loc4_ = this._views[_loc5_]).getBmSprite();
               this._views[_loc5_].renderXy(lerp(this._viewsPos[_loc5_].x,this._blackHolePos.x,_loc8_),lerp(this._viewsPos[_loc5_].y,this._blackHolePos.y,_loc8_),canvas);
               _loc5_++;
            }
         }
         _loc3_ = int(getWantedFrame(20,5));
         if(_loc3_ >= 0 && _loc3_ < 11)
         {
            this._blackHole.setFrame(_loc3_);
            this._blackHole.render2(param1,this._blackHolePos.x,this._blackHolePos.y,canvas,com.midasplayer.games.candycrush.render.BitmapSprite.ALIGN_CENTER,com.midasplayer.games.candycrush.render.BitmapSprite.VALIGN_MIDDLE);
         }
         var _loc7_:int = 0;
         while(_loc7_ < this._flashes.length)
         {
            _loc10_ = this.getPos(_loc7_);
            _loc11_ = GameView.gridToStage(_loc10_.x,_loc10_.y + 0.5);
            _loc3_ = int(getWantedFrame(24,10,0));
            if(_loc3_ >= 0 && _loc3_ < 11)
            {
               if(!(_loc12_ = this._flashes[_loc7_]).visible)
               {
                  _loc12_.visible = true;
               }
               _loc12_.gotoAndStop(this._flashFrames[_loc3_]);
            }
            else if(_loc3_ >= 11)
            {
               done = true;
            }
            _loc7_++;
         }
      }
   }
}
