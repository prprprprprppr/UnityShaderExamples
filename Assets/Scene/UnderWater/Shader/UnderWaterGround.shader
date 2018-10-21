Shader "Example/Surface/UnderWaterGround" {
	Properties{
		_Tess("Tessellation", Range(1,32)) = 4
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Color("Color", color) = (1,1,1,0)
		_SpecColor("Spec color", color) = (0.5,0.5,0.5,0.5)
		_Frequency("Noise Frequency",float) = 1.0
		_Amplitude("Noise Amplitude",float) = 1.0
		_Offset("Noise Offset",float) = 1.0
	}

	SubShader{
		Tags{ "RenderType" = "Opaque" }
		LOD 300

		CGPROGRAM
		#pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:vert tessellate:tessDistance nolightmap
		#pragma target 4.6
		#include "../../../Shader/noiseSimplex.cginc"
		#include "Tessellation.cginc"

		struct appdata {
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
		};

		float _Tess;
		float _Frequency;
		float _Amplitude;
		float _Offset;
		sampler2D _MainTex;
		fixed4 _Color;

		float4 tessDistance(appdata v0, appdata v1, appdata v2) {
			float minDist = 10.0;
			float maxDist = 25.0;
			return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
		}

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata v)
		{
			float3 Bitangent = cross(v.normal, v.tangent.xyz);
			float3 p = v.vertex.xyz;
			float3 pt = v.vertex.xyz + v.tangent.xyz * 0.01;
			float3 pb = v.vertex.xyz + Bitangent * 0.01;
			float n = _Amplitude*(snoise(p*_Frequency+ _Offset)*0.5 + 0.5);
			float nt = _Amplitude*(snoise(pt*_Frequency+ _Offset)*0.5 + 0.5);
			float nb = _Amplitude*(snoise(pb*_Frequency+ _Offset)*0.5 + 0.5);
			
			p += v.normal * n;
			pt += v.normal *nt;
			pb += v.normal *nb;

			v.normal = normalize(cross(p - pt, p - pb));

			v.vertex.xyz = p;
		}

		void surf(Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Specular = 0.2;
			o.Gloss = 1.0;
		}
		ENDCG
	}
	FallBack "Diffuse"
}