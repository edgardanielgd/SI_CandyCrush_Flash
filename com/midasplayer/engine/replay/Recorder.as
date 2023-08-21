package com.midasplayer.engine.replay
{
   import com.midasplayer.debug.Debug;
   import com.midasplayer.engine.comm.IGameComm;
   import com.midasplayer.engine.playdata.IPlayData;
   
   public class Recorder implements IRecorder
   {
       
      
      private var _communicator:IGameComm;
      
      private const _playDatas:Vector.<IPlayData> = new Vector.<IPlayData>();
      
      public function Recorder(param1:IGameComm)
      {
         super();
         this._communicator = param1;
      }
      
      public function add(param1:IPlayData) : void
      {
         Debug.assert(param1 != null,"Trying to add a null play data.");
         this._playDatas.push(param1);
         this._communicator.addPlayData(param1.toPlayData() + "\n");
      }
      
      public function toPlayDataXml(param1:int) : String
      {
         var _loc4_:IPlayData = null;
         var _loc2_:* = "<client action=\"gameover\" slotId=\"57788732\" playId=\"0\" request=\"3\" magic=\"813666108\">\n" + "<gameover time=\"2009-05-29 11:40:16\" lastplaydataid=\"" + this._playDatas.length + "\">\n" + "<result><![CDATA[" + param1 + "]]></result>\n";
         var _loc3_:int = 1;
         for each(_loc4_ in this._playDatas)
         {
            _loc2_ += "  <entry id=\"" + _loc3_ + "\" time=\"2009-05-24 01:34:00\"><![CDATA[" + _loc4_.toPlayData() + "]]></entry>\n";
            _loc3_++;
         }
         return _loc2_ + ("</gameover>\n" + "<process total=\"1\" method=\"1\">\n" + "  <p time=\"2009-05-29 11:36:03\" action=\"error\" code=\"107\" pid=\"0\" />\n" + "</process>\n" + "<focus total=\"1\">\n" + "  <switch time=\"2009-05-29 11:36:03\" pid=\"5768\" title=\"King&#x2e;com &#x28;jk&#x2e;dev&#x2e;midasplayer&#x2e;com&#x29; &#x2d; Microsoft Internet Explorer\" process=\"C&#x3a;&#x5c;Program&#x5c;Internet Explorer&#x5c;iexplore&#x2e;exe\" />\n" + "</focus>\n" + "</client>\n");
      }
   }
}
