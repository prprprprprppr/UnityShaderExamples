Shader "Example/Unlit/VoronoiNoise"
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

			#include "../../../Shader/Hash.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;

			float VoronoiNoise(float2 p) 
			{
				float2 i = floor(p);
				float2 f = frac(p);
				float m_dist = 2;
				for (int x = -1;x <= 1;x++) {
					for (int y = -1;y <= 1;y++) {
						float2 g = float2(x, y);
						float2 o = hash22(i + g)*0.5+0.5;
						o = 0.5 + 0.5 * sin(_Time.y + 6.2831 * o);
						float2 r = g + o - f;
						float dist = length(r);
						m_dist = min(dist, m_dist);
					}
				}
				return m_dist;
			}
			
			float3 VoronoiNoise2(float2 p)
			{
				float2 i = floor(p);
				float2 f = frac(p);
				float3 ret = 1;
				float m_dist = 2;
				for (int x = -1;x <= 1;x++) {
					for (int y = -1;y <= 1;y++) {
						float2 g = float2(x, y);
						float2 o = hash22(i + g);
						o = 0.5 + 0.5 * sin(_Time.y + 6.2831 * o);
						float2 r = g + o;
						float dist = distance(r,f);
						if (m_dist > dist) {
							m_dist = dist;
							ret = float3(dist,o);
						}
					}
				}
				return ret;
			}

			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				int num = 10;
				float2 uv = i.uv * float2(1,_MainTex_TexelSize.x / _MainTex_TexelSize.y) * num;
				fixed3 col = 0;
				if(i.uv.x < 0.5)
					col = VoronoiNoise(uv);
				else {
					float3 CellNoise = VoronoiNoise2(uv);
					col.y = CellNoise.z*(1-CellNoise.x);
					col *= smoothstep(0.09, 0.1, CellNoise.x);
				}
				return fixed4(col,1);
			}
			ENDCG
		}
	}
}
