Shader "Example/Unlit/MixColor"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_UpColor("up color",color)=(1,1,1,1)
		_DownColor("down color",color) = (1,1,1,1)
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
			float4 _UpColor;
			float4 _DownColor;
			float3 _ModelTop;
			float3 _ModelBottom;

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float3 worldNor : TEXCOORD2;
				float height : TEXCOORD3;
				float4 vertex : SV_POSITION;
			};
			
			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNor = UnityObjectToWorldNormal(v.normal);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				float4 top = UnityWorldToClipPos(_ModelTop);
				float4 bottom = UnityWorldToClipPos(_ModelBottom);
				o.height = smoothstep(bottom.y / bottom.w, top.y / top.w, o.vertex.y / o.vertex.w);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				float diff = dot(lightDir, i.worldNor) * 0.5 + 0.5;
				float spec = pow(saturate(dot(i.worldNor, normalize(lightDir + viewDir))),10);

				float3 col = lerp(_DownColor, _UpColor, i.height);

				col = _LightColor0 * (diff * col + spec);
				return float4(col, 1);
			}
			ENDCG
		}
	}
}
