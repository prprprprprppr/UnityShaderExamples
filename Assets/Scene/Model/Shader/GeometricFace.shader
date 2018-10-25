Shader "Example/Unlit/GeometricFace"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
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
#include "Lighting.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			struct v2g
			{
				float2 uv : TEXCOORD0;
				float4 vertex : POSITION;
			};

			struct g2f
			{
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
				float4 vertex : SV_POSITION;
			};
			
			v2g vert (appdata_base v)
			{
				v2g o;
				o.vertex = v.vertex;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			[maxvertexcount(3)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> tristream)
			{
				g2f o;
				float3 edgeA = IN[1].vertex - IN[0].vertex;
				float3 edgeB = IN[2].vertex - IN[0].vertex;
				float3 FaceNormal = normalize(cross(edgeA, edgeB));

				o.uv = IN[0].uv;
				o.worldPos = mul(unity_ObjectToWorld, IN[0].vertex);
				o.vertex = UnityObjectToClipPos(IN[0].vertex);
				o.normal = UnityObjectToWorldNormal(FaceNormal);
				tristream.Append(o);

				o.uv = IN[1].uv;
				o.worldPos = mul(unity_ObjectToWorld, IN[1].vertex);
				o.vertex = UnityObjectToClipPos(IN[1].vertex);
				tristream.Append(o);

				o.uv = IN[2].uv;
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

				float3 col = tex2D(_MainTex, i.uv);
				return float4(_LightColor0 * (diff * col + spec), 1);
			}
			ENDCG
		}
	}
}
