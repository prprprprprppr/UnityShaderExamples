# UnityShaderExamples

拙劣的shader效果

1.温斯顿的盾😅(Cover)

Makin' Stuff Look Good里面的教程

本质上只是depth的应用加上动态纹理的效果.

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/Cover.png)

2.Camera效果(GlobalSnow)

深度值还原为世界坐标,使用xz对雪纹理采样(待优化)

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/GlobalSnow.jpg)

3.模型效果(Model)

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/Model.png)

4.一些高度纹理的效果(NormalMapHeightMap)

SimpleHeight-直接偏移uv采样(视角较平时失真严重)

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/SimpleHeight.png)

ParallaxHeight-从上至下分层采样

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/ParallaxHeight.jpg)

ParallaxHeight2-一个优化,分层采样结束后,取线性平均

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/ParallaxHeight2.jpg)

ParallaxHeight3-一个优化,分层采样结束后,再二分采样

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/ParallaxHeight3.jpg)

ParallaxHeightwithShadow-加阴影

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/ParallaxHeightwithShadow.jpg)

ParallaxHeightwithShadow2-加阴影的优化

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/ParallaxHeightwithShadow2.jpg)

5.外边框(Outline)

commandbuffer+高斯模糊

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/Outline.gif)

6.鼠标指向+shader(RaycastLight)

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/SimpleMouseRay.gif)

7.地图扫描(Scan)

两种深度值转化为世界坐标的方法

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/Scan.gif)

8.雪地(Snow)

Tessellation SurfaceShader的使用

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/Snow.gif)

9.海底(UnderWater)

简单深度雾效+simplexNoise

![image](https://github.com/prprprprprppr/UnityShaderExamples/raw/master/pic/UnderWater.gif)

