Shader "Example/Unlit/Dissolve"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_NoiseTex("Noise",2D) = "white"{}
		_Color("Color",color) = (1,1,1,1)
		_Intensity("Intensity",range(0,1)) = 0.5
		_Breadth("Breadth",range(0,0.1)) = 0.01
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		
		cull off 

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NoiseTex;
			float _Intensity;
			float _Breadth;
			float4 _Color;

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
				float noise = tex2D(_NoiseTex,i.uv);
				clip(noise - _Intensity);
				float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				float diff = dot(lightDir, i.worldNor) * 0.5 + 0.5;
				float spec = pow(saturate(dot(i.worldNor, normalize(lightDir + viewDir))),10);

				float3 col = tex2D(_MainTex,i.uv);
				if (noise - _Intensity < _Breadth)
					col = _Color;
				col = _LightColor0 * (diff * col + spec);
				return float4(col, 1);
			}
			ENDCG
		}
	}
}
