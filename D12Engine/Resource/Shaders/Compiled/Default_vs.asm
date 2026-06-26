;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   xyz 
; NORMAL                   0   xyz         1     NONE   float   xyz 
; TANGENT                  0   xyz         2     NONE   float       
; TEXCOORD                 0   xy          3     NONE   float   xy  
;
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Position              0   xyzw        0      POS   float   xyzw
; POSITION                 0   xyz         1     NONE   float   xyz 
; NORMAL                   0   xyz         2     NONE   float   xyz 
; TEXCOORD                 0   xy          3     NONE   float   xy  
;
; shader debug name: d4668285c32c72dbc03c5ac83b26aae8.pdb
; shader hash: d4668285c32c72dbc03c5ac83b26aae8
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Vertex Shader
; OutputPositionPresent=1
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 4
; SigOutputElements: 4
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 4
; SigOutputVectors[0]: 4
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: VS
;
;
; Input signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; POSITION                 0                              
; NORMAL                   0                              
; TANGENT                  0                              
; TEXCOORD                 0                              
;
; Output signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_Position              0          noperspective       
; POSITION                 0                 linear       
; NORMAL                   0                 linear       
; TEXCOORD                 0                 linear       
;
; Buffer Definitions:
;
; cbuffer cbPerObject
; {
;
;   struct hostlayout.cbPerObject
;   {
;
;       column_major float4x4 gWorld;                 ; Offset:    0
;       column_major float4x4 gTexTransform;          ; Offset:   64
;       float2 gDisplacementMapTexelSize;             ; Offset:  128
;       float gGridSpatialStep;                       ; Offset:  136
;       float cbPerObjectPad1;                        ; Offset:  140
;   
;   } cbPerObject;                                    ; Offset:    0 Size:   144
;
; }
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
;       float cbPerPassPad1;                          ; Offset:  396
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
; cbPerObject                       cbuffer      NA          NA     CB0            cb0     1
; cbMaterial                        cbuffer      NA          NA     CB1            cb1     1
; cbPass                            cbuffer      NA          NA     CB2            cb2     1
;
;
; ViewId state:
;
; Number of inputs: 14, outputs: 14
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;   output 0 depends on inputs: { 0, 1, 2 }
;   output 1 depends on inputs: { 0, 1, 2 }
;   output 2 depends on inputs: { 0, 1, 2 }
;   output 3 depends on inputs: { 0, 1, 2 }
;   output 4 depends on inputs: { 0, 1, 2 }
;   output 5 depends on inputs: { 0, 1, 2 }
;   output 6 depends on inputs: { 0, 1, 2 }
;   output 8 depends on inputs: { 4, 5, 6 }
;   output 9 depends on inputs: { 4, 5, 6 }
;   output 10 depends on inputs: { 4, 5, 6 }
;   output 12 depends on inputs: { 12, 13 }
;   output 13 depends on inputs: { 12, 13 }
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.CBufRet.f32 = type { float, float, float, float }
%hostlayout.cbPerObject = type { [4 x <4 x float>], [4 x <4 x float>], <2 x float>, float, float }
%hostlayout.cbMaterial = type { <4 x float>, <3 x float>, float, [4 x <4 x float>] }
%hostlayout.cbPass = type { [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], <3 x float>, float, <2 x float>, <2 x float>, float, float, float, float, <4 x float>, [16 x %struct.Light], <4 x float>, float, float, <2 x float> }
%struct.Light = type { <3 x float>, float, <3 x float>, float, <3 x float>, float }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @VS() {
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 2, i32 2, i1 false), !dbg !217 ; line:87 col:23  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbMaterial_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 1, i32 1, i1 false), !dbg !217 ; line:87 col:23  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbPerObject_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 0, i1 false), !dbg !217 ; line:87 col:23  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef), !dbg !217 ; line:87 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !218, metadata !219), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"VS"
  %2 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 1, i32 undef), !dbg !217 ; line:87 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !218, metadata !220), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"VS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 undef), !dbg !217 ; line:87 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !218, metadata !221), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 undef), !dbg !217 ; line:87 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !218, metadata !222), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 undef), !dbg !217 ; line:87 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !218, metadata !223), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"VS"
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 undef), !dbg !217 ; line:87 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !218, metadata !224), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 undef), !dbg !217 ; line:87 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !218, metadata !225), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 undef), !dbg !217 ; line:87 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !218, metadata !219), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !218, metadata !220), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !218, metadata !221), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !218, metadata !222), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !218, metadata !223), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !218, metadata !224), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !218, metadata !225), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !218, metadata !226), !dbg !217 ; var:"vin" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  %9 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !227 ; line:89 col:34
  call void @llvm.dbg.value(metadata <4 x float> zeroinitializer, i64 0, metadata !228, metadata !229), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 0, 128) func:"VS"
  %10 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !227 ; line:89 col:34
  call void @llvm.dbg.value(metadata <3 x float> zeroinitializer, i64 0, metadata !228, metadata !231), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 128, 96) func:"VS"
  %11 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !227 ; line:89 col:34
  call void @llvm.dbg.value(metadata <3 x float> zeroinitializer, i64 0, metadata !228, metadata !232), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 224, 96) func:"VS"
  %12 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !227 ; line:89 col:34
  call void @llvm.dbg.value(metadata <2 x float> zeroinitializer, i64 0, metadata !228, metadata !233), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 320, 64) func:"VS"
  %13 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 0), !dbg !234 ; line:106 col:47  ; CBufferLoadLegacy(handle,regIndex)
  %14 = extractvalue %dx.types.CBufRet.f32 %13, 0, !dbg !234 ; line:106 col:47
  %15 = extractvalue %dx.types.CBufRet.f32 %13, 1, !dbg !234 ; line:106 col:47
  %16 = extractvalue %dx.types.CBufRet.f32 %13, 2, !dbg !234 ; line:106 col:47
  %17 = extractvalue %dx.types.CBufRet.f32 %13, 3, !dbg !234 ; line:106 col:47
  %18 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 1), !dbg !234 ; line:106 col:47  ; CBufferLoadLegacy(handle,regIndex)
  %19 = extractvalue %dx.types.CBufRet.f32 %18, 0, !dbg !234 ; line:106 col:47
  %20 = extractvalue %dx.types.CBufRet.f32 %18, 1, !dbg !234 ; line:106 col:47
  %21 = extractvalue %dx.types.CBufRet.f32 %18, 2, !dbg !234 ; line:106 col:47
  %22 = extractvalue %dx.types.CBufRet.f32 %18, 3, !dbg !234 ; line:106 col:47
  %23 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 2), !dbg !234 ; line:106 col:47  ; CBufferLoadLegacy(handle,regIndex)
  %24 = extractvalue %dx.types.CBufRet.f32 %23, 0, !dbg !234 ; line:106 col:47
  %25 = extractvalue %dx.types.CBufRet.f32 %23, 1, !dbg !234 ; line:106 col:47
  %26 = extractvalue %dx.types.CBufRet.f32 %23, 2, !dbg !234 ; line:106 col:47
  %27 = extractvalue %dx.types.CBufRet.f32 %23, 3, !dbg !234 ; line:106 col:47
  %28 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 3), !dbg !234 ; line:106 col:47  ; CBufferLoadLegacy(handle,regIndex)
  %29 = extractvalue %dx.types.CBufRet.f32 %28, 0, !dbg !234 ; line:106 col:47
  %30 = extractvalue %dx.types.CBufRet.f32 %28, 1, !dbg !234 ; line:106 col:47
  %31 = extractvalue %dx.types.CBufRet.f32 %28, 2, !dbg !234 ; line:106 col:47
  %32 = extractvalue %dx.types.CBufRet.f32 %28, 3, !dbg !234 ; line:106 col:47
  %33 = fmul fast float %6, %14, !dbg !235 ; line:106 col:19
  %FMad57 = call float @dx.op.tertiary.f32(i32 46, float %7, float %15, float %33), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %FMad56 = call float @dx.op.tertiary.f32(i32 46, float %8, float %16, float %FMad57), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %FMad55 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %17, float %FMad56), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %34 = fmul fast float %6, %19, !dbg !235 ; line:106 col:19
  %FMad54 = call float @dx.op.tertiary.f32(i32 46, float %7, float %20, float %34), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %FMad53 = call float @dx.op.tertiary.f32(i32 46, float %8, float %21, float %FMad54), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %FMad52 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %22, float %FMad53), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %35 = fmul fast float %6, %24, !dbg !235 ; line:106 col:19
  %FMad51 = call float @dx.op.tertiary.f32(i32 46, float %7, float %25, float %35), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %FMad50 = call float @dx.op.tertiary.f32(i32 46, float %8, float %26, float %FMad51), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %FMad49 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %27, float %FMad50), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %36 = fmul fast float %6, %29, !dbg !235 ; line:106 col:19
  %FMad48 = call float @dx.op.tertiary.f32(i32 46, float %7, float %30, float %36), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %FMad47 = call float @dx.op.tertiary.f32(i32 46, float %8, float %31, float %FMad48), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %FMad46 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %32, float %FMad47), !dbg !235 ; line:106 col:19  ; FMad(a,b,c)
  %37 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !236 ; line:106 col:12
  call void @llvm.dbg.value(metadata float %FMad55, i64 0, metadata !237, metadata !224), !dbg !236 ; var:"posW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad52, i64 0, metadata !237, metadata !225), !dbg !236 ; var:"posW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad49, i64 0, metadata !237, metadata !226), !dbg !236 ; var:"posW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad46, i64 0, metadata !237, metadata !221), !dbg !236 ; var:"posW" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  %38 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !238 ; line:107 col:15
  call void @llvm.dbg.value(metadata float %FMad55, i64 0, metadata !228, metadata !222), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad52, i64 0, metadata !228, metadata !223), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad49, i64 0, metadata !228, metadata !239), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"VS"
  %39 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 0), !dbg !240 ; line:110 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %40 = extractvalue %dx.types.CBufRet.f32 %39, 0, !dbg !240 ; line:110 col:48
  %41 = extractvalue %dx.types.CBufRet.f32 %39, 1, !dbg !240 ; line:110 col:48
  %42 = extractvalue %dx.types.CBufRet.f32 %39, 2, !dbg !240 ; line:110 col:48
  %43 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 1), !dbg !240 ; line:110 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %44 = extractvalue %dx.types.CBufRet.f32 %43, 0, !dbg !240 ; line:110 col:48
  %45 = extractvalue %dx.types.CBufRet.f32 %43, 1, !dbg !240 ; line:110 col:48
  %46 = extractvalue %dx.types.CBufRet.f32 %43, 2, !dbg !240 ; line:110 col:48
  %47 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 2), !dbg !240 ; line:110 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %48 = extractvalue %dx.types.CBufRet.f32 %47, 0, !dbg !240 ; line:110 col:48
  %49 = extractvalue %dx.types.CBufRet.f32 %47, 1, !dbg !240 ; line:110 col:48
  %50 = extractvalue %dx.types.CBufRet.f32 %47, 2, !dbg !240 ; line:110 col:48
  %51 = fmul fast float %3, %40, !dbg !241 ; line:110 col:20
  %FMad45 = call float @dx.op.tertiary.f32(i32 46, float %4, float %41, float %51), !dbg !241 ; line:110 col:20  ; FMad(a,b,c)
  %FMad44 = call float @dx.op.tertiary.f32(i32 46, float %5, float %42, float %FMad45), !dbg !241 ; line:110 col:20  ; FMad(a,b,c)
  %52 = fmul fast float %3, %44, !dbg !241 ; line:110 col:20
  %FMad43 = call float @dx.op.tertiary.f32(i32 46, float %4, float %45, float %52), !dbg !241 ; line:110 col:20  ; FMad(a,b,c)
  %FMad42 = call float @dx.op.tertiary.f32(i32 46, float %5, float %46, float %FMad43), !dbg !241 ; line:110 col:20  ; FMad(a,b,c)
  %53 = fmul fast float %3, %48, !dbg !241 ; line:110 col:20
  %FMad41 = call float @dx.op.tertiary.f32(i32 46, float %4, float %49, float %53), !dbg !241 ; line:110 col:20  ; FMad(a,b,c)
  %FMad40 = call float @dx.op.tertiary.f32(i32 46, float %5, float %50, float %FMad41), !dbg !241 ; line:110 col:20  ; FMad(a,b,c)
  %54 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !242 ; line:110 col:18
  call void @llvm.dbg.value(metadata float %FMad44, i64 0, metadata !228, metadata !243), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad42, i64 0, metadata !228, metadata !244), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad40, i64 0, metadata !228, metadata !219), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"VS"
  %55 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !245 ; line:113 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %56 = extractvalue %dx.types.CBufRet.f32 %55, 0, !dbg !245 ; line:113 col:27
  %57 = extractvalue %dx.types.CBufRet.f32 %55, 1, !dbg !245 ; line:113 col:27
  %58 = extractvalue %dx.types.CBufRet.f32 %55, 2, !dbg !245 ; line:113 col:27
  %59 = extractvalue %dx.types.CBufRet.f32 %55, 3, !dbg !245 ; line:113 col:27
  %60 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !245 ; line:113 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %61 = extractvalue %dx.types.CBufRet.f32 %60, 0, !dbg !245 ; line:113 col:27
  %62 = extractvalue %dx.types.CBufRet.f32 %60, 1, !dbg !245 ; line:113 col:27
  %63 = extractvalue %dx.types.CBufRet.f32 %60, 2, !dbg !245 ; line:113 col:27
  %64 = extractvalue %dx.types.CBufRet.f32 %60, 3, !dbg !245 ; line:113 col:27
  %65 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !245 ; line:113 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %66 = extractvalue %dx.types.CBufRet.f32 %65, 0, !dbg !245 ; line:113 col:27
  %67 = extractvalue %dx.types.CBufRet.f32 %65, 1, !dbg !245 ; line:113 col:27
  %68 = extractvalue %dx.types.CBufRet.f32 %65, 2, !dbg !245 ; line:113 col:27
  %69 = extractvalue %dx.types.CBufRet.f32 %65, 3, !dbg !245 ; line:113 col:27
  %70 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !245 ; line:113 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %71 = extractvalue %dx.types.CBufRet.f32 %70, 0, !dbg !245 ; line:113 col:27
  %72 = extractvalue %dx.types.CBufRet.f32 %70, 1, !dbg !245 ; line:113 col:27
  %73 = extractvalue %dx.types.CBufRet.f32 %70, 2, !dbg !245 ; line:113 col:27
  %74 = extractvalue %dx.types.CBufRet.f32 %70, 3, !dbg !245 ; line:113 col:27
  %75 = fmul fast float %FMad55, %56, !dbg !246 ; line:113 col:17
  %FMad39 = call float @dx.op.tertiary.f32(i32 46, float %FMad52, float %57, float %75), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %FMad38 = call float @dx.op.tertiary.f32(i32 46, float %FMad49, float %58, float %FMad39), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %FMad37 = call float @dx.op.tertiary.f32(i32 46, float %FMad46, float %59, float %FMad38), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %76 = fmul fast float %FMad55, %61, !dbg !246 ; line:113 col:17
  %FMad36 = call float @dx.op.tertiary.f32(i32 46, float %FMad52, float %62, float %76), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %FMad35 = call float @dx.op.tertiary.f32(i32 46, float %FMad49, float %63, float %FMad36), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %FMad34 = call float @dx.op.tertiary.f32(i32 46, float %FMad46, float %64, float %FMad35), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %77 = fmul fast float %FMad55, %66, !dbg !246 ; line:113 col:17
  %FMad33 = call float @dx.op.tertiary.f32(i32 46, float %FMad52, float %67, float %77), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %FMad32 = call float @dx.op.tertiary.f32(i32 46, float %FMad49, float %68, float %FMad33), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %FMad31 = call float @dx.op.tertiary.f32(i32 46, float %FMad46, float %69, float %FMad32), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %78 = fmul fast float %FMad55, %71, !dbg !246 ; line:113 col:17
  %FMad30 = call float @dx.op.tertiary.f32(i32 46, float %FMad52, float %72, float %78), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %FMad29 = call float @dx.op.tertiary.f32(i32 46, float %FMad49, float %73, float %FMad30), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %FMad28 = call float @dx.op.tertiary.f32(i32 46, float %FMad46, float %74, float %FMad29), !dbg !246 ; line:113 col:17  ; FMad(a,b,c)
  %79 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !247 ; line:113 col:15
  call void @llvm.dbg.value(metadata float %FMad37, i64 0, metadata !228, metadata !224), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad34, i64 0, metadata !228, metadata !225), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad31, i64 0, metadata !228, metadata !226), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad28, i64 0, metadata !228, metadata !221), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  %80 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 4), !dbg !248 ; line:115 col:51  ; CBufferLoadLegacy(handle,regIndex)
  %81 = extractvalue %dx.types.CBufRet.f32 %80, 0, !dbg !248 ; line:115 col:51
  %82 = extractvalue %dx.types.CBufRet.f32 %80, 1, !dbg !248 ; line:115 col:51
  %83 = extractvalue %dx.types.CBufRet.f32 %80, 2, !dbg !248 ; line:115 col:51
  %84 = extractvalue %dx.types.CBufRet.f32 %80, 3, !dbg !248 ; line:115 col:51
  %85 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 5), !dbg !248 ; line:115 col:51  ; CBufferLoadLegacy(handle,regIndex)
  %86 = extractvalue %dx.types.CBufRet.f32 %85, 0, !dbg !248 ; line:115 col:51
  %87 = extractvalue %dx.types.CBufRet.f32 %85, 1, !dbg !248 ; line:115 col:51
  %88 = extractvalue %dx.types.CBufRet.f32 %85, 2, !dbg !248 ; line:115 col:51
  %89 = extractvalue %dx.types.CBufRet.f32 %85, 3, !dbg !248 ; line:115 col:51
  %90 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 6), !dbg !248 ; line:115 col:51  ; CBufferLoadLegacy(handle,regIndex)
  %91 = extractvalue %dx.types.CBufRet.f32 %90, 0, !dbg !248 ; line:115 col:51
  %92 = extractvalue %dx.types.CBufRet.f32 %90, 1, !dbg !248 ; line:115 col:51
  %93 = extractvalue %dx.types.CBufRet.f32 %90, 2, !dbg !248 ; line:115 col:51
  %94 = extractvalue %dx.types.CBufRet.f32 %90, 3, !dbg !248 ; line:115 col:51
  %95 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 7), !dbg !248 ; line:115 col:51  ; CBufferLoadLegacy(handle,regIndex)
  %96 = extractvalue %dx.types.CBufRet.f32 %95, 0, !dbg !248 ; line:115 col:51
  %97 = extractvalue %dx.types.CBufRet.f32 %95, 1, !dbg !248 ; line:115 col:51
  %98 = extractvalue %dx.types.CBufRet.f32 %95, 2, !dbg !248 ; line:115 col:51
  %99 = extractvalue %dx.types.CBufRet.f32 %95, 3, !dbg !248 ; line:115 col:51
  %100 = fmul fast float %1, %81, !dbg !249 ; line:115 col:19
  %FMad27 = call float @dx.op.tertiary.f32(i32 46, float %2, float %82, float %100), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %FMad26 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %83, float %FMad27), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %FMad25 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %84, float %FMad26), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %101 = fmul fast float %1, %86, !dbg !249 ; line:115 col:19
  %FMad24 = call float @dx.op.tertiary.f32(i32 46, float %2, float %87, float %101), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %FMad23 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %88, float %FMad24), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %FMad22 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %89, float %FMad23), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %102 = fmul fast float %1, %91, !dbg !249 ; line:115 col:19
  %FMad21 = call float @dx.op.tertiary.f32(i32 46, float %2, float %92, float %102), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %FMad20 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %93, float %FMad21), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %FMad19 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %94, float %FMad20), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %103 = fmul fast float %1, %96, !dbg !249 ; line:115 col:19
  %FMad18 = call float @dx.op.tertiary.f32(i32 46, float %2, float %97, float %103), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %FMad17 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %98, float %FMad18), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %FMad16 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %99, float %FMad17), !dbg !249 ; line:115 col:19  ; FMad(a,b,c)
  %104 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !250 ; line:115 col:12
  call void @llvm.dbg.value(metadata float %FMad25, i64 0, metadata !251, metadata !224), !dbg !250 ; var:"texC" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad22, i64 0, metadata !251, metadata !225), !dbg !250 ; var:"texC" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad19, i64 0, metadata !251, metadata !226), !dbg !250 ; var:"texC" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad16, i64 0, metadata !251, metadata !221), !dbg !250 ; var:"texC" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  %105 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 2), !dbg !252 ; line:116 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %106 = extractvalue %dx.types.CBufRet.f32 %105, 0, !dbg !252 ; line:116 col:27
  %107 = extractvalue %dx.types.CBufRet.f32 %105, 1, !dbg !252 ; line:116 col:27
  %108 = extractvalue %dx.types.CBufRet.f32 %105, 2, !dbg !252 ; line:116 col:27
  %109 = extractvalue %dx.types.CBufRet.f32 %105, 3, !dbg !252 ; line:116 col:27
  %110 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 3), !dbg !252 ; line:116 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %111 = extractvalue %dx.types.CBufRet.f32 %110, 0, !dbg !252 ; line:116 col:27
  %112 = extractvalue %dx.types.CBufRet.f32 %110, 1, !dbg !252 ; line:116 col:27
  %113 = extractvalue %dx.types.CBufRet.f32 %110, 2, !dbg !252 ; line:116 col:27
  %114 = extractvalue %dx.types.CBufRet.f32 %110, 3, !dbg !252 ; line:116 col:27
  %115 = fmul fast float %FMad25, %106, !dbg !253 ; line:116 col:17
  %FMad15 = call float @dx.op.tertiary.f32(i32 46, float %FMad22, float %107, float %115), !dbg !253 ; line:116 col:17  ; FMad(a,b,c)
  %FMad14 = call float @dx.op.tertiary.f32(i32 46, float %FMad19, float %108, float %FMad15), !dbg !253 ; line:116 col:17  ; FMad(a,b,c)
  %FMad13 = call float @dx.op.tertiary.f32(i32 46, float %FMad16, float %109, float %FMad14), !dbg !253 ; line:116 col:17  ; FMad(a,b,c)
  %116 = fmul fast float %FMad25, %111, !dbg !253 ; line:116 col:17
  %FMad12 = call float @dx.op.tertiary.f32(i32 46, float %FMad22, float %112, float %116), !dbg !253 ; line:116 col:17  ; FMad(a,b,c)
  %FMad11 = call float @dx.op.tertiary.f32(i32 46, float %FMad19, float %113, float %FMad12), !dbg !253 ; line:116 col:17  ; FMad(a,b,c)
  %FMad10 = call float @dx.op.tertiary.f32(i32 46, float %FMad16, float %114, float %FMad11), !dbg !253 ; line:116 col:17  ; FMad(a,b,c)
  %117 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !253 ; line:116 col:17
  %118 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !254 ; line:116 col:15
  call void @llvm.dbg.value(metadata float %FMad13, i64 0, metadata !228, metadata !220), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad10, i64 0, metadata !228, metadata !255), !dbg !230 ; var:"vout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"VS"
  %119 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !256 ; line:118 col:12
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad37), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad34), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad31), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad28), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %FMad55), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %FMad52), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %FMad49), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %FMad44), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float %FMad42), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %FMad40), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %FMad13), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %FMad10), !dbg !256 ; line:118 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  %120 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !257 ; line:118 col:5
  ret void, !dbg !257 ; line:118 col:5
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare float @dx.op.loadInput.f32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #1

; Function Attrs: nounwind readonly
declare %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32, %dx.types.Handle, i32) #2

; Function Attrs: nounwind readnone
declare float @dx.op.tertiary.f32(i32, float, float, float) #0

; Function Attrs: nounwind readonly
declare %dx.types.Handle @dx.op.createHandle(i32, i8, i32, i32, i1) #2

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }
attributes #2 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!140, !141}
!llvm.ident = !{!142}
!dx.source.contents = !{!143, !144}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!145}
!dx.source.args = !{!146}
!dx.version = !{!147}
!dx.valver = !{!148}
!dx.shaderModel = !{!149}
!dx.resources = !{!150}
!dx.typeAnnotations = !{!155, !196}
!dx.viewIdState = !{!199}
!dx.entryPoints = !{!200}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !31, globals: !62)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDefault.hlsl", directory: "")
!2 = !{}
!3 = !{!4, !16}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 34, baseType: !5)
!5 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 34, size: 128, align: 32, elements: !6, templateParams: !12)
!6 = !{!7, !9, !10, !11}
!7 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !5, file: !1, line: 34, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!8 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!9 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !5, file: !1, line: 34, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!10 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !5, file: !1, line: 34, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!11 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !5, file: !1, line: 34, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!12 = !{!13, !14}
!13 = !DITemplateTypeParameter(name: "element", type: !8)
!14 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 4)
!15 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3x3", file: !1, line: 110, baseType: !17)
!17 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 3, 3>", file: !1, line: 110, size: 288, align: 32, elements: !18, templateParams: !28)
!18 = !{!19, !20, !21, !22, !23, !24, !25, !26, !27}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !17, file: !1, line: 110, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !17, file: !1, line: 110, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !17, file: !1, line: 110, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !17, file: !1, line: 110, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !17, file: !1, line: 110, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !17, file: !1, line: 110, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !17, file: !1, line: 110, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !17, file: !1, line: 110, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !17, file: !1, line: 110, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!28 = !{!13, !29, !30}
!29 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 3)
!30 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 3)
!31 = !{!32}
!32 = !DISubprogram(name: "VS", scope: !1, file: !1, line: 87, type: !33, isLocal: false, isDefinition: true, scopeLine: 88, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @VS)
!33 = !DISubroutineType(types: !34)
!34 = !{!35, !56}
!35 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexOut", file: !1, line: 79, size: 384, align: 32, elements: !36)
!36 = !{!37, !38, !47, !48}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !35, file: !1, line: 81, baseType: !4, size: 128, align: 32)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !35, file: !1, line: 82, baseType: !39, size: 96, align: 32, offset: 128)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 35, baseType: !40)
!40 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 35, size: 96, align: 32, elements: !41, templateParams: !45)
!41 = !{!42, !43, !44}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !40, file: !1, line: 35, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !40, file: !1, line: 35, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !40, file: !1, line: 35, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!45 = !{!13, !46}
!46 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 3)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !35, file: !1, line: 83, baseType: !39, size: 96, align: 32, offset: 224)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !35, file: !1, line: 84, baseType: !49, size: 64, align: 32, offset: 320)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 27, baseType: !50)
!50 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 27, size: 64, align: 32, elements: !51, templateParams: !54)
!51 = !{!52, !53}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !50, file: !1, line: 27, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !50, file: !1, line: 27, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!54 = !{!13, !55}
!55 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 2)
!56 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexIn", file: !1, line: 71, size: 352, align: 32, elements: !57)
!57 = !{!58, !59, !60, !61}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "PosL", scope: !56, file: !1, line: 73, baseType: !39, size: 96, align: 32)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "NormalL", scope: !56, file: !1, line: 74, baseType: !39, size: 96, align: 32, offset: 96)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "Tangent", scope: !56, file: !1, line: 75, baseType: !39, size: 96, align: 32, offset: 192)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !56, file: !1, line: 76, baseType: !49, size: 64, align: 32, offset: 288)
!62 = !{!63, !87, !88, !90, !92, !93, !95, !97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !128, !129, !130, !131, !132, !136, !137, !138}
!63 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 25, type: !64, isLocal: false, isDefinition: true)
!64 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !65)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 25, baseType: !66)
!66 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 25, size: 512, align: 32, elements: !67, templateParams: !84)
!67 = !{!68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !66, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!84 = !{!13, !85, !86}
!85 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 4)
!86 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 4)
!87 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 26, type: !64, isLocal: false, isDefinition: true)
!88 = !DIGlobalVariable(name: "gDisplacementMapTexelSize", linkageName: "\01?gDisplacementMapTexelSize@cbPerObject@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 27, type: !89, isLocal: false, isDefinition: true)
!89 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !49)
!90 = !DIGlobalVariable(name: "gGridSpatialStep", linkageName: "\01?gGridSpatialStep@cbPerObject@@3MB", scope: !0, file: !1, line: 28, type: !91, isLocal: false, isDefinition: true)
!91 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!92 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPerObject@@3MB", scope: !0, file: !1, line: 29, type: !91, isLocal: false, isDefinition: true)
!93 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 34, type: !94, isLocal: false, isDefinition: true)
!94 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!95 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 35, type: !96, isLocal: false, isDefinition: true)
!96 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !39)
!97 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 36, type: !91, isLocal: false, isDefinition: true)
!98 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 37, type: !64, isLocal: false, isDefinition: true)
!99 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !64, isLocal: false, isDefinition: true)
!100 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 43, type: !64, isLocal: false, isDefinition: true)
!101 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 44, type: !64, isLocal: false, isDefinition: true)
!102 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 45, type: !64, isLocal: false, isDefinition: true)
!103 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 46, type: !64, isLocal: false, isDefinition: true)
!104 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 47, type: !64, isLocal: false, isDefinition: true)
!105 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 48, type: !96, isLocal: false, isDefinition: true)
!106 = !DIGlobalVariable(name: "cbPerPassPad1", linkageName: "\01?cbPerPassPad1@cbPass@@3MB", scope: !0, file: !1, line: 49, type: !91, isLocal: false, isDefinition: true)
!107 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 50, type: !89, isLocal: false, isDefinition: true)
!108 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 51, type: !89, isLocal: false, isDefinition: true)
!109 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 52, type: !91, isLocal: false, isDefinition: true)
!110 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 53, type: !91, isLocal: false, isDefinition: true)
!111 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 54, type: !91, isLocal: false, isDefinition: true)
!112 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 55, type: !91, isLocal: false, isDefinition: true)
!113 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 56, type: !94, isLocal: false, isDefinition: true)
!114 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 61, type: !115, isLocal: false, isDefinition: true)
!115 = !DICompositeType(tag: DW_TAG_array_type, baseType: !116, size: 6144, align: 32, elements: !126)
!116 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !117)
!117 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !118, line: 3, size: 384, align: 32, elements: !119)
!118 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!119 = !{!120, !121, !122, !123, !124, !125}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !117, file: !118, line: 5, baseType: !39, size: 96, align: 32)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !117, file: !118, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !117, file: !118, line: 7, baseType: !39, size: 96, align: 32, offset: 128)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !117, file: !118, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !117, file: !118, line: 9, baseType: !39, size: 96, align: 32, offset: 256)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !117, file: !118, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!126 = !{!127}
!127 = !DISubrange(count: 16)
!128 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 65, type: !94, isLocal: false, isDefinition: true)
!129 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 66, type: !91, isLocal: false, isDefinition: true)
!130 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 67, type: !91, isLocal: false, isDefinition: true)
!131 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 68, type: !89, isLocal: false, isDefinition: true)
!132 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 17, type: !133, isLocal: false, isDefinition: true)
!133 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 17, size: 160, align: 32, elements: !2, templateParams: !134)
!134 = !{!135}
!135 = !DITemplateTypeParameter(name: "element", type: !5)
!136 = !DIGlobalVariable(name: "gDiffuseMap2", linkageName: "\01?gDiffuseMap2@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 18, type: !133, isLocal: false, isDefinition: true)
!137 = !DIGlobalVariable(name: "gDisplacementMap", linkageName: "\01?gDisplacementMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 19, type: !133, isLocal: false, isDefinition: true)
!138 = !DIGlobalVariable(name: "gsamLinear", linkageName: "\01?gsamLinear@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !139, isLocal: false, isDefinition: true)
!139 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 21, size: 32, align: 32, elements: !2)
!140 = !{i32 2, !"Dwarf Version", i32 4}
!141 = !{i32 2, !"Debug Info Version", i32 3}
!142 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!143 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDefault.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A//#define CARTOON\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0ATexture2D gDiffuseMap2 : register(t1);\0D\0ATexture2D gDisplacementMap : register(t2);\0D\0A\0D\0ASamplerState gsamLinear : register(s0);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A    float2 gDisplacementMapTexelSize;\0D\0A    float gGridSpatialStep;\0D\0A    float cbPerObjectPad1;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerPassPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    // \EC\9D\B8\EB\8D\B1\EC\8A\A4 [0, NUM_DIR_LIGHTS)\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B4\91\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)\EB\8A\94 \EC\A0\90\EA\B4\91\EC\9B\90\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHT + NUM_SPOT_LIGHTS)\EB\8A\94 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\B4\EB\A9\B0, \EA\B0\9D\EC\B2\B4\EB\8B\B9 \EC\B5\9C\EB\8C\80 MaxLights \EA\B0\9C\EC\88\98\EA\B9\8C\EC\A7\80 \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    //\EC\95\B1\EC\9D\B4 \ED\94\84\EB\A0\88\EC\9E\84\EB\8B\B9 \ED\95\9C \EB\B2\88\EC\94\A9 \EC\95\88\EA\B0\9C \EB\A7\A4\EA\B0\9C\EB\B3\80\EC\88\98\EB\A5\BC \EB\B3\80\EA\B2\BD\ED\95\A0 \EC\88\98 \EC\9E\88\EB\8F\84\EB\A1\9D \ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    //\ED\8A\B9\EC\A0\95 \EC\8B\9C\EA\B0\84\EB\8C\80\EC\97\90\EB\A7\8C \EC\95\88\EA\B0\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosL : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float3 Tangent : TANGENT;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float4 PosH : SV_Position;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout = (VertexOut) 0.0f;\0D\0A    \0D\0A#ifdef DISPLACEMENT_MAP\0D\0A    //\EB\B3\80\ED\99\98\EB\90\98\EC\A7\80 \EC\95\8A\EC\9D\80 [0,1]^2 tex \EC\A2\8C\ED\91\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\98\EC\97\AC \EB\B3\80\EC\9C\84 \EB\A7\B5\EC\9D\84 \EC\83\98\ED\94\8C\EB\A7\81.\0D\0A    vin.PosL.y += gDisplacementMap.SampleLevel(gsamLinear, vin.TexC, 1.0f).r;\0D\0A\09\0D\0A\09//\EC\9C\A0\ED\95\9C\EC\B0\A8\EB\B6\84\EB\B2\95\EC\9D\84 \EC\9D\B4\EC\9A\A9\ED\95\98\EC\97\AC \EC\A0\95\EA\B7\9C\EB\B6\84\ED\8F\AC\EB\A5\BC \EC\B6\94\EC\A0\95.\0D\0A    float du = gDisplacementMapTexelSize.x;\0D\0A    float dv = gDisplacementMapTexelSize.y;\0D\0A    float l = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC - float2(du, 0.0f), 0.0f).r;\0D\0A    float r = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC + float2(du, 0.0f), 0.0f).r;\0D\0A    float t = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC - float2(0.0f, dv), 0.0f).r;\0D\0A    float b = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC + float2(0.0f, dv), 0.0f).r;\0D\0A    vin.NormalL = normalize(float3(-r + l, 2.0f * gGridSpatialStep, b - t));\0D\0A    \0D\0A#endif\0D\0A    \0D\0A    float4 posW = mul(float4(vin.PosL, 1.0f), gWorld);\0D\0A    vout.PosW = posW.xyz;\0D\0A    \0D\0A    // \EB\B9\84\EA\B7\A0\EC\9D\BC \EC\8A\A4\EC\BC\80\EC\9D\BC\EB\A7\81\EC\9D\84 \EA\B0\80\EC\A0\95. \EC\95\84\EB\8B\88\EB\9D\BC\EB\A9\B4 \EC\9B\94\EB\93\9C \ED\96\89\EB\A0\AC\EC\9D\98 \EC\97\AD\EC\A0\84\EC\B9\98 \ED\96\89\EB\A0\AC\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\B4\EC\95\BC \ED\95\9C\EB\8B\A4.\0D\0A    vout.NormalW = mul(vin.NormalL, (float3x3) gWorld);\0D\0A    \0D\0A    // homogeneous clip \EA\B3\B5\EA\B0\84\EC\9C\BC\EB\A1\9C \EB\B3\80\ED\99\98.\0D\0A    vout.PosH = mul(posW, gViewProj);\0D\0A    \0D\0A    float4 texC = mul(float4(vin.TexC, 0.f, 1.f), gTexTransform);\0D\0A    vout.TexC = mul(texC, gMatTransform).xy;\0D\0A    \0D\0A    return vout;\0D\0A}\0D\0A \0D\0Afloat4 PS(VertexOut pin) : SV_Target\0D\0A{\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamLinear, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A#ifdef TEXTURE_BLEND\0D\0A    diffuseAlbedo *= (gDiffuseMap2.Sample(gsamLinear, pin.TexC) * gDiffuseAlbedo).r;\0D\0A#endif\0D\0A    \0D\0A#ifdef ALPHA_TEST\0D\0A\09//value < 0 \EC\9D\B4\EB\A9\B4 \ED\98\84\EC\9E\AC \ED\94\BD\EC\85\80\EC\9D\84 \EB\B2\84\EB\A6\AC\EA\B3\A0 \EB\8D\94 \EC\9D\B4\EC\83\81 \EB\A0\8C\EB\8D\94 \ED\83\80\EA\B9\83\EC\97\90 \EA\B8\B0\EB\A1\9D\ED\95\98\EC\A7\80 \EC\95\8A\EB\8A\94\EB\8B\A4.\0D\0A\09clip(diffuseAlbedo.a - 0.1f);\0D\0A#endif\0D\0A    \0D\0A    //\EB\B3\B4\EA\B0\84\EB\90\9C \EB\B2\95\EC\84\A0 \EB\B2\A1\ED\84\B0\EB\8A\94 \EA\B8\B8\EC\9D\B4\EA\B0\80 1\EC\9D\B4 \EC\95\84\EB\8B\90 \EC\88\98 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C.\0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A\0D\0A    //\EA\B4\91\EC\9B\90\EC\97\90\EC\84\9C \EC\B9\B4\EB\A9\94\EB\9D\BC\EB\A1\9C \ED\96\A5\ED\95\98\EB\8A\94 \EB\B2\A1\ED\84\B0.\0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    \0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A    \0D\0A#ifdef FOG\0D\0A    float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A    litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A\0D\0A    //\EC\9D\BC\EB\B0\98\EC\A0\81\EC\9C\BC\EB\A1\9C \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\80 \EB\94\94\ED\93\A8\EC\A6\88 \EB\A8\B8\ED\8B\B0\EB\A6\AC\EC\96\BC\EC\9D\98 \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\9C\EB\8B\A4.\0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A    \0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_MirrorBaseFill(VertexOut pin) : SV_Target\0D\0A{\0D\0A    return gDiffuseAlbedo;\0D\0A}"}
!144 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhongToon(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    // 1) kd\0D\0A    float kd = saturate(dot(lightVec, normal));\0D\0A    float kd_q = QuantizeKd(kd);\0D\0A\0D\0A    // 2) ks (Blinn-Phong)\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    float ndoth = saturate(dot(halfVec, normal));\0D\0A\0D\0A    float ks = pow(max(ndoth, 0), m); // \EC\8A\A4\ED\8E\99\ED\81\98\EB\9F\AC \EA\B0\95\EB\8F\84\EC\9D\98 \ED\95\B5\EC\8B\AC\0D\0A    float ks_q = QuantizeKs(ks); // \EC\9D\B4\EC\82\B0\ED\99\94\0D\0A\0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    // fresnel(\EC\83\89) + (\ED\95\84\EC\9A\94\ED\95\98\EB\A9\B4) \EC\A0\95\EA\B7\9C\ED\99\94 \EA\B3\84\EC\88\98\EB\8A\94 \EC\B7\A8\ED\96\A5\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A\0D\0A    // ks_q\EB\A5\BC spec\EC\97\90 \EB\B0\98\EC\98\81\0D\0A    float3 specAlbedo = roughnessFactor * fresnelFactor * ks_q;\0D\0A\0D\0A    // LDR clamp\EB\8A\94 \EC\9C\A0\EC\A7\80 \EA\B0\80\EB\8A\A5\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A\0D\0A    // diffuse\EB\8A\94 kd_q\EB\A5\BC \EB\B0\98\EC\98\81\0D\0A    float3 diffuse = mat.DiffuseAlbedo.rgb * kd_q;\0D\0A    \0D\0A    return (diffuse + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!145 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDefault.hlsl"}
!146 = !{!"-E", !"VS", !"-T", !"vs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CDefault_vs.cso"}
!147 = !{i32 1, i32 0}
!148 = !{i32 1, i32 8}
!149 = !{!"vs", i32 6, i32 0}
!150 = !{null, null, !151, null}
!151 = !{!152, !153, !154}
!152 = !{i32 0, %hostlayout.cbPerObject* undef, !"cbPerObject", i32 0, i32 0, i32 1, i32 144, null}
!153 = !{i32 1, %hostlayout.cbMaterial* undef, !"cbMaterial", i32 0, i32 1, i32 1, i32 96, null}
!154 = !{i32 2, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!155 = !{i32 0, %struct.Light undef, !156, %hostlayout.cbPerObject undef, !163, %hostlayout.cbMaterial undef, !170, %hostlayout.cbPass undef, !175}
!156 = !{i32 48, !157, !158, !159, !160, !161, !162}
!157 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!158 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!159 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!160 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!161 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!162 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!163 = !{i32 144, !164, !166, !167, !168, !169}
!164 = !{i32 6, !"gWorld", i32 2, !165, i32 3, i32 0, i32 7, i32 9}
!165 = !{i32 4, i32 4, i32 2}
!166 = !{i32 6, !"gTexTransform", i32 2, !165, i32 3, i32 64, i32 7, i32 9}
!167 = !{i32 6, !"gDisplacementMapTexelSize", i32 3, i32 128, i32 7, i32 9}
!168 = !{i32 6, !"gGridSpatialStep", i32 3, i32 136, i32 7, i32 9}
!169 = !{i32 6, !"cbPerObjectPad1", i32 3, i32 140, i32 7, i32 9}
!170 = !{i32 96, !171, !172, !173, !174}
!171 = !{i32 6, !"gDiffuseAlbedo", i32 3, i32 0, i32 7, i32 9}
!172 = !{i32 6, !"gFresnelR0", i32 3, i32 16, i32 7, i32 9}
!173 = !{i32 6, !"gRoughness", i32 3, i32 28, i32 7, i32 9}
!174 = !{i32 6, !"gMatTransform", i32 2, !165, i32 3, i32 32, i32 7, i32 9}
!175 = !{i32 1248, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194, !195}
!176 = !{i32 6, !"gView", i32 2, !165, i32 3, i32 0, i32 7, i32 9}
!177 = !{i32 6, !"gInvView", i32 2, !165, i32 3, i32 64, i32 7, i32 9}
!178 = !{i32 6, !"gProj", i32 2, !165, i32 3, i32 128, i32 7, i32 9}
!179 = !{i32 6, !"gInvProj", i32 2, !165, i32 3, i32 192, i32 7, i32 9}
!180 = !{i32 6, !"gViewProj", i32 2, !165, i32 3, i32 256, i32 7, i32 9}
!181 = !{i32 6, !"gInvViewProj", i32 2, !165, i32 3, i32 320, i32 7, i32 9}
!182 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!183 = !{i32 6, !"cbPerPassPad1", i32 3, i32 396, i32 7, i32 9}
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
!196 = !{i32 1, void ()* @VS, !197}
!197 = !{!198}
!198 = !{i32 0, !2, !2}
!199 = !{[16 x i32] [i32 14, i32 14, i32 127, i32 127, i32 127, i32 0, i32 1792, i32 1792, i32 1792, i32 0, i32 0, i32 0, i32 0, i32 0, i32 12288, i32 12288]}
!200 = !{void ()* @VS, !"VS", !201, !150, !216}
!201 = !{!202, !210, null}
!202 = !{!203, !206, !207, !208}
!203 = !{i32 0, !"POSITION", i8 9, i8 0, !204, i8 0, i32 1, i8 3, i32 0, i8 0, !205}
!204 = !{i32 0}
!205 = !{i32 3, i32 7}
!206 = !{i32 1, !"NORMAL", i8 9, i8 0, !204, i8 0, i32 1, i8 3, i32 1, i8 0, !205}
!207 = !{i32 2, !"TANGENT", i8 9, i8 0, !204, i8 0, i32 1, i8 3, i32 2, i8 0, null}
!208 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !204, i8 0, i32 1, i8 2, i32 3, i8 0, !209}
!209 = !{i32 3, i32 3}
!210 = !{!211, !213, !214, !215}
!211 = !{i32 0, !"SV_Position", i8 9, i8 3, !204, i8 4, i32 1, i8 4, i32 0, i8 0, !212}
!212 = !{i32 3, i32 15}
!213 = !{i32 1, !"POSITION", i8 9, i8 0, !204, i8 2, i32 1, i8 3, i32 1, i8 0, !205}
!214 = !{i32 2, !"NORMAL", i8 9, i8 0, !204, i8 2, i32 1, i8 3, i32 2, i8 0, !205}
!215 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !204, i8 2, i32 1, i8 2, i32 3, i8 0, !209}
!216 = !{i32 0, i64 1}
!217 = !DILocation(line: 87, column: 23, scope: !32)
!218 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "vin", arg: 1, scope: !32, file: !1, line: 87, type: !56)
!219 = !DIExpression(DW_OP_bit_piece, 288, 32)
!220 = !DIExpression(DW_OP_bit_piece, 320, 32)
!221 = !DIExpression(DW_OP_bit_piece, 96, 32)
!222 = !DIExpression(DW_OP_bit_piece, 128, 32)
!223 = !DIExpression(DW_OP_bit_piece, 160, 32)
!224 = !DIExpression(DW_OP_bit_piece, 0, 32)
!225 = !DIExpression(DW_OP_bit_piece, 32, 32)
!226 = !DIExpression(DW_OP_bit_piece, 64, 32)
!227 = !DILocation(line: 89, column: 34, scope: !32)
!228 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "vout", scope: !32, file: !1, line: 89, type: !35)
!229 = !DIExpression(DW_OP_bit_piece, 0, 128)
!230 = !DILocation(line: 89, column: 15, scope: !32)
!231 = !DIExpression(DW_OP_bit_piece, 128, 96)
!232 = !DIExpression(DW_OP_bit_piece, 224, 96)
!233 = !DIExpression(DW_OP_bit_piece, 320, 64)
!234 = !DILocation(line: 106, column: 47, scope: !32)
!235 = !DILocation(line: 106, column: 19, scope: !32)
!236 = !DILocation(line: 106, column: 12, scope: !32)
!237 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "posW", scope: !32, file: !1, line: 106, type: !4)
!238 = !DILocation(line: 107, column: 15, scope: !32)
!239 = !DIExpression(DW_OP_bit_piece, 192, 32)
!240 = !DILocation(line: 110, column: 48, scope: !32)
!241 = !DILocation(line: 110, column: 20, scope: !32)
!242 = !DILocation(line: 110, column: 18, scope: !32)
!243 = !DIExpression(DW_OP_bit_piece, 224, 32)
!244 = !DIExpression(DW_OP_bit_piece, 256, 32)
!245 = !DILocation(line: 113, column: 27, scope: !32)
!246 = !DILocation(line: 113, column: 17, scope: !32)
!247 = !DILocation(line: 113, column: 15, scope: !32)
!248 = !DILocation(line: 115, column: 51, scope: !32)
!249 = !DILocation(line: 115, column: 19, scope: !32)
!250 = !DILocation(line: 115, column: 12, scope: !32)
!251 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "texC", scope: !32, file: !1, line: 115, type: !4)
!252 = !DILocation(line: 116, column: 27, scope: !32)
!253 = !DILocation(line: 116, column: 17, scope: !32)
!254 = !DILocation(line: 116, column: 15, scope: !32)
!255 = !DIExpression(DW_OP_bit_piece, 352, 32)
!256 = !DILocation(line: 118, column: 12, scope: !32)
!257 = !DILocation(line: 118, column: 5, scope: !32)
