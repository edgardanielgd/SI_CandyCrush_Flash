package com.midasplayer.engine
{
   import com.midasplayer.debug.Debug;
   
   public class GameDataParser
   {
       
      
      private var _seed:int = 0;
      
      private var _gameData:XML;
      
      private var _textElements:XMLList;
      
      public function GameDataParser(param1:String)
      {
         super();
         Debug.assert(param1 != null,"Could not parse the game data, the xml parameter is null.");
         this._gameData = new XML(param1);
         Debug.assert(this._gameData.length() == 1,"The game data XML should only have 1 root child.");
         this._seed = parseInt(this._gameData.attribute("randomseed"));
         Debug.assert(this._seed != 0,"The game data randomseed attribute is 0, this may result in complete randomness.");
         this._textElements = this._gameData.child("text");
      }
      
      public function getRandomSeed() : int
      {
         return this._seed;
      }
      
      public function getText(param1:String) : String
      {
         var texts:XMLList = null;
         var id:String = param1;
         texts = this._textElements.(@id == id);
         Debug.assert(texts.length() == 1,"Could not find the text element (or found more than 1) with attribute id \'" + id + "\' in the game data.");
         return texts.text();
      }
      
      public function getAsString(param1:String) : String
      {
         return this._getOneElement(param1).text();
      }
      
      public function getAsInt(param1:String) : int
      {
         var _loc2_:XMLList = null;
         _loc2_ = this._getOneElement(param1);
         var _loc3_:Number = Number(parseInt(_loc2_.text()));
         Debug.assert(!isNaN(_loc3_),"Could not parse a game data property as int \'" + param1 + "\' value: " + _loc2_.text());
         return int(_loc3_);
      }
      
      public function getAsBool(param1:String) : Boolean
      {
         var _loc2_:String = String(this.getAsString(param1).toLowerCase());
         Debug.assert(_loc2_ == "0" || _loc2_ == "1" || _loc2_ == "false" || _loc2_ == "true","Could not parse a boolean, the value should be \'true\', \'false\', \'0\' or \'1\'. Element: " + param1 + ", value: " + _loc2_);
         return _loc2_ == "true" || _loc2_ == "1";
      }
      
      private function _getOneElement(param1:String) : XMLList
      {
         var _loc2_:XMLList = this._gameData.child(param1);
         Debug.assert(_loc2_.length() == 1,"Could not find the element (or found more than 1) with the name \'" + param1 + "\' in the game data.");
         return _loc2_;
      }
   }
}
