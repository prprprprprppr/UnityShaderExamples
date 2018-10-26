Shader "Example/Unlit/OutlineWithView"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Color",color) = (1,1,1,1)
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
				float2 uv : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
				float3 normal : TEXCOORD2;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _Intensity;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.viewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.normal = UnityObjectToWorldNormal(v.normal);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float dotvn = saturate(1-dot(i.viewDir,i.normal));
				fixed4 col = tex2D(_MainTex, i.uv);
				col = lerp(col, _Color, smoothstep(0.85, 0.9, pow(dotvn, _Intensity)));
				return col;
			}
			ENDCG
		}
	}
}
