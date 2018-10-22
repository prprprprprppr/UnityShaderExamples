Shader "Example/Unlit/Scan"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_WorldOriginPos("World Origin Position",vector) = (0,0,0,0)
		_WorldRadius("World Radius",float) = 1
	}
	SubShader
	{
		Tags {"Queue"="Transparent" "RenderType"="Transparent" }
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
				float4 screenPos : TEXCOORD2;
				float4 viewray:TEXCOORD3;
				float4 vertex : SV_POSITION;
			};

			sampler2D _CameraDepthTexture;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _WorldOriginPos;
			float _WorldRadius;
			float4x4 _RayMatrix;
			float4x4 _cammatrix;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				float index = 0;
				if (v.texcoord.x < 0.5 && v.texcoord.y < 0.5) {
					index = 0;
				}else if (v.texcoord.x > 0.5 && v.texcoord.y < 0.5) {
					index = 1;
				}
				else if (v.texcoord.x < 0.5 && v.texcoord.y > 0.5) {
					index = 2;
				}
				else {
					index = 3;
				}
				o.viewray = _RayMatrix[index];
				o.screenPos = ComputeGrabScreenPos(o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex,i.uv);
				float depth = Linear01Depth(tex2D(_CameraDepthTexture,i.uv));

				//1.
				float2 f2 = float2(unity_CameraProjection._11, unity_CameraProjection._22);
				float3 vp = float3((i.uv * 2 - 1) / f2, -1) * depth * _ProjectionParams.z;
				float3 ws = mul(_cammatrix, float4(vp,1));

				//2.
				//float3 ws = _WorldSpaceCameraPos + (i.viewray * depth);

				float dis = distance(ws, _WorldOriginPos);
				if (dis < _WorldRadius && dis > _WorldRadius - 1 && depth < 1)
					col = float4(1, 1, 1, 1);
						
				return col;
			}
			ENDCG
		}
	}
}
