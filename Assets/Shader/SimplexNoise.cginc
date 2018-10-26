#ifndef _SIMPLEXNOISE__
#define _SIMPLEXNOISE__

#ifndef USINGOLDHASH
	#include "Hash.cginc"
#else 
	#include "Hash_Old.cginc"
#endif

float SNoise(float2 p)
{
	const float K1 = 0.366025404; // (sqrt(3)-1)/2;
	const float K2 = -0.211324865; // (sqrt(3)-3)/6;

	float2 i = floor(p + (p.x + p.y) * K1);

	float2 a = p - (i + (i.x + i.y) * K2);
	float2 o = (a.x < a.y) ? float2(0.0, 1.0) : float2(1.0, 0.0);
	float2 b = a - o - K2;
	float2 c = a - 1.0 - 2.0 * K2;

	float3 h = max(0.5 - float3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
	float3 n = h * h * h * h * float3(dot(a, hash22(i)), dot(b, hash22(i + o)), dot(c, hash22(i + 1.0)));

	return dot(float3(70.0, 70.0, 70.0), n) * 0.5 + 0.5;
}

float SNoise(float3 p)
{
	const float K1 = 0.333333333; // (sqrt(4)-1)/3;
	const float K2 = -0.166666667;

	float3 i = floor(p + (p.x + p.y + p.z) * K1);

	float3 a = p - (i + (i.x + i.y + i.z) * K2);

	float3 e = step(0, a - a.yzx);
	float3 o1 = e * (1.0 - e.zxy);
	float3 o2 = 1.0 - e.zxy*(1.0 - e);

	float3 b = a - o1 - K2;
	float3 c = a - o2 - 2.0 * K2;
	float3 d = a - 1.0 - 3.0 * K2;

	float4 h = max(0.6 - float4(dot(a, a), dot(b, b), dot(c, c), dot(d, d)), 0.0);
	float4 n = h * h * h * h * float4(dot(a, hash33(i)), dot(b, hash33(i + o1)), dot(c, hash33(i + o2)), dot(d, hash33(i + 1.0)));

	return dot(float4(52, 52, 52, 52), n) * 0.5 + 0.5;
}

#endif