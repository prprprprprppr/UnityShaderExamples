Shader "Example/Surface/Snow" 
{
	Properties{
		_Tess("Tessellation", Range(1,32)) = 4
		_SnowTex("Snow Base (RGB)", 2D) = "white" {}
		_TraceTex("Trace Map",2D) = "white" {}
		_Depth("Depth", Range(0, 1)) = 1.0
		_SnowColor("SnowColor", color) = (1,1,1,1)
		_TraceColor("TraceColor",color) = (1,1,1,1)
	}
	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 300

		CGPROGRAM
		#pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:disp tessellate:tessDistance  nolightmap
		#pragma target 4.6
		#include "Tessellation.cginc"

		float _Tess;
		sampler2D _SnowTex;
		sampler2D _TraceTex;
		float _Depth;
		float4 _SnowColor;
		float4 _TraceColor;

		struct appdata {
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		struct Input {
			float2 uv_SnowTex;
			float2 uv_TraceTex;
		};

		float4 tessDistance(appdata v0, appdata v1, appdata v2)
		{
			float minDist = 10.0;
			float maxDist = 25.0;
			return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
		}

		void disp(inout appdata v)
		{
			float d = tex2Dlod(_TraceTex, float4(v.texcoord.xy,0,0)).r * _Depth;
			v.vertex.y -= v.normal.y * d;
			v.vertex.y += v.normal.y * _Depth;
		}

		void surf(Input IN, inout SurfaceOutput o) {
			float amount = tex2D(_TraceTex, IN.uv_TraceTex).r;
			float4 col = lerp(_SnowColor, _TraceColor, amount);
			float4 c = tex2D(_SnowTex, IN.uv_SnowTex) * col;
			o.Albedo = c.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}