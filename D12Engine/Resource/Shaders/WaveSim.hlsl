cbuffer cbUpdateSettings : register(b0)
{
    float gWaveConstant0;
    float gWaveConstant1;
    float gWaveConstant2;
    
    float gDisturbMag;
    uint2 gDisturbIndex;
};

RWTexture2D<float> gPrevSolInput : register(u0);
RWTexture2D<float> gCurrSolInput : register(u1);
RWTexture2D<float> gOutput : register(u2);

[numthreads(16, 16, 1)]
void UpdateWavesCS(int3 dispatchThreadID : SV_DispatchThreadID)
{
    //경계 검사를 할 필요가 없음.
    //경계 밖 읽기는 0반환(해당 시뮬레이션에서는 문제 없음), 경계 밖 쓰기는 무시됨.
    //0반환이 문제가 되는 경우, 경계 검사를 해야할 수도 있음.
    
    int x = dispatchThreadID.x;
    int y = dispatchThreadID.y;
    
    gOutput[int2(x, y)] =
        gWaveConstant0 * gPrevSolInput[int2(x, y)].r +
        gWaveConstant1 * gCurrSolInput[int2(x, y)].r +
        gWaveConstant2 * (
            gCurrSolInput[int2(x + 1, y)].r +
            gCurrSolInput[int2(x - 1, y)].r +
            gCurrSolInput[int2(x, y + 1)].r +
            gCurrSolInput[int2(x, y - 1)].r);
}

[numthreads(1, 1, 1)]
void DisturbWavesCS(int3 dispatchThreadID : SV_DispatchThreadID)
{
    //경계검사 필요x.
    int x = gDisturbIndex.x;
    int y = gDisturbIndex.y;
    
    float halfMag = 0.5 * gDisturbMag;
    
    gOutput[int2(x, y)] += gDisturbMag;
    gOutput[int2(x + 1, y)] += halfMag;
    gOutput[int2(x - 1, y)] += halfMag;
    gOutput[int2(x, y + 1)] += halfMag;
    gOutput[int2(x, y - 1)] += halfMag;
}
