﻿Shader "Hidden/DrawTrace"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Coord ("Coord",vector) = (0,0,0,0)
		_Color ("Color",color) = (1,0,0,1)
		_Smooth ("Smooth",float) = 500
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

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Coord;
			float4 _Color;
			float _Smooth;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				float draw = pow(saturate(1 - distance(i.uv, _Coord.xy)), _Smooth);
				return min(col + _Color * draw,1);
			}
			ENDCG
		}
	}
}
