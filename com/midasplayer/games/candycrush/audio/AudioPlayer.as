package com.midasplayer.games.candycrush.audio
{
   import com.midasplayer.sound.ManagedSoundChannel;
   import com.midasplayer.sound.SoundManager;
   import flash.utils.setTimeout;
   
   public class AudioPlayer
   {
      
      public static const PAN_CENTER:Number = -999999;
       
      
      public var manager:SoundManager;
      
      private var _invHalfWidth:Number;
      
      private var _center:Number;
      
      public function AudioPlayer(param1:SoundManager, param2:Number, param3:Number)
      {
         super();
         this.manager = param1;
         this._center = param2;
         this._invHalfWidth = 1 / param3;
      }
      
      private static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public function play(param1:Class, param2:Number = 1, param3:Number = -999999, param4:int = 0) : ManagedSoundChannel
      {
         var pan:Number = NaN;
         var klass:Class = param1;
         var volumeMult:Number = param2;
         var panPixel:Number = param3;
         var inMs:int = param4;
         pan = panPixel == PAN_CENTER ? 0 : this.panFromPixel(panPixel);
         if(inMs == 0)
         {
            return this._play(klass,volumeMult,pan);
         }
         setTimeout(function():void
         {
            _play(klass,volumeMult,pan);
         },inMs);
         return null;
      }
      
      protected function panFromPixel(param1:Number) : Number
      {
         return clamp((param1 - this._center) * this._invHalfWidth,-1,1);
      }
      
      protected function _play(param1:Class, param2:Number = 1, param3:Number = 0) : ManagedSoundChannel
      {
         if(this._isAudioOn())
         {
            return this.manager.getFromClass(param1).play(param2 * this._getVolume(),param3);
         }
         return null;
      }
      
      protected function _getVolume() : Number
      {
         return 1;
      }
      
      protected function _isAudioOn() : Boolean
      {
         return true;
      }
      
      public function tick(param1:int) : void
      {
      }
   }
}
