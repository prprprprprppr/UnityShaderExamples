Shader "Example/Unlit/OutlineWithSobelCameraSampler"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Intensity("Intensity",float) = 1
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

			sampler2D _CameraDepthNormalsTexture;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			float _Intensity;

			v2f vert(appdata_base v)
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

			fixed4 frag(v2f i) : SV_Target
			{ 
				float depth[4];
				float3 normal[4];
				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.uv[1]), depth[0], normal[0]);
				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.uv[2]), depth[1], normal[1]);
				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.uv[3]), depth[2], normal[2]);
				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.uv[4]), depth[3], normal[3]);

				float edge = 1;
				edge *= (abs(depth[0] - depth[3]) < _Intensity) ? 1 : 0;
				edge *= (abs(depth[1] - depth[2]) < _Intensity) ? 1 : 0;
				edge *= (distance(normal[0],normal[3]) < _Intensity) ? 1 : 0;
				edge *= (distance(normal[1],normal[2]) < _Intensity) ? 1 : 0;

				return edge;
			}
			ENDCG
		}
	}
}
