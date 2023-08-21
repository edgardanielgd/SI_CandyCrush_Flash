package
{
   import fl.motion.AnimatorFactoryUniversal;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public dynamic class GA_GameOver extends MovieClip
   {
       
      
      public var s_0:MovieClip;
      
      public var s_1:MovieClip;
      
      public var scoreboard:GA_ScoreBoard;
      
      public var s_2:MovieClip;
      
      public var s_3:MovieClip;
      
      public var s_4:MovieClip;
      
      public var s_5:MovieClip;
      
      public var s_6:MovieClip;
      
      public var s_10:MovieClip;
      
      public var s_7:MovieClip;
      
      public var s_11:MovieClip;
      
      public var s_8:MovieClip;
      
      public var s_12:MovieClip;
      
      public var s_9:MovieClip;
      
      public var s_13:MovieClip;
      
      public var s_14:MovieClip;
      
      public var s_15:MovieClip;
      
      public var __animFactory_scoreboardaf1:AnimatorFactoryUniversal;
      
      public var __animArray_scoreboardaf1:Array;
      
      public var __motion_scoreboardaf1:MotionBase;
      
      public function GA_GameOver()
      {
         super();
         if(this.__animFactory_scoreboardaf1 == null)
         {
            this.__animArray_scoreboardaf1 = new Array();
            this.__motion_scoreboardaf1 = new MotionBase();
            this.__motion_scoreboardaf1.duration = 13;
            this.__motion_scoreboardaf1.overrideTargetTransform();
            this.__motion_scoreboardaf1.addPropertyArray("x",[0,55.2216,110.473,165.78,221.078,276.307,331.586,386.897,442.152,497.446,552.723,608,606.501]);
            this.__motion_scoreboardaf1.addPropertyArray("y",[0,-0.817425,-1.63529,-2.45399,-3.27254,-4.09007,-4.90834,-5.72709,-6.54501,-7.36351,-8.18176,-9,-9]);
            this.__motion_scoreboardaf1.addPropertyArray("scaleX",[0.679976,0.721736,0.761468,0.799424,0.835548,0.869665,0.901496,0.930625,0.956432,0.977949,0.993536,1,1]);
            this.__motion_scoreboardaf1.addPropertyArray("scaleY",[0.679976,0.721736,0.761468,0.799424,0.835548,0.869665,0.901496,0.930625,0.956432,0.977949,0.993536,1,1]);
            this.__motion_scoreboardaf1.addPropertyArray("skewX",[0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("skewY",[0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("z",[0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("rotationX",[0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("rotationY",[78,67.8217,58.1379,48.8867,40.0822,31.7667,24.0085,16.9089,10.619,5.37463,1.57551,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("rotationZ",[0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_scoreboardaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_scoreboardaf1.addPropertyArray("alphaMultiplier",[1,1,1,1,1,1,1,1,1,1,1,1,1]);
            this.__motion_scoreboardaf1.motion_internal::transformationPoint = new Point(140,201.45);
            this.__motion_scoreboardaf1.motion_internal::initialPosition = [-435.15,296.25,0];
            this.__motion_scoreboardaf1.is3D = true;
            this.__motion_scoreboardaf1.motion_internal::spanStart = 70;
            this.__animArray_scoreboardaf1.push(this.__motion_scoreboardaf1);
            this.__motion_scoreboardaf1 = new MotionBase();
            this.__motion_scoreboardaf1.duration = 117;
            this.__motion_scoreboardaf1.overrideTargetTransform();
            this.__motion_scoreboardaf1.addPropertyArray("x",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("y",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("scaleX",[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
            this.__motion_scoreboardaf1.addPropertyArray("scaleY",[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
            this.__motion_scoreboardaf1.addPropertyArray("skewX",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("skewY",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("rotationConcat",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_scoreboardaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_scoreboardaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_scoreboardaf1.addPropertyArray("alphaMultiplier",[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
            this.__motion_scoreboardaf1.motion_internal::transformationPoint = new Point(0.490757,0.443722);
            this.__motion_scoreboardaf1.motion_internal::initialMatrix = new Matrix(1,0,0,1,29,86.55);
            this.__motion_scoreboardaf1.motion_internal::spanStart = 83;
            this.__animArray_scoreboardaf1.push(this.__motion_scoreboardaf1);
            this.__animFactory_scoreboardaf1 = new AnimatorFactoryUniversal(null,this.__animArray_scoreboardaf1);
            this.__animFactory_scoreboardaf1.sceneName = "draperi_gameover";
            this.__animFactory_scoreboardaf1.addTargetInfo(this,"scoreboard",0,true,0,true,null,-1);
         }
      }
   }
}
