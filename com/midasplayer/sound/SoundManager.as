package com.midasplayer.sound
{
   import flash.utils.*;
   
   public class SoundManager
   {
       
      
      private var managedSoundMap:Object;
      
      private var managedSounds:Array;
      
      private var lastTime:Number = -1;
      
      public var volume:Number = 1;
      
      private var fadeStartTime:Number = -1;
      
      private var fadeEndTime:Number = -1;
      
      private var fadeStartVolume:Number = -1;
      
      private var fadeEndVolume:Number = -1;
      
      public function SoundManager()
      {
         this.managedSoundMap = new Object();
         this.managedSounds = new Array();
         super();
      }
      
      public function get(param1:String) : ManagedSound
      {
         var _loc2_:Class = null;
         if(this.managedSoundMap[param1] == null)
         {
            _loc2_ = getDefinitionByName(param1) as Class;
            if(_loc2_ == null)
            {
               _loc2_ = getDefinitionByName("sound." + param1) as Class;
            }
            if(_loc2_ == null)
            {
               _loc2_ = getDefinitionByName("snd." + param1) as Class;
            }
            if(_loc2_ == null)
            {
               throw new Error("Failed to find sound " + param1);
            }
            this.managedSoundMap[param1] = new ManagedSound(this,_loc2_);
            this.managedSounds.push(this.managedSoundMap[param1]);
         }
         return this.managedSoundMap[param1];
      }
      
      public function getFromClass(param1:Class) : ManagedSound
      {
         var _loc2_:String = String(getQualifiedClassName(param1));
         if(this.managedSoundMap[_loc2_] == null)
         {
            this.managedSoundMap[_loc2_] = new ManagedSound(this,param1);
            this.managedSounds.push(this.managedSoundMap[_loc2_]);
         }
         return this.managedSoundMap[_loc2_];
      }
      
      public function fadeTo(param1:Number, param2:Number) : void
      {
         this.fadeStartVolume = Math.sqrt(this.volume);
         this.fadeEndVolume = Math.sqrt(param1);
         this.fadeStartTime = getTimer();
         this.fadeEndTime = getTimer() + param2;
      }
      
      public function setVolume(param1:Number) : void
      {
         this.volume = param1;
         this.fadeStartTime = -1;
      }
      
      public function stopAll() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.managedSounds.length)
         {
            this.managedSounds[_loc1_].stop();
            _loc1_++;
         }
      }
      
      public function update() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = Number(getTimer());
         if(this.lastTime < 0)
         {
            this.lastTime = _loc1_;
         }
         if(this.fadeStartTime >= 0)
         {
            _loc3_ = (getTimer() - this.fadeStartTime) / (this.fadeEndTime - this.fadeStartTime);
            if(_loc3_ < 0)
            {
               _loc3_ = 0;
            }
            if(_loc3_ > 1)
            {
               _loc3_ = 1;
            }
            this.volume = this.fadeStartVolume + (this.fadeEndVolume - this.fadeStartVolume) * _loc3_;
            this.volume = this.volume * this.volume;
            if(_loc3_ == 1)
            {
               this.fadeStartTime = -1;
            }
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.managedSounds.length)
         {
            this.managedSounds[_loc2_].update();
            _loc2_++;
         }
      }
   }
}
