Shader "Example/Unlit/CameraEffect_GaussianBlur"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_BlurSize("BlurSize",float) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		float4 _MainTex_TexelSize;
		float _BlurSize;

		struct v2f
		{
			float2 uv[5]:TEXCOORD;
			float4 vertex : SV_POSITION;
		};

		v2f vert_Vertical(appdata_base v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv[0] = v.texcoord;
			o.uv[1] = v.texcoord - float2(0, _MainTex_TexelSize.y)*_BlurSize;
			o.uv[2] = v.texcoord + float2(0, _MainTex_TexelSize.y)*_BlurSize;
			o.uv[3] = v.texcoord - float2(0, _MainTex_TexelSize.y)*_BlurSize * 2;
			o.uv[4] = v.texcoord + float2(0, _MainTex_TexelSize.y)*_BlurSize * 2;
			return o;
		}

		v2f vert_Horizontal(appdata_base v)
		{
			v2f o;
			o.vertex = UnityObjectToClipPos(v.vertex);
			o.uv[0] = v.texcoord;
			o.uv[1] = v.texcoord - float2(_MainTex_TexelSize.x,0)*_BlurSize;
			o.uv[2] = v.texcoord + float2(_MainTex_TexelSize.x,0)*_BlurSize;
			o.uv[3] = v.texcoord - float2(_MainTex_TexelSize.x,0)*_BlurSize * 2;
			o.uv[4] = v.texcoord + float2(_MainTex_TexelSize.x,0)*_BlurSize * 2;
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			fixed4 col = tex2D(_MainTex,i.uv[0]) * 0.38774 +
			tex2D(_MainTex,i.uv[1]) * 0.24477 +
			tex2D(_MainTex,i.uv[2]) * 0.24477 +
			tex2D(_MainTex,i.uv[3]) * 0.06136 +
			tex2D(_MainTex,i.uv[4]) * 0.06136;
			return col;
		}

		ENDCG


		Pass
		{
			Name "CameraEffect_GaussianBlur_Vertical"

			CGPROGRAM
			#pragma vertex vert_Vertical
			#pragma fragment frag
			ENDCG
		}
		Pass
		{
			Name "CameraEffect_GaussianBlur_Horizontal"

			CGPROGRAM
			#pragma vertex vert_Horizontal
			#pragma fragment frag
			ENDCG
		}
	}
}
