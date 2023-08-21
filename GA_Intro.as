package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class GA_Intro extends MovieClip
   {
       
      
      public var title1:MovieClip;
      
      public var info1:MovieClip;
      
      public var info2:MovieClip;
      
      public var time:TextField;
      
      public function GA_Intro()
      {
         super();
         addFrameScript(0,this.frame1,67,this.frame68);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame68() : *
      {
         stop();
      }
   }
}
