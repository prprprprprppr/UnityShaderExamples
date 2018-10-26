Shader "Example/Unlit/OutlineWithSobelCameraEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
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
				float4 vertex : SV_POSITION;
			};

			sampler2D _Global_OutlineWithSobelTexture;
			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata_base v)
			{
				v2f o;
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.vertex = UnityObjectToClipPos(v.vertex);

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{ 
				fixed4 col = tex2D(_MainTex,i.uv);
				fixed sobel = tex2D(_Global_OutlineWithSobelTexture, i.uv);
				return col*sobel;
			}
			ENDCG
		}
	}
}
