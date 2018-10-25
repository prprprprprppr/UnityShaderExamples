Shader "Example/Unlit/CameraEffect_EdgeDetection"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Intensity ("Intensity",range(0,0.1)) = 0.05
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

			struct v2f
			{
				float2 uv[5] : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _CameraDepthTexture;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			float _Intensity;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.uv[0] = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.vertex = UnityObjectToClipPos(v.vertex);

				o.uv[1] = o.uv[0] + _MainTex_TexelSize.xy * float2(-1, -1);
				o.uv[2] = o.uv[0] + _MainTex_TexelSize.xy * float2(-1, 1);
				o.uv[3] = o.uv[0] + _MainTex_TexelSize.xy * float2(1, -1);
				o.uv[4] = o.uv[0] + _MainTex_TexelSize.xy * float2(1, 1);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float depthA = Linear01Depth(tex2D(_CameraDepthTexture, i.uv[1]));
				float depthB = Linear01Depth(tex2D(_CameraDepthTexture, i.uv[2]));
				float depthC = Linear01Depth(tex2D(_CameraDepthTexture, i.uv[3]));
				float depthD = Linear01Depth(tex2D(_CameraDepthTexture, i.uv[4]));

				float edge = 1;
				edge *= (abs(depthA - depthD) < _Intensity) ? 1 : 0;
				edge *= (abs(depthB - depthC) < _Intensity) ? 1 : 0;

				return edge;
			}
			ENDCG
		}
	}
}
