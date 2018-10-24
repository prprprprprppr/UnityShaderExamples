Shader "Example/Unlit/ParallaxHeight3"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NormalTex("NormalTexture",2D) = "white"{}
		_HeightTex("HeightTexture",2D) = "white"{}
		_Smooth("SpecSmooth",float) = 50
		_HeightScale("HeightScale",range(0,0.2)) = 0.1
		_MaxLayer("MaxLayer",range(1,50)) = 30
		_MinLayer("MinLayer",range(1,50)) = 15
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float3 TanView:TEXCOORD1;
				float3 TanLight:TEXCOORD2;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _NormalTex;
			sampler2D _HeightTex;
			float _Smooth;
			float _HeightScale;
			float _MaxLayer;
			float _MinLayer;
			
			v2f vert (appdata_tan v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				TANGENT_SPACE_ROTATION;
				float3 TanPos = mul(rotation, v.vertex);
				o.TanView = normalize(mul(rotation, ObjSpaceViewDir(v.vertex)));
				o.TanLight = normalize(mul(rotation, ObjSpaceLightDir(v.vertex)));
				return o;
			}

			//根据纹理颜色 ("高度"即是深度)
			float2 ParallaxFunc(float2 uv, float3 view)
			{
				float layer = lerp(_MaxLayer, _MinLayer, saturate(dot(view, float3(0, 0, 1))));
				float DeltaDepth = 1.0 / layer;
				float CurDepth = 0;
				float CurDepthValue = tex2Dlod(_HeightTex, uv.xyxy);
				float2 Deltauv = view.xy / view.z * _HeightScale / layer;

				while (CurDepth < CurDepthValue)
				{
					uv -= Deltauv;
					CurDepth += DeltaDepth;
					CurDepthValue = tex2Dlod(_HeightTex, uv.xyxy);
				}

				//二分查找
				for (int i = 0;i < 5;i++) {
					Deltauv /= 2;
					DeltaDepth /= 2;
					if (CurDepth < CurDepthValue + 0.001) {
						uv -= Deltauv;
						CurDepth += DeltaDepth;
					}
					else if (CurDepth > CurDepthValue - 0.001) {
						uv += Deltauv;
						CurDepth -= DeltaDepth;
					}
					else
						break;
					CurDepthValue = tex2Dlod(_HeightTex, uv.xyxy);
				}
				return uv;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = ParallaxFunc(i.uv,i.TanView);

				if (uv.x > 1.0 || uv.y > 1.0 || uv.x < 0.0 || uv.y < 0.0) //去掉边上的一些古怪的失真，在平面上工作得挺好的
					discard;

				float3 TanNormal = normalize(UnpackNormal(tex2D(_NormalTex,uv)));
				float diff = 0.5*dot(TanNormal, i.TanLight)+0.5;
				float3 H = normalize(i.TanView + i.TanLight);
				float spec = pow(saturate(dot(TanNormal, H)),_Smooth);

				fixed4 col = tex2D(_MainTex, uv);
				col = UNITY_LIGHTMODEL_AMBIENT * col + _LightColor0 * diff * col + _LightColor0 * spec;
				return col;
			}
			ENDCG
		}
	}
}
