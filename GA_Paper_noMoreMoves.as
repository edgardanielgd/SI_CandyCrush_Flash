package
{
   import flash.display.MovieClip;
   
   public dynamic class GA_Paper_noMoreMoves extends MovieClip
   {
       
      
      public var sprite:MovieClip;
      
      public function GA_Paper_noMoreMoves()
      {
         super();
         addFrameScript(44,this.frame45);
      }
      
      internal function frame45() : *
      {
         stop();
      }
   }
}
