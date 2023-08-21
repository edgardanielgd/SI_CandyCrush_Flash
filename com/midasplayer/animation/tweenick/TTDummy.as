package com.midasplayer.animation.tweenick
{
   public class TTDummy extends TTItem
   {
       
      
      public function TTDummy(param1:int)
      {
         super(new _TTDummyItem(),param1,"dummy",param1);
      }
   }
}

class _TTDummyItem
{
    
   
   public var dummy:Number = 0;
   
   public function _TTDummyItem()
   {
      super();
   }
}
