;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Position              0   xyzw        0      POS   float       
; POSITION                 0   xyz         1     NONE   float   xyz 
; NORMAL                   0   xyz         2     NONE   float   xyz 
; TEXCOORD                 0   xy          3     NONE   float   xy  
;
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Target                0   xyzw        0   TARGET   float   xyzw
;
; shader debug name: 70b7b2ed13bb3003bb227578de4ec3ad.pdb
; shader hash: 70b7b2ed13bb3003bb227578de4ec3ad
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
; SigInputElements: 4
; SigOutputElements: 1
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 4
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
; cbMaterial                        cbuffer      NA          NA     CB0            cb1     1
; cbPass                            cbuffer      NA          NA     CB1            cb2     1
; gsamLinearWrap                    sampler      NA          NA      S0             s2     1
; gDiffuseMap                       texture     f32          2d      T0             t0     1
;
;
; ViewId state:
;
; Number of inputs: 14, outputs: 4
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;   output 0 depends on inputs: { 4, 5, 6, 8, 9, 10, 12, 13 }
;   output 1 depends on inputs: { 4, 5, 6, 8, 9, 10, 12, 13 }
;   output 2 depends on inputs: { 4, 5, 6, 8, 9, 10, 12, 13 }
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
  %gDiffuseMap_texture_2d = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 0, i32 0, i32 0, i1 false), !dbg !245 ; line:213 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %gsamLinearWrap_sampler = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 3, i32 0, i32 2, i1 false), !dbg !245 ; line:213 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 1, i32 2, i1 false), !dbg !245 ; line:213 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbMaterial_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 1, i1 false), !dbg !245 ; line:213 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !246, metadata !247), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"PS"
  %2 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !246, metadata !249), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 352, 32) func:"PS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !246, metadata !250), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !246, metadata !251), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 2, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !246, metadata !252), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !246, metadata !253), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !246, metadata !254), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !246, metadata !255), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  %9 = alloca [3 x float], align 4
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !246, metadata !253), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !246, metadata !254), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !246, metadata !255), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !246, metadata !250), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !246, metadata !251), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !246, metadata !252), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !246, metadata !247), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !246, metadata !249), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 352, 32) func:"PS"
  %10 = call %dx.types.ResRet.f32 @dx.op.sample.f32(i32 60, %dx.types.Handle %gDiffuseMap_texture_2d, %dx.types.Handle %gsamLinearWrap_sampler, float %1, float %2, float undef, float undef, i32 0, i32 0, i32 undef, float undef), !dbg !245 ; line:213 col:28  ; Sample(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,clamp)
  %11 = extractvalue %dx.types.ResRet.f32 %10, 0, !dbg !245 ; line:213 col:28
  %12 = extractvalue %dx.types.ResRet.f32 %10, 1, !dbg !245 ; line:213 col:28
  %13 = extractvalue %dx.types.ResRet.f32 %10, 2, !dbg !245 ; line:213 col:28
  %14 = extractvalue %dx.types.ResRet.f32 %10, 3, !dbg !245 ; line:213 col:28
  %15 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 0), !dbg !256 ; line:213 col:75  ; CBufferLoadLegacy(handle,regIndex)
  %16 = extractvalue %dx.types.CBufRet.f32 %15, 0, !dbg !256 ; line:213 col:75
  %17 = extractvalue %dx.types.CBufRet.f32 %15, 1, !dbg !256 ; line:213 col:75
  %18 = extractvalue %dx.types.CBufRet.f32 %15, 2, !dbg !256 ; line:213 col:75
  %19 = extractvalue %dx.types.CBufRet.f32 %15, 3, !dbg !256 ; line:213 col:75
  %.i0 = fmul fast float %11, %16, !dbg !257 ; line:213 col:73
  %.i1 = fmul fast float %12, %17, !dbg !257 ; line:213 col:73
  %.i2 = fmul fast float %13, %18, !dbg !257 ; line:213 col:73
  %.i3 = fmul fast float %14, %19, !dbg !257 ; line:213 col:73
  %20 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !258 ; line:213 col:12
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !259, metadata !260), !dbg !258 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !259, metadata !261), !dbg !258 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !259, metadata !262), !dbg !258 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !259, metadata !263), !dbg !258 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %21 = call float @dx.op.dot3.f32(i32 55, float %3, float %4, float %5, float %3, float %4, float %5), !dbg !264 ; line:216 col:19  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt1 = call float @dx.op.unary.f32(i32 25, float %21), !dbg !264 ; line:216 col:19  ; Rsqrt(value)
  %.i05 = fmul fast float %3, %Rsqrt1, !dbg !264 ; line:216 col:19
  %.i16 = fmul fast float %4, %Rsqrt1, !dbg !264 ; line:216 col:19
  %.i27 = fmul fast float %5, %Rsqrt1, !dbg !264 ; line:216 col:19
  %22 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !265 ; line:216 col:17
  call void @llvm.dbg.value(metadata float %.i05, i64 0, metadata !246, metadata !250), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i16, i64 0, metadata !246, metadata !251), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i27, i64 0, metadata !246, metadata !252), !dbg !248 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  %23 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 24), !dbg !266 ; line:219 col:21  ; CBufferLoadLegacy(handle,regIndex)
  %24 = extractvalue %dx.types.CBufRet.f32 %23, 0, !dbg !266 ; line:219 col:21
  %25 = extractvalue %dx.types.CBufRet.f32 %23, 1, !dbg !266 ; line:219 col:21
  %26 = extractvalue %dx.types.CBufRet.f32 %23, 2, !dbg !266 ; line:219 col:21
  %.i08 = fsub fast float %24, %6, !dbg !267 ; line:219 col:30
  %.i19 = fsub fast float %25, %7, !dbg !267 ; line:219 col:30
  %.i210 = fsub fast float %26, %8, !dbg !267 ; line:219 col:30
  %27 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !268 ; line:219 col:12
  call void @llvm.dbg.value(metadata float %.i08, i64 0, metadata !269, metadata !260), !dbg !268 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i19, i64 0, metadata !269, metadata !261), !dbg !268 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i210, i64 0, metadata !269, metadata !262), !dbg !268 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %28 = fmul fast float %.i08, %.i08, !dbg !270 ; line:220 col:23
  %29 = fmul fast float %.i19, %.i19, !dbg !270 ; line:220 col:23
  %30 = fadd fast float %28, %29, !dbg !270 ; line:220 col:23
  %31 = fmul fast float %.i210, %.i210, !dbg !270 ; line:220 col:23
  %32 = fadd fast float %30, %31, !dbg !270 ; line:220 col:23
  %Sqrt = call float @dx.op.unary.f32(i32 24, float %32), !dbg !270 ; line:220 col:23  ; Sqrt(value)
  %33 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !271 ; line:220 col:11
  call void @llvm.dbg.value(metadata float %Sqrt, i64 0, metadata !272, metadata !273), !dbg !271 ; var:"distToEye" !DIExpression() func:"PS"
  %.i011 = fdiv fast float %.i08, %Sqrt, !dbg !274 ; line:221 col:12
  %.i112 = fdiv fast float %.i19, %Sqrt, !dbg !274 ; line:221 col:12
  %.i213 = fdiv fast float %.i210, %Sqrt, !dbg !274 ; line:221 col:12
  %34 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !274 ; line:221 col:12
  call void @llvm.dbg.value(metadata float %.i011, i64 0, metadata !269, metadata !260), !dbg !268 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i112, i64 0, metadata !269, metadata !261), !dbg !268 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i213, i64 0, metadata !269, metadata !262), !dbg !268 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %35 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 27), !dbg !275 ; line:223 col:22  ; CBufferLoadLegacy(handle,regIndex)
  %36 = extractvalue %dx.types.CBufRet.f32 %35, 0, !dbg !275 ; line:223 col:22
  %37 = extractvalue %dx.types.CBufRet.f32 %35, 1, !dbg !275 ; line:223 col:22
  %38 = extractvalue %dx.types.CBufRet.f32 %35, 2, !dbg !275 ; line:223 col:22
  %.i014 = fmul fast float %36, %.i0, !dbg !276 ; line:223 col:36
  %.i115 = fmul fast float %37, %.i1, !dbg !276 ; line:223 col:36
  %.i216 = fmul fast float %38, %.i2, !dbg !276 ; line:223 col:36
  %39 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !277 ; line:223 col:12
  call void @llvm.dbg.value(metadata float %.i014, i64 0, metadata !278, metadata !260), !dbg !277 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i115, i64 0, metadata !278, metadata !261), !dbg !277 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i216, i64 0, metadata !278, metadata !262), !dbg !277 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %40 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 1), !dbg !279 ; line:224 col:36  ; CBufferLoadLegacy(handle,regIndex)
  %41 = extractvalue %dx.types.CBufRet.f32 %40, 3, !dbg !279 ; line:224 col:36
  %42 = fsub fast float 1.000000e+00, %41, !dbg !280 ; line:224 col:34
  %43 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !281 ; line:224 col:17
  call void @llvm.dbg.value(metadata float %42, i64 0, metadata !282, metadata !273), !dbg !281 ; var:"shininess" !DIExpression() func:"PS"
  %44 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !283 ; line:225 col:20
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !284, metadata !260), !dbg !285 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !284, metadata !261), !dbg !285 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !284, metadata !262), !dbg !285 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !284, metadata !263), !dbg !285 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !286, metadata !260), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !286, metadata !261), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !286, metadata !262), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !286, metadata !263), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !289, metadata !260), !dbg !290 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !289, metadata !261), !dbg !290 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !289, metadata !262), !dbg !290 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !289, metadata !263), !dbg !290 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !295, metadata !260), !dbg !296 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !295, metadata !261), !dbg !296 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !295, metadata !262), !dbg !296 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !295, metadata !263), !dbg !296 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"BlinnPhong"
  %45 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 1), !dbg !298 ; line:225 col:37  ; CBufferLoadLegacy(handle,regIndex)
  %46 = extractvalue %dx.types.CBufRet.f32 %45, 0, !dbg !298 ; line:225 col:37
  call void @llvm.dbg.value(metadata float %46, i64 0, metadata !299, metadata !260), !dbg !300 ; var:"R0" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  %47 = extractvalue %dx.types.CBufRet.f32 %45, 1, !dbg !298 ; line:225 col:37
  call void @llvm.dbg.value(metadata float %47, i64 0, metadata !299, metadata !261), !dbg !300 ; var:"R0" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  %48 = extractvalue %dx.types.CBufRet.f32 %45, 2, !dbg !298 ; line:225 col:37
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !299, metadata !262), !dbg !300 ; var:"R0" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %49 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !283 ; line:225 col:20
  call void @llvm.dbg.value(metadata float %46, i64 0, metadata !284, metadata !253), !dbg !285 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %47, i64 0, metadata !284, metadata !254), !dbg !285 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !284, metadata !255), !dbg !285 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %46, i64 0, metadata !286, metadata !253), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %47, i64 0, metadata !286, metadata !254), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !286, metadata !255), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %46, i64 0, metadata !289, metadata !253), !dbg !290 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %47, i64 0, metadata !289, metadata !254), !dbg !290 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !289, metadata !255), !dbg !290 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %46, i64 0, metadata !295, metadata !253), !dbg !296 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %47, i64 0, metadata !295, metadata !254), !dbg !296 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !295, metadata !255), !dbg !296 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"BlinnPhong"
  %50 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !283 ; line:225 col:20
  call void @llvm.dbg.value(metadata float %42, i64 0, metadata !284, metadata !250), !dbg !285 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %42, i64 0, metadata !286, metadata !250), !dbg !287 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %42, i64 0, metadata !289, metadata !250), !dbg !290 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %42, i64 0, metadata !295, metadata !250), !dbg !296 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"BlinnPhong"
  %51 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !302 ; line:226 col:12
  call void @llvm.dbg.value(metadata <3 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, i64 0, metadata !303, metadata !273), !dbg !302 ; var:"shadowFactor" !DIExpression() func:"PS"
  %52 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !304 ; line:228 col:26
  %53 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !304 ; line:228 col:26
  %54 = getelementptr inbounds [3 x float], [3 x float]* %9, i32 0, i32 0, !dbg !304 ; line:228 col:26
  store float 1.000000e+00, float* %54, align 4, !dbg !304 ; line:228 col:26
  %55 = getelementptr inbounds [3 x float], [3 x float]* %9, i32 0, i32 1, !dbg !304 ; line:228 col:26
  store float 1.000000e+00, float* %55, align 4, !dbg !304 ; line:228 col:26
  %56 = getelementptr inbounds [3 x float], [3 x float]* %9, i32 0, i32 2, !dbg !304 ; line:228 col:26
  store float 1.000000e+00, float* %56, align 4, !dbg !304 ; line:228 col:26
  call void @llvm.dbg.value(metadata float %.i011, i64 0, metadata !305, metadata !260), !dbg !306 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i112, i64 0, metadata !305, metadata !261), !dbg !306 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i213, i64 0, metadata !305, metadata !262), !dbg !306 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i05, i64 0, metadata !307, metadata !260), !dbg !308 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i16, i64 0, metadata !307, metadata !261), !dbg !308 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i27, i64 0, metadata !307, metadata !262), !dbg !308 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %57 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !309 ; line:196 col:12
  call void @llvm.dbg.value(metadata <3 x float> zeroinitializer, i64 0, metadata !310, metadata !273), !dbg !309 ; var:"result" !DIExpression() func:"ComputeLighting"
  %58 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !311 ; line:197 col:9
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !312, metadata !273), !dbg !311 ; var:"i" !DIExpression() func:"ComputeLighting"
  %59 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !313 ; line:200 col:11
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !312, metadata !273), !dbg !311 ; var:"i" !DIExpression() func:"ComputeLighting"
  br label %.lr.ph, !dbg !314 ; line:200 col:5

.lr.ph:                                           ; preds = %0
  br label %60, !dbg !314 ; line:200 col:5

; <label>:60                                      ; preds = %60, %.lr.ph
  %result.i.0.i0 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i018, %60 ]
  %result.i.0.i1 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i119, %60 ]
  %result.i.0.i2 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i220, %60 ]
  %i.i.0 = phi i32 [ 0, %.lr.ph ], [ %109, %60 ]
  call void @llvm.dbg.value(metadata i32 %i.i.0, i64 0, metadata !312, metadata !273), !dbg !311 ; var:"i" !DIExpression() func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i0, i64 0, metadata !310, metadata !260), !dbg !309 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i1, i64 0, metadata !310, metadata !261), !dbg !309 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i2, i64 0, metadata !310, metadata !262), !dbg !309 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %61 = getelementptr [3 x float], [3 x float]* %9, i32 0, i32 %i.i.0, !dbg !315 ; line:202 col:19
  %62 = load float, float* %61, !dbg !315 ; line:202 col:19
  %63 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !316 ; line:202 col:37
  %64 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !316 ; line:202 col:37
  %65 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !316 ; line:202 col:37
  call void @llvm.dbg.value(metadata float %.i011, i64 0, metadata !317, metadata !260), !dbg !318 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i112, i64 0, metadata !317, metadata !261), !dbg !318 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i213, i64 0, metadata !317, metadata !262), !dbg !318 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i05, i64 0, metadata !319, metadata !260), !dbg !320 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i16, i64 0, metadata !319, metadata !261), !dbg !320 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i27, i64 0, metadata !319, metadata !262), !dbg !320 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %66 = mul i32 %i.i.0, 3, !dbg !321 ; line:118 col:26
  %67 = add i32 28, %66, !dbg !321 ; line:118 col:26
  %68 = add i32 %67, 1, !dbg !321 ; line:118 col:26
  %69 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 %68), !dbg !321 ; line:118 col:26  ; CBufferLoadLegacy(handle,regIndex)
  %70 = extractvalue %dx.types.CBufRet.f32 %69, 0, !dbg !321 ; line:118 col:26
  %71 = extractvalue %dx.types.CBufRet.f32 %69, 1, !dbg !321 ; line:118 col:26
  %72 = extractvalue %dx.types.CBufRet.f32 %69, 2, !dbg !321 ; line:118 col:26
  %.i022 = fsub fast float -0.000000e+00, %70, !dbg !322 ; line:118 col:23
  %.i124 = fsub fast float -0.000000e+00, %71, !dbg !322 ; line:118 col:23
  %.i226 = fsub fast float -0.000000e+00, %72, !dbg !322 ; line:118 col:23
  %73 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !323 ; line:118 col:12
  call void @llvm.dbg.value(metadata float %.i022, i64 0, metadata !324, metadata !260), !dbg !323 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i124, i64 0, metadata !324, metadata !261), !dbg !323 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i226, i64 0, metadata !324, metadata !262), !dbg !323 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %74 = call float @dx.op.dot3.f32(i32 55, float %.i022, float %.i124, float %.i226, float %.i05, float %.i16, float %.i27), !dbg !325 ; line:121 col:23  ; Dot3(ax,ay,az,bx,by,bz)
  %FMax4 = call float @dx.op.binary.f32(i32 35, float %74, float 0.000000e+00), !dbg !326 ; line:121 col:19  ; FMax(a,b)
  %75 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !327 ; line:121 col:11
  call void @llvm.dbg.value(metadata float %FMax4, i64 0, metadata !328, metadata !273), !dbg !327 ; var:"ndotl" !DIExpression() func:"ComputeDirectionalLight"
  %76 = mul i32 %i.i.0, 3, !dbg !329 ; line:127 col:30
  %77 = add i32 28, %76, !dbg !329 ; line:127 col:30
  %78 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 %77), !dbg !329 ; line:127 col:30  ; CBufferLoadLegacy(handle,regIndex)
  %79 = extractvalue %dx.types.CBufRet.f32 %78, 0, !dbg !329 ; line:127 col:30
  %80 = extractvalue %dx.types.CBufRet.f32 %78, 1, !dbg !329 ; line:127 col:30
  %81 = extractvalue %dx.types.CBufRet.f32 %78, 2, !dbg !329 ; line:127 col:30
  %.i027 = fmul fast float %79, %FMax4, !dbg !330 ; line:127 col:39
  %.i128 = fmul fast float %80, %FMax4, !dbg !330 ; line:127 col:39
  %.i229 = fmul fast float %81, %FMax4, !dbg !330 ; line:127 col:39
  %82 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !331 ; line:127 col:12
  call void @llvm.dbg.value(metadata float %.i027, i64 0, metadata !332, metadata !260), !dbg !331 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i128, i64 0, metadata !332, metadata !261), !dbg !331 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i229, i64 0, metadata !332, metadata !262), !dbg !331 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %83 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !333 ; line:128 col:12
  %84 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !333 ; line:128 col:12
  call void @llvm.dbg.value(metadata float %.i011, i64 0, metadata !334, metadata !260), !dbg !335 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i112, i64 0, metadata !334, metadata !261), !dbg !335 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i213, i64 0, metadata !334, metadata !262), !dbg !335 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i05, i64 0, metadata !336, metadata !260), !dbg !337 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i16, i64 0, metadata !336, metadata !261), !dbg !337 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i27, i64 0, metadata !336, metadata !262), !dbg !337 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i022, i64 0, metadata !338, metadata !260), !dbg !339 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i124, i64 0, metadata !338, metadata !261), !dbg !339 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i226, i64 0, metadata !338, metadata !262), !dbg !339 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i027, i64 0, metadata !340, metadata !260), !dbg !341 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i128, i64 0, metadata !340, metadata !261), !dbg !341 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i229, i64 0, metadata !340, metadata !262), !dbg !341 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %85 = fmul fast float %42, 2.560000e+02, !dbg !342 ; line:70 col:35
  %86 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !343 ; line:70 col:17
  call void @llvm.dbg.value(metadata float %85, i64 0, metadata !344, metadata !273), !dbg !343 ; var:"m" !DIExpression() func:"BlinnPhong"
  %.i030 = fadd fast float %.i011, %.i022, !dbg !345 ; line:71 col:38
  %.i131 = fadd fast float %.i112, %.i124, !dbg !345 ; line:71 col:38
  %.i232 = fadd fast float %.i213, %.i226, !dbg !345 ; line:71 col:38
  %87 = call float @dx.op.dot3.f32(i32 55, float %.i030, float %.i131, float %.i232, float %.i030, float %.i131, float %.i232), !dbg !346 ; line:71 col:22  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt = call float @dx.op.unary.f32(i32 25, float %87), !dbg !346 ; line:71 col:22  ; Rsqrt(value)
  %.i033 = fmul fast float %.i030, %Rsqrt, !dbg !346 ; line:71 col:22
  %.i134 = fmul fast float %.i131, %Rsqrt, !dbg !346 ; line:71 col:22
  %.i235 = fmul fast float %.i232, %Rsqrt, !dbg !346 ; line:71 col:22
  %88 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !347 ; line:71 col:12
  call void @llvm.dbg.value(metadata float %.i033, i64 0, metadata !348, metadata !260), !dbg !347 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i134, i64 0, metadata !348, metadata !261), !dbg !347 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i235, i64 0, metadata !348, metadata !262), !dbg !347 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %89 = fadd fast float %85, 8.000000e+00, !dbg !349 ; line:73 col:32
  %90 = call float @dx.op.dot3.f32(i32 55, float %.i033, float %.i134, float %.i235, float %.i05, float %.i16, float %.i27), !dbg !350 ; line:73 col:50  ; Dot3(ax,ay,az,bx,by,bz)
  %FMax = call float @dx.op.binary.f32(i32 35, float %90, float 0.000000e+00), !dbg !351 ; line:73 col:46  ; FMax(a,b)
  %Log2 = call float @dx.op.unary.f32(i32 23, float %FMax), !dbg !352 ; line:73 col:42  ; Log(value)
  %91 = fmul fast float %Log2, %85, !dbg !352 ; line:73 col:42
  %Exp3 = call float @dx.op.unary.f32(i32 21, float %91), !dbg !352 ; line:73 col:42  ; Exp(value)
  %92 = fmul fast float %89, %Exp3, !dbg !353 ; line:73 col:40
  %93 = fdiv fast float %92, 8.000000e+00, !dbg !354 ; line:73 col:82
  %94 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !355 ; line:73 col:11
  call void @llvm.dbg.value(metadata float %93, i64 0, metadata !356, metadata !273), !dbg !355 ; var:"roughnessFactor" !DIExpression() func:"BlinnPhong"
  %95 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !357 ; line:74 col:28
  call void @llvm.dbg.value(metadata float %.i022, i64 0, metadata !358, metadata !260), !dbg !359 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i124, i64 0, metadata !358, metadata !261), !dbg !359 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i226, i64 0, metadata !358, metadata !262), !dbg !359 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i033, i64 0, metadata !360, metadata !260), !dbg !361 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i134, i64 0, metadata !360, metadata !261), !dbg !361 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i235, i64 0, metadata !360, metadata !262), !dbg !361 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %46, i64 0, metadata !299, metadata !260), !dbg !300 ; var:"R0" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %47, i64 0, metadata !299, metadata !261), !dbg !300 ; var:"R0" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !299, metadata !262), !dbg !300 ; var:"R0" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %96 = call float @dx.op.dot3.f32(i32 55, float %.i033, float %.i134, float %.i235, float %.i022, float %.i124, float %.i226), !dbg !362 ; line:61 col:39  ; Dot3(ax,ay,az,bx,by,bz)
  %Saturate = call float @dx.op.unary.f32(i32 7, float %96), !dbg !363 ; line:61 col:30  ; Saturate(value)
  %97 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !364 ; line:61 col:11
  call void @llvm.dbg.value(metadata float %Saturate, i64 0, metadata !365, metadata !273), !dbg !364 ; var:"cosIncidentAngle" !DIExpression() func:"SchlickFresnel"
  %98 = fsub fast float 1.000000e+00, %Saturate, !dbg !366 ; line:62 col:21
  %99 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !367 ; line:62 col:11
  call void @llvm.dbg.value(metadata float %98, i64 0, metadata !368, metadata !273), !dbg !367 ; var:"f0" !DIExpression() func:"SchlickFresnel"
  %.i037 = fsub fast float 1.000000e+00, %46, !dbg !369 ; line:63 col:40
  %.i139 = fsub fast float 1.000000e+00, %47, !dbg !369 ; line:63 col:40
  %.i241 = fsub fast float 1.000000e+00, %48, !dbg !369 ; line:63 col:40
  %Log = call float @dx.op.unary.f32(i32 23, float %98), !dbg !370 ; line:63 col:48  ; Log(value)
  %100 = fmul fast float %Log, 5.000000e+00, !dbg !370 ; line:63 col:48
  %Exp = call float @dx.op.unary.f32(i32 21, float %100), !dbg !370 ; line:63 col:48  ; Exp(value)
  %.i042 = fmul fast float %.i037, %Exp, !dbg !371 ; line:63 col:46
  %.i143 = fmul fast float %.i139, %Exp, !dbg !371 ; line:63 col:46
  %.i244 = fmul fast float %.i241, %Exp, !dbg !371 ; line:63 col:46
  %.i045 = fadd fast float %46, %.i042, !dbg !372 ; line:63 col:32
  %.i146 = fadd fast float %47, %.i143, !dbg !372 ; line:63 col:32
  %.i247 = fadd fast float %48, %.i244, !dbg !372 ; line:63 col:32
  %101 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !373 ; line:63 col:12
  call void @llvm.dbg.value(metadata float %.i045, i64 0, metadata !374, metadata !260), !dbg !373 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i146, i64 0, metadata !374, metadata !261), !dbg !373 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i247, i64 0, metadata !374, metadata !262), !dbg !373 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %102 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !375 ; line:65 col:5
  %103 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !376 ; line:74 col:12
  call void @llvm.dbg.value(metadata float %.i045, i64 0, metadata !377, metadata !260), !dbg !376 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i146, i64 0, metadata !377, metadata !261), !dbg !376 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i247, i64 0, metadata !377, metadata !262), !dbg !376 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i048 = fmul fast float %.i045, %93, !dbg !378 ; line:76 col:39
  %.i149 = fmul fast float %.i146, %93, !dbg !378 ; line:76 col:39
  %.i250 = fmul fast float %.i247, %93, !dbg !378 ; line:76 col:39
  %104 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !379 ; line:76 col:12
  call void @llvm.dbg.value(metadata float %.i048, i64 0, metadata !380, metadata !260), !dbg !379 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i149, i64 0, metadata !380, metadata !261), !dbg !379 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i250, i64 0, metadata !380, metadata !262), !dbg !379 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i052 = fadd fast float %.i048, 1.000000e+00, !dbg !381 ; line:80 col:43
  %.i154 = fadd fast float %.i149, 1.000000e+00, !dbg !381 ; line:80 col:43
  %.i256 = fadd fast float %.i250, 1.000000e+00, !dbg !381 ; line:80 col:43
  %.i057 = fdiv fast float %.i048, %.i052, !dbg !382 ; line:80 col:29
  %.i158 = fdiv fast float %.i149, %.i154, !dbg !382 ; line:80 col:29
  %.i259 = fdiv fast float %.i250, %.i256, !dbg !382 ; line:80 col:29
  %105 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !383 ; line:80 col:16
  call void @llvm.dbg.value(metadata float %.i057, i64 0, metadata !380, metadata !260), !dbg !379 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i158, i64 0, metadata !380, metadata !261), !dbg !379 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i259, i64 0, metadata !380, metadata !262), !dbg !379 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i060 = fadd fast float %.i0, %.i057, !dbg !384 ; line:82 col:35
  %.i161 = fadd fast float %.i1, %.i158, !dbg !384 ; line:82 col:35
  %.i262 = fadd fast float %.i2, %.i259, !dbg !384 ; line:82 col:35
  %.i063 = fmul fast float %.i060, %.i027, !dbg !385 ; line:82 col:49
  %.i164 = fmul fast float %.i161, %.i128, !dbg !385 ; line:82 col:49
  %.i265 = fmul fast float %.i262, %.i229, !dbg !385 ; line:82 col:49
  %106 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !386 ; line:82 col:5
  %107 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !387 ; line:128 col:5
  %.i066 = fmul fast float %62, %.i063, !dbg !388 ; line:202 col:35
  %.i167 = fmul fast float %62, %.i164, !dbg !388 ; line:202 col:35
  %.i268 = fmul fast float %62, %.i265, !dbg !388 ; line:202 col:35
  %.i018 = fadd fast float %result.i.0.i0, %.i066, !dbg !389 ; line:202 col:16
  %.i119 = fadd fast float %result.i.0.i1, %.i167, !dbg !389 ; line:202 col:16
  %.i220 = fadd fast float %result.i.0.i2, %.i268, !dbg !389 ; line:202 col:16
  %108 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !389 ; line:202 col:16
  call void @llvm.dbg.value(metadata float %.i018, i64 0, metadata !310, metadata !260), !dbg !309 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i119, i64 0, metadata !310, metadata !261), !dbg !309 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i220, i64 0, metadata !310, metadata !262), !dbg !309 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %109 = add nsw i32 %i.i.0, 1, !dbg !390 ; line:200 col:36
  %110 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !390 ; line:200 col:36
  call void @llvm.dbg.value(metadata i32 %109, i64 0, metadata !312, metadata !273), !dbg !311 ; var:"i" !DIExpression() func:"ComputeLighting"
  %111 = icmp slt i32 %109, 3, !dbg !391 ; line:200 col:18
  br i1 %111, label %60, label %".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge", !dbg !314 ; line:200 col:5

".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge": ; preds = %60
  br label %"\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit", !dbg !314 ; line:200 col:5

"\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit": ; preds = %".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge"
  call void @llvm.dbg.value(metadata float %.i018, i64 0, metadata !310, metadata !260), !dbg !309 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i119, i64 0, metadata !310, metadata !261), !dbg !309 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i220, i64 0, metadata !310, metadata !262), !dbg !309 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %112 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !392 ; line:220 col:5
  %113 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !393 ; line:228 col:12
  call void @llvm.dbg.value(metadata float %.i018, i64 0, metadata !394, metadata !260), !dbg !393 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i119, i64 0, metadata !394, metadata !261), !dbg !393 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i220, i64 0, metadata !394, metadata !262), !dbg !393 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !394, metadata !263), !dbg !393 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %.i072 = fadd fast float %.i014, %.i018, !dbg !395 ; line:231 col:31
  %.i173 = fadd fast float %.i115, %.i119, !dbg !395 ; line:231 col:31
  %.i274 = fadd fast float %.i216, %.i220, !dbg !395 ; line:231 col:31
  %114 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !396 ; line:231 col:12
  call void @llvm.dbg.value(metadata float %.i072, i64 0, metadata !397, metadata !260), !dbg !396 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i173, i64 0, metadata !397, metadata !261), !dbg !396 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i274, i64 0, metadata !397, metadata !262), !dbg !396 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %115 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !398 ; line:234 col:16
  call void @llvm.dbg.value(metadata float %.i072, i64 0, metadata !397, metadata !260), !dbg !396 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i173, i64 0, metadata !397, metadata !261), !dbg !396 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i274, i64 0, metadata !397, metadata !262), !dbg !396 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !397, metadata !263), !dbg !396 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %116 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !399 ; line:236 col:5
  call void @llvm.dbg.declare(metadata [3 x float]* %9, metadata !400, metadata !273), !dbg !401 ; var:"shadowFactor" !DIExpression() func:"ComputeLighting"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %.i072), !dbg !399 ; line:236 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %.i173), !dbg !399 ; line:236 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %.i274), !dbg !399 ; line:236 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %.i3), !dbg !399 ; line:236 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  ret void, !dbg !399 ; line:236 col:5
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare float @dx.op.loadInput.f32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #1

; Function Attrs: nounwind readnone
declare float @dx.op.dot3.f32(i32, float, float, float, float, float, float) #0

; Function Attrs: nounwind readnone
declare float @dx.op.unary.f32(i32, float) #0

; Function Attrs: nounwind readonly
declare %dx.types.ResRet.f32 @dx.op.sample.f32(i32, %dx.types.Handle, %dx.types.Handle, float, float, float, float, i32, i32, i32, float) #2

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
!llvm.module.flags = !{!173, !174}
!llvm.ident = !{!175}
!dx.source.contents = !{!176, !177}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!178}
!dx.source.args = !{!179}
!dx.version = !{!180}
!dx.valver = !{!181}
!dx.shaderModel = !{!182}
!dx.resources = !{!183}
!dx.typeAnnotations = !{!192, !227}
!dx.viewIdState = !{!230}
!dx.entryPoints = !{!231}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !16, globals: !99)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl", directory: "")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 39, baseType: !5)
!5 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 39, size: 128, align: 32, elements: !6, templateParams: !12)
!6 = !{!7, !9, !10, !11}
!7 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !5, file: !1, line: 39, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!8 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!9 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !5, file: !1, line: 39, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!10 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !5, file: !1, line: 39, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!11 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !5, file: !1, line: 39, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!12 = !{!13, !14}
!13 = !DITemplateTypeParameter(name: "element", type: !8)
!14 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 4)
!15 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!16 = !{!17, !61, !70, !90, !93, !96}
!17 = !DISubprogram(name: "ConstantHS", linkageName: "\01?ConstantHS@@YA?AUPatchTess@@V?$InputPatch@UVertexIn@@$03@@I@Z", scope: !1, file: !1, line: 118, type: !18, isLocal: false, isDefinition: true, scopeLine: 119, flags: DIFlagPrototyped, isOptimized: false)
!18 = !DISubroutineType(types: !19)
!19 = !{!20, !30, !59}
!20 = !DICompositeType(tag: DW_TAG_structure_type, name: "PatchTess", file: !1, line: 83, size: 192, align: 32, elements: !21)
!21 = !{!22, !26}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "EdgeTess", scope: !20, file: !1, line: 85, baseType: !23, size: 128, align: 32)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 128, align: 32, elements: !24)
!24 = !{!25}
!25 = !DISubrange(count: 4)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "InsideTess", scope: !20, file: !1, line: 86, baseType: !27, size: 64, align: 32, offset: 128)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 64, align: 32, elements: !28)
!28 = !{!29}
!29 = !DISubrange(count: 2)
!30 = !DICompositeType(tag: DW_TAG_class_type, name: "InputPatch<VertexIn, 4>", file: !1, line: 73, size: 1024, align: 32, elements: !31, templateParams: !56)
!31 = !{!32, !34}
!32 = !DIDerivedType(tag: DW_TAG_member, name: "Length", scope: !30, file: !1, line: 73, baseType: !33, flags: DIFlagPublic | DIFlagStaticMember, extraData: i32 4)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "h", scope: !30, file: !1, line: 73, baseType: !35, size: 1024, align: 32)
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !36, size: 1024, align: 32, elements: !24)
!36 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexIn", file: !1, line: 76, size: 256, align: 32, elements: !37)
!37 = !{!38, !47, !48}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "PosL", scope: !36, file: !1, line: 78, baseType: !39, size: 96, align: 32)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 40, baseType: !40)
!40 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 40, size: 96, align: 32, elements: !41, templateParams: !45)
!41 = !{!42, !43, !44}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !40, file: !1, line: 40, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !40, file: !1, line: 40, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !40, file: !1, line: 40, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!45 = !{!13, !46}
!46 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 3)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "NormalL", scope: !36, file: !1, line: 79, baseType: !39, size: 96, align: 32, offset: 96)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !36, file: !1, line: 80, baseType: !49, size: 64, align: 32, offset: 192)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 32, baseType: !50)
!50 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 32, size: 64, align: 32, elements: !51, templateParams: !54)
!51 = !{!52, !53}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !50, file: !1, line: 32, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !50, file: !1, line: 32, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!54 = !{!13, !55}
!55 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 2)
!56 = !{!57, !58}
!57 = !DITemplateTypeParameter(name: "element", type: !36)
!58 = !DITemplateValueParameter(name: "count", type: !15, value: i32 4)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 73, baseType: !60)
!60 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!61 = !DISubprogram(name: "PS", scope: !1, file: !1, line: 211, type: !62, isLocal: false, isDefinition: true, scopeLine: 212, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @PS)
!62 = !DISubroutineType(types: !63)
!63 = !{!4, !64}
!64 = !DICompositeType(tag: DW_TAG_structure_type, name: "DomainOut", file: !1, line: 89, size: 384, align: 32, elements: !65)
!65 = !{!66, !67, !68, !69}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !64, file: !1, line: 91, baseType: !4, size: 128, align: 32)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !64, file: !1, line: 92, baseType: !39, size: 96, align: 32, offset: 128)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !64, file: !1, line: 93, baseType: !39, size: 96, align: 32, offset: 224)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !64, file: !1, line: 94, baseType: !49, size: 64, align: 32, offset: 320)
!70 = !DISubprogram(name: "ComputeLighting", linkageName: "\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z", scope: !71, file: !71, line: 194, type: !72, isLocal: false, isDefinition: true, scopeLine: 195, flags: DIFlagPrototyped, isOptimized: false)
!71 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!72 = !DISubroutineType(types: !73)
!73 = !{!4, !74, !85, !39, !39, !39, !39}
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !75, size: 6144, align: 32, elements: !83)
!75 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !71, line: 3, size: 384, align: 32, elements: !76)
!76 = !{!77, !78, !79, !80, !81, !82}
!77 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !75, file: !71, line: 5, baseType: !39, size: 96, align: 32)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !75, file: !71, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !75, file: !71, line: 7, baseType: !39, size: 96, align: 32, offset: 128)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !75, file: !71, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !75, file: !71, line: 9, baseType: !39, size: 96, align: 32, offset: 256)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !75, file: !71, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!83 = !{!84}
!84 = !DISubrange(count: 16)
!85 = !DICompositeType(tag: DW_TAG_structure_type, name: "Material", file: !71, line: 13, size: 256, align: 32, elements: !86)
!86 = !{!87, !88, !89}
!87 = !DIDerivedType(tag: DW_TAG_member, name: "DiffuseAlbedo", scope: !85, file: !71, line: 15, baseType: !4, size: 128, align: 32)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "FresnelR0", scope: !85, file: !71, line: 16, baseType: !39, size: 96, align: 32, offset: 128)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "Shininess", scope: !85, file: !71, line: 17, baseType: !8, size: 32, align: 32, offset: 224)
!90 = !DISubprogram(name: "ComputeDirectionalLight", linkageName: "\01?ComputeDirectionalLight@@YA?AV?$vector@M$02@@ULight@@UMaterial@@V1@2@Z", scope: !71, file: !71, line: 115, type: !91, isLocal: false, isDefinition: true, scopeLine: 116, flags: DIFlagPrototyped, isOptimized: false)
!91 = !DISubroutineType(types: !92)
!92 = !{!39, !75, !85, !39, !39}
!93 = !DISubprogram(name: "BlinnPhong", linkageName: "\01?BlinnPhong@@YA?AV?$vector@M$02@@V1@000UMaterial@@@Z", scope: !71, file: !71, line: 68, type: !94, isLocal: false, isDefinition: true, scopeLine: 69, flags: DIFlagPrototyped, isOptimized: false)
!94 = !DISubroutineType(types: !95)
!95 = !{!39, !39, !39, !39, !39, !85}
!96 = !DISubprogram(name: "SchlickFresnel", linkageName: "\01?SchlickFresnel@@YA?AV?$vector@M$02@@V1@00@Z", scope: !71, file: !71, line: 59, type: !97, isLocal: false, isDefinition: true, scopeLine: 60, flags: DIFlagPrototyped, isOptimized: false)
!97 = !DISubroutineType(types: !98)
!98 = !{!39, !39, !39, !39}
!99 = !{!100, !124, !125, !127, !129, !130, !132, !134, !135, !136, !137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151, !154, !155, !156, !157, !158, !159, !160, !164, !165, !166, !168, !169, !170, !171, !172}
!100 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 30, type: !101, isLocal: false, isDefinition: true)
!101 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !102)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 30, baseType: !103)
!103 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 30, size: 512, align: 32, elements: !104, templateParams: !121)
!104 = !{!105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !103, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!121 = !{!13, !122, !123}
!122 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 4)
!123 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 4)
!124 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 31, type: !101, isLocal: false, isDefinition: true)
!125 = !DIGlobalVariable(name: "gDisplacementMapTexelSize", linkageName: "\01?gDisplacementMapTexelSize@cbPerObject@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 32, type: !126, isLocal: false, isDefinition: true)
!126 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !49)
!127 = !DIGlobalVariable(name: "gGridSpatialStep", linkageName: "\01?gGridSpatialStep@cbPerObject@@3MB", scope: !0, file: !1, line: 33, type: !128, isLocal: false, isDefinition: true)
!128 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!129 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPerObject@@3MB", scope: !0, file: !1, line: 34, type: !128, isLocal: false, isDefinition: true)
!130 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 39, type: !131, isLocal: false, isDefinition: true)
!131 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!132 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 40, type: !133, isLocal: false, isDefinition: true)
!133 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !39)
!134 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 41, type: !128, isLocal: false, isDefinition: true)
!135 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !101, isLocal: false, isDefinition: true)
!136 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 47, type: !101, isLocal: false, isDefinition: true)
!137 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 48, type: !101, isLocal: false, isDefinition: true)
!138 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 49, type: !101, isLocal: false, isDefinition: true)
!139 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 50, type: !101, isLocal: false, isDefinition: true)
!140 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 51, type: !101, isLocal: false, isDefinition: true)
!141 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 52, type: !101, isLocal: false, isDefinition: true)
!142 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 53, type: !133, isLocal: false, isDefinition: true)
!143 = !DIGlobalVariable(name: "cbPerPassPad1", linkageName: "\01?cbPerPassPad1@cbPass@@3MB", scope: !0, file: !1, line: 54, type: !128, isLocal: false, isDefinition: true)
!144 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 55, type: !126, isLocal: false, isDefinition: true)
!145 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 56, type: !126, isLocal: false, isDefinition: true)
!146 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 57, type: !128, isLocal: false, isDefinition: true)
!147 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 58, type: !128, isLocal: false, isDefinition: true)
!148 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 59, type: !128, isLocal: false, isDefinition: true)
!149 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 60, type: !128, isLocal: false, isDefinition: true)
!150 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 61, type: !131, isLocal: false, isDefinition: true)
!151 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 66, type: !152, isLocal: false, isDefinition: true)
!152 = !DICompositeType(tag: DW_TAG_array_type, baseType: !153, size: 6144, align: 32, elements: !83)
!153 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !75)
!154 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 70, type: !131, isLocal: false, isDefinition: true)
!155 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 71, type: !128, isLocal: false, isDefinition: true)
!156 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 72, type: !128, isLocal: false, isDefinition: true)
!157 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 73, type: !126, isLocal: false, isDefinition: true)
!158 = !DIGlobalVariable(name: "d0", scope: !17, file: !1, line: 131, type: !128, isLocal: true, isDefinition: true)
!159 = !DIGlobalVariable(name: "d1", scope: !17, file: !1, line: 132, type: !128, isLocal: true, isDefinition: true)
!160 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 17, type: !161, isLocal: false, isDefinition: true)
!161 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 17, size: 160, align: 32, elements: !2, templateParams: !162)
!162 = !{!163}
!163 = !DITemplateTypeParameter(name: "element", type: !5)
!164 = !DIGlobalVariable(name: "gDiffuseMap2", linkageName: "\01?gDiffuseMap2@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 18, type: !161, isLocal: false, isDefinition: true)
!165 = !DIGlobalVariable(name: "gDisplacementMap", linkageName: "\01?gDisplacementMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 19, type: !161, isLocal: false, isDefinition: true)
!166 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !167, isLocal: false, isDefinition: true)
!167 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 21, size: 32, align: 32, elements: !2)
!168 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !167, isLocal: false, isDefinition: true)
!169 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 23, type: !167, isLocal: false, isDefinition: true)
!170 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 24, type: !167, isLocal: false, isDefinition: true)
!171 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 25, type: !167, isLocal: false, isDefinition: true)
!172 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 26, type: !167, isLocal: false, isDefinition: true)
!173 = !{i32 2, !"Dwarf Version", i32 4}
!174 = !{i32 2, !"Debug Info Version", i32 3}
!175 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!176 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A//#define CARTOON\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0ATexture2D gDiffuseMap2 : register(t1);\0D\0ATexture2D gDisplacementMap : register(t2);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A    float2 gDisplacementMapTexelSize;\0D\0A    float gGridSpatialStep;\0D\0A    float cbPerObjectPad1;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerPassPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    // \EC\9D\B8\EB\8D\B1\EC\8A\A4 [0, NUM_DIR_LIGHTS)\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B4\91\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)\EB\8A\94 \EC\A0\90\EA\B4\91\EC\9B\90\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHT + NUM_SPOT_LIGHTS)\EB\8A\94 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\B4\EB\A9\B0, \EA\B0\9D\EC\B2\B4\EB\8B\B9 \EC\B5\9C\EB\8C\80 MaxLights \EA\B0\9C\EC\88\98\EA\B9\8C\EC\A7\80 \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    //\EC\95\B1\EC\9D\B4 \ED\94\84\EB\A0\88\EC\9E\84\EB\8B\B9 \ED\95\9C \EB\B2\88\EC\94\A9 \EC\95\88\EA\B0\9C \EB\A7\A4\EA\B0\9C\EB\B3\80\EC\88\98\EB\A5\BC \EB\B3\80\EA\B2\BD\ED\95\A0 \EC\88\98 \EC\9E\88\EB\8F\84\EB\A1\9D \ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    //\ED\8A\B9\EC\A0\95 \EC\8B\9C\EA\B0\84\EB\8C\80\EC\97\90\EB\A7\8C \EC\95\88\EA\B0\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosL : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct PatchTess\0D\0A{\0D\0A    float EdgeTess[4] : SV_TessFactor;\0D\0A    float InsideTess[2] : SV_InsideTessFactor;\0D\0A};\0D\0A\0D\0Astruct DomainOut\0D\0A{\0D\0A    float4 PosH : SV_Position;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Afloat GetHillsHeight(float x, float z)\0D\0A{\0D\0A    return 0.3f * (z * sin(0.05f * x) + x * cos(0.1f * z));\0D\0A}\0D\0A\0D\0Afloat3 GetHillsNormal(float x, float z)\0D\0A{\0D\0A    // y = f(x, z)\0D\0A    // normal = normalize((-df/dx, 1, -df/dz))\0D\0A\0D\0A    float df_dx = 0.3f * (0.05f * z * cos(0.05f * x) + cos(0.1f * z));\0D\0A    float df_dz = 0.3f * (sin(0.05f * x) - 0.1f * x * sin(0.1f * z));\0D\0A\0D\0A    return normalize(float3(-df_dx, 1.0f, -df_dz));\0D\0A}\0D\0A\0D\0AVertexIn VS(VertexIn vin)\0D\0A{\0D\0A    return vin;\0D\0A}\0D\0A\0D\0APatchTess ConstantHS(InputPatch<VertexIn, 4> patch, uint patchID : SV_PrimitiveID)\0D\0A{\0D\0A    PatchTess pt;\0D\0A    \0D\0A    float3 centerL = 0.25f * (patch[0].PosL + patch[1].PosL + patch[2].PosL + patch[3].PosL);\0D\0A    float3 centerW = mul(float4(centerL, 1.0f), gWorld).xyz;\0D\0A    \0D\0A    float d = distance(centerW, gEyePosW);\0D\0A    \0D\0A    // \EC\8B\9C\EC\A0\90(eye)\EC\9C\BC\EB\A1\9C\EB\B6\80\ED\84\B0\EC\9D\98 \EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\9D\BC \ED\8C\A8\EC\B9\98\EB\A5\BC \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98\ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    // \EC\9D\B4\EB\95\8C \EA\B1\B0\EB\A6\AC\EA\B0\80 d1 \EC\9D\B4\EC\83\81\EC\9D\B4\EB\A9\B4 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98 \EC\88\98\EC\A4\80\EC\9D\80 0\EC\9D\B4 \EB\90\98\EA\B3\A0, d0 \EC\9D\B4\ED\95\98\EC\9D\B4\EB\A9\B4 64\EA\B0\80 \EB\90\A9\EB\8B\88\EB\8B\A4.\0D\0A    // \EA\B5\AC\EA\B0\84 [d0, d1]\EC\9D\80 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98\EC\9D\B4 \EC\88\98\ED\96\89\EB\90\98\EB\8A\94 \EB\B2\94\EC\9C\84\EB\A5\BC \EC\A0\95\EC\9D\98\ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    \0D\0A    const float d0 = 20.0f;\0D\0A    const float d1 = 100.0f;\0D\0A    float tess = 64.0f * saturate((d1 - d) / (d1 - d0));\0D\0A    \0D\0A    //\EA\B7\A0\EC\9D\BC\ED\95\98\EA\B2\8C \ED\8C\A8\EC\B9\98\EB\A5\BC tessellate\0D\0A    \0D\0A    pt.EdgeTess[0] = tess;\0D\0A    pt.EdgeTess[1] = tess;\0D\0A    pt.EdgeTess[2] = tess;\0D\0A    pt.EdgeTess[3] = tess;\0D\0A\09\0D\0A    pt.InsideTess[0] = tess;\0D\0A    pt.InsideTess[1] = tess;\0D\0A\09\0D\0A    return pt;\0D\0A}\0D\0A\0D\0A[domain(\22quad\22)]\0D\0A[partitioning(\22integer\22)]\0D\0A[outputtopology(\22triangle_cw\22)]\0D\0A[outputcontrolpoints(4)]\0D\0A[patchconstantfunc(\22ConstantHS\22)]\0D\0A[maxtessfactor(64.0f)]\0D\0AVertexIn HS(InputPatch<VertexIn, 4> p,\0D\0A           uint i : SV_OutputControlPointID,\0D\0A           uint patchId : SV_PrimitiveID)\0D\0A{\0D\0A    return p[i];\0D\0A}\0D\0A\0D\0A//\EC\9C\A0\EC\82\AC \EB\9E\9C\EB\8D\A4\ED\95\A8\EC\88\98\0D\0Afloat Hash12(float2 p)\0D\0A{\0D\0A    return frac(sin(dot(p, float2(127.1f, 311.7f))) * 43758.5453123f);\0D\0A}\0D\0A\0D\0A// \EB\8F\84\EB\A9\94\EC\9D\B8 \EC\85\B0\EC\9D\B4\EB\8D\94\EB\8A\94 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\ED\84\B0\EA\B0\80 \EC\83\9D\EC\84\B1\ED\95\9C \EB\AA\A8\EB\93\A0 \EC\A0\95\EC\A0\90\EB\A7\88\EB\8B\A4 \ED\98\B8\EC\B6\9C\EB\90\9C\EB\8B\A4.\0D\0A// \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98 \EC\9D\B4\ED\9B\84\EC\9D\98 \EC\A0\95\EC\A0\90 \EC\85\B0\EC\9D\B4\EB\8D\94\EC\99\80 \EB\B9\84\EC\8A\B7\ED\95\9C \EC\97\AD\ED\95\A0\EC\9D\84 \ED\95\9C\EB\8B\A4.\0D\0A[domain(\22quad\22)]\0D\0ADomainOut DS(PatchTess patchTess,\0D\0A            float2 uv : SV_DomainLocation,\0D\0A            const OutputPatch<VertexIn, 4> quad)\0D\0A{\0D\0A    DomainOut dout;\0D\0A    \0D\0A    //\EC\8C\8D\EC\84\A0\ED\98\95 \EB\B3\B4\EA\B0\84\0D\0A    float3 v1 = lerp(quad[0].PosL, quad[1].PosL, uv.x);\0D\0A    float3 v2 = lerp(quad[2].PosL, quad[3].PosL, uv.x);\0D\0A    float3 posL = lerp(v1, v2, uv.y);\0D\0A    \0D\0A    float3 n1 = lerp(quad[0].NormalL, quad[1].NormalL, uv.x);\0D\0A    float3 n2 = lerp(quad[2].NormalL, quad[3].NormalL, uv.x);\0D\0A    float3 normalL = normalize(lerp(n1, n2, uv.y));\0D\0A    \0D\0A    float h = Hash12(floor(uv * 128.0f)) * 0.1f;\0D\0A#ifdef WALL\0D\0A    // \EB\B2\BD\EB\8F\8C \EB\B2\BD: normal \EB\B0\A9\ED\96\A5\EC\9C\BC\EB\A1\9C \EB\B0\80\EA\B8\B0\0D\0A    posL += normalL * h;\0D\0A#else\0D\0A    // \EC\A7\80\ED\98\95: y \EB\86\92\EC\9D\B4\EB\A5\BC \ED\95\A8\EC\88\98\EB\A1\9C \EA\B2\B0\EC\A0\95\0D\0A    posL.y = GetHillsHeight(posL.x, posL.z);\0D\0A    posL.y += h * 10;\0D\0A    normalL = GetHillsNormal(posL.x, posL.z);\0D\0A#endif\0D\0A    \0D\0A    //\EB\B3\80\EC\9C\84 \EB\A7\A4\ED\95\91\0D\0A    float4 posW = mul(float4(posL, 1.0f), gWorld);\0D\0A    dout.PosW = posW.xyz;\0D\0A    \0D\0A    dout.PosH = mul(posW, gViewProj);\0D\0A    \0D\0A    float3 normalW = normalize(mul(normalL, (float3x3) gWorld));\0D\0A    dout.NormalW = normalW;    \0D\0A    \0D\0A    float4 texC = mul(float4(uv, 0.f, 1.f), gTexTransform);\0D\0A    dout.TexC = mul(texC, gMatTransform).xy;\0D\0A    \0D\0A    return dout;\0D\0A}\0D\0A\0D\0Afloat4 PS(DomainOut pin) : SV_Target\0D\0A{\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamLinearWrap, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A    //\EB\B3\B4\EA\B0\84\EB\90\9C \EB\B2\95\EC\84\A0 \EB\B2\A1\ED\84\B0\EB\8A\94 \EA\B8\B8\EC\9D\B4\EA\B0\80 1\EC\9D\B4 \EC\95\84\EB\8B\90 \EC\88\98 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C.\0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A\0D\0A    //\EA\B4\91\EC\9B\90\EC\97\90\EC\84\9C \EC\B9\B4\EB\A9\94\EB\9D\BC\EB\A1\9C \ED\96\A5\ED\95\98\EB\8A\94 \EB\B2\A1\ED\84\B0.\0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    \0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A    //\EC\9D\BC\EB\B0\98\EC\A0\81\EC\9C\BC\EB\A1\9C \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\80 \EB\94\94\ED\93\A8\EC\A6\88 \EB\A8\B8\ED\8B\B0\EB\A6\AC\EC\96\BC\EC\9D\98 \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\9C\EB\8B\A4.\0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A    \0D\0A    return litColor;\0D\0A}"}
!177 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhongToon(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    // 1) kd\0D\0A    float kd = saturate(dot(lightVec, normal));\0D\0A    float kd_q = QuantizeKd(kd);\0D\0A\0D\0A    // 2) ks (Blinn-Phong)\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    float ndoth = saturate(dot(halfVec, normal));\0D\0A\0D\0A    float ks = pow(max(ndoth, 0), m); // \EC\8A\A4\ED\8E\99\ED\81\98\EB\9F\AC \EA\B0\95\EB\8F\84\EC\9D\98 \ED\95\B5\EC\8B\AC\0D\0A    float ks_q = QuantizeKs(ks); // \EC\9D\B4\EC\82\B0\ED\99\94\0D\0A\0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    // fresnel(\EC\83\89) + (\ED\95\84\EC\9A\94\ED\95\98\EB\A9\B4) \EC\A0\95\EA\B7\9C\ED\99\94 \EA\B3\84\EC\88\98\EB\8A\94 \EC\B7\A8\ED\96\A5\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A\0D\0A    // ks_q\EB\A5\BC spec\EC\97\90 \EB\B0\98\EC\98\81\0D\0A    float3 specAlbedo = roughnessFactor * fresnelFactor * ks_q;\0D\0A\0D\0A    // LDR clamp\EB\8A\94 \EC\9C\A0\EC\A7\80 \EA\B0\80\EB\8A\A5\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A\0D\0A    // diffuse\EB\8A\94 kd_q\EB\A5\BC \EB\B0\98\EC\98\81\0D\0A    float3 diffuse = mat.DiffuseAlbedo.rgb * kd_q;\0D\0A    \0D\0A    return (diffuse + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!178 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl"}
!179 = !{!"-E", !"PS", !"-T", !"ps_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CtessPS.cso"}
!180 = !{i32 1, i32 0}
!181 = !{i32 1, i32 8}
!182 = !{!"ps", i32 6, i32 0}
!183 = !{!184, null, !187, !190}
!184 = !{!185}
!185 = !{i32 0, %"class.Texture2D<vector<float, 4> >"* undef, !"gDiffuseMap", i32 0, i32 0, i32 1, i32 2, i32 0, !186}
!186 = !{i32 0, i32 9}
!187 = !{!188, !189}
!188 = !{i32 0, %hostlayout.cbMaterial* undef, !"cbMaterial", i32 0, i32 1, i32 1, i32 96, null}
!189 = !{i32 1, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!190 = !{!191}
!191 = !{i32 0, %struct.SamplerState* undef, !"gsamLinearWrap", i32 0, i32 2, i32 1, i32 0, null}
!192 = !{i32 0, %struct.Light undef, !193, %hostlayout.cbMaterial undef, !200, %hostlayout.cbPass undef, !206}
!193 = !{i32 48, !194, !195, !196, !197, !198, !199}
!194 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!195 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!196 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!197 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!198 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!199 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!200 = !{i32 96, !201, !202, !203, !204}
!201 = !{i32 6, !"gDiffuseAlbedo", i32 3, i32 0, i32 7, i32 9}
!202 = !{i32 6, !"gFresnelR0", i32 3, i32 16, i32 7, i32 9}
!203 = !{i32 6, !"gRoughness", i32 3, i32 28, i32 7, i32 9}
!204 = !{i32 6, !"gMatTransform", i32 2, !205, i32 3, i32 32, i32 7, i32 9}
!205 = !{i32 4, i32 4, i32 2}
!206 = !{i32 1248, !207, !208, !209, !210, !211, !212, !213, !214, !215, !216, !217, !218, !219, !220, !221, !222, !223, !224, !225, !226}
!207 = !{i32 6, !"gView", i32 2, !205, i32 3, i32 0, i32 7, i32 9}
!208 = !{i32 6, !"gInvView", i32 2, !205, i32 3, i32 64, i32 7, i32 9}
!209 = !{i32 6, !"gProj", i32 2, !205, i32 3, i32 128, i32 7, i32 9}
!210 = !{i32 6, !"gInvProj", i32 2, !205, i32 3, i32 192, i32 7, i32 9}
!211 = !{i32 6, !"gViewProj", i32 2, !205, i32 3, i32 256, i32 7, i32 9}
!212 = !{i32 6, !"gInvViewProj", i32 2, !205, i32 3, i32 320, i32 7, i32 9}
!213 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!214 = !{i32 6, !"cbPerPassPad1", i32 3, i32 396, i32 7, i32 9}
!215 = !{i32 6, !"gRenderTargetSize", i32 3, i32 400, i32 7, i32 9}
!216 = !{i32 6, !"gInvRenderTargetSize", i32 3, i32 408, i32 7, i32 9}
!217 = !{i32 6, !"gNearZ", i32 3, i32 416, i32 7, i32 9}
!218 = !{i32 6, !"gFarZ", i32 3, i32 420, i32 7, i32 9}
!219 = !{i32 6, !"gTotalTime", i32 3, i32 424, i32 7, i32 9}
!220 = !{i32 6, !"gDeltaTime", i32 3, i32 428, i32 7, i32 9}
!221 = !{i32 6, !"gAmbientLight", i32 3, i32 432, i32 7, i32 9}
!222 = !{i32 6, !"gLights", i32 3, i32 448}
!223 = !{i32 6, !"gFogColor", i32 3, i32 1216, i32 7, i32 9}
!224 = !{i32 6, !"gFogStart", i32 3, i32 1232, i32 7, i32 9}
!225 = !{i32 6, !"gFogRange", i32 3, i32 1236, i32 7, i32 9}
!226 = !{i32 6, !"cbPerObjectPad2", i32 3, i32 1240, i32 7, i32 9}
!227 = !{i32 1, void ()* @PS, !228}
!228 = !{!229}
!229 = !{i32 0, !2, !2}
!230 = !{[16 x i32] [i32 14, i32 4, i32 0, i32 0, i32 0, i32 0, i32 7, i32 7, i32 7, i32 0, i32 7, i32 7, i32 7, i32 0, i32 15, i32 15]}
!231 = !{void ()* @PS, !"PS", !232, !183, !244}
!232 = !{!233, !241, null}
!233 = !{!234, !236, !238, !239}
!234 = !{i32 0, !"SV_Position", i8 9, i8 3, !235, i8 4, i32 1, i8 4, i32 0, i8 0, null}
!235 = !{i32 0}
!236 = !{i32 1, !"POSITION", i8 9, i8 0, !235, i8 2, i32 1, i8 3, i32 1, i8 0, !237}
!237 = !{i32 3, i32 7}
!238 = !{i32 2, !"NORMAL", i8 9, i8 0, !235, i8 2, i32 1, i8 3, i32 2, i8 0, !237}
!239 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !235, i8 2, i32 1, i8 2, i32 3, i8 0, !240}
!240 = !{i32 3, i32 3}
!241 = !{!242}
!242 = !{i32 0, !"SV_Target", i8 9, i8 16, !235, i8 0, i32 1, i8 4, i32 0, i8 0, !243}
!243 = !{i32 3, i32 15}
!244 = !{i32 0, i64 1}
!245 = !DILocation(line: 213, column: 28, scope: !61)
!246 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "pin", arg: 1, scope: !61, file: !1, line: 211, type: !64)
!247 = !DIExpression(DW_OP_bit_piece, 320, 32)
!248 = !DILocation(line: 211, column: 21, scope: !61)
!249 = !DIExpression(DW_OP_bit_piece, 352, 32)
!250 = !DIExpression(DW_OP_bit_piece, 224, 32)
!251 = !DIExpression(DW_OP_bit_piece, 256, 32)
!252 = !DIExpression(DW_OP_bit_piece, 288, 32)
!253 = !DIExpression(DW_OP_bit_piece, 128, 32)
!254 = !DIExpression(DW_OP_bit_piece, 160, 32)
!255 = !DIExpression(DW_OP_bit_piece, 192, 32)
!256 = !DILocation(line: 213, column: 75, scope: !61)
!257 = !DILocation(line: 213, column: 73, scope: !61)
!258 = !DILocation(line: 213, column: 12, scope: !61)
!259 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "diffuseAlbedo", scope: !61, file: !1, line: 213, type: !4)
!260 = !DIExpression(DW_OP_bit_piece, 0, 32)
!261 = !DIExpression(DW_OP_bit_piece, 32, 32)
!262 = !DIExpression(DW_OP_bit_piece, 64, 32)
!263 = !DIExpression(DW_OP_bit_piece, 96, 32)
!264 = !DILocation(line: 216, column: 19, scope: !61)
!265 = !DILocation(line: 216, column: 17, scope: !61)
!266 = !DILocation(line: 219, column: 21, scope: !61)
!267 = !DILocation(line: 219, column: 30, scope: !61)
!268 = !DILocation(line: 219, column: 12, scope: !61)
!269 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "toEyeW", scope: !61, file: !1, line: 219, type: !39)
!270 = !DILocation(line: 220, column: 23, scope: !61)
!271 = !DILocation(line: 220, column: 11, scope: !61)
!272 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "distToEye", scope: !61, file: !1, line: 220, type: !8)
!273 = !DIExpression()
!274 = !DILocation(line: 221, column: 12, scope: !61)
!275 = !DILocation(line: 223, column: 22, scope: !61)
!276 = !DILocation(line: 223, column: 36, scope: !61)
!277 = !DILocation(line: 223, column: 12, scope: !61)
!278 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "ambient", scope: !61, file: !1, line: 223, type: !4)
!279 = !DILocation(line: 224, column: 36, scope: !61)
!280 = !DILocation(line: 224, column: 34, scope: !61)
!281 = !DILocation(line: 224, column: 17, scope: !61)
!282 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "shininess", scope: !61, file: !1, line: 224, type: !128)
!283 = !DILocation(line: 225, column: 20, scope: !61)
!284 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "mat", scope: !61, file: !1, line: 225, type: !85)
!285 = !DILocation(line: 225, column: 14, scope: !61)
!286 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 2, scope: !70, file: !71, line: 194, type: !85)
!287 = !DILocation(line: 194, column: 59, scope: !70, inlinedAt: !288)
!288 = distinct !DILocation(line: 228, column: 26, scope: !61)
!289 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 2, scope: !90, file: !71, line: 115, type: !85)
!290 = !DILocation(line: 115, column: 50, scope: !90, inlinedAt: !291)
!291 = distinct !DILocation(line: 202, column: 37, scope: !292, inlinedAt: !288)
!292 = distinct !DILexicalBlock(scope: !293, file: !71, line: 201, column: 5)
!293 = distinct !DILexicalBlock(scope: !294, file: !71, line: 200, column: 5)
!294 = distinct !DILexicalBlock(scope: !70, file: !71, line: 200, column: 5)
!295 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 5, scope: !93, file: !71, line: 68, type: !85)
!296 = !DILocation(line: 68, column: 96, scope: !93, inlinedAt: !297)
!297 = distinct !DILocation(line: 128, column: 12, scope: !90, inlinedAt: !291)
!298 = !DILocation(line: 225, column: 37, scope: !61)
!299 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "R0", arg: 1, scope: !96, file: !71, line: 59, type: !39)
!300 = !DILocation(line: 59, column: 30, scope: !96, inlinedAt: !301)
!301 = distinct !DILocation(line: 74, column: 28, scope: !93, inlinedAt: !297)
!302 = !DILocation(line: 226, column: 12, scope: !61)
!303 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "shadowFactor", scope: !61, file: !1, line: 226, type: !39)
!304 = !DILocation(line: 228, column: 26, scope: !61)
!305 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 5, scope: !70, file: !71, line: 194, type: !39)
!306 = !DILocation(line: 194, column: 98, scope: !70, inlinedAt: !288)
!307 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 4, scope: !70, file: !71, line: 194, type: !39)
!308 = !DILocation(line: 194, column: 83, scope: !70, inlinedAt: !288)
!309 = !DILocation(line: 196, column: 12, scope: !70, inlinedAt: !288)
!310 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "result", scope: !70, file: !71, line: 196, type: !39)
!311 = !DILocation(line: 197, column: 9, scope: !70, inlinedAt: !288)
!312 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !70, file: !71, line: 197, type: !15)
!313 = !DILocation(line: 200, column: 11, scope: !294, inlinedAt: !288)
!314 = !DILocation(line: 200, column: 5, scope: !294, inlinedAt: !288)
!315 = !DILocation(line: 202, column: 19, scope: !292, inlinedAt: !288)
!316 = !DILocation(line: 202, column: 37, scope: !292, inlinedAt: !288)
!317 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 4, scope: !90, file: !71, line: 115, type: !39)
!318 = !DILocation(line: 115, column: 77, scope: !90, inlinedAt: !291)
!319 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 3, scope: !90, file: !71, line: 115, type: !39)
!320 = !DILocation(line: 115, column: 62, scope: !90, inlinedAt: !291)
!321 = !DILocation(line: 118, column: 26, scope: !90, inlinedAt: !291)
!322 = !DILocation(line: 118, column: 23, scope: !90, inlinedAt: !291)
!323 = !DILocation(line: 118, column: 12, scope: !90, inlinedAt: !291)
!324 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "lightVec", scope: !90, file: !71, line: 118, type: !39)
!325 = !DILocation(line: 121, column: 23, scope: !90, inlinedAt: !291)
!326 = !DILocation(line: 121, column: 19, scope: !90, inlinedAt: !291)
!327 = !DILocation(line: 121, column: 11, scope: !90, inlinedAt: !291)
!328 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "ndotl", scope: !90, file: !71, line: 121, type: !8)
!329 = !DILocation(line: 127, column: 30, scope: !90, inlinedAt: !291)
!330 = !DILocation(line: 127, column: 39, scope: !90, inlinedAt: !291)
!331 = !DILocation(line: 127, column: 12, scope: !90, inlinedAt: !291)
!332 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "lightStrength", scope: !90, file: !71, line: 127, type: !39)
!333 = !DILocation(line: 128, column: 12, scope: !90, inlinedAt: !291)
!334 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 4, scope: !93, file: !71, line: 68, type: !39)
!335 = !DILocation(line: 68, column: 80, scope: !93, inlinedAt: !297)
!336 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 3, scope: !93, file: !71, line: 68, type: !39)
!337 = !DILocation(line: 68, column: 65, scope: !93, inlinedAt: !297)
!338 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightVec", arg: 2, scope: !93, file: !71, line: 68, type: !39)
!339 = !DILocation(line: 68, column: 48, scope: !93, inlinedAt: !297)
!340 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightStrength", arg: 1, scope: !93, file: !71, line: 68, type: !39)
!341 = !DILocation(line: 68, column: 26, scope: !93, inlinedAt: !297)
!342 = !DILocation(line: 70, column: 35, scope: !93, inlinedAt: !297)
!343 = !DILocation(line: 70, column: 17, scope: !93, inlinedAt: !297)
!344 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "m", scope: !93, file: !71, line: 70, type: !128)
!345 = !DILocation(line: 71, column: 38, scope: !93, inlinedAt: !297)
!346 = !DILocation(line: 71, column: 22, scope: !93, inlinedAt: !297)
!347 = !DILocation(line: 71, column: 12, scope: !93, inlinedAt: !297)
!348 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "halfVec", scope: !93, file: !71, line: 71, type: !39)
!349 = !DILocation(line: 73, column: 32, scope: !93, inlinedAt: !297)
!350 = !DILocation(line: 73, column: 50, scope: !93, inlinedAt: !297)
!351 = !DILocation(line: 73, column: 46, scope: !93, inlinedAt: !297)
!352 = !DILocation(line: 73, column: 42, scope: !93, inlinedAt: !297)
!353 = !DILocation(line: 73, column: 40, scope: !93, inlinedAt: !297)
!354 = !DILocation(line: 73, column: 82, scope: !93, inlinedAt: !297)
!355 = !DILocation(line: 73, column: 11, scope: !93, inlinedAt: !297)
!356 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "roughnessFactor", scope: !93, file: !71, line: 73, type: !8)
!357 = !DILocation(line: 74, column: 28, scope: !93, inlinedAt: !297)
!358 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightVec", arg: 3, scope: !96, file: !71, line: 59, type: !39)
!359 = !DILocation(line: 59, column: 56, scope: !96, inlinedAt: !301)
!360 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 2, scope: !96, file: !71, line: 59, type: !39)
!361 = !DILocation(line: 59, column: 41, scope: !96, inlinedAt: !301)
!362 = !DILocation(line: 61, column: 39, scope: !96, inlinedAt: !301)
!363 = !DILocation(line: 61, column: 30, scope: !96, inlinedAt: !301)
!364 = !DILocation(line: 61, column: 11, scope: !96, inlinedAt: !301)
!365 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "cosIncidentAngle", scope: !96, file: !71, line: 61, type: !8)
!366 = !DILocation(line: 62, column: 21, scope: !96, inlinedAt: !301)
!367 = !DILocation(line: 62, column: 11, scope: !96, inlinedAt: !301)
!368 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "f0", scope: !96, file: !71, line: 62, type: !8)
!369 = !DILocation(line: 63, column: 40, scope: !96, inlinedAt: !301)
!370 = !DILocation(line: 63, column: 48, scope: !96, inlinedAt: !301)
!371 = !DILocation(line: 63, column: 46, scope: !96, inlinedAt: !301)
!372 = !DILocation(line: 63, column: 32, scope: !96, inlinedAt: !301)
!373 = !DILocation(line: 63, column: 12, scope: !96, inlinedAt: !301)
!374 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "reflectPercent", scope: !96, file: !71, line: 63, type: !39)
!375 = !DILocation(line: 65, column: 5, scope: !96, inlinedAt: !301)
!376 = !DILocation(line: 74, column: 12, scope: !93, inlinedAt: !297)
!377 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "fresnelFactor", scope: !93, file: !71, line: 74, type: !39)
!378 = !DILocation(line: 76, column: 39, scope: !93, inlinedAt: !297)
!379 = !DILocation(line: 76, column: 12, scope: !93, inlinedAt: !297)
!380 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "specAlbedo", scope: !93, file: !71, line: 76, type: !39)
!381 = !DILocation(line: 80, column: 43, scope: !93, inlinedAt: !297)
!382 = !DILocation(line: 80, column: 29, scope: !93, inlinedAt: !297)
!383 = !DILocation(line: 80, column: 16, scope: !93, inlinedAt: !297)
!384 = !DILocation(line: 82, column: 35, scope: !93, inlinedAt: !297)
!385 = !DILocation(line: 82, column: 49, scope: !93, inlinedAt: !297)
!386 = !DILocation(line: 82, column: 5, scope: !93, inlinedAt: !297)
!387 = !DILocation(line: 128, column: 5, scope: !90, inlinedAt: !291)
!388 = !DILocation(line: 202, column: 35, scope: !292, inlinedAt: !288)
!389 = !DILocation(line: 202, column: 16, scope: !292, inlinedAt: !288)
!390 = !DILocation(line: 200, column: 36, scope: !293, inlinedAt: !288)
!391 = !DILocation(line: 200, column: 18, scope: !293, inlinedAt: !288)
!392 = !DILocation(line: 220, column: 5, scope: !70, inlinedAt: !288)
!393 = !DILocation(line: 228, column: 12, scope: !61)
!394 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "directLight", scope: !61, file: !1, line: 228, type: !4)
!395 = !DILocation(line: 231, column: 31, scope: !61)
!396 = !DILocation(line: 231, column: 12, scope: !61)
!397 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "litColor", scope: !61, file: !1, line: 231, type: !4)
!398 = !DILocation(line: 234, column: 16, scope: !61)
!399 = !DILocation(line: 236, column: 5, scope: !61)
!400 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "shadowFactor", arg: 6, scope: !70, file: !71, line: 194, type: !39)
!401 = !DILocation(line: 194, column: 112, scope: !70, inlinedAt: !288)
