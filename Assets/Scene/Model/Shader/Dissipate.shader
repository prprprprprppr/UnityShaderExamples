Shader "Example/Unlit/Dissipate"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Acceleration("Acceleration",float) = 0.1
		_Intensity("Intensity",range(0,1)) = 0.5
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
			#pragma geometry geom
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct v2g
			{
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 vertex : POSITION;
			};

			struct g2f 
			{
				float4 vertex : SV_POSITION;
			};


			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Acceleration;
			float _Intensity;
			//float _StartTime;

			v2g vert (appdata_base v)
			{
				v2g o;
				o.vertex = v.vertex;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.normal = v.normal;
				return o;
			}
			
			[maxvertexcount(3)]
			void geom(triangle v2g IN[3], inout PointStream<g2f> pstream)
			{
				g2f o;
				float3 edgeA = IN[1].vertex - IN[0].vertex;
				float3 edgeB = IN[2].vertex - IN[0].vertex;
				float3 FaceNormal = normalize(cross(edgeA, edgeB));

				float3 centerPos = (IN[0].vertex + IN[1].vertex + IN[2].vertex)/3;

				//float realTime = _Time.y - _StartTime;

				for (int i = 0;i < 3;i++) 
				{
					//float3 tempPos = IN[i].vertex + FaceNormal * ( 2 * _Acceleration * pow(realTime, 2));
					float3 tempPos = IN[i].vertex + FaceNormal * _Intensity * 10;
					o.vertex = UnityObjectToClipPos(tempPos);

					pstream.Append(o);
				}

			}


			fixed4 frag (g2f i) : SV_Target
			{
				fixed4 col = fixed4(1,1,1,1);
				return col;
			}
			ENDCG
		}
	}
}
