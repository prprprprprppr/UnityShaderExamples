Shader "Example/Unlit/RaycastLight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Strength("Spec Strength",float) = 50
		_Radius("Radius",float) = 0.5
		_WorldPos("WorldPostion",vector) = (0,0,0,0)
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
				float3 worldPos:TEXCOORD1;
				float3 viewDir:TEXCOORD2;
				float3 worldNor:TEXCOORD3;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Strength;
			float _Radius;
			float4 _WorldPos;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.viewDir = normalize(UnityWorldSpaceViewDir(o.worldPos));
				o.worldNor = UnityObjectToWorldNormal(v.normal);
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float diff = saturate(dot(i.worldNor, lightDir)) * 0.5 + 0.5;
				float spec = pow(saturate(dot(i.worldNor, normalize(lightDir + i.viewDir))),_Strength);

				float p = _Radius - distance(_WorldPos, i.worldPos);

				float4 col = float4(1,1,1,1);
				if (p > 0)
					col.r = 0;
				if (p < 0)
					col.r = 1;

				return col*(diff + spec);
			}
			ENDCG
		}
	}
}
