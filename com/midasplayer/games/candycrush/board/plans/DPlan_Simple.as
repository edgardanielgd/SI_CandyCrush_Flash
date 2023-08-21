package com.midasplayer.games.candycrush.board.plans
{
   import com.midasplayer.games.candycrush.board.IDestructionPlan;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.board.ItemFactory;
   
   public class DPlan_Simple implements IDestructionPlan
   {
       
      
      private var _item:Item;
      
      private const _id:int = _loc3_ = (_loc2_ = ItemFactory).DPLAN_ID + 1;
      
      public function DPlan_Simple(param1:Item)
      {
         _loc2_.DPLAN_ID = _loc3_;
         super();
         this._item = param1;
      }
      
      public function setup(param1:int) : void
      {
      }
      
      public function tick(param1:int) : void
      {
      }
      
      public function getDestructionItem() : Item
      {
         return this._item;
      }
      
      public function getItemsToRemove() : Vector.<Item>
      {
         return null;
      }
      
      public function isDone() : Boolean
      {
         return true;
      }
      
      public function isImmediate() : Boolean
      {
         return false;
      }
      
      public function scorepopPerItem() : Boolean
      {
         return false;
      }
      
      public function getId() : int
      {
         return this._id;
      }
   }
}
