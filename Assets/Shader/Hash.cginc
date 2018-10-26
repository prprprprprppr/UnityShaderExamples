#ifndef _HASH__
#define _HASH__

//reference:https://www.shadertoy.com/view/4djSRW
//return -1~1
//最好输出-1~1不然计算Perlin时方块感很严重!

// *** Change these to suit your range of random numbers..

// *** Use this for integer stepped ranges, ie Value-Noise/Perlin noise functions.
#define HASHSCALE1 0.1031
#define HASHSCALE3 float3(0.1031, 0.1030, 0.0973)
#define HASHSCALE4 float4(0.1031, 0.1030, 0.0973, 0.1099)

// For smaller input rangers like audio tick or 0-1 UVs use these...
//#define HASHSCALE1 443.8975
//#define HASHSCALE3 float3(443.897, 441.423, 437.195)
//#define HASHSCALE4 float4(443.897, 441.423, 437.195, 444.129)

float hash11(float p)
{
	float3 p3 = frac(p * HASHSCALE1);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.x + p3.y) * p3.z) * 2 -1;
}

//----------------------------------------------------------------------------------------
//  1 out, 2 in...
float hash12(float2 p)
{
	float3 p3 = frac(float3(p.xyx) * HASHSCALE1);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.x + p3.y) * p3.z) * 2 - 1;
}

//----------------------------------------------------------------------------------------
//  1 out, 3 in...
float hash13(float3 p3)
{
	p3 = frac(p3 * HASHSCALE1);
	p3 += dot(p3, p3.yzx + 6.1254225243);
	return frac((p3.x + p3.y) * p3.z) * 2 - 1;
}

//----------------------------------------------------------------------------------------
//  2 out, 1 in...
float2 hash21(float p)
{
	float3 p3 = frac(p * HASHSCALE3);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.xx + p3.yz)*p3.zy) * 2 - 1;

}

//----------------------------------------------------------------------------------------
///  2 out, 2 in...
float2 hash22(float2 p)
{
	float3 p3 = frac(float3(p.xyx) * HASHSCALE3);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.xx + p3.yz)*p3.zy) * 2 - 1;

}

//----------------------------------------------------------------------------------------
///  2 out, 3 in...
float2 hash23(float3 p3)
{
	p3 = frac(p3 * HASHSCALE3);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.xx + p3.yz)*p3.zy) * 2 - 1;
}

//----------------------------------------------------------------------------------------
//  3 out, 1 in...
float3 hash31(float p)
{
	float3 p3 = frac(p * HASHSCALE3);
	p3 += dot(p3, p3.yzx + 19.19);
	return frac((p3.xxy + p3.yzz)*p3.zyx) * 2 - 1;
}


//----------------------------------------------------------------------------------------
///  3 out, 2 in...
float3 hash32(float2 p)
{
	float3 p3 = frac(float3(p.xyx) * HASHSCALE3);
	p3 += dot(p3, p3.yxz + 19.19);
	return frac((p3.xxy + p3.yzz)*p3.zyx) * 2 - 1;
}

//----------------------------------------------------------------------------------------
///  3 out, 3 in...
float3 hash33(float3 p3)
{
	p3 = frac(p3 * HASHSCALE3);
	p3 += dot(p3, p3.yxz + 19.19);
	return frac((p3.xxy + p3.yxx)*p3.zyx) * 2 - 1;

}

//----------------------------------------------------------------------------------------
// 4 out, 1 in...
float4 hash41(float p)
{
	float4 p4 = frac(p * HASHSCALE4);
	p4 += dot(p4, p4.wzxy + 19.19);
	return frac((p4.xxyz + p4.yzzw)*p4.zywx) * 2 - 1;

}

//----------------------------------------------------------------------------------------
// 4 out, 2 in...
float4 hash42(float2 p)
{
	float4 p4 = frac(float4(p.xyxy) * HASHSCALE4);
	p4 += dot(p4, p4.wzxy + 19.19);
	return frac((p4.xxyz + p4.yzzw)*p4.zywx) * 2 - 1;

}

//----------------------------------------------------------------------------------------
// 4 out, 3 in...
float4 hash43(float3 p)
{
	float4 p4 = frac(float4(p.xyzx)  * HASHSCALE4);
	p4 += dot(p4, p4.wzxy + 19.19);
	return frac((p4.xxyz + p4.yzzw)*p4.zywx) * 2 - 1;
}

//----------------------------------------------------------------------------------------
// 4 out, 4 in...
float4 hash44(float4 p4)
{
	p4 = frac(p4  * HASHSCALE4);
	p4 += dot(p4, p4.wzxy + 19.19);
	return frac((p4.xxyz + p4.yzzw)*p4.zywx) * 2 - 1;
}

#endif