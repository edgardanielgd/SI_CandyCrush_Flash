package com.midasplayer.games.candycrush.audio
{
   import com.midasplayer.sound.ManagedSound;
   import com.midasplayer.sound.ManagedSoundChannel;
   import com.midasplayer.sound.SoundManager;
   
   public class MusicPlayer extends AudioPlayer
   {
       
      
      private var _currentMusic:ManagedSound = null;
      
      private var _currentChannel:ManagedSoundChannel = null;
      
      public function MusicPlayer()
      {
         super(new SoundManager(),1,1);
      }
      
      override protected function _play(param1:Class, param2:Number = 1, param3:Number = -999999) : ManagedSoundChannel
      {
         this._currentMusic = manager.getFromClass(param1);
         this._currentChannel = this._currentMusic.play(param2 * this._getVolume());
         return this._currentChannel;
      }
      
      override protected function _getVolume() : Number
      {
         return SoundVars.MusicVolume;
      }
      
      public function fadeCurrentMusic(param1:Number, param2:int, param3:Boolean) : void
      {
         if(!this._currentMusic)
         {
            return;
         }
         if(param3)
         {
            this._currentMusic.fadeToAndStop(param1 * this._getVolume(),param2);
         }
         else
         {
            this._currentMusic.fadeTo(param1 * this._getVolume(),param2);
         }
      }
      
      public function setCurrentMusic(param1:ManagedSound) : void
      {
         this._currentMusic = param1;
      }
   }
}
