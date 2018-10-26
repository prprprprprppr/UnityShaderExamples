#ifndef _HASH_OLD__
#define _HASH_OLD__

//reference:shadertoy iq
//return -1~1
//最好输出-1~1不然计算Perlin时方块感很严重!
float hash12(float2 p)
{
	float q = dot(p, float2(127.1, 311.7));

	return frac(sin(q)*43758.5453) * 2 - 1;
}

float2 hash22(float2 p)
{
	float2 q = float2(dot(p, float2(127.1, 311.7)),
				dot(p, float2(269.5, 183.3)));

	return frac(sin(q)*43758.5453) * 2 - 1;
}

float3 hash32(float2 p)
{
	float3 q = float3(dot(p, float2(127.1, 311.7)),
				dot(p, float2(269.5, 183.3)),
				dot(p, float2(419.2, 371.9)));

	return frac(sin(q)*43758.5453) * 2 - 1;
}

float hash13(float3 p)
{
	float q = dot(p, float3(127.1, 311.7, 74.7));

	return frac(sin(q)*43758.5453123) * 2 - 1;
}

float2 hash23(float3 p)
{
	float2 q = float2(dot(p, float3(127.1, 311.7, 74.7)),
				dot(p, float3(269.5, 183.3, 246.1)));

	return frac(sin(q)*43758.5453123) * 2 - 1;
}

float3 hash33(float3 p)
{
	float3 q = float3(dot(p, float3(127.1, 311.7, 74.7)),
				dot(p, float3(269.5, 183.3, 246.1)),
				dot(p, float3(113.5, 271.9, 124.6)));

	return frac(sin(q)*43758.5453123) * 2 - 1;
}

#endif