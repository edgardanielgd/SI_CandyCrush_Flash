package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.animation.tweenick.TTEasing;
   import com.midasplayer.animation.tweenick.TTGroup;
   import com.midasplayer.animation.tweenick.TTItem;
   import com.midasplayer.animation.tweenick.TickTween;
   import com.midasplayer.games.candycrush.audio.SoundVars;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class UiButtonRenderer
   {
      
      private static var _instance:com.midasplayer.games.candycrush.render.UiButtonRenderer;
       
      
      private var _buttonMusicFrame:int = -1;
      
      private var _buttonSoundFrame:int = -1;
      
      private var _buttonSound:GA_Ui_Mc_buttons;
      
      private var _buttonMusic:GA_Ui_Mc_buttons;
      
      private var _buttonQuit:GA_Ui_Mc_buttons;
      
      private var _buttonSoundHolder:Sprite;
      
      private var _buttonMusicHolder:Sprite;
      
      private var _buttonQuitHolder:Sprite;
      
      private var _sprite:Sprite;
      
      private var _tweener:TickTween;
      
      private var ButtonbaseX:int = 17;
      
      public function UiButtonRenderer()
      {
         this._buttonSoundHolder = new Sprite();
         this._buttonMusicHolder = new Sprite();
         this._buttonQuitHolder = new Sprite();
         this._sprite = new Sprite();
         super();
         if(_instance)
         {
            throw new Error("Only one UiButtonRenderer can be created!");
         }
         var _loc1_:int = 600 - 16 - 1;
         this._buttonQuit = new GA_Ui_Mc_buttons();
         this._buttonQuit.x = -this._buttonQuit.width / 2;
         this._buttonQuit.y = -this._buttonQuit.width / 2;
         this._buttonQuit.gotoAndStop(1);
         this._buttonQuitHolder.x = this.ButtonbaseX - 32;
         this._buttonQuitHolder.y = _loc1_;
         this._buttonQuitHolder.addChild(this._buttonQuit);
         this._buttonMusic = new GA_Ui_Mc_buttons();
         this._buttonMusic.x = -this._buttonMusic.width / 2;
         this._buttonMusic.y = -this._buttonMusic.width / 2;
         this._buttonMusic.gotoAndStop(1);
         this._buttonMusicHolder.x = this.ButtonbaseX;
         this._buttonMusicHolder.y = _loc1_;
         this._buttonMusicHolder.addChild(this._buttonMusic);
         this._buttonSound = new GA_Ui_Mc_buttons();
         this._buttonSound.x = -this._buttonMusic.width / 2;
         this._buttonSound.y = -this._buttonMusic.width / 2;
         this._buttonSoundHolder.x = this.ButtonbaseX + 32;
         this._buttonSoundHolder.y = _loc1_;
         this._buttonSoundHolder.addChild(this._buttonSound);
         this._sprite.addChild(this._buttonQuitHolder);
         this._sprite.addChild(this._buttonMusicHolder);
         this._sprite.addChild(this._buttonSoundHolder);
         this.update();
      }
      
      public static function get instance() : com.midasplayer.games.candycrush.render.UiButtonRenderer
      {
         if(!_instance)
         {
            _instance = new com.midasplayer.games.candycrush.render.UiButtonRenderer();
         }
         return _instance;
      }
      
      public static function changeParent(param1:DisplayObject, param2:DisplayObjectContainer, param3:int = -1) : void
      {
         var _loc4_:Point = param1.localToGlobal(new Point());
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         var _loc5_:Point = param2.globalToLocal(_loc4_);
         param1.x = _loc5_.x;
         param1.y = _loc5_.y;
         if(param3 >= 0)
         {
            param2.addChildAt(param1,param3);
         }
         else
         {
            param2.addChild(param1);
         }
      }
      
      public function setTweener(param1:TickTween) : void
      {
         this._tweener = param1;
      }
      
      public function getSprite() : Sprite
      {
         return this._sprite;
      }
      
      public function hitTest(param1:int, param2:int) : Boolean
      {
         if(this._buttonSound.hitTestPoint(param1,param2))
         {
            SoundVars.soundOn = !SoundVars.soundOn;
         }
         else
         {
            if(!this._buttonMusic.hitTestPoint(param1,param2))
            {
               return false;
            }
            SoundVars.musicOn = !SoundVars.musicOn;
         }
         this.update();
         return true;
      }
      
      private function press(param1:DisplayObject) : void
      {
         if(!this._tweener)
         {
            return;
         }
         var _loc2_:TTGroup = new TTGroup();
         _loc2_.add(new TTItem(param1,5,"scaleX",1,{
            "start":0.85,
            "easing":TTEasing.QuadraticOutReturner
         }));
         _loc2_.add(new TTItem(param1,5,"scaleY",1,{
            "start":0.85,
            "easing":TTEasing.QuadraticOutReturner
         }));
         this._tweener.addGroup(_loc2_);
      }
      
      public function moveIn(param1:int = 3) : void
      {
         if(!this._tweener)
         {
            return;
         }
         var _loc2_:TTGroup = new TTGroup();
         _loc2_.addInTicks(11,new TTItem(this._buttonQuitHolder,param1 - 1,"x",this.ButtonbaseX));
         _loc2_.addInTicks(10,new TTItem(this._buttonMusicHolder,param1,"x",this.ButtonbaseX + 32));
         _loc2_.addInTicks(10,new TTItem(this._buttonSoundHolder,param1,"x",this.ButtonbaseX + 64));
         this._tweener.addGroup(_loc2_);
      }
      
      public function moveOut(param1:int = 3) : void
      {
         if(!this._tweener)
         {
            return;
         }
         var _loc2_:TTGroup = new TTGroup();
         _loc2_.addInTicks(15,new TTItem(this._buttonQuitHolder,param1,"x",this.ButtonbaseX - 32));
         _loc2_.addInTicks(15,new TTItem(this._buttonMusicHolder,param1,"x",this.ButtonbaseX));
         _loc2_.addInTicks(15,new TTItem(this._buttonSoundHolder,param1,"x",this.ButtonbaseX + 32));
         this._tweener.addGroup(_loc2_);
      }
      
      public function update() : void
      {
         var _loc1_:int = this.getMusicFrame();
         if(_loc1_ != this._buttonMusicFrame)
         {
            this._buttonMusic.gotoAndStop(_loc1_);
            this._buttonMusicFrame = _loc1_;
         }
         var _loc2_:int = this.getSoundFrame();
         if(_loc2_ != this._buttonSoundFrame)
         {
            this._buttonSound.gotoAndStop(_loc2_);
            this._buttonSoundFrame = _loc2_;
         }
      }
      
      public function changeParentTo(param1:DisplayObjectContainer, param2:int = -1) : void
      {
         changeParent(this._sprite,param1,param2);
      }
      
      private function getMusicFrame() : int
      {
         return SoundVars.musicOn ? 2 : 3;
      }
      
      private function getSoundFrame() : int
      {
         return SoundVars.soundOn ? 4 : 5;
      }
   }
}
