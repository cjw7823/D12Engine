cbuffer DebugColorCB : register(b0)
{
    float4 gDebugColor;
};

struct VSOut
{
    float4 PosH : SV_POSITION;
};

VSOut FullscreenVS(uint vid : SV_VertexID)
{
    VSOut vout;

    float2 pos[3] =
    {
        float2(-1.0f, -1.0f),
        float2(-1.0f, 3.0f),
        float2(3.0f, -1.0f)
    };

    vout.PosH = float4(pos[vid], 0.0f, 1.0f);
    return vout;
}

float4 FullscreenPS(VSOut pin) : SV_Target
{
    return gDebugColor;
}