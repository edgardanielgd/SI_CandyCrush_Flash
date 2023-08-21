package com.midasplayer.games.candycrush.render.particles
{
   import com.midasplayer.games.candycrush.render.TickedSprite;
   import com.midasplayer.math.IntCoord;
   import flash.display.BitmapData;
   
   public class PSystem
   {
       
      
      protected var _c:IntCoord;
      
      private var _particles:Vector.<TickedSprite>;
      
      private var _canvas:BitmapData;
      
      private var _color:int;
      
      private var _ticks:int = 0;
      
      private var _ticks2:int = 0;
      
      private var _created:Boolean = false;
      
      private var _isVertical:Boolean;
      
      public var perTick:int = 3;
      
      public var WaitTicks:int = 10;
      
      public function PSystem(param1:BitmapData, param2:int, param3:Boolean, param4:int, param5:int)
      {
         this._particles = new Vector.<TickedSprite>();
         super();
         this._c = new IntCoord(param4,param5);
         this._canvas = param1;
         this._color = param2;
         this._isVertical = param3;
      }
      
      public static function rsigned() : Number
      {
         return 2 * Math.random() - 1;
      }
      
      public function tick(param1:int) : void
      {
         var _loc6_:TickedSprite = null;
         var _loc7_:*;
         var _loc8_:* = (_loc7_ = this)._ticks + 1;
         _loc7_._ticks = _loc8_;
         if(this._ticks < this.WaitTicks)
         {
            return;
         }
         _loc8_ = (_loc7_ = this)._ticks2 + 1;
         _loc7_._ticks2 = _loc8_;
         var _loc2_:Object = {
            "px":this._c.x,
            "py":this._c.y
         };
         var _loc3_:int = 0;
         while(_loc3_ < this.perTick)
         {
            this._createParticle(param1,_loc3_);
            _loc3_++;
         }
         var _loc4_:Vector.<TickedSprite> = new Vector.<TickedSprite>();
         var _loc5_:int = 0;
         while(_loc5_ < this._particles.length)
         {
            if(!(_loc6_ = this._particles[_loc5_]).isDone())
            {
               _loc6_.tick(param1);
               _loc4_.push(_loc6_);
            }
            _loc5_++;
         }
         this._particles = _loc4_;
      }
      
      protected function _createParticle(param1:int, param2:int) : void
      {
         var _loc3_:Object = {};
         if(param2 & 1 ^ param1 & 1)
         {
            if(this._isVertical)
            {
               _loc3_.px = this._c.x + 30 * rsigned();
               _loc3_.py = this._c.y - 2 * this._ticks2 * 16 + 4 * rsigned();
               _loc3_.vy = 2 + 2 * Math.random();
            }
            else
            {
               _loc3_.px = this._c.x - 2 * this._ticks2 * 16 + 4 * rsigned();
               _loc3_.py = this._c.y + 30 * rsigned();
               _loc3_.vx = 2 + 2 * Math.random();
            }
            this.addParticle(new Particle(this._canvas,param1,this._color,_loc3_));
         }
         else
         {
            if(this._isVertical)
            {
               _loc3_.px = this._c.x + 30 * rsigned();
               _loc3_.py = this._c.y + 2 * this._ticks2 * 16 + 4 * rsigned();
               _loc3_.vy = -2 - 2 * Math.random();
            }
            else
            {
               _loc3_.px = this._c.x + 2 * this._ticks2 * 16 + 4 * rsigned();
               _loc3_.py = this._c.y + 30 * rsigned();
               _loc3_.vx = -2 - 2 * Math.random();
            }
            this.addParticle(new Particle(this._canvas,param1,this._color,_loc3_));
         }
      }
      
      public function addParticle(param1:Particle) : void
      {
         this._particles.push(param1);
      }
      
      public function render(param1:int, param2:Number) : void
      {
         var _loc3_:TickedSprite = null;
         for each(_loc3_ in this._particles)
         {
            _loc3_._renderFront(param1,param2);
         }
      }
   }
}
