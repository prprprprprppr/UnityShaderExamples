Shader "Example/Unlit/Shine"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_ShineColor("Shine Color",color) = (1,1,1,1)
		_ShineRange("Shine Range",float) = 0.5
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
			float4 _ShineColor;
			float _ShineRange;

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
				float spec = pow(saturate(dot(i.worldNor, normalize(lightDir + viewDir))),10);

				float shine = pow(saturate(1 - dot(i.worldNor, viewDir)), _ShineRange);

				float3 col = tex2D(_MainTex, i.uv);
				col = _LightColor0 * (diff * col + spec);
				col = lerp(col, _ShineColor, shine);
				return float4(col, 1);
			}
			ENDCG
		}
	}
}
