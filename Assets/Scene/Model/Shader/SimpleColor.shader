Shader "Example/Unlit/SimpleColor"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("color",color)=(1,1,1,1)
		_Intensity("Intensity",range(0,1)) = 0.5
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
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _Intensity;

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float3 worldNor : TEXCOORD2;
				float4 vertex : POSITION;
			};
			
			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNor = UnityObjectToWorldNormal(v.normal);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				float diff = dot(lightDir, i.worldNor) * 0.5 + 0.5;
				//float spec = pow(saturate(dot(i.worldNor, normalize(lightDir + viewDir))),10);

				float3 col = lerp(tex2D(_MainTex, i.uv),_Color, _Intensity);

				col = _LightColor0 * (diff * col);
				return float4(col, 1);
			}
			ENDCG
		}
	}
}
