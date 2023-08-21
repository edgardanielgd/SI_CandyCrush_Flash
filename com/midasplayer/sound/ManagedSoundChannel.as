package com.midasplayer.sound
{
   import flash.events.Event;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.getTimer;
   
   public class ManagedSoundChannel
   {
       
      
      private var sound:com.midasplayer.sound.ManagedSound;
      
      private var channel:SoundChannel;
      
      private var manager:com.midasplayer.sound.SoundManager;
      
      private var targetVolume:Number;
      
      private var targetPan:Number;
      
      private var fadeStartTime:Number = -1;
      
      private var fadeEndTime:Number = -1;
      
      private var fadeStartVolume:Number = -1;
      
      private var fadeEndVolume:Number = -1;
      
      private var panStartTime:Number = -1;
      
      private var panEndTime:Number = -1;
      
      private var panStartVolume:Number = -1;
      
      private var panEndVolume:Number = -1;
      
      private var stopAfterFade:Boolean = false;
      
      private var playing:Boolean = true;
      
      public function ManagedSoundChannel(param1:com.midasplayer.sound.SoundManager, param2:com.midasplayer.sound.ManagedSound, param3:SoundChannel)
      {
         super();
         this.manager = param1;
         this.sound = param2;
         this.channel = param3;
         param2.activeSounds.push(this);
         if(param3 == null)
         {
            this.soundComplete(null);
            return;
         }
         param3.addEventListener(Event.SOUND_COMPLETE,this.soundComplete);
         this.targetVolume = param3.soundTransform.volume;
         this.targetPan = param3.soundTransform.pan;
         this.update();
      }
      
      public function soundComplete(param1:Event) : void
      {
         if(!this.playing)
         {
            return;
         }
         this.sound.activeSounds.splice(this.sound.activeSounds.indexOf(this),1);
         this.playing = false;
      }
      
      public function setPan(param1:Number) : void
      {
         if(!this.playing)
         {
            return;
         }
         if(this.channel == null)
         {
            return;
         }
         this.channel.soundTransform.pan = param1;
         this.panStartTime = -1;
         this.update();
      }
      
      public function setVolume(param1:Number) : void
      {
         if(!this.playing)
         {
            return;
         }
         this.stopAfterFade = false;
         this.targetVolume = param1;
         this.fadeStartTime = -1;
         this.update();
      }
      
      public function stop() : void
      {
         if(!this.playing)
         {
            return;
         }
         if(this.channel == null)
         {
            return;
         }
         this.channel.stop();
         this.soundComplete(null);
      }
      
      public function fadeTo(param1:Number, param2:Number) : void
      {
         if(!this.playing)
         {
            return;
         }
         this.fadeStartVolume = Math.sqrt(this.targetVolume);
         this.fadeEndVolume = Math.sqrt(param1);
         this.fadeStartTime = getTimer();
         this.fadeEndTime = getTimer() + param2;
         this.stopAfterFade = false;
      }
      
      public function fadeToAndStop(param1:Number, param2:Number) : void
      {
         if(!this.playing)
         {
            return;
         }
         this.fadeTo(param1,param2);
         this.stopAfterFade = true;
      }
      
      public function panTo(param1:Number, param2:Number) : void
      {
         if(!this.playing)
         {
            return;
         }
         this.panStartVolume = this.targetPan;
         this.panEndVolume = param1;
         this.panStartTime = getTimer();
         this.panEndTime = getTimer() + param2;
      }
      
      public function update() : void
      {
         var _loc1_:Number = NaN;
         if(!this.playing)
         {
            return;
         }
         if(this.fadeStartTime >= 0)
         {
            _loc1_ = (getTimer() - this.fadeStartTime) / (this.fadeEndTime - this.fadeStartTime);
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            if(_loc1_ > 1)
            {
               _loc1_ = 1;
            }
            this.targetVolume = this.fadeStartVolume + (this.fadeEndVolume - this.fadeStartVolume) * _loc1_;
            this.targetVolume = this.targetVolume * this.targetVolume;
            if(_loc1_ == 1)
            {
               this.fadeStartTime = -1;
            }
            if(_loc1_ == 1 && this.stopAfterFade)
            {
               this.stop();
            }
         }
         if(this.panStartTime >= 0)
         {
            _loc1_ = (getTimer() - this.panStartTime) / (this.panEndTime - this.panStartTime);
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            if(_loc1_ > 1)
            {
               _loc1_ = 1;
            }
            this.targetPan = this.panStartVolume + (this.panEndVolume - this.panStartVolume) * _loc1_;
            if(_loc1_ == 1)
            {
               this.panStartTime = -1;
            }
         }
         var _loc2_:Number = this.targetVolume * this.manager.volume;
         var _loc3_:Number = this.targetPan;
         if(this.channel == null)
         {
            return;
         }
         if(_loc2_ != this.channel.soundTransform.volume || _loc3_ != this.channel.soundTransform.pan)
         {
            this.channel.soundTransform = new SoundTransform(_loc2_,_loc3_);
         }
      }
      
      public function isPlaying() : Boolean
      {
         return this.playing;
      }
   }
}
