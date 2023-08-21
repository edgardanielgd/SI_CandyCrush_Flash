package
{
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public dynamic class GA_Anim_CaneIn extends MovieClip
   {
       
      
      public var levelLabel:GA_Ui_Mc_labelNewLevel;
      
      public var __animFactory_levelLabelaf1:AnimatorFactory3D;
      
      public var __animArray_levelLabelaf1:Array;
      
      public var __motion_levelLabelaf1:MotionBase;
      
      public function GA_Anim_CaneIn()
      {
         super();
         if(this.__animFactory_levelLabelaf1 == null)
         {
            this.__animArray_levelLabelaf1 = new Array();
            this.__motion_levelLabelaf1 = new MotionBase();
            this.__motion_levelLabelaf1.duration = 11;
            this.__motion_levelLabelaf1.overrideTargetTransform();
            this.__motion_levelLabelaf1.addPropertyArray("x",[0,17.4167,34.8333,52.25,69.6667,87.0833,104.5]);
            this.__motion_levelLabelaf1.addPropertyArray("y",[0,1.41667,2.83333,4.25,5.66667,7.08333,8.5]);
            this.__motion_levelLabelaf1.addPropertyArray("scaleX",[1]);
            this.__motion_levelLabelaf1.addPropertyArray("scaleY",[1]);
            this.__motion_levelLabelaf1.addPropertyArray("skewX",[0]);
            this.__motion_levelLabelaf1.addPropertyArray("skewY",[0]);
            this.__motion_levelLabelaf1.addPropertyArray("z",[0,0,0,0,0,0,0]);
            this.__motion_levelLabelaf1.addPropertyArray("rotationX",[0]);
            this.__motion_levelLabelaf1.addPropertyArray("rotationY",[0]);
            this.__motion_levelLabelaf1.addPropertyArray("rotationZ",[21,19.1667,17.3333,15.5,13.6667,11.8333,10,3,-4,-2,0]);
            this.__motion_levelLabelaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_levelLabelaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_levelLabelaf1.motion_internal::transformationPoint = new Point(6.6,5.3);
            this.__motion_levelLabelaf1.motion_internal::initialPosition = [-428.6,457.55,0];
            this.__motion_levelLabelaf1.is3D = true;
            this.__motion_levelLabelaf1.motion_internal::spanStart = 0;
            this.__animArray_levelLabelaf1.push(this.__motion_levelLabelaf1);
            this.__animFactory_levelLabelaf1 = new AnimatorFactory3D(null,this.__animArray_levelLabelaf1);
            this.__animFactory_levelLabelaf1.sceneName = "CaneAnim";
            this.__animFactory_levelLabelaf1.addTargetInfo(this,"levelLabel",0,true,0,true,null,-1);
         }
      }
   }
}
