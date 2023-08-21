package com.midasplayer.games.candycrush.audio
{
   import com.midasplayer.sound.SoundManager;
   
   public class SoundPlayer extends AudioPlayer
   {
       
      
      private var _tick:int = 0;
      
      public function SoundPlayer()
      {
         super(new SoundManager(),432,432);
      }
      
      override protected function _getVolume() : Number
      {
         return SoundVars.SoundVolume;
      }
      
      override protected function _isAudioOn() : Boolean
      {
         return SoundVars.soundOn;
      }
      
      override public function tick(param1:int) : void
      {
      }
   }
}
