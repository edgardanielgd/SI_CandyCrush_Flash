package com.midasplayer.engine.playdata
{
   import com.midasplayer.debug.Debug;
   
   public class PlayDataParser
   {
       
      
      private const _entries:Vector.<com.midasplayer.engine.playdata.IPlayData> = new Vector.<com.midasplayer.engine.playdata.IPlayData>();
      
      public function PlayDataParser(param1:String, param2:IPlayDataFactory)
      {
         var _loc3_:XML = null;
         var _loc4_:XMLList = null;
         var _loc6_:String = null;
         super();
         Debug.assert(param2 != null,"The play data factory is null.");
         Debug.assert(param1 != null,"The play data is null.");
         _loc3_ = new XML(param1);
         Debug.assert(_loc3_.length() == 1,"The play data XML should only have 1 root child.");
         _loc4_ = _loc3_.child("gameover");
         Debug.assert(_loc4_.length() == 1,"Expected exactly one game over element in playdata.");
         var _loc5_:XMLList = _loc4_.child("entry");
         for each(_loc6_ in _loc5_)
         {
            this._entries.push(param2.create(_loc6_));
         }
      }
      
      public function getEntries() : Vector.<com.midasplayer.engine.playdata.IPlayData>
      {
         return this._entries;
      }
   }
}
