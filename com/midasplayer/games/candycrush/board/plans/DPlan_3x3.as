package com.midasplayer.games.candycrush.board.plans
{
   import com.midasplayer.games.candycrush.board.Board;
   import com.midasplayer.games.candycrush.board.IDestructionPlan;
   import com.midasplayer.games.candycrush.board.Item;
   import com.midasplayer.games.candycrush.board.ItemFactory;
   
   public class DPlan_3x3 implements IDestructionPlan
   {
       
      
      private var _linePlans:Vector.<com.midasplayer.games.candycrush.board.plans.DPlan_Line>;
      
      private var _columnPlans:Vector.<com.midasplayer.games.candycrush.board.plans.DPlan_Column>;
      
      private var _board:Board;
      
      private var _item:Item;
      
      private var _ticks:int = 0;
      
      private var _done:Boolean = false;
      
      private var _destruction:Item;
      
      private const _id:int = _loc5_ = (_loc4_ = ItemFactory).DPLAN_ID + 1;
      
      public function DPlan_3x3(param1:Board, param2:Item, param3:Item)
      {
         this._linePlans = new Vector.<com.midasplayer.games.candycrush.board.plans.DPlan_Line>();
         this._columnPlans = new Vector.<com.midasplayer.games.candycrush.board.plans.DPlan_Column>();
         _loc4_.DPLAN_ID = _loc5_;
         super();
         this._board = param1;
         this._item = param2;
         this._destruction = param3;
      }
      
      public function setup(param1:int) : void
      {
         var _loc6_:Item = null;
         var _loc9_:IDestructionPlan = null;
         var _loc2_:int = this._board.getRow(this._item.y - 1);
         var _loc3_:int = this._board.getRow(this._item.y + 1);
         var _loc4_:int = this._board.getColumn(this._item.x - 1);
         var _loc5_:int = this._board.getColumn(this._item.x + 1);
         var _loc7_:int = _loc2_;
         while(_loc7_ <= _loc3_)
         {
            if(_loc6_ = this._board.getGridItem(this._item.x,_loc7_))
            {
               (_loc9_ = new com.midasplayer.games.candycrush.board.plans.DPlan_Line(this._board,_loc6_)).setup(param1);
               this._linePlans.push(_loc9_);
            }
            _loc7_++;
         }
         var _loc8_:int = _loc4_;
         while(_loc8_ <= _loc5_)
         {
            if(_loc6_ = this._board.getUnifiedGridItem(_loc8_,this._item.y))
            {
               (_loc9_ = new com.midasplayer.games.candycrush.board.plans.DPlan_Column(this._board,_loc6_)).setup(param1);
               this._columnPlans.push(_loc9_);
            }
            _loc8_++;
         }
      }
      
      public function tick(param1:int) : void
      {
         var _loc2_:com.midasplayer.games.candycrush.board.plans.DPlan_Line = null;
         var _loc3_:com.midasplayer.games.candycrush.board.plans.DPlan_Column = null;
         if(this._ticks < 20)
         {
            for each(_loc2_ in this._linePlans)
            {
               _loc2_.tick(param1);
            }
         }
         else if(this._ticks >= 30 && this._ticks < 50)
         {
            for each(_loc3_ in this._columnPlans)
            {
               _loc3_.tick(param1);
            }
         }
         var _loc4_:*;
         var _loc5_:* = (_loc4_ = this)._ticks + 1;
         _loc4_._ticks = _loc5_;
         this._done = this._ticks > 64;
      }
      
      public function getDestructionItem() : Item
      {
         return this._destruction;
      }
      
      public function getItemsToRemove() : Vector.<Item>
      {
         var _loc3_:Vector.<Item> = null;
         var _loc4_:Vector.<Item> = null;
         var _loc1_:Vector.<Item> = new Vector.<Item>();
         var _loc2_:int = 0;
         while(_loc2_ < this._linePlans.length)
         {
            _loc3_ = this._linePlans[_loc2_].getItemsToRemove();
            _loc1_ = _loc1_.concat(_loc3_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this._columnPlans.length)
         {
            _loc4_ = this._columnPlans[_loc2_].getItemsToRemove();
            _loc1_ = _loc1_.concat(_loc4_);
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function isDone() : Boolean
      {
         return this._done;
      }
      
      public function isImmediate() : Boolean
      {
         return false;
      }
      
      public function scorepopPerItem() : Boolean
      {
         return true;
      }
      
      public function getId() : int
      {
         return this._id;
      }
   }
}
