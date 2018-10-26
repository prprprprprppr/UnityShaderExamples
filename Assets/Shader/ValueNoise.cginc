#ifndef _VALUENOISE__
#define _VALUENOISE__

#ifndef USINGOLDHASH
	#include "Hash.cginc"
#else 
	#include "Hash_Old.cginc"
#endif

float VNoise(float2 p) {
	float2 i = floor(p);
	float2 f = frac(p);

	float2 u = f * f * f * (10.0 - 15.0 * f + 6.0 * f * f);
	//float2 u = f * f * (3 - 2 * f); 

	float noise = lerp(lerp(hash12(i + float2(0, 0)), hash12(i + float2(1, 0)), u.x),
					   lerp(hash12(i + float2(0, 1)), hash12(i + float2(1, 1)), u.x), u.y);
	return noise * 0.5 + 0.5;
}

float VNoise(float3 p) {
	float3 i = floor(p);
	float3 f = frac(p);

	float3 u = f * f * f * (10.0 - 15.0 * f + 6.0 * f * f);
	//float2 u = f * f * (3 - 2 * f); 

	float noise = lerp(lerp(lerp(hash13(i + float3(0, 0, 0)), hash13(i + float3(1, 0, 0)), u.x),
							lerp(hash13(i + float3(0, 1, 0)), hash13(i + float3(1, 1, 0)), u.x), u.y),
					   lerp(lerp(hash13(i + float3(0, 0, 1)), hash13(i + float3(1, 0, 1)), u.x),
						    lerp(hash13(i + float3(0, 1, 1)), hash13(i + float3(1, 1, 1)), u.x), u.y), u.z);
	return noise * 0.5 + 0.5;
}

#endif