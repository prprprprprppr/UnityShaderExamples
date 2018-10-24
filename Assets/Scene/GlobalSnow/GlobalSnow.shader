Shader "Example/Unlit/GlobalSnow"
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

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			float _SnowScale;
			sampler2D _CameraDepthNormalsTexture;
			sampler2D _SnowTex;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4x4 _cammatrix;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);

				o.vertex = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float depth;
				float3 normal;
				DecodeDepthNormal(tex2D(_CameraDepthNormalsTexture, i.uv), depth, normal);
				normal = mul(_cammatrix, normal);
				float3 worldPos = float3((i.uv * 2 - 1) / float2(unity_CameraProjection._11, unity_CameraProjection._22), -1) * depth * _ProjectionParams.z;
				worldPos = mul(_cammatrix, float4(worldPos, 1));
				fixed4 snowcol = tex2D(_SnowTex, worldPos.xz*_SnowScale);
				fixed4 col = tex2D(_MainTex, i.uv);

				return lerp(col,snowcol,smoothstep(0.5,1,normal.y));
			}
			ENDCG
		}
	}
}
