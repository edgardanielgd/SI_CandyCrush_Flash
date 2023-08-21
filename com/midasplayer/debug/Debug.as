package com.midasplayer.debug
{
   public class Debug
   {
      
      private static var s_assertHandler:com.midasplayer.debug.IAssertHandler = null;
       
      
      public function Debug()
      {
         super();
      }
      
      public static function assert(param1:Boolean, param2:String = null) : void
      {
         var condition:Boolean = param1;
         var message:String = param2;
         if(condition)
         {
            return;
         }
         if(s_assertHandler != null)
         {
            s_assertHandler.assert(message);
            return;
         }
         try
         {
            throw new Error("StackTrace");
         }
         catch(e:Error)
         {
            if(message != null)
            {
            }
            return;
         }
      }
      
      public static function setAssertHandler(param1:com.midasplayer.debug.IAssertHandler) : void
      {
         s_assertHandler = param1;
      }
   }
}
