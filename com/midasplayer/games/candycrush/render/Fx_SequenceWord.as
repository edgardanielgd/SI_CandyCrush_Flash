package com.midasplayer.games.candycrush.render
{
   import com.midasplayer.animation.tweenick.TTEasing;
   import com.midasplayer.animation.tweenick.TTGroup;
   import com.midasplayer.animation.tweenick.TTItem;
   import com.midasplayer.animation.tweenick.TickTween;
   import flash.display.BitmapData;
   
   public class Fx_SequenceWord extends TickedSprite
   {
      
      public static const LEVEL_LASTBLAST:int = -99;
      
      private static const Words1:BitmapData = new GA_Words_1();
      
      private static const Words2:BitmapData = new GA_Words_2();
      
      private static const Words3:BitmapData = new GA_Words_3();
      
      private static const Words4:BitmapData = new GA_Words_4();
       
      
      private var _word:com.midasplayer.games.candycrush.render.BitmapSprite;
      
      private var _isLastBlast:Boolean;
      
      public function Fx_SequenceWord(param1:BitmapData, param2:int, param3:TickTween, param4:int)
      {
         super(param1,param2);
         this._isLastBlast = param4 == LEVEL_LASTBLAST;
         var _loc5_:BitmapData = this._isLastBlast ? new GA_Words_LastBlast() : getWordData(param4);
         this._word = new com.midasplayer.games.candycrush.render.BitmapSprite(_loc5_,1,1);
         this._word.scaleX = this._word.scaleY = this._word.alpha = 0;
         this._word.smoothing = true;
         var _loc6_:Number = 1.8;
         var _loc7_:TTGroup = new TTGroup();
         if(this._isLastBlast)
         {
            _loc6_ = 1.7;
            _loc7_.add(new TTItem(this._word,5 * _loc6_,"alpha",1));
            _loc7_.add(new TTItem(this._word,5 * _loc6_,"scaleX",0.6));
            _loc7_.add(new TTItem(this._word,5 * _loc6_,"scaleY",0.6));
            _loc7_.addInTicks(5 * _loc6_,new TTItem(this._word,15 * _loc6_,"scaleX",1.1,{"start":0.6}));
            _loc7_.addInTicks(5 * _loc6_,new TTItem(this._word,15 * _loc6_,"scaleY",1.1,{"start":0.6}));
            _loc7_.addInTicks(16 * _loc6_,new TTItem(this._word,4 * _loc6_,"alpha",0,{"start":1}));
         }
         else
         {
            _loc7_.add(new TTItem(this._word,3 * _loc6_,"alpha",1));
            _loc7_.add(new TTItem(this._word,8 * _loc6_,"scaleX",1,{"easing":TTEasing.QuadraticOut}));
            _loc7_.add(new TTItem(this._word,8 * _loc6_,"scaleY",1,{"easing":TTEasing.QuadraticOut}));
            _loc7_.addInTicks(9 * _loc6_,new TTItem(this._word,6 * _loc6_,"alpha",0,{"start":1}));
         }
         param3.addGroup(_loc7_);
      }
      
      private static function getWordData(param1:int) : BitmapData
      {
         return [Words1,Words2,Words3,Words4][param1];
      }
      
      override protected function renderFront(param1:int, param2:Number) : void
      {
         var _loc3_:Number = NaN;
         _loc3_ = param1 + param2;
         var _loc4_:Number = _loc3_ - firstTick;
         var _loc5_:Number = 36;
         var _loc6_:int = this._isLastBlast ? 320 : 200;
         this._word.render2(param1,420,_loc6_ - (this._isLastBlast ? 2.5 : 2) * _loc4_,canvas,com.midasplayer.games.candycrush.render.BitmapSprite.ALIGN_CENTER,com.midasplayer.games.candycrush.render.BitmapSprite.VALIGN_MIDDLE);
         if(_loc4_ >= _loc5_)
         {
            done = true;
         }
      }
   }
}
