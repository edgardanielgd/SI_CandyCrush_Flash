package com.midasplayer.games.candycrush
{
   import com.midasplayer.games.candycrush.board.match.Match;
   
   public class ScoreHolder
   {
       
      
      private var _levelScore:int = 0;
      
      private var _totalScore:int = 0;
      
      private var _latestAdded:int = 0;
      
      private var _level:int = 0;
      
      private var _sequenceLength:int = 1;
      
      private var _longestSequence:int = 0;
      
      private var _powerupsSequence:int = 0;
      
      private var _powerupsMixed:int = 0;
      
      private var _removedItemsLevel:int = 0;
      
      private var _removedItemsTotal:int = 0;
      
      private var _powerupsBlasted:int = 0;
      
      private var _mixedWrapWithLineOrColumn:int = 0;
      
      private var _mixedColorWithColor:int = 0;
      
      private var _mixedColorWithLineOrColumn:int = 0;
      
      private var _mixedColorWithWrapper:int = 0;
      
      public function ScoreHolder()
      {
         super();
      }
      
      public static function getLevelItemLimit(param1:int) : int
      {
         var _loc2_:int = 100;
         while(--param1 >= 0)
         {
            _loc2_ += _loc2_;
         }
         return _loc2_ > 400 ? 400 : _loc2_;
      }
      
      public static function imax(param1:int, param2:int) : int
      {
         return param1 > param2 ? param1 : param2;
      }
      
      public function setLevel(param1:int, param2:Boolean) : void
      {
         this._level = param1;
         if(param2)
         {
            this.resetLevel();
         }
      }
      
      public function getLevel() : int
      {
         return this._level;
      }
      
      public function getTotalScore() : int
      {
         return this._totalScore;
      }
      
      public function getLevelScore() : int
      {
         return this._levelScore;
      }
      
      public function resetSequences() : void
      {
         this._sequenceLength = 0;
         this._powerupsSequence = 0;
      }
      
      public function getSequenceLength() : int
      {
         return this._sequenceLength;
      }
      
      public function getLongestSequence() : int
      {
         return this._longestSequence;
      }
      
      public function getMixedWrapWithLineOrColumn() : int
      {
         return this._mixedWrapWithLineOrColumn;
      }
      
      public function getMixedColorWithColor() : int
      {
         return this._mixedColorWithColor;
      }
      
      public function getMixedColorWithLineOrColumn() : int
      {
         return this._mixedColorWithLineOrColumn;
      }
      
      public function getMixedColorWithWrapper() : int
      {
         return this._mixedColorWithWrapper;
      }
      
      public function getFeedbackSequenceLength() : int
      {
         return this.getSequenceLength() + this._powerupsSequence;
      }
      
      public function removedByPowerup(param1:int) : void
      {
         this.addScore(3 * param1 * (20 + this.getLevelAddon()),false);
         this.removeItems(param1);
      }
      
      public function powerupExploded(param1:int, param2:Boolean) : void
      {
         var _loc3_:Boolean = param2 && (param1 == ItemType.COLUMN || param1 == ItemType.LINE);
         if(!_loc3_)
         {
            var _loc4_:*;
            var _loc5_:* = (_loc4_ = this)._powerupsSequence + 1;
            _loc4_._powerupsSequence = _loc5_;
            _loc5_ = (_loc4_ = this)._powerupsBlasted + 1;
            _loc4_._powerupsBlasted = _loc5_;
         }
         this.removeItems(1);
      }
      
      public function powerupsMixed(param1:int, param2:int) : void
      {
         if(Boolean(param1 & ItemType.COLOR) && Boolean(param2 & ItemType.COLOR))
         {
            var _loc3_:*;
            var _loc4_:* = (_loc3_ = this)._mixedColorWithColor + 1;
            _loc3_._mixedColorWithColor = _loc4_;
         }
         else if(Boolean(param1 & ItemType.COLOR) && (Boolean(param2 & ItemType.COLUMN) || Boolean(param2 & ItemType.LINE)))
         {
            _loc4_ = (_loc3_ = this)._mixedColorWithLineOrColumn + 1;
            _loc3_._mixedColorWithLineOrColumn = _loc4_;
         }
         else if(Boolean(param2 & ItemType.COLOR) && (Boolean(param1 & ItemType.COLUMN) || Boolean(param1 & ItemType.LINE)))
         {
            _loc4_ = (_loc3_ = this)._mixedColorWithLineOrColumn + 1;
            _loc3_._mixedColorWithLineOrColumn = _loc4_;
         }
         else if(Boolean(param1 & ItemType.COLOR) && Boolean(param2 & ItemType.WRAP))
         {
            _loc4_ = (_loc3_ = this)._mixedColorWithWrapper + 1;
            _loc3_._mixedColorWithWrapper = _loc4_;
         }
         else if(Boolean(param2 & ItemType.COLOR) && Boolean(param1 & ItemType.WRAP))
         {
            _loc4_ = (_loc3_ = this)._mixedColorWithWrapper + 1;
            _loc3_._mixedColorWithWrapper = _loc4_;
         }
         else if(Boolean(param1 & ItemType.WRAP) && (Boolean(param2 & ItemType.COLUMN) || Boolean(param2 & ItemType.LINE)))
         {
            _loc4_ = (_loc3_ = this)._mixedWrapWithLineOrColumn + 1;
            _loc3_._mixedWrapWithLineOrColumn = _loc4_;
         }
         else if(Boolean(param2 & ItemType.WRAP) && (Boolean(param1 & ItemType.COLUMN) || Boolean(param1 & ItemType.LINE)))
         {
            _loc4_ = (_loc3_ = this)._mixedWrapWithLineOrColumn + 1;
            _loc3_._mixedWrapWithLineOrColumn = _loc4_;
         }
         if(param1 > 0 && param2 > 0)
         {
            _loc4_ = (_loc3_ = this)._powerupsMixed + 1;
            _loc3_._powerupsMixed = _loc4_;
         }
      }
      
      public function getPowerupsMixedCount() : int
      {
         return this._powerupsMixed;
      }
      
      public function matched(param1:Match) : void
      {
         if(param1.size == 3)
         {
            this.addScore(3 * (20 + this.getLevelAddon()),true);
         }
         if(param1.size == 4)
         {
            this.addScore(4 * (30 + this.getLevelAddon()),true);
         }
         if(param1.size >= 5)
         {
            this.addScore(param1.size * (40 + this.getLevelAddon()),true);
         }
         var _loc2_:*;
         var _loc3_:* = (_loc2_ = this)._sequenceLength + 1;
         _loc2_._sequenceLength = _loc3_;
         if(this._sequenceLength > this._longestSequence)
         {
            this._longestSequence = this._sequenceLength;
         }
         this.removeItems(param1.size);
      }
      
      private function getLevelAddon() : int
      {
         return this._level * 10;
      }
      
      private function addScore(param1:int, param2:Boolean) : void
      {
         if(param2)
         {
            param1 *= 1 + this._sequenceLength;
         }
         this._latestAdded = param1;
         this._levelScore = this._levelScore + param1;
         this._totalScore = this._totalScore + param1;
      }
      
      private function removeItems(param1:int) : void
      {
         this._removedItemsLevel = this._removedItemsLevel + param1;
         this._removedItemsTotal = this._removedItemsTotal + param1;
      }
      
      public function getLevelRemoveItemCount() : int
      {
         return this._removedItemsLevel;
      }
      
      public function getTotalRemoveItemCount() : int
      {
         return this._removedItemsTotal;
      }
      
      public function getPowerupsBlastedCount() : int
      {
         return this._powerupsBlasted;
      }
      
      public function getLastAddedScore() : int
      {
         return this._latestAdded;
      }
      
      private function resetLevel() : void
      {
         this._levelScore = 0;
         this._latestAdded = 0;
         this._removedItemsLevel = 0;
         this.resetSequences();
      }
   }
}
