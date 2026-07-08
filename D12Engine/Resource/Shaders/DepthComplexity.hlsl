cbuffer DebugColorCB : register(b0)
{
    float4 gDebugColor;
};

struct VOut
{
    float4 PosH : SV_Position;
};

VOut FullscreenVS(uint vid : SV_VertexID)
{
    VOut vout;
    
    float2 pos[3] =
    {
        float2(-1.0f, -1.0f),
        float2(-1.0f, 3.0f),
        float2(3.0f, -1.0f),
    };

    vout.PosH = float4(pos[vid], 0.0f, 1.0f);
    return vout;
}

float4 FullscreenPS(VOut pin) : SV_Target
{
    return gDebugColor;
}