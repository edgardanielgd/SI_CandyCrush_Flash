package com.midasplayer.engine.render
{
   import flash.display.DisplayObject;
   
   public interface IRenderableRoot extends IRenderable
   {
       
      
      function getDisplayObject() : DisplayObject;
   }
}
