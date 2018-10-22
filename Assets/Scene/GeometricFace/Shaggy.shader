Shader "Example/Unlit/Shaggy"
{
	Properties
	{
		_Color("Color",color) = (1,1,1,1)
		_Length("Length",float) = 0.1
		_Account("Account",range(0,1)) = 0.5
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		cull off


		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag

			#include "UnityCG.cginc"

			float4 _Color;
			float _Length;
			float _Account;

			struct v2g
			{
				float4 vertex : POSITION;
			};

			struct g2f
			{
				float4 col : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			v2g vert (appdata_base v)
			{
				v2g o;
				o.vertex = v.vertex;
				return o;
			}

			[maxvertexcount(12)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> tristream)
			{
				g2f o;
				float3 edgeA = IN[1].vertex - IN[0].vertex;
				float3 edgeB = IN[2].vertex - IN[0].vertex;
				float3 FaceNormal = normalize(cross(edgeA, edgeB));

				float3 centerPos = (IN[0].vertex + IN[1].vertex + IN[2].vertex) / 3;

				o.col = float4(0, 0, 0, 1);
				o.vertex = UnityObjectToClipPos(IN[0].vertex);
				tristream.Append(o);
				o.vertex = UnityObjectToClipPos(IN[1].vertex);
				tristream.Append(o);
				o.vertex = UnityObjectToClipPos(IN[2].vertex);
				tristream.Append(o);
				tristream.RestartStrip();

				for (int i = 0;i < 3;i++) {
					o.col = _Color;
					o.vertex = UnityObjectToClipPos(IN[i].vertex + FaceNormal * _Length);
					tristream.Append(o);
					o.col = float4(0, 0, 0, 1);
					o.vertex = UnityObjectToClipPos(IN[i].vertex);
					tristream.Append(o);
					o.vertex = UnityObjectToClipPos(centerPos);
					tristream.Append(o);
					tristream.RestartStrip();
				}

			}

			
			fixed4 frag (g2f i) : SV_Target
			{
				return pow(i.col,_Account);
			}
			ENDCG
		}
	}
}
