Shader "Example/Unlit/GeometricFace"
{
	Properties
	{

	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma geometry geom
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct v2g
			{
				float4 vertex : POSITION;
			};

			struct g2f
			{
				float3 normal : NORMAL;
				float3 worldPos : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};
			
			v2g vert (appdata_base v)
			{
				v2g o;
				o.vertex = v.vertex;
				return o;
			}

			[maxvertexcount(3)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> tristream)
			{
				g2f o;
				float3 edgeA = IN[1].vertex - IN[0].vertex;
				float3 edgeB = IN[2].vertex - IN[0].vertex;
				float3 FaceNormal = normalize(cross(edgeA, edgeB));

				o.worldPos = mul(unity_ObjectToWorld, IN[0].vertex);
				o.vertex = UnityObjectToClipPos(IN[0].vertex);
				o.normal = UnityObjectToWorldNormal(FaceNormal);
				tristream.Append(o);

				o.worldPos = mul(unity_ObjectToWorld, IN[1].vertex);
				o.vertex = UnityObjectToClipPos(IN[1].vertex);
				tristream.Append(o);

				o.worldPos = mul(unity_ObjectToWorld, IN[2].vertex);
				o.vertex = UnityObjectToClipPos(IN[2].vertex);
				tristream.Append(o);

				tristream.RestartStrip();
			}

			
			fixed4 frag (g2f i) : SV_Target
			{
				float3 lightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				float3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				float diff = dot(lightDir, i.normal) * 0.5 + 0.5;
				float spec = pow(saturate(dot(i.normal, normalize(lightDir + viewDir))),10);

				return diff+spec;
			}
			ENDCG
		}
	}
}
