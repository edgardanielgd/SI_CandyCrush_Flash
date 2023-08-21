package com.midasplayer.sound
{
   import flash.media.*;
   
   public class ManagedSound
   {
       
      
      private var ClassReference:Class;
      
      public var activeSounds:Array;
      
      private var manager:com.midasplayer.sound.SoundManager;
      
      public function ManagedSound(param1:com.midasplayer.sound.SoundManager, param2:Class)
      {
         this.activeSounds = new Array();
         super();
         this.manager = param1;
         this.ClassReference = param2;
      }
      
      public function play(param1:Number = 1, param2:Number = 0) : ManagedSoundChannel
      {
         var _loc3_:SoundChannel = new this.ClassReference().play(0,0,new SoundTransform(param1,param2));
         return new ManagedSoundChannel(this.manager,this,_loc3_);
      }
      
      public function loop(param1:Number = 1, param2:Number = 0, param3:Number = 999999999) : ManagedSoundChannel
      {
         var _loc4_:SoundChannel = new this.ClassReference().play(0,param3,new SoundTransform(param1,param2));
         return new ManagedSoundChannel(this.manager,this,_loc4_);
      }
      
      public function stop() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.activeSounds.length)
         {
            this.activeSounds[_loc1_].stop();
            _loc1_++;
         }
      }
      
      public function setPan(param1:Number) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.activeSounds.length)
         {
            this.activeSounds[_loc2_].setPan(param1);
            _loc2_++;
         }
      }
      
      public function setVolume(param1:Number) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.activeSounds.length)
         {
            this.activeSounds[_loc2_].setVolume(param1);
            _loc2_++;
         }
      }
      
      public function fadeTo(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.activeSounds.length)
         {
            this.activeSounds[_loc3_].fadeTo(param1,param2);
            _loc3_++;
         }
      }
      
      public function fadeToAndStop(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.activeSounds.length)
         {
            this.activeSounds[_loc3_].fadeToAndStop(param1,param2);
            _loc3_++;
         }
      }
      
      public function panTo(param1:Number, param2:Number) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.activeSounds.length)
         {
            this.activeSounds[_loc3_].panTo(param1,param2);
            _loc3_++;
         }
      }
      
      public function isPlaying() : Boolean
      {
         return this.activeSounds.length > 0;
      }
      
      public function update() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.activeSounds.length)
         {
            this.activeSounds[_loc1_].update();
            _loc1_++;
         }
      }
   }
}
