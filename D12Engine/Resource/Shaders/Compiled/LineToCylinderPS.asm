;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Position              0   xyzw        0      POS   float       
; POSITION                 0   xyz         1     NONE   float   xyz 
; NORMAL                   0   xyz         2     NONE   float   xyz 
; TEXCOORD                 0   xy          3     NONE   float   xy  
; SV_PrimitiveID           0   x           4   PRIMID    uint       
; TEXCOORD                 1   x           5     NONE    uint   x   
;
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Target                0   xyzw        0   TARGET   float   xyzw
;
; shader debug name: a9b93417a44be08da6e9d389bf733455.pdb
; shader hash: a9b93417a44be08da6e9d389bf733455
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Pixel Shader
; DepthOutput=0
; SampleFrequency=0
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 6
; SigOutputElements: 1
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 6
; SigOutputVectors[0]: 1
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: PS
;
;
; Input signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_Position              0          noperspective       
; POSITION                 0                 linear       
; NORMAL                   0                 linear       
; TEXCOORD                 0                 linear       
; SV_PrimitiveID           0        nointerpolation       
; TEXCOORD                 1        nointerpolation       
;
; Output signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_Target                0                              
;
; Buffer Definitions:
;
; cbuffer cbMaterial
; {
;
;   struct hostlayout.cbMaterial
;   {
;
;       float4 gDiffuseAlbedo;                        ; Offset:    0
;       float3 gFresnelR0;                            ; Offset:   16
;       float gRoughness;                             ; Offset:   28
;       column_major float4x4 gMatTransform;          ; Offset:   32
;   
;   } cbMaterial;                                     ; Offset:    0 Size:    96
;
; }
;
; cbuffer cbPass
; {
;
;   struct hostlayout.cbPass
;   {
;
;       column_major float4x4 gView;                  ; Offset:    0
;       column_major float4x4 gInvView;               ; Offset:   64
;       column_major float4x4 gProj;                  ; Offset:  128
;       column_major float4x4 gInvProj;               ; Offset:  192
;       column_major float4x4 gViewProj;              ; Offset:  256
;       column_major float4x4 gInvViewProj;           ; Offset:  320
;       float3 gEyePosW;                              ; Offset:  384
;       float cbPerObjectPad1;                        ; Offset:  396
;       float2 gRenderTargetSize;                     ; Offset:  400
;       float2 gInvRenderTargetSize;                  ; Offset:  408
;       float gNearZ;                                 ; Offset:  416
;       float gFarZ;                                  ; Offset:  420
;       float gTotalTime;                             ; Offset:  424
;       float gDeltaTime;                             ; Offset:  428
;       float4 gAmbientLight;                         ; Offset:  432
;       struct struct.Light
;       {
;
;           float3 Strength;                          ; Offset:  448
;           float FalloffStart;                       ; Offset:  460
;           float3 Direction;                         ; Offset:  464
;           float FalloffEnd;                         ; Offset:  476
;           float3 Position;                          ; Offset:  480
;           float SpotPower;                          ; Offset:  492
;       
;       } gLights[16];;                               ; Offset:  448
;
;       float4 gFogColor;                             ; Offset: 1216
;       float gFogStart;                              ; Offset: 1232
;       float gFogRange;                              ; Offset: 1236
;       float2 cbPerObjectPad2;                       ; Offset: 1240
;   
;   } cbPass;                                         ; Offset:    0 Size:  1248
;
; }
;
;
; Resource Bindings:
;
; Name                                 Type  Format         Dim      ID      HLSL Bind  Count
; ------------------------------ ---------- ------- ----------- ------- -------------- ------
; cbMaterial                        cbuffer      NA          NA     CB0            cb1     1
; cbPass                            cbuffer      NA          NA     CB1            cb2     1
; gsamAnisotropicClamp              sampler      NA          NA      S0             s5     1
; gDiffuseMap                       texture     f32          2d      T0             t0     1
;
;
; ViewId state:
;
; Number of inputs: 21, outputs: 4
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;   output 0 depends on inputs: { 4, 5, 6, 8, 9, 10, 12, 13, 20 }
;   output 1 depends on inputs: { 4, 5, 6, 8, 9, 10, 12, 13, 20 }
;   output 2 depends on inputs: { 4, 5, 6, 8, 9, 10, 12, 13, 20 }
;   output 3 depends on inputs: { 12, 13 }
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.ResRet.f32 = type { float, float, float, float, i32 }
%dx.types.CBufRet.f32 = type { float, float, float, float }
%"class.Texture2D<vector<float, 4> >" = type { <4 x float>, %"class.Texture2D<vector<float, 4> >::mips_type" }
%"class.Texture2D<vector<float, 4> >::mips_type" = type { i32 }
%hostlayout.cbMaterial = type { <4 x float>, <3 x float>, float, [4 x <4 x float>] }
%hostlayout.cbPass = type { [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], <3 x float>, float, <2 x float>, <2 x float>, float, float, float, float, <4 x float>, [16 x %struct.Light], <4 x float>, float, float, <2 x float> }
%struct.Light = type { <3 x float>, float, <3 x float>, float, <3 x float>, float }
%struct.SamplerState = type { i32 }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

define void @PS() {
  %gDiffuseMap_texture_2d = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 0, i32 0, i32 0, i1 false), !dbg !218 ; line:346 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %gsamAnisotropicClamp_sampler = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 3, i32 0, i32 5, i1 false), !dbg !218 ; line:346 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 1, i32 2, i1 false), !dbg !218 ; line:346 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbMaterial_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 1, i1 false), !dbg !218 ; line:346 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call i32 @dx.op.loadInput.i32(i32 4, i32 5, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %2 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !219, metadata !220), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"PS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !219, metadata !222), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 352, 32) func:"PS"
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !219, metadata !223), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !219, metadata !224), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 2, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !219, metadata !225), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !219, metadata !226), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !219, metadata !227), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  %9 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %9, i64 0, metadata !219, metadata !228), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  %10 = alloca [3 x float], align 4
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !219, metadata !226), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !219, metadata !227), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %9, i64 0, metadata !219, metadata !228), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !219, metadata !223), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !219, metadata !224), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !219, metadata !225), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !219, metadata !220), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !219, metadata !222), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 352, 32) func:"PS"
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !219, metadata !229), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 416, 32) func:"PS"
  %11 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !230 ; line:345 col:12
  %12 = call %dx.types.ResRet.f32 @dx.op.sample.f32(i32 60, %dx.types.Handle %gDiffuseMap_texture_2d, %dx.types.Handle %gsamAnisotropicClamp_sampler, float %2, float %3, float undef, float undef, i32 0, i32 0, i32 undef, float undef), !dbg !218 ; line:346 col:28  ; Sample(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,clamp)
  %13 = extractvalue %dx.types.ResRet.f32 %12, 0, !dbg !218 ; line:346 col:28
  %14 = extractvalue %dx.types.ResRet.f32 %12, 1, !dbg !218 ; line:346 col:28
  %15 = extractvalue %dx.types.ResRet.f32 %12, 2, !dbg !218 ; line:346 col:28
  %16 = extractvalue %dx.types.ResRet.f32 %12, 3, !dbg !218 ; line:346 col:28
  %17 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 0), !dbg !231 ; line:346 col:81  ; CBufferLoadLegacy(handle,regIndex)
  %18 = extractvalue %dx.types.CBufRet.f32 %17, 0, !dbg !231 ; line:346 col:81
  %19 = extractvalue %dx.types.CBufRet.f32 %17, 1, !dbg !231 ; line:346 col:81
  %20 = extractvalue %dx.types.CBufRet.f32 %17, 2, !dbg !231 ; line:346 col:81
  %21 = extractvalue %dx.types.CBufRet.f32 %17, 3, !dbg !231 ; line:346 col:81
  %.i0 = fmul fast float %13, %18, !dbg !232 ; line:346 col:79
  %.i1 = fmul fast float %14, %19, !dbg !232 ; line:346 col:79
  %.i2 = fmul fast float %15, %20, !dbg !232 ; line:346 col:79
  %.i3 = fmul fast float %16, %21, !dbg !232 ; line:346 col:79
  %22 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !233 ; line:346 col:12
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %23 = icmp eq i32 %1, 2, !dbg !239 ; line:348 col:22
  %24 = icmp ne i1 %23, false, !dbg !239 ; line:348 col:22
  %25 = icmp ne i1 %24, false, !dbg !239 ; line:348 col:22
  call void @llvm.dbg.declare(metadata [3 x float]* %10, metadata !241, metadata !242), !dbg !243 ; var:"shadowFactor" !DIExpression() func:"ComputeLighting"
  br i1 %25, label %26, label %30, !dbg !245 ; line:348 col:9

; <label>:26                                      ; preds = %0
  %.i07 = fmul fast float %.i0, 0x3FF2666660000000, !dbg !246 ; line:350 col:27
  %.i19 = fmul fast float %.i1, 0x3FEE666660000000, !dbg !246 ; line:350 col:27
  %.i211 = fmul fast float %.i2, 0x3FEE666660000000, !dbg !246 ; line:350 col:27
  %27 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !246 ; line:350 col:27
  call void @llvm.dbg.value(metadata float %.i07, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %28 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !246 ; line:350 col:27
  call void @llvm.dbg.value(metadata float %.i07, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i19, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %29 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !246 ; line:350 col:27
  call void @llvm.dbg.value(metadata float %.i07, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i19, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i211, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  br label %43, !dbg !248 ; line:351 col:5

; <label>:30                                      ; preds = %0
  %31 = icmp eq i32 %1, 1, !dbg !249 ; line:352 col:27
  %32 = icmp ne i1 %31, false, !dbg !249 ; line:352 col:27
  %33 = icmp ne i1 %32, false, !dbg !249 ; line:352 col:27
  br i1 %33, label %34, label %38, !dbg !251 ; line:352 col:14

; <label>:34                                      ; preds = %30
  %.i013 = fmul fast float %.i0, 0x3FEE666660000000, !dbg !252 ; line:354 col:27
  %.i115 = fmul fast float %.i1, 0x3FF2666660000000, !dbg !252 ; line:354 col:27
  %.i217 = fmul fast float %.i2, 0x3FEE666660000000, !dbg !252 ; line:354 col:27
  %35 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !252 ; line:354 col:27
  call void @llvm.dbg.value(metadata float %.i013, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %36 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !252 ; line:354 col:27
  call void @llvm.dbg.value(metadata float %.i013, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i115, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %37 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !252 ; line:354 col:27
  call void @llvm.dbg.value(metadata float %.i013, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i115, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i217, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  br label %42, !dbg !254 ; line:355 col:5

; <label>:38                                      ; preds = %30
  %.i019 = fmul fast float %.i0, 0x3FEE666660000000, !dbg !255 ; line:358 col:27
  %.i121 = fmul fast float %.i1, 0x3FEE666660000000, !dbg !255 ; line:358 col:27
  %.i223 = fmul fast float %.i2, 0x3FF2666660000000, !dbg !255 ; line:358 col:27
  %39 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !255 ; line:358 col:27
  call void @llvm.dbg.value(metadata float %.i019, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %40 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !255 ; line:358 col:27
  call void @llvm.dbg.value(metadata float %.i019, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i121, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %41 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !255 ; line:358 col:27
  call void @llvm.dbg.value(metadata float %.i019, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i121, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i223, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  br label %42

; <label>:42                                      ; preds = %38, %34
  %diffuseAlbedo.0.i0 = phi float [ %.i013, %34 ], [ %.i019, %38 ]
  %diffuseAlbedo.0.i1 = phi float [ %.i115, %34 ], [ %.i121, %38 ]
  %diffuseAlbedo.0.i2 = phi float [ %.i217, %34 ], [ %.i223, %38 ]
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.0.i0, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.0.i1, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.0.i2, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  br label %43

; <label>:43                                      ; preds = %42, %26
  %diffuseAlbedo.1.i0 = phi float [ %.i07, %26 ], [ %diffuseAlbedo.0.i0, %42 ]
  %diffuseAlbedo.1.i1 = phi float [ %.i19, %26 ], [ %diffuseAlbedo.0.i1, %42 ]
  %diffuseAlbedo.1.i2 = phi float [ %.i211, %26 ], [ %diffuseAlbedo.0.i2, %42 ]
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i0, i64 0, metadata !234, metadata !235), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i1, i64 0, metadata !234, metadata !236), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i2, i64 0, metadata !234, metadata !237), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !234, metadata !238), !dbg !233 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %44 = call float @dx.op.dot3.f32(i32 55, float %4, float %5, float %6, float %4, float %5, float %6), !dbg !257 ; line:361 col:19  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt1 = call float @dx.op.unary.f32(i32 25, float %44), !dbg !257 ; line:361 col:19  ; Rsqrt(value)
  %.i027 = fmul fast float %4, %Rsqrt1, !dbg !257 ; line:361 col:19
  %.i128 = fmul fast float %5, %Rsqrt1, !dbg !257 ; line:361 col:19
  %.i229 = fmul fast float %6, %Rsqrt1, !dbg !257 ; line:361 col:19
  %45 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !258 ; line:361 col:17
  call void @llvm.dbg.value(metadata float %.i027, i64 0, metadata !219, metadata !223), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i128, i64 0, metadata !219, metadata !224), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i229, i64 0, metadata !219, metadata !225), !dbg !221 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  %46 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 24), !dbg !259 ; line:363 col:21  ; CBufferLoadLegacy(handle,regIndex)
  %47 = extractvalue %dx.types.CBufRet.f32 %46, 0, !dbg !259 ; line:363 col:21
  %48 = extractvalue %dx.types.CBufRet.f32 %46, 1, !dbg !259 ; line:363 col:21
  %49 = extractvalue %dx.types.CBufRet.f32 %46, 2, !dbg !259 ; line:363 col:21
  %.i030 = fsub fast float %47, %7, !dbg !260 ; line:363 col:30
  %.i131 = fsub fast float %48, %8, !dbg !260 ; line:363 col:30
  %.i232 = fsub fast float %49, %9, !dbg !260 ; line:363 col:30
  %50 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !261 ; line:363 col:12
  call void @llvm.dbg.value(metadata float %.i030, i64 0, metadata !262, metadata !235), !dbg !261 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i131, i64 0, metadata !262, metadata !236), !dbg !261 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i232, i64 0, metadata !262, metadata !237), !dbg !261 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %51 = fmul fast float %.i030, %.i030, !dbg !263 ; line:364 col:23
  %52 = fmul fast float %.i131, %.i131, !dbg !263 ; line:364 col:23
  %53 = fadd fast float %51, %52, !dbg !263 ; line:364 col:23
  %54 = fmul fast float %.i232, %.i232, !dbg !263 ; line:364 col:23
  %55 = fadd fast float %53, %54, !dbg !263 ; line:364 col:23
  %Sqrt = call float @dx.op.unary.f32(i32 24, float %55), !dbg !263 ; line:364 col:23  ; Sqrt(value)
  %56 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !264 ; line:364 col:11
  call void @llvm.dbg.value(metadata float %Sqrt, i64 0, metadata !265, metadata !242), !dbg !264 ; var:"distToEye" !DIExpression() func:"PS"
  %.i033 = fdiv fast float %.i030, %Sqrt, !dbg !266 ; line:365 col:12
  %.i134 = fdiv fast float %.i131, %Sqrt, !dbg !266 ; line:365 col:12
  %.i235 = fdiv fast float %.i232, %Sqrt, !dbg !266 ; line:365 col:12
  %57 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !266 ; line:365 col:12
  call void @llvm.dbg.value(metadata float %.i033, i64 0, metadata !262, metadata !235), !dbg !261 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i134, i64 0, metadata !262, metadata !236), !dbg !261 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i235, i64 0, metadata !262, metadata !237), !dbg !261 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %58 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 27), !dbg !267 ; line:367 col:22  ; CBufferLoadLegacy(handle,regIndex)
  %59 = extractvalue %dx.types.CBufRet.f32 %58, 0, !dbg !267 ; line:367 col:22
  %60 = extractvalue %dx.types.CBufRet.f32 %58, 1, !dbg !267 ; line:367 col:22
  %61 = extractvalue %dx.types.CBufRet.f32 %58, 2, !dbg !267 ; line:367 col:22
  %.i036 = fmul fast float %59, %diffuseAlbedo.1.i0, !dbg !268 ; line:367 col:36
  %.i137 = fmul fast float %60, %diffuseAlbedo.1.i1, !dbg !268 ; line:367 col:36
  %.i238 = fmul fast float %61, %diffuseAlbedo.1.i2, !dbg !268 ; line:367 col:36
  %62 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !269 ; line:367 col:12
  call void @llvm.dbg.value(metadata float %.i036, i64 0, metadata !270, metadata !235), !dbg !269 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i137, i64 0, metadata !270, metadata !236), !dbg !269 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i238, i64 0, metadata !270, metadata !237), !dbg !269 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %63 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 1), !dbg !271 ; line:369 col:36  ; CBufferLoadLegacy(handle,regIndex)
  %64 = extractvalue %dx.types.CBufRet.f32 %63, 3, !dbg !271 ; line:369 col:36
  %65 = fsub fast float 1.000000e+00, %64, !dbg !272 ; line:369 col:34
  %66 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !273 ; line:369 col:17
  call void @llvm.dbg.value(metadata float %65, i64 0, metadata !274, metadata !242), !dbg !273 ; var:"shininess" !DIExpression() func:"PS"
  %67 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !275 ; line:370 col:20
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i0, i64 0, metadata !276, metadata !235), !dbg !277 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i1, i64 0, metadata !276, metadata !236), !dbg !277 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i2, i64 0, metadata !276, metadata !237), !dbg !277 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !276, metadata !238), !dbg !277 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i0, i64 0, metadata !278, metadata !235), !dbg !279 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i1, i64 0, metadata !278, metadata !236), !dbg !279 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i2, i64 0, metadata !278, metadata !237), !dbg !279 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !278, metadata !238), !dbg !279 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i0, i64 0, metadata !280, metadata !235), !dbg !281 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i1, i64 0, metadata !280, metadata !236), !dbg !281 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i2, i64 0, metadata !280, metadata !237), !dbg !281 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !280, metadata !238), !dbg !281 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i0, i64 0, metadata !286, metadata !235), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i1, i64 0, metadata !286, metadata !236), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %diffuseAlbedo.1.i2, i64 0, metadata !286, metadata !237), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !286, metadata !238), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"BlinnPhong"
  %68 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 1), !dbg !289 ; line:370 col:37  ; CBufferLoadLegacy(handle,regIndex)
  %69 = extractvalue %dx.types.CBufRet.f32 %68, 0, !dbg !289 ; line:370 col:37
  call void @llvm.dbg.value(metadata float %69, i64 0, metadata !290, metadata !235), !dbg !291 ; var:"R0" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  %70 = extractvalue %dx.types.CBufRet.f32 %68, 1, !dbg !289 ; line:370 col:37
  call void @llvm.dbg.value(metadata float %70, i64 0, metadata !290, metadata !236), !dbg !291 ; var:"R0" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  %71 = extractvalue %dx.types.CBufRet.f32 %68, 2, !dbg !289 ; line:370 col:37
  call void @llvm.dbg.value(metadata float %71, i64 0, metadata !290, metadata !237), !dbg !291 ; var:"R0" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %72 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !275 ; line:370 col:20
  call void @llvm.dbg.value(metadata float %69, i64 0, metadata !276, metadata !226), !dbg !277 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %70, i64 0, metadata !276, metadata !227), !dbg !277 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %71, i64 0, metadata !276, metadata !228), !dbg !277 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %69, i64 0, metadata !278, metadata !226), !dbg !279 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %70, i64 0, metadata !278, metadata !227), !dbg !279 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %71, i64 0, metadata !278, metadata !228), !dbg !279 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %69, i64 0, metadata !280, metadata !226), !dbg !281 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %70, i64 0, metadata !280, metadata !227), !dbg !281 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %71, i64 0, metadata !280, metadata !228), !dbg !281 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %69, i64 0, metadata !286, metadata !226), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %70, i64 0, metadata !286, metadata !227), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %71, i64 0, metadata !286, metadata !228), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"BlinnPhong"
  %73 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !275 ; line:370 col:20
  call void @llvm.dbg.value(metadata float %65, i64 0, metadata !276, metadata !223), !dbg !277 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %65, i64 0, metadata !278, metadata !223), !dbg !279 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %65, i64 0, metadata !280, metadata !223), !dbg !281 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %65, i64 0, metadata !286, metadata !223), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"BlinnPhong"
  %74 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:371 col:12
  call void @llvm.dbg.value(metadata <3 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, i64 0, metadata !294, metadata !242), !dbg !293 ; var:"shadowFactor" !DIExpression() func:"PS"
  %75 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !295 ; line:372 col:26
  %76 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !295 ; line:372 col:26
  %77 = getelementptr inbounds [3 x float], [3 x float]* %10, i32 0, i32 0, !dbg !295 ; line:372 col:26
  store float 1.000000e+00, float* %77, align 4, !dbg !295 ; line:372 col:26
  %78 = getelementptr inbounds [3 x float], [3 x float]* %10, i32 0, i32 1, !dbg !295 ; line:372 col:26
  store float 1.000000e+00, float* %78, align 4, !dbg !295 ; line:372 col:26
  %79 = getelementptr inbounds [3 x float], [3 x float]* %10, i32 0, i32 2, !dbg !295 ; line:372 col:26
  store float 1.000000e+00, float* %79, align 4, !dbg !295 ; line:372 col:26
  call void @llvm.dbg.value(metadata float %.i033, i64 0, metadata !296, metadata !235), !dbg !297 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i134, i64 0, metadata !296, metadata !236), !dbg !297 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i235, i64 0, metadata !296, metadata !237), !dbg !297 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i027, i64 0, metadata !298, metadata !235), !dbg !299 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i128, i64 0, metadata !298, metadata !236), !dbg !299 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i229, i64 0, metadata !298, metadata !237), !dbg !299 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %80 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !300 ; line:145 col:12
  call void @llvm.dbg.value(metadata <3 x float> zeroinitializer, i64 0, metadata !301, metadata !242), !dbg !300 ; var:"result" !DIExpression() func:"ComputeLighting"
  %81 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !302 ; line:146 col:9
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !303, metadata !242), !dbg !302 ; var:"i" !DIExpression() func:"ComputeLighting"
  %82 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !304 ; line:149 col:11
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !303, metadata !242), !dbg !302 ; var:"i" !DIExpression() func:"ComputeLighting"
  br label %.lr.ph, !dbg !305 ; line:149 col:5

.lr.ph:                                           ; preds = %43
  br label %83, !dbg !305 ; line:149 col:5

; <label>:83                                      ; preds = %83, %.lr.ph
  %result.i.0.i0 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i040, %83 ]
  %result.i.0.i1 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i141, %83 ]
  %result.i.0.i2 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i242, %83 ]
  %i.i.0 = phi i32 [ 0, %.lr.ph ], [ %132, %83 ]
  call void @llvm.dbg.value(metadata i32 %i.i.0, i64 0, metadata !303, metadata !242), !dbg !302 ; var:"i" !DIExpression() func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i0, i64 0, metadata !301, metadata !235), !dbg !300 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i1, i64 0, metadata !301, metadata !236), !dbg !300 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i2, i64 0, metadata !301, metadata !237), !dbg !300 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %84 = getelementptr [3 x float], [3 x float]* %10, i32 0, i32 %i.i.0, !dbg !306 ; line:151 col:19
  %85 = load float, float* %84, !dbg !306 ; line:151 col:19
  %86 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !307 ; line:151 col:37
  %87 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !307 ; line:151 col:37
  %88 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !307 ; line:151 col:37
  call void @llvm.dbg.value(metadata float %.i033, i64 0, metadata !308, metadata !235), !dbg !309 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i134, i64 0, metadata !308, metadata !236), !dbg !309 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i235, i64 0, metadata !308, metadata !237), !dbg !309 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i027, i64 0, metadata !310, metadata !235), !dbg !311 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i128, i64 0, metadata !310, metadata !236), !dbg !311 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i229, i64 0, metadata !310, metadata !237), !dbg !311 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %89 = mul i32 %i.i.0, 3, !dbg !312 ; line:88 col:26
  %90 = add i32 28, %89, !dbg !312 ; line:88 col:26
  %91 = add i32 %90, 1, !dbg !312 ; line:88 col:26
  %92 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 %91), !dbg !312 ; line:88 col:26  ; CBufferLoadLegacy(handle,regIndex)
  %93 = extractvalue %dx.types.CBufRet.f32 %92, 0, !dbg !312 ; line:88 col:26
  %94 = extractvalue %dx.types.CBufRet.f32 %92, 1, !dbg !312 ; line:88 col:26
  %95 = extractvalue %dx.types.CBufRet.f32 %92, 2, !dbg !312 ; line:88 col:26
  %.i044 = fsub fast float -0.000000e+00, %93, !dbg !313 ; line:88 col:23
  %.i146 = fsub fast float -0.000000e+00, %94, !dbg !313 ; line:88 col:23
  %.i248 = fsub fast float -0.000000e+00, %95, !dbg !313 ; line:88 col:23
  %96 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !314 ; line:88 col:12
  call void @llvm.dbg.value(metadata float %.i044, i64 0, metadata !315, metadata !235), !dbg !314 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i146, i64 0, metadata !315, metadata !236), !dbg !314 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i248, i64 0, metadata !315, metadata !237), !dbg !314 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %97 = call float @dx.op.dot3.f32(i32 55, float %.i044, float %.i146, float %.i248, float %.i027, float %.i128, float %.i229), !dbg !316 ; line:91 col:23  ; Dot3(ax,ay,az,bx,by,bz)
  %FMax5 = call float @dx.op.binary.f32(i32 35, float %97, float 0.000000e+00), !dbg !317 ; line:91 col:19  ; FMax(a,b)
  %98 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !318 ; line:91 col:11
  call void @llvm.dbg.value(metadata float %FMax5, i64 0, metadata !319, metadata !242), !dbg !318 ; var:"ndotl" !DIExpression() func:"ComputeDirectionalLight"
  %99 = mul i32 %i.i.0, 3, !dbg !320 ; line:92 col:30
  %100 = add i32 28, %99, !dbg !320 ; line:92 col:30
  %101 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 %100), !dbg !320 ; line:92 col:30  ; CBufferLoadLegacy(handle,regIndex)
  %102 = extractvalue %dx.types.CBufRet.f32 %101, 0, !dbg !320 ; line:92 col:30
  %103 = extractvalue %dx.types.CBufRet.f32 %101, 1, !dbg !320 ; line:92 col:30
  %104 = extractvalue %dx.types.CBufRet.f32 %101, 2, !dbg !320 ; line:92 col:30
  %.i049 = fmul fast float %102, %FMax5, !dbg !321 ; line:92 col:39
  %.i150 = fmul fast float %103, %FMax5, !dbg !321 ; line:92 col:39
  %.i251 = fmul fast float %104, %FMax5, !dbg !321 ; line:92 col:39
  %105 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !322 ; line:92 col:12
  call void @llvm.dbg.value(metadata float %.i049, i64 0, metadata !323, metadata !235), !dbg !322 ; var:"lightStrenght" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i150, i64 0, metadata !323, metadata !236), !dbg !322 ; var:"lightStrenght" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i251, i64 0, metadata !323, metadata !237), !dbg !322 ; var:"lightStrenght" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %106 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !324 ; line:94 col:12
  %107 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !324 ; line:94 col:12
  call void @llvm.dbg.value(metadata float %.i033, i64 0, metadata !325, metadata !235), !dbg !326 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i134, i64 0, metadata !325, metadata !236), !dbg !326 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i235, i64 0, metadata !325, metadata !237), !dbg !326 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i027, i64 0, metadata !327, metadata !235), !dbg !328 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i128, i64 0, metadata !327, metadata !236), !dbg !328 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i229, i64 0, metadata !327, metadata !237), !dbg !328 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i044, i64 0, metadata !329, metadata !235), !dbg !330 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i146, i64 0, metadata !329, metadata !236), !dbg !330 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i248, i64 0, metadata !329, metadata !237), !dbg !330 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i049, i64 0, metadata !331, metadata !235), !dbg !332 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i150, i64 0, metadata !331, metadata !236), !dbg !332 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i251, i64 0, metadata !331, metadata !237), !dbg !332 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %108 = fmul fast float %65, 2.560000e+02, !dbg !333 ; line:70 col:35
  %109 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !334 ; line:70 col:17
  call void @llvm.dbg.value(metadata float %108, i64 0, metadata !335, metadata !242), !dbg !334 ; var:"m" !DIExpression() func:"BlinnPhong"
  %.i052 = fadd fast float %.i033, %.i044, !dbg !336 ; line:71 col:38
  %.i153 = fadd fast float %.i134, %.i146, !dbg !336 ; line:71 col:38
  %.i254 = fadd fast float %.i235, %.i248, !dbg !336 ; line:71 col:38
  %110 = call float @dx.op.dot3.f32(i32 55, float %.i052, float %.i153, float %.i254, float %.i052, float %.i153, float %.i254), !dbg !337 ; line:71 col:22  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt = call float @dx.op.unary.f32(i32 25, float %110), !dbg !337 ; line:71 col:22  ; Rsqrt(value)
  %.i055 = fmul fast float %.i052, %Rsqrt, !dbg !337 ; line:71 col:22
  %.i156 = fmul fast float %.i153, %Rsqrt, !dbg !337 ; line:71 col:22
  %.i257 = fmul fast float %.i254, %Rsqrt, !dbg !337 ; line:71 col:22
  %111 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !338 ; line:71 col:12
  call void @llvm.dbg.value(metadata float %.i055, i64 0, metadata !339, metadata !235), !dbg !338 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i156, i64 0, metadata !339, metadata !236), !dbg !338 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i257, i64 0, metadata !339, metadata !237), !dbg !338 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %112 = fadd fast float %108, 8.000000e+00, !dbg !340 ; line:73 col:32
  %113 = call float @dx.op.dot3.f32(i32 55, float %.i055, float %.i156, float %.i257, float %.i027, float %.i128, float %.i229), !dbg !341 ; line:73 col:50  ; Dot3(ax,ay,az,bx,by,bz)
  %FMax = call float @dx.op.binary.f32(i32 35, float %113, float 0.000000e+00), !dbg !342 ; line:73 col:46  ; FMax(a,b)
  %Log3 = call float @dx.op.unary.f32(i32 23, float %FMax), !dbg !343 ; line:73 col:42  ; Log(value)
  %114 = fmul fast float %Log3, %108, !dbg !343 ; line:73 col:42
  %Exp4 = call float @dx.op.unary.f32(i32 21, float %114), !dbg !343 ; line:73 col:42  ; Exp(value)
  %115 = fmul fast float %112, %Exp4, !dbg !344 ; line:73 col:40
  %116 = fdiv fast float %115, 8.000000e+00, !dbg !345 ; line:73 col:82
  %117 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !346 ; line:73 col:11
  call void @llvm.dbg.value(metadata float %116, i64 0, metadata !347, metadata !242), !dbg !346 ; var:"roughnessFactor" !DIExpression() func:"BlinnPhong"
  %118 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !348 ; line:74 col:28
  call void @llvm.dbg.value(metadata float %.i044, i64 0, metadata !349, metadata !235), !dbg !350 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i146, i64 0, metadata !349, metadata !236), !dbg !350 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i248, i64 0, metadata !349, metadata !237), !dbg !350 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i055, i64 0, metadata !351, metadata !235), !dbg !352 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i156, i64 0, metadata !351, metadata !236), !dbg !352 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i257, i64 0, metadata !351, metadata !237), !dbg !352 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %69, i64 0, metadata !290, metadata !235), !dbg !291 ; var:"R0" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %70, i64 0, metadata !290, metadata !236), !dbg !291 ; var:"R0" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %71, i64 0, metadata !290, metadata !237), !dbg !291 ; var:"R0" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %119 = call float @dx.op.dot3.f32(i32 55, float %.i055, float %.i156, float %.i257, float %.i044, float %.i146, float %.i248), !dbg !353 ; line:61 col:39  ; Dot3(ax,ay,az,bx,by,bz)
  %Saturate = call float @dx.op.unary.f32(i32 7, float %119), !dbg !354 ; line:61 col:30  ; Saturate(value)
  %120 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !355 ; line:61 col:11
  call void @llvm.dbg.value(metadata float %Saturate, i64 0, metadata !356, metadata !242), !dbg !355 ; var:"cosIncidentAngle" !DIExpression() func:"SchlickFresnel"
  %121 = fsub fast float 1.000000e+00, %Saturate, !dbg !357 ; line:62 col:21
  %122 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !358 ; line:62 col:11
  call void @llvm.dbg.value(metadata float %121, i64 0, metadata !359, metadata !242), !dbg !358 ; var:"f0" !DIExpression() func:"SchlickFresnel"
  %.i059 = fsub fast float 1.000000e+00, %69, !dbg !360 ; line:63 col:40
  %.i161 = fsub fast float 1.000000e+00, %70, !dbg !360 ; line:63 col:40
  %.i263 = fsub fast float 1.000000e+00, %71, !dbg !360 ; line:63 col:40
  %Log = call float @dx.op.unary.f32(i32 23, float %121), !dbg !361 ; line:63 col:48  ; Log(value)
  %123 = fmul fast float %Log, 5.000000e+00, !dbg !361 ; line:63 col:48
  %Exp = call float @dx.op.unary.f32(i32 21, float %123), !dbg !361 ; line:63 col:48  ; Exp(value)
  %.i064 = fmul fast float %.i059, %Exp, !dbg !362 ; line:63 col:46
  %.i165 = fmul fast float %.i161, %Exp, !dbg !362 ; line:63 col:46
  %.i266 = fmul fast float %.i263, %Exp, !dbg !362 ; line:63 col:46
  %.i067 = fadd fast float %69, %.i064, !dbg !363 ; line:63 col:32
  %.i168 = fadd fast float %70, %.i165, !dbg !363 ; line:63 col:32
  %.i269 = fadd fast float %71, %.i266, !dbg !363 ; line:63 col:32
  %124 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !364 ; line:63 col:12
  call void @llvm.dbg.value(metadata float %.i067, i64 0, metadata !365, metadata !235), !dbg !364 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i168, i64 0, metadata !365, metadata !236), !dbg !364 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i269, i64 0, metadata !365, metadata !237), !dbg !364 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %125 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !366 ; line:65 col:5
  %126 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !367 ; line:74 col:12
  call void @llvm.dbg.value(metadata float %.i067, i64 0, metadata !368, metadata !235), !dbg !367 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i168, i64 0, metadata !368, metadata !236), !dbg !367 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i269, i64 0, metadata !368, metadata !237), !dbg !367 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i070 = fmul fast float %.i067, %116, !dbg !369 ; line:76 col:39
  %.i171 = fmul fast float %.i168, %116, !dbg !369 ; line:76 col:39
  %.i272 = fmul fast float %.i269, %116, !dbg !369 ; line:76 col:39
  %127 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !370 ; line:76 col:12
  call void @llvm.dbg.value(metadata float %.i070, i64 0, metadata !371, metadata !235), !dbg !370 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i171, i64 0, metadata !371, metadata !236), !dbg !370 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i272, i64 0, metadata !371, metadata !237), !dbg !370 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i074 = fadd fast float %.i070, 1.000000e+00, !dbg !372 ; line:80 col:43
  %.i176 = fadd fast float %.i171, 1.000000e+00, !dbg !372 ; line:80 col:43
  %.i278 = fadd fast float %.i272, 1.000000e+00, !dbg !372 ; line:80 col:43
  %.i079 = fdiv fast float %.i070, %.i074, !dbg !373 ; line:80 col:29
  %.i180 = fdiv fast float %.i171, %.i176, !dbg !373 ; line:80 col:29
  %.i281 = fdiv fast float %.i272, %.i278, !dbg !373 ; line:80 col:29
  %128 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !374 ; line:80 col:16
  call void @llvm.dbg.value(metadata float %.i079, i64 0, metadata !371, metadata !235), !dbg !370 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i180, i64 0, metadata !371, metadata !236), !dbg !370 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i281, i64 0, metadata !371, metadata !237), !dbg !370 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i082 = fadd fast float %diffuseAlbedo.1.i0, %.i079, !dbg !375 ; line:82 col:35
  %.i183 = fadd fast float %diffuseAlbedo.1.i1, %.i180, !dbg !375 ; line:82 col:35
  %.i284 = fadd fast float %diffuseAlbedo.1.i2, %.i281, !dbg !375 ; line:82 col:35
  %.i085 = fmul fast float %.i082, %.i049, !dbg !376 ; line:82 col:49
  %.i186 = fmul fast float %.i183, %.i150, !dbg !376 ; line:82 col:49
  %.i287 = fmul fast float %.i284, %.i251, !dbg !376 ; line:82 col:49
  %129 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !377 ; line:82 col:5
  %130 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !378 ; line:94 col:5
  %.i088 = fmul fast float %85, %.i085, !dbg !379 ; line:151 col:35
  %.i189 = fmul fast float %85, %.i186, !dbg !379 ; line:151 col:35
  %.i290 = fmul fast float %85, %.i287, !dbg !379 ; line:151 col:35
  %.i040 = fadd fast float %result.i.0.i0, %.i088, !dbg !380 ; line:151 col:16
  %.i141 = fadd fast float %result.i.0.i1, %.i189, !dbg !380 ; line:151 col:16
  %.i242 = fadd fast float %result.i.0.i2, %.i290, !dbg !380 ; line:151 col:16
  %131 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !380 ; line:151 col:16
  call void @llvm.dbg.value(metadata float %.i040, i64 0, metadata !301, metadata !235), !dbg !300 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i141, i64 0, metadata !301, metadata !236), !dbg !300 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i242, i64 0, metadata !301, metadata !237), !dbg !300 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %132 = add nsw i32 %i.i.0, 1, !dbg !381 ; line:149 col:36
  %133 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !381 ; line:149 col:36
  call void @llvm.dbg.value(metadata i32 %132, i64 0, metadata !303, metadata !242), !dbg !302 ; var:"i" !DIExpression() func:"ComputeLighting"
  %134 = icmp slt i32 %132, 3, !dbg !382 ; line:149 col:18
  br i1 %134, label %83, label %".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge", !dbg !305 ; line:149 col:5

".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge": ; preds = %83
  br label %"\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit", !dbg !305 ; line:149 col:5

"\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit": ; preds = %".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge"
  call void @llvm.dbg.value(metadata float %.i040, i64 0, metadata !301, metadata !235), !dbg !300 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i141, i64 0, metadata !301, metadata !236), !dbg !300 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i242, i64 0, metadata !301, metadata !237), !dbg !300 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %135 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !383 ; line:169 col:5
  %136 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !384 ; line:372 col:12
  call void @llvm.dbg.value(metadata float %.i040, i64 0, metadata !385, metadata !235), !dbg !384 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i141, i64 0, metadata !385, metadata !236), !dbg !384 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i242, i64 0, metadata !385, metadata !237), !dbg !384 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !385, metadata !238), !dbg !384 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %.i094 = fadd fast float %.i036, %.i040, !dbg !386 ; line:375 col:31
  %.i195 = fadd fast float %.i137, %.i141, !dbg !386 ; line:375 col:31
  %.i296 = fadd fast float %.i238, %.i242, !dbg !386 ; line:375 col:31
  %137 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !387 ; line:375 col:12
  call void @llvm.dbg.value(metadata float %.i094, i64 0, metadata !388, metadata !235), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i195, i64 0, metadata !388, metadata !236), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i296, i64 0, metadata !388, metadata !237), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %138 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 77), !dbg !389 ; line:378 col:42  ; CBufferLoadLegacy(handle,regIndex)
  %139 = extractvalue %dx.types.CBufRet.f32 %138, 0, !dbg !389 ; line:378 col:42
  %140 = fsub fast float %Sqrt, %139, !dbg !390 ; line:378 col:40
  %141 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 77), !dbg !391 ; line:378 col:55  ; CBufferLoadLegacy(handle,regIndex)
  %142 = extractvalue %dx.types.CBufRet.f32 %141, 1, !dbg !391 ; line:378 col:55
  %143 = fdiv fast float %140, %142, !dbg !392 ; line:378 col:53
  %Saturate2 = call float @dx.op.unary.f32(i32 7, float %143), !dbg !393 ; line:378 col:20  ; Saturate(value)
  %144 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !394 ; line:378 col:8
  call void @llvm.dbg.value(metadata float %Saturate2, i64 0, metadata !395, metadata !242), !dbg !394 ; var:"fogAmount" !DIExpression() func:"PS"
  %145 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 76), !dbg !396 ; line:379 col:28  ; CBufferLoadLegacy(handle,regIndex)
  %146 = extractvalue %dx.types.CBufRet.f32 %145, 0, !dbg !396 ; line:379 col:28
  %147 = extractvalue %dx.types.CBufRet.f32 %145, 1, !dbg !396 ; line:379 col:28
  %148 = extractvalue %dx.types.CBufRet.f32 %145, 2, !dbg !396 ; line:379 col:28
  %.i098 = fsub fast float %146, %.i094, !dbg !397 ; line:379 col:13
  %.i199 = fsub fast float %147, %.i195, !dbg !397 ; line:379 col:13
  %.i2100 = fsub fast float %148, %.i296, !dbg !397 ; line:379 col:13
  %.i0102 = fmul fast float %Saturate2, %.i098, !dbg !397 ; line:379 col:13
  %.i1103 = fmul fast float %Saturate2, %.i199, !dbg !397 ; line:379 col:13
  %.i2104 = fmul fast float %Saturate2, %.i2100, !dbg !397 ; line:379 col:13
  %.i0106 = fadd fast float %.i094, %.i0102, !dbg !397 ; line:379 col:13
  %.i1107 = fadd fast float %.i195, %.i1103, !dbg !397 ; line:379 col:13
  %.i2108 = fadd fast float %.i296, %.i2104, !dbg !397 ; line:379 col:13
  %149 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !398 ; line:379 col:11
  call void @llvm.dbg.value(metadata float %.i0106, i64 0, metadata !388, metadata !235), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1107, i64 0, metadata !388, metadata !236), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2108, i64 0, metadata !388, metadata !237), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %150 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !399 ; line:382 col:16
  call void @llvm.dbg.value(metadata float %.i0106, i64 0, metadata !388, metadata !235), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1107, i64 0, metadata !388, metadata !236), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2108, i64 0, metadata !388, metadata !237), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !388, metadata !238), !dbg !387 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %151 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !400 ; line:384 col:5
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %.i0106), !dbg !400 ; line:384 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %.i1107), !dbg !400 ; line:384 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %.i2108), !dbg !400 ; line:384 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %.i3), !dbg !400 ; line:384 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  ret void, !dbg !400 ; line:384 col:5
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare float @dx.op.loadInput.f32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind readnone
declare i32 @dx.op.loadInput.i32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #1

; Function Attrs: nounwind readonly
declare %dx.types.ResRet.f32 @dx.op.sample.f32(i32, %dx.types.Handle, %dx.types.Handle, float, float, float, float, i32, i32, i32, float) #2

; Function Attrs: nounwind readnone
declare float @dx.op.dot3.f32(i32, float, float, float, float, float, float) #0

; Function Attrs: nounwind readnone
declare float @dx.op.unary.f32(i32, float) #0

; Function Attrs: nounwind readnone
declare float @dx.op.binary.f32(i32, float, float) #0

; Function Attrs: nounwind readonly
declare %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32, %dx.types.Handle, i32) #2

; Function Attrs: nounwind readonly
declare %dx.types.Handle @dx.op.createHandle(i32, i8, i32, i32, i1) #2

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }
attributes #2 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!141, !142}
!llvm.ident = !{!143}
!dx.source.contents = !{!144, !145}
!dx.source.defines = !{!146}
!dx.source.mainFileName = !{!147}
!dx.source.args = !{!148}
!dx.version = !{!149}
!dx.valver = !{!150}
!dx.shaderModel = !{!151}
!dx.resources = !{!152}
!dx.typeAnnotations = !{!161, !196}
!dx.viewIdState = !{!199}
!dx.entryPoints = !{!200}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !24, globals: !74)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CTask_GS.hlsl", directory: "")
!2 = !{}
!3 = !{!4, !15}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 33, baseType: !5)
!5 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 33, size: 96, align: 32, elements: !6, templateParams: !11)
!6 = !{!7, !9, !10}
!7 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !5, file: !1, line: 33, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!8 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!9 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !5, file: !1, line: 33, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!10 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !5, file: !1, line: 33, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!11 = !{!12, !13}
!12 = !DITemplateTypeParameter(name: "element", type: !8)
!13 = !DITemplateValueParameter(name: "element_count", type: !14, value: i32 3)
!14 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 32, baseType: !16)
!16 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 32, size: 128, align: 32, elements: !17, templateParams: !22)
!17 = !{!18, !19, !20, !21}
!18 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !16, file: !1, line: 32, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !16, file: !1, line: 32, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !16, file: !1, line: 32, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !16, file: !1, line: 32, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!22 = !{!12, !23}
!23 = !DITemplateValueParameter(name: "element_count", type: !14, value: i32 4)
!24 = !{!25, !45, !65, !68, !71}
!25 = !DISubprogram(name: "PS", scope: !1, file: !1, line: 343, type: !26, isLocal: false, isDefinition: true, scopeLine: 344, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @PS)
!26 = !DISubroutineType(types: !27)
!27 = !{!15, !28}
!28 = !DICompositeType(tag: DW_TAG_structure_type, name: "GeoOut", file: !1, line: 85, size: 448, align: 32, elements: !29)
!29 = !{!30, !31, !32, !33, !41, !44}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !28, file: !1, line: 87, baseType: !15, size: 128, align: 32)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !28, file: !1, line: 88, baseType: !4, size: 96, align: 32, offset: 128)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !28, file: !1, line: 89, baseType: !4, size: 96, align: 32, offset: 224)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !28, file: !1, line: 90, baseType: !34, size: 64, align: 32, offset: 320)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 48, baseType: !35)
!35 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 48, size: 64, align: 32, elements: !36, templateParams: !39)
!36 = !{!37, !38}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !35, file: !1, line: 48, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !35, file: !1, line: 48, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!39 = !{!12, !40}
!40 = !DITemplateValueParameter(name: "element_count", type: !14, value: i32 2)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "PrimID", scope: !28, file: !1, line: 91, baseType: !42, size: 32, align: 32, offset: 384)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 61, baseType: !43)
!43 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "LODLevel", scope: !28, file: !1, line: 92, baseType: !42, size: 32, align: 32, offset: 416)
!45 = !DISubprogram(name: "ComputeLighting", linkageName: "\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z", scope: !46, file: !46, line: 143, type: !47, isLocal: false, isDefinition: true, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!46 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!47 = !DISubroutineType(types: !48)
!48 = !{!15, !49, !60, !4, !4, !4, !4}
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 6144, align: 32, elements: !58)
!50 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !46, line: 3, size: 384, align: 32, elements: !51)
!51 = !{!52, !53, !54, !55, !56, !57}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !50, file: !46, line: 5, baseType: !4, size: 96, align: 32)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !50, file: !46, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !50, file: !46, line: 7, baseType: !4, size: 96, align: 32, offset: 128)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !50, file: !46, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !50, file: !46, line: 9, baseType: !4, size: 96, align: 32, offset: 256)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !50, file: !46, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!58 = !{!59}
!59 = !DISubrange(count: 16)
!60 = !DICompositeType(tag: DW_TAG_structure_type, name: "Material", file: !46, line: 13, size: 256, align: 32, elements: !61)
!61 = !{!62, !63, !64}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "DiffuseAlbedo", scope: !60, file: !46, line: 15, baseType: !15, size: 128, align: 32)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "FresnelR0", scope: !60, file: !46, line: 16, baseType: !4, size: 96, align: 32, offset: 128)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "Shininess", scope: !60, file: !46, line: 17, baseType: !8, size: 32, align: 32, offset: 224)
!65 = !DISubprogram(name: "ComputeDirectionalLight", linkageName: "\01?ComputeDirectionalLight@@YA?AV?$vector@M$02@@ULight@@UMaterial@@V1@2@Z", scope: !46, file: !46, line: 85, type: !66, isLocal: false, isDefinition: true, scopeLine: 86, flags: DIFlagPrototyped, isOptimized: false)
!66 = !DISubroutineType(types: !67)
!67 = !{!4, !50, !60, !4, !4}
!68 = !DISubprogram(name: "BlinnPhong", linkageName: "\01?BlinnPhong@@YA?AV?$vector@M$02@@V1@000UMaterial@@@Z", scope: !46, file: !46, line: 68, type: !69, isLocal: false, isDefinition: true, scopeLine: 69, flags: DIFlagPrototyped, isOptimized: false)
!69 = !DISubroutineType(types: !70)
!70 = !{!4, !4, !4, !4, !4, !60}
!71 = !DISubprogram(name: "SchlickFresnel", linkageName: "\01?SchlickFresnel@@YA?AV?$vector@M$02@@V1@00@Z", scope: !46, file: !46, line: 59, type: !72, isLocal: false, isDefinition: true, scopeLine: 60, flags: DIFlagPrototyped, isOptimized: false)
!72 = !DISubroutineType(types: !73)
!73 = !{!4, !4, !4, !4}
!74 = !{!75, !99, !100, !102, !104, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !117, !118, !119, !120, !121, !122, !123, !126, !127, !128, !129, !130, !134, !136, !137, !138, !139, !140}
!75 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 26, type: !76, isLocal: false, isDefinition: true)
!76 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !77)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 26, baseType: !78)
!78 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 26, size: 512, align: 32, elements: !79, templateParams: !96)
!79 = !{!80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !78, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!96 = !{!12, !97, !98}
!97 = !DITemplateValueParameter(name: "row_count", type: !14, value: i32 4)
!98 = !DITemplateValueParameter(name: "col_count", type: !14, value: i32 4)
!99 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 27, type: !76, isLocal: false, isDefinition: true)
!100 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 32, type: !101, isLocal: false, isDefinition: true)
!101 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!102 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 33, type: !103, isLocal: false, isDefinition: true)
!103 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!104 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 34, type: !105, isLocal: false, isDefinition: true)
!105 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!106 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 35, type: !76, isLocal: false, isDefinition: true)
!107 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 40, type: !76, isLocal: false, isDefinition: true)
!108 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 41, type: !76, isLocal: false, isDefinition: true)
!109 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !76, isLocal: false, isDefinition: true)
!110 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 43, type: !76, isLocal: false, isDefinition: true)
!111 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 44, type: !76, isLocal: false, isDefinition: true)
!112 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 45, type: !76, isLocal: false, isDefinition: true)
!113 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 46, type: !103, isLocal: false, isDefinition: true)
!114 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPass@@3MB", scope: !0, file: !1, line: 47, type: !105, isLocal: false, isDefinition: true)
!115 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 48, type: !116, isLocal: false, isDefinition: true)
!116 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!117 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 49, type: !116, isLocal: false, isDefinition: true)
!118 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 50, type: !105, isLocal: false, isDefinition: true)
!119 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 51, type: !105, isLocal: false, isDefinition: true)
!120 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 52, type: !105, isLocal: false, isDefinition: true)
!121 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 53, type: !105, isLocal: false, isDefinition: true)
!122 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 54, type: !101, isLocal: false, isDefinition: true)
!123 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 56, type: !124, isLocal: false, isDefinition: true)
!124 = !DICompositeType(tag: DW_TAG_array_type, baseType: !125, size: 6144, align: 32, elements: !58)
!125 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !50)
!126 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 58, type: !101, isLocal: false, isDefinition: true)
!127 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 59, type: !105, isLocal: false, isDefinition: true)
!128 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 60, type: !105, isLocal: false, isDefinition: true)
!129 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 61, type: !116, isLocal: false, isDefinition: true)
!130 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 15, type: !131, isLocal: false, isDefinition: true)
!131 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 15, size: 160, align: 32, elements: !2, templateParams: !132)
!132 = !{!133}
!133 = !DITemplateTypeParameter(name: "element", type: !16)
!134 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 17, type: !135, isLocal: false, isDefinition: true)
!135 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 17, size: 32, align: 32, elements: !2)
!136 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 18, type: !135, isLocal: false, isDefinition: true)
!137 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 19, type: !135, isLocal: false, isDefinition: true)
!138 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 20, type: !135, isLocal: false, isDefinition: true)
!139 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !135, isLocal: false, isDefinition: true)
!140 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !135, isLocal: false, isDefinition: true)
!141 = !{i32 2, !"Dwarf Version", i32 4}
!142 = !{i32 2, !"Debug Info Version", i32 3}
!143 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!144 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CTask_GS.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerObjectPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct SubVertex\0D\0A{\0D\0A    float3 PosW;\0D\0A    float3 NormalW;\0D\0A    float2 TexC;\0D\0A};\0D\0A\0D\0Astruct GeoOut\0D\0A{\0D\0A    float4 PosH : SV_POSITION;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A    uint PrimID : SV_PrimitiveID;\0D\0A    nointerpolation uint LODLevel : TEXCOORD1;\0D\0A};\0D\0A\0D\0ASubVertex MakeMidVertex(SubVertex a, SubVertex b, float3 centerW, float radius)\0D\0A{\0D\0A    SubVertex r;\0D\0A\0D\0A    float3 p = 0.5f * (a.PosW + b.PosW);\0D\0A    p = centerW + normalize(p - centerW) * radius;\0D\0A\0D\0A    r.PosW = p;\0D\0A    r.NormalW = normalize(r.PosW - centerW);\0D\0A    r.TexC = 0.5f * (a.TexC + b.TexC);\0D\0A\0D\0A    return r;\0D\0A}\0D\0A\0D\0Avoid EmitTriangle(SubVertex a, SubVertex b, SubVertex c, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    GeoOut gout;\0D\0A\0D\0A    gout.PosW = a.PosW;\0D\0A    gout.PosH = mul(float4(a.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = a.NormalW;\0D\0A    gout.TexC = a.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    gout.PosW = b.PosW;\0D\0A    gout.PosH = mul(float4(b.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = b.NormalW;\0D\0A    gout.TexC = b.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    gout.PosW = c.PosW;\0D\0A    gout.PosH = mul(float4(c.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = c.NormalW;\0D\0A    gout.TexC = c.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    triStream.RestartStrip();\0D\0A}\0D\0A\0D\0Avoid SubdivideOnce(SubVertex v0, SubVertex v1, SubVertex v2, float3 centerW, float radius, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);\0D\0A    SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);\0D\0A    SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);\0D\0A\0D\0A    EmitTriangle(v0, m0, m2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m0, m1, m2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m2, m1, v2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m0, v1, m1, primID, lodLevel, triStream);\0D\0A}\0D\0A\0D\0A//\B1\D7\B3\C9 \C6\D0\BD\BA\BD\BA\B7\E7 \BC\CE\C0\CC\B4\F5.\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout;\0D\0A    \0D\0A    float4 posW = mul(float4(vin.PosW, 1.0f), gWorld);\0D\0A    vout.PosW = posW.xyz;\0D\0A    vout.NormalW = mul(vin.NormalL, (float3x3) gWorld);\0D\0A    vout.TexC = vin.TexC;\0D\0A\0D\0A    return vout;\0D\0A}\0D\0A \0D\0A[maxvertexcount(4)]\0D\0Avoid GS(line VertexOut gin[2],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    float3 up = float3(0.0f, 1.0f, 0.0f);\0D\0A    float3 look = gEyePosW - gin[0].PosW;\0D\0A    look.y = 0.0f; //project to xz-plane\0D\0A    look = normalize(look);\0D\0A    float3 right = cross(up, look);\0D\0A\0D\0A    //float halfWidth = 0.5f * gin[0].SizeW.x;\0D\0A    //float halfHeight = 0.5f * gin[0].SizeW.y;\0D\0A\09\0D\0A    float4 v[4];\0D\0A    v[0] = float4(gin[0].PosW, 1.0f);\0D\0A    v[1] = float4(gin[1].PosW, 1.0f);\0D\0A    v[2] = float4(gin[0].PosW + up * 3.0f, 1.0f);\0D\0A    v[3] = float4(gin[1].PosW + up * 3.0f, 1.0f);\0D\0A    \0D\0A    float2 texC[4] =\0D\0A    {\0D\0A        float2(0.0f, 1.0f),\0D\0A\09\09float2(0.0f, 0.0f),\0D\0A\09\09float2(1.0f, 1.0f),\0D\0A\09\09float2(1.0f, 0.0f)\0D\0A    };\0D\0A\09\0D\0A    GeoOut gout;\0D\0A\09[unroll]//\C4\C4\C6\C4\C0\CF\C7\D2 \B6\A7 \B7\E7\C7\C1\B8\A6 \C7\AE\BE\EE\BC\AD \B0\A2 \B9\DD\BA\B9\B8\B6\B4\D9 \BA\B0\B5\B5\C0\C7 \B8\ED\B7\C9\BE\EE\B7\CE \B8\B8\B5\E9\BE\EE\C1\D8\B4\D9. \C0\CC\B7\B8\B0\D4 \C7\CF\B8\E9 GPU\B0\A1 \B8\ED\B7\C9\BE\EE\B8\A6 \B4\F5 \C8\BF\C0\B2\C0\FB\C0\B8\B7\CE \BD\C7\C7\E0\C7\D2 \BC\F6 \C0\D6\B4\D9.\0D\0A    for (int i = 0; i < 4; ++i)\0D\0A    {\0D\0A        gout.PosH = mul(v[i], gViewProj);\0D\0A        gout.PosW = v[i].xyz;\0D\0A        gout.NormalW = look;\0D\0A        gout.TexC = texC[i];\0D\0A        gout.PrimID = primID;\0D\0A        gout.LODLevel = 0;\0D\0A\09\09\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A}\0D\0A\0D\0A\0D\0A[maxvertexcount(48)]\0D\0Avoid GS_LOD(triangle VertexOut gin[3],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    float3 center = (gin[0].PosW + gin[1].PosW + gin[2].PosW) / 3.0f;\0D\0A    float distToEye = distance(gEyePosW, center);\0D\0A    \0D\0A    float3 centerW = mul(float4(0, 0, 0, 1), gWorld).xyz; // \B1\B8 \C1\DF\BD\C9\C0\C7 \BF\F9\B5\E5\C1\C2\C7\A5\0D\0A    float radius = length(gin[0].PosW - centerW);\0D\0A    \0D\0A    SubVertex v0, v1, v2;\0D\0A    v0.PosW = gin[0].PosW;\0D\0A    v0.NormalW = gin[0].NormalW;\0D\0A    v0.TexC = gin[0].TexC;\0D\0A    v1.PosW = gin[1].PosW;\0D\0A    v1.NormalW = gin[1].NormalW;\0D\0A    v1.TexC = gin[1].TexC;\0D\0A    v2.PosW = gin[2].PosW;\0D\0A    v2.NormalW = gin[2].NormalW;\0D\0A    v2.TexC = gin[2].TexC;\0D\0A    \0D\0A    if(distToEye < 15)\0D\0A    {\0D\0A        //1\C2\F7 \BC\BC\BA\D0\C8\AD\BF\A1 \C7\CA\BF\E4\C7\D1 \C1\DF\C1\A1\B5\E9\0D\0A        SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);\0D\0A        SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);\0D\0A        SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);\0D\0A\0D\0A        //1\C2\F7 \BC\BC\BA\D0\C8\AD\B7\CE \B3\AA\BF\C2 4\B0\B3 \BB\EF\B0\A2\C7\FC\C0\BB \B0\A2\B0\A2 \B4\D9\BD\C3 \BC\BC\BA\D0\C8\AD (2\C2\F7 \BC\BC\BA\D0\C8\AD)\0D\0A        SubdivideOnce(v0, m0, m2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m0, m1, m2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m2, m1, v2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m0, v1, m1, centerW, radius, primID, 2, triStream);\0D\0A    }\0D\0A    else if (distToEye >= 15 && distToEye < 25)\0D\0A    {\0D\0A        SubdivideOnce(v0, v1, v2, centerW, radius, primID, 1, triStream);\0D\0A    }\0D\0A    else //distToEye >= 25\0D\0A    {\0D\0A        int vertexNum = 3;\0D\0A        GeoOut gout;\0D\0A\09    [unroll]\0D\0A        for (int i = 0; i < vertexNum; ++i)\0D\0A        {\0D\0A            gout.PosH = mul(float4(gin[i].PosW, 1.0f), gViewProj);\0D\0A            gout.PosW = gin[i].PosW;\0D\0A            gout.NormalW = gin[i].NormalW;\0D\0A            gout.TexC = gin[i].TexC;\0D\0A            gout.PrimID = primID;\0D\0A            gout.LODLevel = 0;\0D\0A\09\09\0D\0A            triStream.Append(gout);\0D\0A        }\0D\0A    }\0D\0A}\0D\0A\0D\0A[maxvertexcount(4)]\0D\0Avoid GS_Explode(triangle VertexOut gin[3],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{    \0D\0A    float rand = frac(sin(primID * 12.9898f) * 758.5453f);\0D\0A    float t = frac(gTotalTime + rand * 0.13f);\0D\0A    \0D\0A    float explodeAmount;\0D\0A    float explodeDuration = 0.95f; // \C6\F8\B9\DF\C0\CC \BF\CF\C0\FC\C8\F7 \C1\F8\C7\E0\B5\C7\B4\C2 \BD\C3\B0\A3\0D\0A    if (t < explodeDuration)\0D\0A    {\0D\0A        float localT = t / explodeDuration; // 0~1\B7\CE \C0\E7\C1\A4\B1\D4\C8\AD\0D\0A        explodeAmount = pow(localT, 18.0f);\0D\0A    }\0D\0A    else\0D\0A        explodeAmount = 1.0f;\0D\0A    \0D\0A    float3 e0 = gin[1].PosW - gin[0].PosW;\0D\0A    float3 e1 = gin[2].PosW - gin[0].PosW;\0D\0A    float3 faceNormal = normalize(cross(e0, e1)) * 2.0f;\0D\0A    \0D\0A    float3 explodeVector = explodeAmount * faceNormal;\0D\0A    \0D\0A    [unroll]\0D\0A    for (int i = 0; i < 3; ++i)\0D\0A    {\0D\0A        GeoOut gout;\0D\0A\0D\0A        float3 newPosW = gin[i].PosW + explodeVector;\0D\0A\0D\0A        gout.PosW = newPosW;\0D\0A        gout.NormalW = faceNormal;\0D\0A        gout.TexC = gin[i].TexC;\0D\0A        gout.PosH = mul(float4(newPosW, 1.0f), gViewProj);\0D\0A        gout.PrimID = primID;\0D\0A        gout.LODLevel = 0;\0D\0A\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A\0D\0A    triStream.RestartStrip();\0D\0A}\0D\0A\0D\0A[maxvertexcount(2)]\0D\0Avoid GS_Debugging(point VertexOut gin[1],\0D\0A                  uint primID : SV_PrimitiveID,\0D\0A                  inout LineStream<GeoOut> lineStream)\0D\0A{\0D\0A    GeoOut gout;\0D\0A\0D\0A    float NormalLength = 0.2f;\0D\0A    float3 p0 = gin[0].PosW;\0D\0A    float3 p1 = gin[0].PosW + gin[0].NormalW * NormalLength;\0D\0A\0D\0A    // \BD\C3\C0\DB\C1\A1\0D\0A    gout.PosW = p0;\0D\0A    gout.NormalW = gin[0].NormalW;\0D\0A    gout.TexC = gin[0].TexC;\0D\0A    gout.PosH = mul(float4(p0, 1.0f), gViewProj);\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = 0;\0D\0A    lineStream.Append(gout);\0D\0A\0D\0A    // \B3\A1\C1\A1\0D\0A    gout.PosW = p1;\0D\0A    gout.NormalW = gin[0].NormalW;\0D\0A    gout.TexC = gin[0].TexC;\0D\0A    gout.PosH = mul(float4(p1, 1.0f), gViewProj);\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = 0;\0D\0A    lineStream.Append(gout);\0D\0A\0D\0A    lineStream.RestartStrip();\0D\0A}\0D\0A\0D\0Afloat4 PS(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 uvw = float3(pin.TexC, pin.PrimID % 3);\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamAnisotropicClamp, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A    if (pin.LODLevel == 2)\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(1.15f, 0.95f, 0.95f); // \BA\D3\C0\BA\B1\E2\0D\0A    }\0D\0A    else if (pin.LODLevel == 1)\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(0.95f, 1.15f, 0.95f); // \C3\CA\B7\CF\B1\E2\0D\0A    }\0D\0A    else\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(0.95f, 0.95f, 1.15f); // \C7\AA\B8\A5\B1\E2\0D\0A    }\0D\0A    \0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A    \0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A#ifdef FOG\0D\0A\09float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A\09litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A    \0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A\0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_VertexNormal(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 normalColor = pin.NormalW * 0.5f + 0.5f;\0D\0A    return float4(normalColor, 1.0f);\0D\0A}"}
!145 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0\E3\84\B4.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrenght = L.Strength * ndotl;\0D\0A    \0D\0A    return BlinnPhong(lightStrenght, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!146 = !{!"FOG=1", !"ALPHA_TEST=1", !"FOG=1", !"ALPHA_TEST=1"}
!147 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CTask_GS.hlsl"}
!148 = !{!"-E", !"PS", !"-T", !"ps_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-D", !"FOG=1", !"-D", !"ALPHA_TEST=1", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CCompiled\5CLineToCylinderPS.cso", !"-D", !"FOG=1", !"-D", !"ALPHA_TEST=1"}
!149 = !{i32 1, i32 0}
!150 = !{i32 1, i32 8}
!151 = !{!"ps", i32 6, i32 0}
!152 = !{!153, null, !156, !159}
!153 = !{!154}
!154 = !{i32 0, %"class.Texture2D<vector<float, 4> >"* undef, !"gDiffuseMap", i32 0, i32 0, i32 1, i32 2, i32 0, !155}
!155 = !{i32 0, i32 9}
!156 = !{!157, !158}
!157 = !{i32 0, %hostlayout.cbMaterial* undef, !"cbMaterial", i32 0, i32 1, i32 1, i32 96, null}
!158 = !{i32 1, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!159 = !{!160}
!160 = !{i32 0, %struct.SamplerState* undef, !"gsamAnisotropicClamp", i32 0, i32 5, i32 1, i32 0, null}
!161 = !{i32 0, %struct.Light undef, !162, %hostlayout.cbMaterial undef, !169, %hostlayout.cbPass undef, !175}
!162 = !{i32 48, !163, !164, !165, !166, !167, !168}
!163 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!164 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!165 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!166 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!167 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!168 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!169 = !{i32 96, !170, !171, !172, !173}
!170 = !{i32 6, !"gDiffuseAlbedo", i32 3, i32 0, i32 7, i32 9}
!171 = !{i32 6, !"gFresnelR0", i32 3, i32 16, i32 7, i32 9}
!172 = !{i32 6, !"gRoughness", i32 3, i32 28, i32 7, i32 9}
!173 = !{i32 6, !"gMatTransform", i32 2, !174, i32 3, i32 32, i32 7, i32 9}
!174 = !{i32 4, i32 4, i32 2}
!175 = !{i32 1248, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195}
!176 = !{i32 6, !"gView", i32 2, !174, i32 3, i32 0, i32 7, i32 9}
!177 = !{i32 6, !"gInvView", i32 2, !174, i32 3, i32 64, i32 7, i32 9}
!178 = !{i32 6, !"gProj", i32 2, !174, i32 3, i32 128, i32 7, i32 9}
!179 = !{i32 6, !"gInvProj", i32 2, !174, i32 3, i32 192, i32 7, i32 9}
!180 = !{i32 6, !"gViewProj", i32 2, !174, i32 3, i32 256, i32 7, i32 9}
!181 = !{i32 6, !"gInvViewProj", i32 2, !174, i32 3, i32 320, i32 7, i32 9}
!182 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!183 = !{i32 6, !"cbPerObjectPad1", i32 3, i32 396, i32 7, i32 9}
!184 = !{i32 6, !"gRenderTargetSize", i32 3, i32 400, i32 7, i32 9}
!185 = !{i32 6, !"gInvRenderTargetSize", i32 3, i32 408, i32 7, i32 9}
!186 = !{i32 6, !"gNearZ", i32 3, i32 416, i32 7, i32 9}
!187 = !{i32 6, !"gFarZ", i32 3, i32 420, i32 7, i32 9}
!188 = !{i32 6, !"gTotalTime", i32 3, i32 424, i32 7, i32 9}
!189 = !{i32 6, !"gDeltaTime", i32 3, i32 428, i32 7, i32 9}
!190 = !{i32 6, !"gAmbientLight", i32 3, i32 432, i32 7, i32 9}
!191 = !{i32 6, !"gLights", i32 3, i32 448}
!192 = !{i32 6, !"gFogColor", i32 3, i32 1216, i32 7, i32 9}
!193 = !{i32 6, !"gFogStart", i32 3, i32 1232, i32 7, i32 9}
!194 = !{i32 6, !"gFogRange", i32 3, i32 1236, i32 7, i32 9}
!195 = !{i32 6, !"cbPerObjectPad2", i32 3, i32 1240, i32 7, i32 9}
!196 = !{i32 1, void ()* @PS, !197}
!197 = !{!198}
!198 = !{i32 0, !2, !2}
!199 = !{[23 x i32] [i32 21, i32 4, i32 0, i32 0, i32 0, i32 0, i32 7, i32 7, i32 7, i32 0, i32 7, i32 7, i32 7, i32 0, i32 15, i32 15, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 7]}
!200 = !{void ()* @PS, !"PS", !201, !152, !217}
!201 = !{!202, !214, null}
!202 = !{!203, !205, !207, !208, !210, !211}
!203 = !{i32 0, !"SV_Position", i8 9, i8 3, !204, i8 4, i32 1, i8 4, i32 0, i8 0, null}
!204 = !{i32 0}
!205 = !{i32 1, !"POSITION", i8 9, i8 0, !204, i8 2, i32 1, i8 3, i32 1, i8 0, !206}
!206 = !{i32 3, i32 7}
!207 = !{i32 2, !"NORMAL", i8 9, i8 0, !204, i8 2, i32 1, i8 3, i32 2, i8 0, !206}
!208 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !204, i8 2, i32 1, i8 2, i32 3, i8 0, !209}
!209 = !{i32 3, i32 3}
!210 = !{i32 4, !"SV_PrimitiveID", i8 5, i8 10, !204, i8 1, i32 1, i8 1, i32 4, i8 0, null}
!211 = !{i32 5, !"TEXCOORD", i8 5, i8 0, !212, i8 1, i32 1, i8 1, i32 5, i8 0, !213}
!212 = !{i32 1}
!213 = !{i32 3, i32 1}
!214 = !{!215}
!215 = !{i32 0, !"SV_Target", i8 9, i8 16, !204, i8 0, i32 1, i8 4, i32 0, i8 0, !216}
!216 = !{i32 3, i32 15}
!217 = !{i32 0, i64 1}
!218 = !DILocation(line: 346, column: 28, scope: !25)
!219 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "pin", arg: 1, scope: !25, file: !1, line: 343, type: !28)
!220 = !DIExpression(DW_OP_bit_piece, 320, 32)
!221 = !DILocation(line: 343, column: 18, scope: !25)
!222 = !DIExpression(DW_OP_bit_piece, 352, 32)
!223 = !DIExpression(DW_OP_bit_piece, 224, 32)
!224 = !DIExpression(DW_OP_bit_piece, 256, 32)
!225 = !DIExpression(DW_OP_bit_piece, 288, 32)
!226 = !DIExpression(DW_OP_bit_piece, 128, 32)
!227 = !DIExpression(DW_OP_bit_piece, 160, 32)
!228 = !DIExpression(DW_OP_bit_piece, 192, 32)
!229 = !DIExpression(DW_OP_bit_piece, 416, 32)
!230 = !DILocation(line: 345, column: 12, scope: !25)
!231 = !DILocation(line: 346, column: 81, scope: !25)
!232 = !DILocation(line: 346, column: 79, scope: !25)
!233 = !DILocation(line: 346, column: 12, scope: !25)
!234 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "diffuseAlbedo", scope: !25, file: !1, line: 346, type: !15)
!235 = !DIExpression(DW_OP_bit_piece, 0, 32)
!236 = !DIExpression(DW_OP_bit_piece, 32, 32)
!237 = !DIExpression(DW_OP_bit_piece, 64, 32)
!238 = !DIExpression(DW_OP_bit_piece, 96, 32)
!239 = !DILocation(line: 348, column: 22, scope: !240)
!240 = distinct !DILexicalBlock(scope: !25, file: !1, line: 348, column: 9)
!241 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "shadowFactor", arg: 6, scope: !45, file: !46, line: 143, type: !4)
!242 = !DIExpression()
!243 = !DILocation(line: 143, column: 112, scope: !45, inlinedAt: !244)
!244 = distinct !DILocation(line: 372, column: 26, scope: !25)
!245 = !DILocation(line: 348, column: 9, scope: !25)
!246 = !DILocation(line: 350, column: 27, scope: !247)
!247 = distinct !DILexicalBlock(scope: !240, file: !1, line: 349, column: 5)
!248 = !DILocation(line: 351, column: 5, scope: !247)
!249 = !DILocation(line: 352, column: 27, scope: !250)
!250 = distinct !DILexicalBlock(scope: !240, file: !1, line: 352, column: 14)
!251 = !DILocation(line: 352, column: 14, scope: !240)
!252 = !DILocation(line: 354, column: 27, scope: !253)
!253 = distinct !DILexicalBlock(scope: !250, file: !1, line: 353, column: 5)
!254 = !DILocation(line: 355, column: 5, scope: !253)
!255 = !DILocation(line: 358, column: 27, scope: !256)
!256 = distinct !DILexicalBlock(scope: !250, file: !1, line: 357, column: 5)
!257 = !DILocation(line: 361, column: 19, scope: !25)
!258 = !DILocation(line: 361, column: 17, scope: !25)
!259 = !DILocation(line: 363, column: 21, scope: !25)
!260 = !DILocation(line: 363, column: 30, scope: !25)
!261 = !DILocation(line: 363, column: 12, scope: !25)
!262 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "toEyeW", scope: !25, file: !1, line: 363, type: !4)
!263 = !DILocation(line: 364, column: 23, scope: !25)
!264 = !DILocation(line: 364, column: 11, scope: !25)
!265 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "distToEye", scope: !25, file: !1, line: 364, type: !8)
!266 = !DILocation(line: 365, column: 12, scope: !25)
!267 = !DILocation(line: 367, column: 22, scope: !25)
!268 = !DILocation(line: 367, column: 36, scope: !25)
!269 = !DILocation(line: 367, column: 12, scope: !25)
!270 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "ambient", scope: !25, file: !1, line: 367, type: !15)
!271 = !DILocation(line: 369, column: 36, scope: !25)
!272 = !DILocation(line: 369, column: 34, scope: !25)
!273 = !DILocation(line: 369, column: 17, scope: !25)
!274 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "shininess", scope: !25, file: !1, line: 369, type: !105)
!275 = !DILocation(line: 370, column: 20, scope: !25)
!276 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "mat", scope: !25, file: !1, line: 370, type: !60)
!277 = !DILocation(line: 370, column: 14, scope: !25)
!278 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 2, scope: !45, file: !46, line: 143, type: !60)
!279 = !DILocation(line: 143, column: 59, scope: !45, inlinedAt: !244)
!280 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 2, scope: !65, file: !46, line: 85, type: !60)
!281 = !DILocation(line: 85, column: 50, scope: !65, inlinedAt: !282)
!282 = distinct !DILocation(line: 151, column: 37, scope: !283, inlinedAt: !244)
!283 = distinct !DILexicalBlock(scope: !284, file: !46, line: 150, column: 5)
!284 = distinct !DILexicalBlock(scope: !285, file: !46, line: 149, column: 5)
!285 = distinct !DILexicalBlock(scope: !45, file: !46, line: 149, column: 5)
!286 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 5, scope: !68, file: !46, line: 68, type: !60)
!287 = !DILocation(line: 68, column: 96, scope: !68, inlinedAt: !288)
!288 = distinct !DILocation(line: 94, column: 12, scope: !65, inlinedAt: !282)
!289 = !DILocation(line: 370, column: 37, scope: !25)
!290 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "R0", arg: 1, scope: !71, file: !46, line: 59, type: !4)
!291 = !DILocation(line: 59, column: 30, scope: !71, inlinedAt: !292)
!292 = distinct !DILocation(line: 74, column: 28, scope: !68, inlinedAt: !288)
!293 = !DILocation(line: 371, column: 12, scope: !25)
!294 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "shadowFactor", scope: !25, file: !1, line: 371, type: !4)
!295 = !DILocation(line: 372, column: 26, scope: !25)
!296 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 5, scope: !45, file: !46, line: 143, type: !4)
!297 = !DILocation(line: 143, column: 98, scope: !45, inlinedAt: !244)
!298 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 4, scope: !45, file: !46, line: 143, type: !4)
!299 = !DILocation(line: 143, column: 83, scope: !45, inlinedAt: !244)
!300 = !DILocation(line: 145, column: 12, scope: !45, inlinedAt: !244)
!301 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "result", scope: !45, file: !46, line: 145, type: !4)
!302 = !DILocation(line: 146, column: 9, scope: !45, inlinedAt: !244)
!303 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !45, file: !46, line: 146, type: !14)
!304 = !DILocation(line: 149, column: 11, scope: !285, inlinedAt: !244)
!305 = !DILocation(line: 149, column: 5, scope: !285, inlinedAt: !244)
!306 = !DILocation(line: 151, column: 19, scope: !283, inlinedAt: !244)
!307 = !DILocation(line: 151, column: 37, scope: !283, inlinedAt: !244)
!308 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 4, scope: !65, file: !46, line: 85, type: !4)
!309 = !DILocation(line: 85, column: 77, scope: !65, inlinedAt: !282)
!310 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 3, scope: !65, file: !46, line: 85, type: !4)
!311 = !DILocation(line: 85, column: 62, scope: !65, inlinedAt: !282)
!312 = !DILocation(line: 88, column: 26, scope: !65, inlinedAt: !282)
!313 = !DILocation(line: 88, column: 23, scope: !65, inlinedAt: !282)
!314 = !DILocation(line: 88, column: 12, scope: !65, inlinedAt: !282)
!315 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "lightVec", scope: !65, file: !46, line: 88, type: !4)
!316 = !DILocation(line: 91, column: 23, scope: !65, inlinedAt: !282)
!317 = !DILocation(line: 91, column: 19, scope: !65, inlinedAt: !282)
!318 = !DILocation(line: 91, column: 11, scope: !65, inlinedAt: !282)
!319 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "ndotl", scope: !65, file: !46, line: 91, type: !8)
!320 = !DILocation(line: 92, column: 30, scope: !65, inlinedAt: !282)
!321 = !DILocation(line: 92, column: 39, scope: !65, inlinedAt: !282)
!322 = !DILocation(line: 92, column: 12, scope: !65, inlinedAt: !282)
!323 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "lightStrenght", scope: !65, file: !46, line: 92, type: !4)
!324 = !DILocation(line: 94, column: 12, scope: !65, inlinedAt: !282)
!325 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 4, scope: !68, file: !46, line: 68, type: !4)
!326 = !DILocation(line: 68, column: 80, scope: !68, inlinedAt: !288)
!327 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 3, scope: !68, file: !46, line: 68, type: !4)
!328 = !DILocation(line: 68, column: 65, scope: !68, inlinedAt: !288)
!329 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightVec", arg: 2, scope: !68, file: !46, line: 68, type: !4)
!330 = !DILocation(line: 68, column: 48, scope: !68, inlinedAt: !288)
!331 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightStrength", arg: 1, scope: !68, file: !46, line: 68, type: !4)
!332 = !DILocation(line: 68, column: 26, scope: !68, inlinedAt: !288)
!333 = !DILocation(line: 70, column: 35, scope: !68, inlinedAt: !288)
!334 = !DILocation(line: 70, column: 17, scope: !68, inlinedAt: !288)
!335 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "m", scope: !68, file: !46, line: 70, type: !105)
!336 = !DILocation(line: 71, column: 38, scope: !68, inlinedAt: !288)
!337 = !DILocation(line: 71, column: 22, scope: !68, inlinedAt: !288)
!338 = !DILocation(line: 71, column: 12, scope: !68, inlinedAt: !288)
!339 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "halfVec", scope: !68, file: !46, line: 71, type: !4)
!340 = !DILocation(line: 73, column: 32, scope: !68, inlinedAt: !288)
!341 = !DILocation(line: 73, column: 50, scope: !68, inlinedAt: !288)
!342 = !DILocation(line: 73, column: 46, scope: !68, inlinedAt: !288)
!343 = !DILocation(line: 73, column: 42, scope: !68, inlinedAt: !288)
!344 = !DILocation(line: 73, column: 40, scope: !68, inlinedAt: !288)
!345 = !DILocation(line: 73, column: 82, scope: !68, inlinedAt: !288)
!346 = !DILocation(line: 73, column: 11, scope: !68, inlinedAt: !288)
!347 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "roughnessFactor", scope: !68, file: !46, line: 73, type: !8)
!348 = !DILocation(line: 74, column: 28, scope: !68, inlinedAt: !288)
!349 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightVec", arg: 3, scope: !71, file: !46, line: 59, type: !4)
!350 = !DILocation(line: 59, column: 56, scope: !71, inlinedAt: !292)
!351 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 2, scope: !71, file: !46, line: 59, type: !4)
!352 = !DILocation(line: 59, column: 41, scope: !71, inlinedAt: !292)
!353 = !DILocation(line: 61, column: 39, scope: !71, inlinedAt: !292)
!354 = !DILocation(line: 61, column: 30, scope: !71, inlinedAt: !292)
!355 = !DILocation(line: 61, column: 11, scope: !71, inlinedAt: !292)
!356 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "cosIncidentAngle", scope: !71, file: !46, line: 61, type: !8)
!357 = !DILocation(line: 62, column: 21, scope: !71, inlinedAt: !292)
!358 = !DILocation(line: 62, column: 11, scope: !71, inlinedAt: !292)
!359 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "f0", scope: !71, file: !46, line: 62, type: !8)
!360 = !DILocation(line: 63, column: 40, scope: !71, inlinedAt: !292)
!361 = !DILocation(line: 63, column: 48, scope: !71, inlinedAt: !292)
!362 = !DILocation(line: 63, column: 46, scope: !71, inlinedAt: !292)
!363 = !DILocation(line: 63, column: 32, scope: !71, inlinedAt: !292)
!364 = !DILocation(line: 63, column: 12, scope: !71, inlinedAt: !292)
!365 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "reflectPercent", scope: !71, file: !46, line: 63, type: !4)
!366 = !DILocation(line: 65, column: 5, scope: !71, inlinedAt: !292)
!367 = !DILocation(line: 74, column: 12, scope: !68, inlinedAt: !288)
!368 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "fresnelFactor", scope: !68, file: !46, line: 74, type: !4)
!369 = !DILocation(line: 76, column: 39, scope: !68, inlinedAt: !288)
!370 = !DILocation(line: 76, column: 12, scope: !68, inlinedAt: !288)
!371 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "specAlbedo", scope: !68, file: !46, line: 76, type: !4)
!372 = !DILocation(line: 80, column: 43, scope: !68, inlinedAt: !288)
!373 = !DILocation(line: 80, column: 29, scope: !68, inlinedAt: !288)
!374 = !DILocation(line: 80, column: 16, scope: !68, inlinedAt: !288)
!375 = !DILocation(line: 82, column: 35, scope: !68, inlinedAt: !288)
!376 = !DILocation(line: 82, column: 49, scope: !68, inlinedAt: !288)
!377 = !DILocation(line: 82, column: 5, scope: !68, inlinedAt: !288)
!378 = !DILocation(line: 94, column: 5, scope: !65, inlinedAt: !282)
!379 = !DILocation(line: 151, column: 35, scope: !283, inlinedAt: !244)
!380 = !DILocation(line: 151, column: 16, scope: !283, inlinedAt: !244)
!381 = !DILocation(line: 149, column: 36, scope: !284, inlinedAt: !244)
!382 = !DILocation(line: 149, column: 18, scope: !284, inlinedAt: !244)
!383 = !DILocation(line: 169, column: 5, scope: !45, inlinedAt: !244)
!384 = !DILocation(line: 372, column: 12, scope: !25)
!385 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "directLight", scope: !25, file: !1, line: 372, type: !15)
!386 = !DILocation(line: 375, column: 31, scope: !25)
!387 = !DILocation(line: 375, column: 12, scope: !25)
!388 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "litColor", scope: !25, file: !1, line: 375, type: !15)
!389 = !DILocation(line: 378, column: 42, scope: !25)
!390 = !DILocation(line: 378, column: 40, scope: !25)
!391 = !DILocation(line: 378, column: 55, scope: !25)
!392 = !DILocation(line: 378, column: 53, scope: !25)
!393 = !DILocation(line: 378, column: 20, scope: !25)
!394 = !DILocation(line: 378, column: 8, scope: !25)
!395 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "fogAmount", scope: !25, file: !1, line: 378, type: !8)
!396 = !DILocation(line: 379, column: 28, scope: !25)
!397 = !DILocation(line: 379, column: 13, scope: !25)
!398 = !DILocation(line: 379, column: 11, scope: !25)
!399 = !DILocation(line: 382, column: 16, scope: !25)
!400 = !DILocation(line: 384, column: 5, scope: !25)
