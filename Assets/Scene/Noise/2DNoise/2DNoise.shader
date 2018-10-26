Shader "Example/Unlit/2DNoise"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			#include "../../Shader/ValueNoise.cginc"
			#include "../../Shader/PerlinNoise.cginc"
			#include "../../Shader/SimplexNoise.cginc"

			#define FBM(uv,FBM_FUNC)\
					{\
						noise = 0.5 * FBM_FUNC(1 * uv);\
						noise += 0.25 * FBM_FUNC(2.1 * uv);\
						noise += 0.125 * FBM_FUNC(4.2 * uv);\
						noise += 0.0625 * FBM_FUNC(8.3 * uv);\
					}\
 
			struct v2f 
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			}; 

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;

			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float num = lerp(20,50,(sin(_Time.x)*0.5+0.5));
				float2 uv = i.uv * float2(1,_MainTex_TexelSize.x / _MainTex_TexelSize.y) * num;
				 
				float noise = 0;
				if(i.uv.x < 1 / 3.0){
					if (i.uv.y < 0.5) 
						noise = VNoise(uv);
					else
						FBM(uv, VNoise);  

				}
				else if(i.uv.x < 2 / 3.0){
					if (i.uv.y < 0.5)
						noise = PNoise(uv);
					else
						FBM(uv, PNoise);
				}
				else {
					if (i.uv.y < 0.5)
						noise = SNoise(uv);
					else
						FBM(uv, SNoise);
				}

				return float4(noise.xxx,1) ;
			}
			ENDCG
		}
	}
}
