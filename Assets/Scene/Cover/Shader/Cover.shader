Shader "Example/Unlit/Cover"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Offset("Offset",float) = 0.1
		_Color("Color",color) = (1,1,1,1)
	}
		SubShader
		{
			Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
			LOD 100

			Blend One One
			ZWrite Off
			Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			
			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 vertexPos : TEXCOORD1;
				float3 worldViewDir:TEXCOORD2;
				float3 worldNor : TEXCOORD3;
				float4 screenPos: TEXCOORD4;
				float depth : DEPTH;
				float4 vertex : SV_POSITION;
			};

			sampler2D _CameraDepthTexture;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _Offset;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.vertexPos = v.vertex.xyz;
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
				o.worldNor = UnityObjectToWorldNormal(v.normal);
				o.depth = -UnityObjectToViewPos(v.vertex).z *_ProjectionParams.w;;
				o.screenPos = ComputeGrabScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 maincol = tex2D(_MainTex, i.uv*15);
				float camdepth = Linear01Depth(tex2Dproj(_CameraDepthTexture, i.screenPos));

				float diff = camdepth - i.depth;
				float sd = 0;

				if (camdepth - i.depth > 0) {
					sd = 1 - smoothstep(0, _ProjectionParams.w/2, diff);
				}

				float rim = maincol.g * saturate(1-abs(dot(i.worldViewDir, i.worldNor))*2) * (sin(maincol.b+_Time.y)+1);

				float wave = maincol.r * saturate(abs(frac(_Time.x*5+i.vertexPos.y)*2-1)-_Offset)*6;

				float top = smoothstep(0.45, 0.5, i.vertexPos.y);

				return (top+rim+wave)*_Color+sd*0.5;
			}
			ENDCG
		}
	}
}
