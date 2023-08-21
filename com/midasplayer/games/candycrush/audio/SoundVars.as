package com.midasplayer.games.candycrush.audio
{
   public class SoundVars
   {
      
      public static const SoundVolume:Number = 0.6;
      
      public static const MusicVolume:Number = 0.4;
      
      public static const sound:com.midasplayer.games.candycrush.audio.SoundPlayer = new com.midasplayer.games.candycrush.audio.SoundPlayer();
      
      public static const music:com.midasplayer.games.candycrush.audio.MusicPlayer = new com.midasplayer.games.candycrush.audio.MusicPlayer();
      
      private static var _musicOn:Boolean = true;
      
      private static var _soundOn:Boolean = true;
       
      
      public function SoundVars()
      {
         super();
      }
      
      public static function get soundOn() : Boolean
      {
         return _soundOn;
      }
      
      public static function set soundOn(param1:Boolean) : void
      {
         _soundOn = param1;
         sound.manager.setVolume(_soundOn ? 1 : 0);
      }
      
      public static function get musicOn() : Boolean
      {
         return _musicOn;
      }
      
      public static function set musicOn(param1:Boolean) : void
      {
         _musicOn = param1;
         music.manager.setVolume(_musicOn ? 1 : 0);
      }
      
      public static function update() : void
      {
         sound.manager.update();
         music.manager.update();
      }
   }
}
