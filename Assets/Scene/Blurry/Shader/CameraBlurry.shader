Shader "Example/Unlit/CameraBlurry"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Size("blurry size",vector) = (0,0,0,0)
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
			float4 _Size;
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv + float2(-_Size.x,-_Size.y)) +
							tex2D(_MainTex, i.uv + float2(-_Size.x,0)) +
							tex2D(_MainTex, i.uv + float2(-_Size.x,_Size.y)) +
							tex2D(_MainTex, i.uv + float2(0,-_Size.y)) +
							tex2D(_MainTex, i.uv + float2(0,0)) +
							tex2D(_MainTex, i.uv + float2(0,_Size.y)) +
							tex2D(_MainTex, i.uv + float2(_Size.x,-_Size.y)) +
							tex2D(_MainTex, i.uv + float2(_Size.x,0)) +
							tex2D(_MainTex, i.uv + float2(_Size.x,_Size.y));

				return col/9.0;
			}
			ENDCG
		} 
	}
}
