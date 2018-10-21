Shader "Hidden/EraseTrace"
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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _FlakeAmount;
			float _FlakeOpacity;
			
			float rand(float3 co) {
				return frac(sin(dot(co, float3(12.9898, 78.233, 45.5432)))*43.3124);
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
				float noise = floor(rand(float3(i.uv,0)*_Time.x) + _FlakeAmount);
				fixed4 col = tex2D(_MainTex, i.uv);
				return max(0,col - noise * _FlakeOpacity);
			}
			ENDCG
		}
	}
}
