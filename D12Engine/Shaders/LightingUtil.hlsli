#define MaxLights 16

struct Light
{
    float3 Strength;
    float FalloffStart; // point/spot light only
    float3 Direction; // directional/spot light only
    float FalloffEnd; // point/spot light only
    float3 Position; // point light only
    float SpotPower; // spot light only
};

struct Material
{
    float4 DiffuseAlbedo;
    float3 FresnelR0;
    float Shininess;
};

float QuantizeKd(float kd)
{
    if (kd <= 0.0f)
        return 0.2f;
    else if (kd <= 0.3f)
        return 0.4f;
    else if (kd <= 0.6f)
        return 0.6f;
    else if (kd <= 0.9f)
        return 0.8f;
    else
        return 1.0f;
}

float QuantizeKs(float ks)
{
    if (ks <= 0.1f)
        return 0.0f;
    else if (ks <= 0.3f)
        return 0.2f;
    else if (ks <= 0.5f)
        return 0.4f;
    else if (ks <= 0.7f)
        return 0.6f;
    else if (ks <= 0.9f)
        return 0.8f;
    else
        return 1.f;
}

float CalcAttenuation(float d, float falloffStart, float falloffEnd)
{
    //선형 감쇠
    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));
}

// Schlick은 프레넬 반사율에 대한 근사치를 제시합니다(233페이지 "실시간 렌더링 3판" 참조).
// R0 = ( (n-1)/(n+1) )^2, 여기서 n은 굴절률입니다.
float3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)
{
    float cosIncidentAngle = saturate(dot(normal, lightVec));
    
    float f0 = 1.0f - cosIncidentAngle;
    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);
    
    return reflectPercent;
}

float3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)
{
    const float m = mat.Shininess * 256.0f;
    float3 halfVec = normalize(toEye + lightVec);
    
    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;
    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);
    
    float3 specAlbedo = fresnelFactor * roughnessFactor;

    //Blinn-Phong 모델에서는 specAlbedo가 1보다 클 수 있다.
    //LDR 렌더링을 수행하고 있으므로 범위를 약간 축소한다.
    specAlbedo = specAlbedo / (specAlbedo + 1.0f);
    
    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;
}

float3 BlinnPhongToon(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)
{
    // 1) kd
    float kd = saturate(dot(lightVec, normal));
    float kd_q = QuantizeKd(kd);

    // 2) ks (Blinn-Phong)
    const float m = mat.Shininess * 256.0f;
    float3 halfVec = normalize(toEye + lightVec);
    float ndoth = saturate(dot(halfVec, normal));

    float ks = pow(max(ndoth, 0), m); // 스펙큘러 강도의 핵심
    float ks_q = QuantizeKs(ks); // 이산화

    // fresnel(색) + (필요하면) 정규화 계수는 취향
    float3 F = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);

    // ks_q를 spec에 반영
    float3 specAlbedo = F * ks_q;

    // LDR clamp는 유지 가능
    specAlbedo = specAlbedo / (specAlbedo + 1.0f);

    // diffuse는 kd_q를 반영
    float3 diffuse = mat.DiffuseAlbedo.rgb * kd_q;
    
    return (diffuse + specAlbedo) * lightStrength;
}

float3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)
{
    //광 벡터는 빛이 진행하는 방향과 반대 방향.
    float3 lightVec = -L.Direction;
    
    //람베르트 코사인 법칙에 따라 빛 강도 계산.
    float ndotl = max(dot(lightVec, normal), 0.0f);
    float3 lightStrength = L.Strength * ndotl;
    
    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);
}

float3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)
{
    float3 lightVec = L.Position - pos;
    float d = length(lightVec);
    
    if(d > L.FalloffEnd)
        return 0;
    
    lightVec /= d; //정규화
    
    //람베르트 코사인 법칙에 따라 빛 강도 계산.
    float ndotl = max(dot(lightVec, normal), 0.0f);
    float3 lightStrength = L.Strength * ndotl;
    
    //거리에 따른 빛 감쇠 계산.
    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);
    lightStrength *= att;
    
    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);
}

float3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)
{
    float3 lightVec = L.Position - pos;
    float d = length(lightVec);
    
    if(d > L.FalloffEnd)
        return 0;
    
    lightVec /= d; //정규화
    
    //람베르트 코사인 법칙에 따라 빛 강도 계산.
    float ndotl = max(dot(lightVec, normal), 0.0f);
    float3 lightStrength = L.Strength * ndotl;
    
    //거리에 따른 빛 감쇠 계산.
    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);
    lightStrength *= att;
    
    //스포트라이트의 경우, 빛이 스포트라이트의 중심에서 멀어질수록 빛이 약해진다.
    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);
    lightStrength *= spotFactor;    
    
    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);
}

float4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)
{
    float3 result = 0;
    int i = 0;
    
#if (NUM_DIR_LIGHTS > 0)
    for(i = 0; i < NUM_DIR_LIGHTS; ++i)
    {
        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);
    }
#endif

#if (NUM_POINT_LIGHTS > 0)
    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)
    {
        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);
    }
#endif

#if (NUM_SPOT_LIGHTS > 0)
    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)
    {
        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);
    }
#endif 
    
    return float4(result, 0.0f);
}