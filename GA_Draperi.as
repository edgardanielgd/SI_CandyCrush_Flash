package
{
   import fl.motion.AnimatorFactory3D;
   import fl.motion.MotionBase;
   import fl.motion.motion_internal;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public dynamic class GA_Draperi extends MovieClip
   {
       
      
      public var s_0:MovieClip;
      
      public var s_1:MovieClip;
      
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
      
      public var intro:GA_Intro;
      
      public var s_13:MovieClip;
      
      public var s_14:MovieClip;
      
      public var s_15:MovieClip;
      
      public var __animFactory_introaf1:AnimatorFactory3D;
      
      public var __animArray_introaf1:Array;
      
      public var __motion_introaf1:MotionBase;
      
      public function GA_Draperi()
      {
         super();
         if(this.__animFactory_introaf1 == null)
         {
            this.__animArray_introaf1 = new Array();
            this.__motion_introaf1 = new MotionBase();
            this.__motion_introaf1.duration = 26;
            this.__motion_introaf1.overrideTargetTransform();
            this.__motion_introaf1.addPropertyArray("x",[0,-31.7273,-63.4545,-95.1501,-126.909,-158.636,-190.332,-222.059,-253.818,-285.545,-317.273,-349,-349,-349,-349,-349,-349,-349,-349,-349,-349,-349,-349,-349,-349,-349]);
            this.__motion_introaf1.addPropertyArray("y",[0,12.1818,24.3636,36.5333,48.7273,60.9091,73.0787,85.2605,97.4545,109.636,121.818,134,134,134,134,134,142.37,175.826,237.248,298.669,360.091,421.513,482.935,544.356,605.717,667.2]);
            this.__motion_introaf1.addPropertyArray("scaleX",[0.099991,0.18181,0.263629,0.345448,0.427267,0.509086,0.590905,0.672724,0.754543,0.836362,0.918181,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
            this.__motion_introaf1.addPropertyArray("scaleY",[0.099991,0.18181,0.263629,0.345448,0.427267,0.509086,0.590905,0.672724,0.754543,0.836362,0.918181,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
            this.__motion_introaf1.addPropertyArray("skewX",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_introaf1.addPropertyArray("skewY",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_introaf1.addPropertyArray("z",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_introaf1.addPropertyArray("rotationX",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_introaf1.addPropertyArray("rotationY",[78,76.2237,74.4473,72.671,70.8947,69.1183,67.342,53.8736,40.4052,26.9368,13.4684,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_introaf1.addPropertyArray("rotationZ",[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
            this.__motion_introaf1.addPropertyArray("blendMode",["normal"]);
            this.__motion_introaf1.addPropertyArray("cacheAsBitmap",[false]);
            this.__motion_introaf1.addPropertyArray("alphaMultiplier",[0.3,0.373333,0.446667,0.52,0.593333,0.666667,0.74,0.792,0.844,0.896,0.948,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
            this.__motion_introaf1.motion_internal::transformationPoint = new Point(140,201.5);
            this.__motion_introaf1.motion_internal::initialPosition = [344.85,156.25,0];
            this.__motion_introaf1.is3D = true;
            this.__motion_introaf1.motion_internal::spanStart = 42;
            this.__animArray_introaf1.push(this.__motion_introaf1);
            this.__animFactory_introaf1 = new AnimatorFactory3D(null,this.__animArray_introaf1);
            this.__animFactory_introaf1.sceneName = "draperi";
            this.__animFactory_introaf1.addTargetInfo(this,"intro",0,true,0,true,null,-1);
         }
      }
   }
}
