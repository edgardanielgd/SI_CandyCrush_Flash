package
{
   import com.midasplayer.debug.DebugLog;
   import com.midasplayer.engine.DebugMain;
   import com.midasplayer.engine.GameMain;
   import com.midasplayer.engine.comm.DebugGameComm;
   import com.midasplayer.engine.comm.GameComm;
   import com.midasplayer.games.candycrush.EngineFactory;
   import com.midasplayer.games.candycrush.ReplayEngineFactory;
   import com.midasplayer.time.AdjustableTimer;
   import com.midasplayer.time.ITimer;
   import com.midasplayer.time.SystemTimer;
   import flash.display.Sprite;
   
   public class Main extends Sprite
   {
      
      private static const _testGameData:String = "<gamedata randomseed=\"123456\" version=\"1\">" + "   <musicOn>false</musicOn>" + "   <soundOn>true</soundOn>" + "   <isShortGame>false</isShortGame>" + "   <booster_1>0</booster_1>" + "   <booster_2>0</booster_2>" + "   <booster_3>0</booster_3>" + "   <booster_4>0</booster_4>" + "   <booster_5>0</booster_5>" + "   <bestScore>100</bestScore>" + "   <bestChain>2</bestChain>" + "   <bestLevel>1</bestLevel>" + "   <bestCrushed>5</bestCrushed>" + "   <bestMixed>2</bestMixed>" + "\t<text id=\"intro.time\">The game begins in {0} Second</text>" + "\t<text id=\"intro.title\">Play as follows:</text>" + "\t<text id=\"intro.info1\">Match 3 Candy of the same colour to crush them. Matching 4 or 5 in different formations generates special sweets that are extra tasty</text>" + "\t<text id=\"intro.info2\">You can also combine the power candy for additional effects by switching them with each other, so if you have time left you may want to save the best sweets for later.Try these combinations for  a taste you will not forget: Extra rad 1.</text>" + "\t<text id=\"game.nomoves\">No more moves!</text>" + "\t<text id=\"outro.opengame\">Please register to play the full game</text>" + "\t<text id=\"outro.title\">Game Over</text>" + "\t<text id=\"outro.now\">now</text>" + "\t<text id=\"outro.bestever\">best ever</text>" + "\t<text id=\"outro.score\">Score</text>" + "\t<text id=\"outro.chain\">Longest chain</text>" + "\t<text id=\"outro.level\">Level reached</text>" + "\t<text id=\"outro.crushed\">Candy crushed</text>" + "\t<text id=\"outro.time\">Game ends in {0} seconds</text>" + "\t<text id=\"outro.trophy.one\">crushed {0} candy in one game</text>" + "\t<text id=\"outro.trophy.two\">scored {0} in one game</text>" + "\t<text id=\"outro.trophy.three\">made {0} combined candy in one game</text>" + "\t<text id=\"outro.combo_wrapper_line\">combo wrapper line description</text>" + "\t<text id=\"outro.combo_color_color\">combo color color description</text>" + "\t<text id=\"outro.combo_color_line\">combo color line description</text>" + "\t<text id=\"outro.combo_color_wrapper\">combo color wrapper description. very long description yes yes.</text>" + "</gamedata>";
      
      public static const Log:DebugLog = new DebugLog(30);
      
      private static var mainSeed:int;
       
      
      private var _bestScore:int;
      
      public function Main()
      {
         var _loc1_:String = null;
         var _loc2_:EngineFactory = null;
         var _loc3_:DebugMain = null;
         var _loc4_:GameMain = null;
         super();
         if(!GameComm.isAvailable())
         {
            mainSeed = 1 + Math.random() * 999999;
            _loc1_ = String(_getTestGameData(mainSeed));
            _loc2_ = new EngineFactory(new DebugGameComm(_loc1_),new AdjustableTimer(new SystemTimer()));
            _loc3_ = new DebugMain(_loc2_,new ReplayEngineFactory(),_loc1_);
            addChild(_loc3_);
         }
         else
         {
            _loc4_ = new GameMain(new EngineFactory(new GameComm(),new SystemTimer()));
            addChild(_loc4_);
         }
      }
      
      public static function canBotBeActive() : Boolean
      {
         return false;
      }
      
      public static function configTimer(param1:ITimer) : void
      {
      }
      
      public static function emitPlayData(param1:int, param2:String) : void
      {
      }
      
      public static function _getTestGameData(param1:int) : String
      {
         return _testGameData.replace("123456",param1.toString());
      }
   }
}
