Shader "Example/Unlit/SimpleHeight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NormalTex("NormalTexture",2D) = "white"{}
		_HeightTex("HeightTexture",2D) = "white"{}
		_Smooth("SpecSmooth",float) = 50
		_HeightScale("HeightScale",range(0,0.2)) = 0.1
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
			
			fixed4 frag (v2f i) : SV_Target
			{
				float height = tex2D(_HeightTex,i.uv);
				float2 uv = i.uv - i.TanView.xy / i.TanView.z * height * _HeightScale;

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
