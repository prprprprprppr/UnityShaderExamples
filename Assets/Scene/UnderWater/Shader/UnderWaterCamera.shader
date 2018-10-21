Shader "Example/Unlit/UnderWaterCamera"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Frequency("Noise Frequency",float) = 1.0
		_Amplitude("Noise Amplitude",float) = 1.0
		_Speed("Noise Speed",float) = 1.0
		_Scale("Scale",float) = 0.1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		cull off zwrite off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "../../../Shader/noiseSimplex.cginc"
			#include "UnityCG.cginc"
			#define PI 3.1415926

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 scrPos : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Frequency;
			float _Amplitude;
			float _Speed;
			float _Scale;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.scrPos = ComputeScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float noise = (snoise(float3(i.scrPos.xy*_Frequency,_Time.y*_Speed))*0.5 + 0.5)*_Amplitude;
				float2 circle = normalize(float2(sin(noise*2*PI), cos(noise*2*PI)))*_Scale;
				fixed4 col = tex2D(_MainTex,i.scrPos + circle);
				return col;
			}
			ENDCG
		}
	}
}
