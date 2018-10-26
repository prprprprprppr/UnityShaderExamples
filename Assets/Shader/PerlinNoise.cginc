#ifndef _PERLINNOISE__
#define _PERLINNOISE__

#ifndef USINGOLDHASH
	#include "Hash.cginc"
#else 
	#include "Hash_Old.cginc"
#endif

float PNoise(float2 uv) {
	float2 i = floor(uv);
	float2 f = frac(uv);

	float2 u = f * f * f * (10.0 - 15.0 * f + 6 * f * f);
	//float2 u = f * f * (3 - 2 * f);

	float noise = lerp(lerp(dot(hash22(i + float2(0.0, 0.0)), f - float2(0.0, 0.0)),
							dot(hash22(i + float2(1.0, 0.0)), f - float2(1.0, 0.0)), u.x),
					   lerp(dot(hash22(i + float2(0.0, 1.0)), f - float2(0.0, 1.0)),
							dot(hash22(i + float2(1.0, 1.0)), f - float2(1.0, 1.0)), u.x), u.y);
	return noise * 0.5 + 0.5;
}

float PNoise(float3 uv) {
	float3 i = floor(uv);
	float3 f = frac(uv);

	float3 u = f * f * f * (10.0 - 15.0 * f + 6 * f * f);
	//float3 u = f * f * (3 - 2 * f);

	float noise = lerp(lerp(lerp(dot(hash33(i + float3(0, 0, 0)), f - float3(0, 0, 0)),
								 dot(hash33(i + float3(1, 0, 0)), f - float3(1, 0, 0)), u.x),
							lerp(dot(hash33(i + float3(0, 1, 0)), f - float3(0, 1, 0)),
								 dot(hash33(i + float3(1, 1, 0)), f - float3(1, 1, 0)), u.x), u.y),
					   lerp(lerp(dot(hash33(i + float3(0, 0, 1)), f - float3(0, 0, 1)),
								 dot(hash33(i + float3(1, 0, 1)), f - float3(1, 0, 1)), u.x),
							lerp(dot(hash33(i + float3(0, 1, 1)), f - float3(0, 1, 1)),
								 dot(hash33(i + float3(1, 1, 1)), f - float3(1, 1, 1)), u.x), u.y), u.z);
	return noise * 0.5 + 0.5;
}

#endif