Shader "Example/Unlit/OutlineWithZOffset"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color("Color",color) = (1,1,1,1)
		_Intensity("Intensity",float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			cull front

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			float4 _Color;
			float _Intensity;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				float3 viewPos = UnityObjectToViewPos(v.vertex);
				viewPos.z += _Intensity;
				o.vertex = UnityViewToClipPos(viewPos);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return _Color;
			}
			ENDCG
		}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return tex2D(_MainTex,i.uv);
			}
			ENDCG
		}
	}
}
