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
; shader debug name: 4396d2421a9a79e7513988dbe526c70b.pdb
; shader hash: 4396d2421a9a79e7513988dbe526c70b
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
; gsamLinear                        sampler      NA          NA      S0             s0     1
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
  %gDiffuseMap_texture_2d = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 0, i32 0, i32 0, i1 false), !dbg !210 ; line:121 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %gsamLinear_sampler = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 3, i32 0, i32 0, i1 false), !dbg !210 ; line:121 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 1, i32 2, i1 false), !dbg !210 ; line:121 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbMaterial_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 1, i1 false), !dbg !210 ; line:121 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !211, metadata !212), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"PS"
  %2 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !211, metadata !214), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 352, 32) func:"PS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !211, metadata !215), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !211, metadata !216), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 2, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !211, metadata !217), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !211, metadata !218), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !211, metadata !219), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !211, metadata !220), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  %9 = alloca [3 x float], align 4
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !211, metadata !218), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !211, metadata !219), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !211, metadata !220), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !211, metadata !215), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !211, metadata !216), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !211, metadata !217), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !211, metadata !212), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !211, metadata !214), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 352, 32) func:"PS"
  %10 = call %dx.types.ResRet.f32 @dx.op.sample.f32(i32 60, %dx.types.Handle %gDiffuseMap_texture_2d, %dx.types.Handle %gsamLinear_sampler, float %1, float %2, float undef, float undef, i32 0, i32 0, i32 undef, float undef), !dbg !210 ; line:121 col:28  ; Sample(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,clamp)
  %11 = extractvalue %dx.types.ResRet.f32 %10, 0, !dbg !210 ; line:121 col:28
  %12 = extractvalue %dx.types.ResRet.f32 %10, 1, !dbg !210 ; line:121 col:28
  %13 = extractvalue %dx.types.ResRet.f32 %10, 2, !dbg !210 ; line:121 col:28
  %14 = extractvalue %dx.types.ResRet.f32 %10, 3, !dbg !210 ; line:121 col:28
  %15 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 0), !dbg !221 ; line:121 col:71  ; CBufferLoadLegacy(handle,regIndex)
  %16 = extractvalue %dx.types.CBufRet.f32 %15, 0, !dbg !221 ; line:121 col:71
  %17 = extractvalue %dx.types.CBufRet.f32 %15, 1, !dbg !221 ; line:121 col:71
  %18 = extractvalue %dx.types.CBufRet.f32 %15, 2, !dbg !221 ; line:121 col:71
  %19 = extractvalue %dx.types.CBufRet.f32 %15, 3, !dbg !221 ; line:121 col:71
  %.i0 = fmul fast float %11, %16, !dbg !222 ; line:121 col:69
  %.i1 = fmul fast float %12, %17, !dbg !222 ; line:121 col:69
  %.i2 = fmul fast float %13, %18, !dbg !222 ; line:121 col:69
  %.i3 = fmul fast float %14, %19, !dbg !222 ; line:121 col:69
  %20 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !223 ; line:121 col:12
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !224, metadata !225), !dbg !223 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !224, metadata !226), !dbg !223 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !224, metadata !227), !dbg !223 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !224, metadata !228), !dbg !223 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %21 = fsub fast float %.i3, 0x3FB99999A0000000, !dbg !229 ; line:129 col:23
  %22 = fcmp fast olt float %21, 0.000000e+00, !dbg !230 ; line:129 col:2
  call void @dx.op.discard(i32 82, i1 %22), !dbg !230 ; line:129 col:2  ; Discard(condition)
  %23 = call float @dx.op.dot3.f32(i32 55, float %3, float %4, float %5, float %3, float %4, float %5), !dbg !231 ; line:133 col:19  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt1 = call float @dx.op.unary.f32(i32 25, float %23), !dbg !231 ; line:133 col:19  ; Rsqrt(value)
  %.i06 = fmul fast float %3, %Rsqrt1, !dbg !231 ; line:133 col:19
  %.i17 = fmul fast float %4, %Rsqrt1, !dbg !231 ; line:133 col:19
  %.i28 = fmul fast float %5, %Rsqrt1, !dbg !231 ; line:133 col:19
  %24 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !232 ; line:133 col:17
  call void @llvm.dbg.value(metadata float %.i06, i64 0, metadata !211, metadata !215), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i17, i64 0, metadata !211, metadata !216), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i28, i64 0, metadata !211, metadata !217), !dbg !213 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  %25 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 24), !dbg !233 ; line:136 col:21  ; CBufferLoadLegacy(handle,regIndex)
  %26 = extractvalue %dx.types.CBufRet.f32 %25, 0, !dbg !233 ; line:136 col:21
  %27 = extractvalue %dx.types.CBufRet.f32 %25, 1, !dbg !233 ; line:136 col:21
  %28 = extractvalue %dx.types.CBufRet.f32 %25, 2, !dbg !233 ; line:136 col:21
  %.i09 = fsub fast float %26, %6, !dbg !234 ; line:136 col:30
  %.i110 = fsub fast float %27, %7, !dbg !234 ; line:136 col:30
  %.i211 = fsub fast float %28, %8, !dbg !234 ; line:136 col:30
  %29 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !235 ; line:136 col:12
  call void @llvm.dbg.value(metadata float %.i09, i64 0, metadata !236, metadata !225), !dbg !235 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i110, i64 0, metadata !236, metadata !226), !dbg !235 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i211, i64 0, metadata !236, metadata !227), !dbg !235 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %30 = fmul fast float %.i09, %.i09, !dbg !237 ; line:137 col:23
  %31 = fmul fast float %.i110, %.i110, !dbg !237 ; line:137 col:23
  %32 = fadd fast float %30, %31, !dbg !237 ; line:137 col:23
  %33 = fmul fast float %.i211, %.i211, !dbg !237 ; line:137 col:23
  %34 = fadd fast float %32, %33, !dbg !237 ; line:137 col:23
  %Sqrt = call float @dx.op.unary.f32(i32 24, float %34), !dbg !237 ; line:137 col:23  ; Sqrt(value)
  %35 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !238 ; line:137 col:11
  call void @llvm.dbg.value(metadata float %Sqrt, i64 0, metadata !239, metadata !240), !dbg !238 ; var:"distToEye" !DIExpression() func:"PS"
  %.i012 = fdiv fast float %.i09, %Sqrt, !dbg !241 ; line:138 col:12
  %.i113 = fdiv fast float %.i110, %Sqrt, !dbg !241 ; line:138 col:12
  %.i214 = fdiv fast float %.i211, %Sqrt, !dbg !241 ; line:138 col:12
  %36 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !241 ; line:138 col:12
  call void @llvm.dbg.value(metadata float %.i012, i64 0, metadata !236, metadata !225), !dbg !235 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i113, i64 0, metadata !236, metadata !226), !dbg !235 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i214, i64 0, metadata !236, metadata !227), !dbg !235 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %37 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 27), !dbg !242 ; line:140 col:22  ; CBufferLoadLegacy(handle,regIndex)
  %38 = extractvalue %dx.types.CBufRet.f32 %37, 0, !dbg !242 ; line:140 col:22
  %39 = extractvalue %dx.types.CBufRet.f32 %37, 1, !dbg !242 ; line:140 col:22
  %40 = extractvalue %dx.types.CBufRet.f32 %37, 2, !dbg !242 ; line:140 col:22
  %.i015 = fmul fast float %38, %.i0, !dbg !243 ; line:140 col:36
  %.i116 = fmul fast float %39, %.i1, !dbg !243 ; line:140 col:36
  %.i217 = fmul fast float %40, %.i2, !dbg !243 ; line:140 col:36
  %41 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !244 ; line:140 col:12
  call void @llvm.dbg.value(metadata float %.i015, i64 0, metadata !245, metadata !225), !dbg !244 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i116, i64 0, metadata !245, metadata !226), !dbg !244 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i217, i64 0, metadata !245, metadata !227), !dbg !244 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %42 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 1), !dbg !246 ; line:141 col:36  ; CBufferLoadLegacy(handle,regIndex)
  %43 = extractvalue %dx.types.CBufRet.f32 %42, 3, !dbg !246 ; line:141 col:36
  %44 = fsub fast float 1.000000e+00, %43, !dbg !247 ; line:141 col:34
  %45 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !248 ; line:141 col:17
  call void @llvm.dbg.value(metadata float %44, i64 0, metadata !249, metadata !240), !dbg !248 ; var:"shininess" !DIExpression() func:"PS"
  %46 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !250 ; line:142 col:20
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !251, metadata !225), !dbg !252 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !251, metadata !226), !dbg !252 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !251, metadata !227), !dbg !252 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !251, metadata !228), !dbg !252 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !253, metadata !225), !dbg !254 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !253, metadata !226), !dbg !254 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !253, metadata !227), !dbg !254 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !253, metadata !228), !dbg !254 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !256, metadata !225), !dbg !257 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !256, metadata !226), !dbg !257 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !256, metadata !227), !dbg !257 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !256, metadata !228), !dbg !257 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !263, metadata !225), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !263, metadata !226), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !263, metadata !227), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !263, metadata !228), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"ComputeDirectionalLight"
  %47 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 1), !dbg !265 ; line:142 col:37  ; CBufferLoadLegacy(handle,regIndex)
  %48 = extractvalue %dx.types.CBufRet.f32 %47, 0, !dbg !265 ; line:142 col:37
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !266, metadata !225), !dbg !267 ; var:"R0" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  %49 = extractvalue %dx.types.CBufRet.f32 %47, 1, !dbg !265 ; line:142 col:37
  call void @llvm.dbg.value(metadata float %49, i64 0, metadata !266, metadata !226), !dbg !267 ; var:"R0" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  %50 = extractvalue %dx.types.CBufRet.f32 %47, 2, !dbg !265 ; line:142 col:37
  call void @llvm.dbg.value(metadata float %50, i64 0, metadata !266, metadata !227), !dbg !267 ; var:"R0" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %51 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !250 ; line:142 col:20
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !251, metadata !218), !dbg !252 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %49, i64 0, metadata !251, metadata !219), !dbg !252 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %50, i64 0, metadata !251, metadata !220), !dbg !252 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !253, metadata !218), !dbg !254 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %49, i64 0, metadata !253, metadata !219), !dbg !254 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %50, i64 0, metadata !253, metadata !220), !dbg !254 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !256, metadata !218), !dbg !257 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %49, i64 0, metadata !256, metadata !219), !dbg !257 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %50, i64 0, metadata !256, metadata !220), !dbg !257 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !263, metadata !218), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %49, i64 0, metadata !263, metadata !219), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %50, i64 0, metadata !263, metadata !220), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"ComputeDirectionalLight"
  %52 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !250 ; line:142 col:20
  call void @llvm.dbg.value(metadata float %44, i64 0, metadata !251, metadata !215), !dbg !252 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %44, i64 0, metadata !253, metadata !215), !dbg !254 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %44, i64 0, metadata !256, metadata !215), !dbg !257 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %44, i64 0, metadata !263, metadata !215), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"ComputeDirectionalLight"
  %53 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !269 ; line:143 col:12
  call void @llvm.dbg.value(metadata <3 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, i64 0, metadata !270, metadata !240), !dbg !269 ; var:"shadowFactor" !DIExpression() func:"PS"
  %54 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !271 ; line:145 col:26
  %55 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !271 ; line:145 col:26
  %56 = getelementptr inbounds [3 x float], [3 x float]* %9, i32 0, i32 0, !dbg !271 ; line:145 col:26
  store float 1.000000e+00, float* %56, align 4, !dbg !271 ; line:145 col:26
  %57 = getelementptr inbounds [3 x float], [3 x float]* %9, i32 0, i32 1, !dbg !271 ; line:145 col:26
  store float 1.000000e+00, float* %57, align 4, !dbg !271 ; line:145 col:26
  %58 = getelementptr inbounds [3 x float], [3 x float]* %9, i32 0, i32 2, !dbg !271 ; line:145 col:26
  store float 1.000000e+00, float* %58, align 4, !dbg !271 ; line:145 col:26
  call void @llvm.dbg.value(metadata float %.i012, i64 0, metadata !272, metadata !225), !dbg !273 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i113, i64 0, metadata !272, metadata !226), !dbg !273 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i214, i64 0, metadata !272, metadata !227), !dbg !273 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i06, i64 0, metadata !274, metadata !225), !dbg !275 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i17, i64 0, metadata !274, metadata !226), !dbg !275 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i28, i64 0, metadata !274, metadata !227), !dbg !275 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %59 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !276 ; line:145 col:12
  call void @llvm.dbg.value(metadata <3 x float> zeroinitializer, i64 0, metadata !277, metadata !240), !dbg !276 ; var:"result" !DIExpression() func:"ComputeLighting"
  %60 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !278 ; line:146 col:9
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !279, metadata !240), !dbg !278 ; var:"i" !DIExpression() func:"ComputeLighting"
  %61 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !280 ; line:149 col:11
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !279, metadata !240), !dbg !278 ; var:"i" !DIExpression() func:"ComputeLighting"
  br label %.lr.ph, !dbg !281 ; line:149 col:5

.lr.ph:                                           ; preds = %0
  br label %62, !dbg !281 ; line:149 col:5

; <label>:62                                      ; preds = %62, %.lr.ph
  %result.i.0.i0 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i019, %62 ]
  %result.i.0.i1 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i120, %62 ]
  %result.i.0.i2 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i221, %62 ]
  %i.i.0 = phi i32 [ 0, %.lr.ph ], [ %111, %62 ]
  call void @llvm.dbg.value(metadata i32 %i.i.0, i64 0, metadata !279, metadata !240), !dbg !278 ; var:"i" !DIExpression() func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i0, i64 0, metadata !277, metadata !225), !dbg !276 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i1, i64 0, metadata !277, metadata !226), !dbg !276 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i2, i64 0, metadata !277, metadata !227), !dbg !276 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %63 = getelementptr [3 x float], [3 x float]* %9, i32 0, i32 %i.i.0, !dbg !282 ; line:151 col:19
  %64 = load float, float* %63, !dbg !282 ; line:151 col:19
  %65 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !283 ; line:151 col:37
  %66 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !283 ; line:151 col:37
  %67 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !283 ; line:151 col:37
  call void @llvm.dbg.value(metadata float %.i012, i64 0, metadata !284, metadata !225), !dbg !285 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i113, i64 0, metadata !284, metadata !226), !dbg !285 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i214, i64 0, metadata !284, metadata !227), !dbg !285 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i06, i64 0, metadata !286, metadata !225), !dbg !287 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i17, i64 0, metadata !286, metadata !226), !dbg !287 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i28, i64 0, metadata !286, metadata !227), !dbg !287 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %68 = mul i32 %i.i.0, 3, !dbg !288 ; line:88 col:26
  %69 = add i32 28, %68, !dbg !288 ; line:88 col:26
  %70 = add i32 %69, 1, !dbg !288 ; line:88 col:26
  %71 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 %70), !dbg !288 ; line:88 col:26  ; CBufferLoadLegacy(handle,regIndex)
  %72 = extractvalue %dx.types.CBufRet.f32 %71, 0, !dbg !288 ; line:88 col:26
  %73 = extractvalue %dx.types.CBufRet.f32 %71, 1, !dbg !288 ; line:88 col:26
  %74 = extractvalue %dx.types.CBufRet.f32 %71, 2, !dbg !288 ; line:88 col:26
  %.i023 = fsub fast float -0.000000e+00, %72, !dbg !289 ; line:88 col:23
  %.i125 = fsub fast float -0.000000e+00, %73, !dbg !289 ; line:88 col:23
  %.i227 = fsub fast float -0.000000e+00, %74, !dbg !289 ; line:88 col:23
  %75 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !290 ; line:88 col:12
  call void @llvm.dbg.value(metadata float %.i023, i64 0, metadata !291, metadata !225), !dbg !290 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i125, i64 0, metadata !291, metadata !226), !dbg !290 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i227, i64 0, metadata !291, metadata !227), !dbg !290 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %76 = call float @dx.op.dot3.f32(i32 55, float %.i023, float %.i125, float %.i227, float %.i06, float %.i17, float %.i28), !dbg !292 ; line:91 col:23  ; Dot3(ax,ay,az,bx,by,bz)
  %FMax5 = call float @dx.op.binary.f32(i32 35, float %76, float 0.000000e+00), !dbg !293 ; line:91 col:19  ; FMax(a,b)
  %77 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !294 ; line:91 col:11
  call void @llvm.dbg.value(metadata float %FMax5, i64 0, metadata !295, metadata !240), !dbg !294 ; var:"ndotl" !DIExpression() func:"ComputeDirectionalLight"
  %78 = mul i32 %i.i.0, 3, !dbg !296 ; line:92 col:30
  %79 = add i32 28, %78, !dbg !296 ; line:92 col:30
  %80 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 %79), !dbg !296 ; line:92 col:30  ; CBufferLoadLegacy(handle,regIndex)
  %81 = extractvalue %dx.types.CBufRet.f32 %80, 0, !dbg !296 ; line:92 col:30
  %82 = extractvalue %dx.types.CBufRet.f32 %80, 1, !dbg !296 ; line:92 col:30
  %83 = extractvalue %dx.types.CBufRet.f32 %80, 2, !dbg !296 ; line:92 col:30
  %.i028 = fmul fast float %81, %FMax5, !dbg !297 ; line:92 col:39
  %.i129 = fmul fast float %82, %FMax5, !dbg !297 ; line:92 col:39
  %.i230 = fmul fast float %83, %FMax5, !dbg !297 ; line:92 col:39
  %84 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !298 ; line:92 col:12
  call void @llvm.dbg.value(metadata float %.i028, i64 0, metadata !299, metadata !225), !dbg !298 ; var:"lightStrenght" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i129, i64 0, metadata !299, metadata !226), !dbg !298 ; var:"lightStrenght" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i230, i64 0, metadata !299, metadata !227), !dbg !298 ; var:"lightStrenght" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %85 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !300 ; line:94 col:12
  %86 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !300 ; line:94 col:12
  call void @llvm.dbg.value(metadata float %.i012, i64 0, metadata !301, metadata !225), !dbg !302 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i113, i64 0, metadata !301, metadata !226), !dbg !302 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i214, i64 0, metadata !301, metadata !227), !dbg !302 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i06, i64 0, metadata !303, metadata !225), !dbg !304 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i17, i64 0, metadata !303, metadata !226), !dbg !304 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i28, i64 0, metadata !303, metadata !227), !dbg !304 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i023, i64 0, metadata !305, metadata !225), !dbg !306 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i125, i64 0, metadata !305, metadata !226), !dbg !306 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i227, i64 0, metadata !305, metadata !227), !dbg !306 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i028, i64 0, metadata !307, metadata !225), !dbg !308 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i129, i64 0, metadata !307, metadata !226), !dbg !308 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i230, i64 0, metadata !307, metadata !227), !dbg !308 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %87 = fmul fast float %44, 2.560000e+02, !dbg !309 ; line:70 col:35
  %88 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !310 ; line:70 col:17
  call void @llvm.dbg.value(metadata float %87, i64 0, metadata !311, metadata !240), !dbg !310 ; var:"m" !DIExpression() func:"BlinnPhong"
  %.i031 = fadd fast float %.i012, %.i023, !dbg !312 ; line:71 col:38
  %.i132 = fadd fast float %.i113, %.i125, !dbg !312 ; line:71 col:38
  %.i233 = fadd fast float %.i214, %.i227, !dbg !312 ; line:71 col:38
  %89 = call float @dx.op.dot3.f32(i32 55, float %.i031, float %.i132, float %.i233, float %.i031, float %.i132, float %.i233), !dbg !313 ; line:71 col:22  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt = call float @dx.op.unary.f32(i32 25, float %89), !dbg !313 ; line:71 col:22  ; Rsqrt(value)
  %.i034 = fmul fast float %.i031, %Rsqrt, !dbg !313 ; line:71 col:22
  %.i135 = fmul fast float %.i132, %Rsqrt, !dbg !313 ; line:71 col:22
  %.i236 = fmul fast float %.i233, %Rsqrt, !dbg !313 ; line:71 col:22
  %90 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !314 ; line:71 col:12
  call void @llvm.dbg.value(metadata float %.i034, i64 0, metadata !315, metadata !225), !dbg !314 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i135, i64 0, metadata !315, metadata !226), !dbg !314 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i236, i64 0, metadata !315, metadata !227), !dbg !314 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %91 = fadd fast float %87, 8.000000e+00, !dbg !316 ; line:73 col:32
  %92 = call float @dx.op.dot3.f32(i32 55, float %.i034, float %.i135, float %.i236, float %.i06, float %.i17, float %.i28), !dbg !317 ; line:73 col:50  ; Dot3(ax,ay,az,bx,by,bz)
  %FMax = call float @dx.op.binary.f32(i32 35, float %92, float 0.000000e+00), !dbg !318 ; line:73 col:46  ; FMax(a,b)
  %Log3 = call float @dx.op.unary.f32(i32 23, float %FMax), !dbg !319 ; line:73 col:42  ; Log(value)
  %93 = fmul fast float %Log3, %87, !dbg !319 ; line:73 col:42
  %Exp4 = call float @dx.op.unary.f32(i32 21, float %93), !dbg !319 ; line:73 col:42  ; Exp(value)
  %94 = fmul fast float %91, %Exp4, !dbg !320 ; line:73 col:40
  %95 = fdiv fast float %94, 8.000000e+00, !dbg !321 ; line:73 col:82
  %96 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !322 ; line:73 col:11
  call void @llvm.dbg.value(metadata float %95, i64 0, metadata !323, metadata !240), !dbg !322 ; var:"roughnessFactor" !DIExpression() func:"BlinnPhong"
  %97 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !324 ; line:74 col:28
  call void @llvm.dbg.value(metadata float %.i023, i64 0, metadata !325, metadata !225), !dbg !326 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i125, i64 0, metadata !325, metadata !226), !dbg !326 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i227, i64 0, metadata !325, metadata !227), !dbg !326 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i034, i64 0, metadata !327, metadata !225), !dbg !328 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i135, i64 0, metadata !327, metadata !226), !dbg !328 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i236, i64 0, metadata !327, metadata !227), !dbg !328 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !266, metadata !225), !dbg !267 ; var:"R0" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %49, i64 0, metadata !266, metadata !226), !dbg !267 ; var:"R0" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %50, i64 0, metadata !266, metadata !227), !dbg !267 ; var:"R0" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %98 = call float @dx.op.dot3.f32(i32 55, float %.i034, float %.i135, float %.i236, float %.i023, float %.i125, float %.i227), !dbg !329 ; line:61 col:39  ; Dot3(ax,ay,az,bx,by,bz)
  %Saturate = call float @dx.op.unary.f32(i32 7, float %98), !dbg !330 ; line:61 col:30  ; Saturate(value)
  %99 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !331 ; line:61 col:11
  call void @llvm.dbg.value(metadata float %Saturate, i64 0, metadata !332, metadata !240), !dbg !331 ; var:"cosIncidentAngle" !DIExpression() func:"SchlickFresnel"
  %100 = fsub fast float 1.000000e+00, %Saturate, !dbg !333 ; line:62 col:21
  %101 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !334 ; line:62 col:11
  call void @llvm.dbg.value(metadata float %100, i64 0, metadata !335, metadata !240), !dbg !334 ; var:"f0" !DIExpression() func:"SchlickFresnel"
  %.i038 = fsub fast float 1.000000e+00, %48, !dbg !336 ; line:63 col:40
  %.i140 = fsub fast float 1.000000e+00, %49, !dbg !336 ; line:63 col:40
  %.i242 = fsub fast float 1.000000e+00, %50, !dbg !336 ; line:63 col:40
  %Log = call float @dx.op.unary.f32(i32 23, float %100), !dbg !337 ; line:63 col:48  ; Log(value)
  %102 = fmul fast float %Log, 5.000000e+00, !dbg !337 ; line:63 col:48
  %Exp = call float @dx.op.unary.f32(i32 21, float %102), !dbg !337 ; line:63 col:48  ; Exp(value)
  %.i043 = fmul fast float %.i038, %Exp, !dbg !338 ; line:63 col:46
  %.i144 = fmul fast float %.i140, %Exp, !dbg !338 ; line:63 col:46
  %.i245 = fmul fast float %.i242, %Exp, !dbg !338 ; line:63 col:46
  %.i046 = fadd fast float %48, %.i043, !dbg !339 ; line:63 col:32
  %.i147 = fadd fast float %49, %.i144, !dbg !339 ; line:63 col:32
  %.i248 = fadd fast float %50, %.i245, !dbg !339 ; line:63 col:32
  %103 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !340 ; line:63 col:12
  call void @llvm.dbg.value(metadata float %.i046, i64 0, metadata !341, metadata !225), !dbg !340 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i147, i64 0, metadata !341, metadata !226), !dbg !340 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i248, i64 0, metadata !341, metadata !227), !dbg !340 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %104 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !342 ; line:65 col:5
  %105 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !343 ; line:74 col:12
  call void @llvm.dbg.value(metadata float %.i046, i64 0, metadata !344, metadata !225), !dbg !343 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i147, i64 0, metadata !344, metadata !226), !dbg !343 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i248, i64 0, metadata !344, metadata !227), !dbg !343 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i049 = fmul fast float %.i046, %95, !dbg !345 ; line:76 col:39
  %.i150 = fmul fast float %.i147, %95, !dbg !345 ; line:76 col:39
  %.i251 = fmul fast float %.i248, %95, !dbg !345 ; line:76 col:39
  %106 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !346 ; line:76 col:12
  call void @llvm.dbg.value(metadata float %.i049, i64 0, metadata !347, metadata !225), !dbg !346 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i150, i64 0, metadata !347, metadata !226), !dbg !346 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i251, i64 0, metadata !347, metadata !227), !dbg !346 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i053 = fadd fast float %.i049, 1.000000e+00, !dbg !348 ; line:80 col:43
  %.i155 = fadd fast float %.i150, 1.000000e+00, !dbg !348 ; line:80 col:43
  %.i257 = fadd fast float %.i251, 1.000000e+00, !dbg !348 ; line:80 col:43
  %.i058 = fdiv fast float %.i049, %.i053, !dbg !349 ; line:80 col:29
  %.i159 = fdiv fast float %.i150, %.i155, !dbg !349 ; line:80 col:29
  %.i260 = fdiv fast float %.i251, %.i257, !dbg !349 ; line:80 col:29
  %107 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !350 ; line:80 col:16
  call void @llvm.dbg.value(metadata float %.i058, i64 0, metadata !347, metadata !225), !dbg !346 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i159, i64 0, metadata !347, metadata !226), !dbg !346 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i260, i64 0, metadata !347, metadata !227), !dbg !346 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i061 = fadd fast float %.i0, %.i058, !dbg !351 ; line:82 col:35
  %.i162 = fadd fast float %.i1, %.i159, !dbg !351 ; line:82 col:35
  %.i263 = fadd fast float %.i2, %.i260, !dbg !351 ; line:82 col:35
  %.i064 = fmul fast float %.i061, %.i028, !dbg !352 ; line:82 col:49
  %.i165 = fmul fast float %.i162, %.i129, !dbg !352 ; line:82 col:49
  %.i266 = fmul fast float %.i263, %.i230, !dbg !352 ; line:82 col:49
  %108 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !353 ; line:82 col:5
  %109 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !354 ; line:94 col:5
  %.i067 = fmul fast float %64, %.i064, !dbg !355 ; line:151 col:35
  %.i168 = fmul fast float %64, %.i165, !dbg !355 ; line:151 col:35
  %.i269 = fmul fast float %64, %.i266, !dbg !355 ; line:151 col:35
  %.i019 = fadd fast float %result.i.0.i0, %.i067, !dbg !356 ; line:151 col:16
  %.i120 = fadd fast float %result.i.0.i1, %.i168, !dbg !356 ; line:151 col:16
  %.i221 = fadd fast float %result.i.0.i2, %.i269, !dbg !356 ; line:151 col:16
  %110 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !356 ; line:151 col:16
  call void @llvm.dbg.value(metadata float %.i019, i64 0, metadata !277, metadata !225), !dbg !276 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i120, i64 0, metadata !277, metadata !226), !dbg !276 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i221, i64 0, metadata !277, metadata !227), !dbg !276 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %111 = add nsw i32 %i.i.0, 1, !dbg !357 ; line:149 col:36
  %112 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !357 ; line:149 col:36
  call void @llvm.dbg.value(metadata i32 %111, i64 0, metadata !279, metadata !240), !dbg !278 ; var:"i" !DIExpression() func:"ComputeLighting"
  %113 = icmp slt i32 %111, 3, !dbg !358 ; line:149 col:18
  br i1 %113, label %62, label %".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge", !dbg !281 ; line:149 col:5

".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge": ; preds = %62
  br label %"\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit", !dbg !281 ; line:149 col:5

"\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit": ; preds = %".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge"
  call void @llvm.dbg.value(metadata float %.i019, i64 0, metadata !277, metadata !225), !dbg !276 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i120, i64 0, metadata !277, metadata !226), !dbg !276 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i221, i64 0, metadata !277, metadata !227), !dbg !276 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %114 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !359 ; line:169 col:5
  %115 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !360 ; line:145 col:12
  call void @llvm.dbg.value(metadata float %.i019, i64 0, metadata !361, metadata !225), !dbg !360 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i120, i64 0, metadata !361, metadata !226), !dbg !360 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i221, i64 0, metadata !361, metadata !227), !dbg !360 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !361, metadata !228), !dbg !360 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %.i073 = fadd fast float %.i015, %.i019, !dbg !362 ; line:148 col:31
  %.i174 = fadd fast float %.i116, %.i120, !dbg !362 ; line:148 col:31
  %.i275 = fadd fast float %.i217, %.i221, !dbg !362 ; line:148 col:31
  %116 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !363 ; line:148 col:12
  call void @llvm.dbg.value(metadata float %.i073, i64 0, metadata !364, metadata !225), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i174, i64 0, metadata !364, metadata !226), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i275, i64 0, metadata !364, metadata !227), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %117 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 77), !dbg !365 ; line:151 col:45  ; CBufferLoadLegacy(handle,regIndex)
  %118 = extractvalue %dx.types.CBufRet.f32 %117, 0, !dbg !365 ; line:151 col:45
  %119 = fsub fast float %Sqrt, %118, !dbg !366 ; line:151 col:43
  %120 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 77), !dbg !367 ; line:151 col:58  ; CBufferLoadLegacy(handle,regIndex)
  %121 = extractvalue %dx.types.CBufRet.f32 %120, 1, !dbg !367 ; line:151 col:58
  %122 = fdiv fast float %119, %121, !dbg !368 ; line:151 col:56
  %Saturate2 = call float @dx.op.unary.f32(i32 7, float %122), !dbg !369 ; line:151 col:23  ; Saturate(value)
  %123 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !370 ; line:151 col:11
  call void @llvm.dbg.value(metadata float %Saturate2, i64 0, metadata !371, metadata !240), !dbg !370 ; var:"fogAmount" !DIExpression() func:"PS"
  %124 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 76), !dbg !372 ; line:152 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %125 = extractvalue %dx.types.CBufRet.f32 %124, 0, !dbg !372 ; line:152 col:31
  %126 = extractvalue %dx.types.CBufRet.f32 %124, 1, !dbg !372 ; line:152 col:31
  %127 = extractvalue %dx.types.CBufRet.f32 %124, 2, !dbg !372 ; line:152 col:31
  %.i077 = fsub fast float %125, %.i073, !dbg !373 ; line:152 col:16
  %.i178 = fsub fast float %126, %.i174, !dbg !373 ; line:152 col:16
  %.i279 = fsub fast float %127, %.i275, !dbg !373 ; line:152 col:16
  %.i081 = fmul fast float %Saturate2, %.i077, !dbg !373 ; line:152 col:16
  %.i182 = fmul fast float %Saturate2, %.i178, !dbg !373 ; line:152 col:16
  %.i283 = fmul fast float %Saturate2, %.i279, !dbg !373 ; line:152 col:16
  %.i085 = fadd fast float %.i073, %.i081, !dbg !373 ; line:152 col:16
  %.i186 = fadd fast float %.i174, %.i182, !dbg !373 ; line:152 col:16
  %.i287 = fadd fast float %.i275, %.i283, !dbg !373 ; line:152 col:16
  %128 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !374 ; line:152 col:14
  call void @llvm.dbg.value(metadata float %.i085, i64 0, metadata !364, metadata !225), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i186, i64 0, metadata !364, metadata !226), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i287, i64 0, metadata !364, metadata !227), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %129 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !375 ; line:156 col:16
  call void @llvm.dbg.value(metadata float %.i085, i64 0, metadata !364, metadata !225), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i186, i64 0, metadata !364, metadata !226), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i287, i64 0, metadata !364, metadata !227), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !364, metadata !228), !dbg !363 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %130 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !376 ; line:158 col:5
  call void @llvm.dbg.declare(metadata [3 x float]* %9, metadata !377, metadata !240), !dbg !378 ; var:"shadowFactor" !DIExpression() func:"ComputeLighting"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %.i085), !dbg !376 ; line:158 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %.i186), !dbg !376 ; line:158 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %.i287), !dbg !376 ; line:158 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %.i3), !dbg !376 ; line:158 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  ret void, !dbg !376 ; line:158 col:5
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare float @dx.op.loadInput.f32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #1

; Function Attrs: nounwind readonly
declare %dx.types.ResRet.f32 @dx.op.sample.f32(i32, %dx.types.Handle, %dx.types.Handle, float, float, float, float, i32, i32, i32, float) #2

; Function Attrs: nounwind
declare void @dx.op.discard(i32, i1) #1

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
!llvm.module.flags = !{!137, !138}
!llvm.ident = !{!139}
!dx.source.contents = !{!140, !141}
!dx.source.defines = !{!142}
!dx.source.mainFileName = !{!143}
!dx.source.args = !{!144}
!dx.version = !{!145}
!dx.valver = !{!146}
!dx.shaderModel = !{!147}
!dx.resources = !{!148}
!dx.typeAnnotations = !{!157, !192}
!dx.viewIdState = !{!195}
!dx.entryPoints = !{!196}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !16, globals: !70)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDefault.hlsl", directory: "")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 32, baseType: !5)
!5 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 32, size: 128, align: 32, elements: !6, templateParams: !12)
!6 = !{!7, !9, !10, !11}
!7 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !5, file: !1, line: 32, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!8 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!9 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !5, file: !1, line: 32, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!10 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !5, file: !1, line: 32, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!11 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !5, file: !1, line: 32, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!12 = !{!13, !14}
!13 = !DITemplateTypeParameter(name: "element", type: !8)
!14 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 4)
!15 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!16 = !{!17, !41, !61, !64, !67}
!17 = !DISubprogram(name: "PS", scope: !1, file: !1, line: 119, type: !18, isLocal: false, isDefinition: true, scopeLine: 120, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @PS)
!18 = !DISubroutineType(types: !19)
!19 = !{!4, !20}
!20 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexOut", file: !1, line: 77, size: 384, align: 32, elements: !21)
!21 = !{!22, !23, !32, !33}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !20, file: !1, line: 79, baseType: !4, size: 128, align: 32)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !20, file: !1, line: 80, baseType: !24, size: 96, align: 32, offset: 128)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 33, baseType: !25)
!25 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 33, size: 96, align: 32, elements: !26, templateParams: !30)
!26 = !{!27, !28, !29}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !25, file: !1, line: 33, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !25, file: !1, line: 33, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !25, file: !1, line: 33, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!30 = !{!13, !31}
!31 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 3)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !20, file: !1, line: 81, baseType: !24, size: 96, align: 32, offset: 224)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !20, file: !1, line: 82, baseType: !34, size: 64, align: 32, offset: 320)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 25, baseType: !35)
!35 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 25, size: 64, align: 32, elements: !36, templateParams: !39)
!36 = !{!37, !38}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !35, file: !1, line: 25, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !35, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!39 = !{!13, !40}
!40 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 2)
!41 = !DISubprogram(name: "ComputeLighting", linkageName: "\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z", scope: !42, file: !42, line: 143, type: !43, isLocal: false, isDefinition: true, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!42 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!43 = !DISubroutineType(types: !44)
!44 = !{!4, !45, !56, !24, !24, !24, !24}
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 6144, align: 32, elements: !54)
!46 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !42, line: 3, size: 384, align: 32, elements: !47)
!47 = !{!48, !49, !50, !51, !52, !53}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !46, file: !42, line: 5, baseType: !24, size: 96, align: 32)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !46, file: !42, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !46, file: !42, line: 7, baseType: !24, size: 96, align: 32, offset: 128)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !46, file: !42, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !46, file: !42, line: 9, baseType: !24, size: 96, align: 32, offset: 256)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !46, file: !42, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!54 = !{!55}
!55 = !DISubrange(count: 16)
!56 = !DICompositeType(tag: DW_TAG_structure_type, name: "Material", file: !42, line: 13, size: 256, align: 32, elements: !57)
!57 = !{!58, !59, !60}
!58 = !DIDerivedType(tag: DW_TAG_member, name: "DiffuseAlbedo", scope: !56, file: !42, line: 15, baseType: !4, size: 128, align: 32)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "FresnelR0", scope: !56, file: !42, line: 16, baseType: !24, size: 96, align: 32, offset: 128)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "Shininess", scope: !56, file: !42, line: 17, baseType: !8, size: 32, align: 32, offset: 224)
!61 = !DISubprogram(name: "ComputeDirectionalLight", linkageName: "\01?ComputeDirectionalLight@@YA?AV?$vector@M$02@@ULight@@UMaterial@@V1@2@Z", scope: !42, file: !42, line: 85, type: !62, isLocal: false, isDefinition: true, scopeLine: 86, flags: DIFlagPrototyped, isOptimized: false)
!62 = !DISubroutineType(types: !63)
!63 = !{!24, !46, !56, !24, !24}
!64 = !DISubprogram(name: "BlinnPhong", linkageName: "\01?BlinnPhong@@YA?AV?$vector@M$02@@V1@000UMaterial@@@Z", scope: !42, file: !42, line: 68, type: !65, isLocal: false, isDefinition: true, scopeLine: 69, flags: DIFlagPrototyped, isOptimized: false)
!65 = !DISubroutineType(types: !66)
!66 = !{!24, !24, !24, !24, !24, !56}
!67 = !DISubprogram(name: "SchlickFresnel", linkageName: "\01?SchlickFresnel@@YA?AV?$vector@M$02@@V1@00@Z", scope: !42, file: !42, line: 59, type: !68, isLocal: false, isDefinition: true, scopeLine: 60, flags: DIFlagPrototyped, isOptimized: false)
!68 = !DISubroutineType(types: !69)
!69 = !{!24, !24, !24, !24}
!70 = !{!71, !95, !96, !98, !100, !101, !103, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !125, !126, !127, !128, !129, !133, !134, !135}
!71 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 23, type: !72, isLocal: false, isDefinition: true)
!72 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !73)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 23, baseType: !74)
!74 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 23, size: 512, align: 32, elements: !75, templateParams: !92)
!75 = !{!76, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91}
!76 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !74, file: !1, line: 23, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!92 = !{!13, !93, !94}
!93 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 4)
!94 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 4)
!95 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 24, type: !72, isLocal: false, isDefinition: true)
!96 = !DIGlobalVariable(name: "gDisplacementMapTexelSize", linkageName: "\01?gDisplacementMapTexelSize@cbPerObject@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 25, type: !97, isLocal: false, isDefinition: true)
!97 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!98 = !DIGlobalVariable(name: "gGridSpatialStep", linkageName: "\01?gGridSpatialStep@cbPerObject@@3MB", scope: !0, file: !1, line: 26, type: !99, isLocal: false, isDefinition: true)
!99 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!100 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPerObject@@3MB", scope: !0, file: !1, line: 27, type: !99, isLocal: false, isDefinition: true)
!101 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 32, type: !102, isLocal: false, isDefinition: true)
!102 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!103 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 33, type: !104, isLocal: false, isDefinition: true)
!104 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!105 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 34, type: !99, isLocal: false, isDefinition: true)
!106 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 35, type: !72, isLocal: false, isDefinition: true)
!107 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 40, type: !72, isLocal: false, isDefinition: true)
!108 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 41, type: !72, isLocal: false, isDefinition: true)
!109 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !72, isLocal: false, isDefinition: true)
!110 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 43, type: !72, isLocal: false, isDefinition: true)
!111 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 44, type: !72, isLocal: false, isDefinition: true)
!112 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 45, type: !72, isLocal: false, isDefinition: true)
!113 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 46, type: !104, isLocal: false, isDefinition: true)
!114 = !DIGlobalVariable(name: "cbPerPassPad1", linkageName: "\01?cbPerPassPad1@cbPass@@3MB", scope: !0, file: !1, line: 47, type: !99, isLocal: false, isDefinition: true)
!115 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 48, type: !97, isLocal: false, isDefinition: true)
!116 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 49, type: !97, isLocal: false, isDefinition: true)
!117 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 50, type: !99, isLocal: false, isDefinition: true)
!118 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 51, type: !99, isLocal: false, isDefinition: true)
!119 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 52, type: !99, isLocal: false, isDefinition: true)
!120 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 53, type: !99, isLocal: false, isDefinition: true)
!121 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 54, type: !102, isLocal: false, isDefinition: true)
!122 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 59, type: !123, isLocal: false, isDefinition: true)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !124, size: 6144, align: 32, elements: !54)
!124 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !46)
!125 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 63, type: !102, isLocal: false, isDefinition: true)
!126 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 64, type: !99, isLocal: false, isDefinition: true)
!127 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 65, type: !99, isLocal: false, isDefinition: true)
!128 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 66, type: !97, isLocal: false, isDefinition: true)
!129 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 15, type: !130, isLocal: false, isDefinition: true)
!130 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 15, size: 160, align: 32, elements: !2, templateParams: !131)
!131 = !{!132}
!132 = !DITemplateTypeParameter(name: "element", type: !5)
!133 = !DIGlobalVariable(name: "gDiffuseMap2", linkageName: "\01?gDiffuseMap2@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 16, type: !130, isLocal: false, isDefinition: true)
!134 = !DIGlobalVariable(name: "gDisplacementMap", linkageName: "\01?gDisplacementMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 17, type: !130, isLocal: false, isDefinition: true)
!135 = !DIGlobalVariable(name: "gsamLinear", linkageName: "\01?gsamLinear@@3USamplerState@@A", scope: !0, file: !1, line: 19, type: !136, isLocal: false, isDefinition: true)
!136 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 19, size: 32, align: 32, elements: !2)
!137 = !{i32 2, !"Dwarf Version", i32 4}
!138 = !{i32 2, !"Debug Info Version", i32 3}
!139 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!140 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDefault.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0ATexture2D gDiffuseMap2 : register(t1);\0D\0ATexture2D gDisplacementMap : register(t2);\0D\0A\0D\0ASamplerState gsamLinear : register(s0);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A    float2 gDisplacementMapTexelSize;\0D\0A    float gGridSpatialStep;\0D\0A    float cbPerObjectPad1;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerPassPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    // \EC\9D\B8\EB\8D\B1\EC\8A\A4 [0, NUM_DIR_LIGHTS)\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B4\91\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)\EB\8A\94 \EC\A0\90\EA\B4\91\EC\9B\90\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHT + NUM_SPOT_LIGHTS)\EB\8A\94 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\B4\EB\A9\B0, \EA\B0\9D\EC\B2\B4\EB\8B\B9 \EC\B5\9C\EB\8C\80 MaxLights \EA\B0\9C\EC\88\98\EA\B9\8C\EC\A7\80 \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    //\EC\95\B1\EC\9D\B4 \ED\94\84\EB\A0\88\EC\9E\84\EB\8B\B9 \ED\95\9C \EB\B2\88\EC\94\A9 \EC\95\88\EA\B0\9C \EB\A7\A4\EA\B0\9C\EB\B3\80\EC\88\98\EB\A5\BC \EB\B3\80\EA\B2\BD\ED\95\A0 \EC\88\98 \EC\9E\88\EB\8F\84\EB\A1\9D \ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    //\ED\8A\B9\EC\A0\95 \EC\8B\9C\EA\B0\84\EB\8C\80\EC\97\90\EB\A7\8C \EC\95\88\EA\B0\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosL : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float3 TangentL : TANGENT;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float4 PosH : SV_Position;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout = (VertexOut) 0.0f;\0D\0A    \0D\0A#ifdef DISPLACEMENT_MAP\0D\0A    //\EB\B3\80\ED\99\98\EB\90\98\EC\A7\80 \EC\95\8A\EC\9D\80 [0,1]^2 tex \EC\A2\8C\ED\91\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\98\EC\97\AC \EB\B3\80\EC\9C\84 \EB\A7\B5\EC\9D\84 \EC\83\98\ED\94\8C\EB\A7\81.\0D\0A    vin.PosL.y += gDisplacementMap.SampleLevel(gsamLinear, vin.TexC, 1.0f).r;\0D\0A\09\0D\0A\09//\EC\9C\A0\ED\95\9C\EC\B0\A8\EB\B6\84\EB\B2\95\EC\9D\84 \EC\9D\B4\EC\9A\A9\ED\95\98\EC\97\AC \EC\A0\95\EA\B7\9C\EB\B6\84\ED\8F\AC\EB\A5\BC \EC\B6\94\EC\A0\95.\0D\0A    float du = gDisplacementMapTexelSize.x;\0D\0A    float dv = gDisplacementMapTexelSize.y;\0D\0A    float l = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC - float2(du, 0.0f), 0.0f).r;\0D\0A    float r = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC + float2(du, 0.0f), 0.0f).r;\0D\0A    float t = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC - float2(0.0f, dv), 0.0f).r;\0D\0A    float b = gDisplacementMap.SampleLevel(gsamLinear, vin.TexC + float2(0.0f, dv), 0.0f).r;\0D\0A    vin.NormalL = normalize(float3(-r + l, 2.0f * gGridSpatialStep, b - t));\0D\0A    \0D\0A#endif\0D\0A    \0D\0A    float4 posW = mul(float4(vin.PosL, 1.0f), gWorld);\0D\0A    vout.PosW = posW.xyz;\0D\0A    \0D\0A    // \EB\B9\84\EA\B7\A0\EC\9D\BC \EC\8A\A4\EC\BC\80\EC\9D\BC\EB\A7\81\EC\9D\84 \EA\B0\80\EC\A0\95. \EC\95\84\EB\8B\88\EB\9D\BC\EB\A9\B4 \EC\9B\94\EB\93\9C \ED\96\89\EB\A0\AC\EC\9D\98 \EC\97\AD\EC\A0\84\EC\B9\98 \ED\96\89\EB\A0\AC\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\B4\EC\95\BC \ED\95\9C\EB\8B\A4.\0D\0A    vout.NormalW = mul(vin.NormalL, (float3x3) gWorld);\0D\0A    \0D\0A    // homogeneous clip \EA\B3\B5\EA\B0\84\EC\9C\BC\EB\A1\9C \EB\B3\80\ED\99\98.\0D\0A    vout.PosH = mul(posW, gViewProj);\0D\0A    \0D\0A    float4 texC = mul(float4(vin.TexC, 0.f, 1.f), gTexTransform);\0D\0A    vout.TexC = mul(texC, gMatTransform).xy;\0D\0A    \0D\0A    return vout;\0D\0A}\0D\0A \0D\0Afloat4 PS(VertexOut pin) : SV_Target\0D\0A{\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamLinear, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A#ifdef TEXTURE_BLEND\0D\0A    diffuseAlbedo *= (gDiffuseMap2.Sample(gsamLinear, pin.TexC) * gDiffuseAlbedo).r;\0D\0A#endif\0D\0A    \0D\0A#ifdef ALPHA_TEST\0D\0A\09//value < 0 \EC\9D\B4\EB\A9\B4 \ED\98\84\EC\9E\AC \ED\94\BD\EC\85\80\EC\9D\84 \EB\B2\84\EB\A6\AC\EA\B3\A0 \EB\8D\94 \EC\9D\B4\EC\83\81 \EB\A0\8C\EB\8D\94 \ED\83\80\EA\B9\83\EC\97\90 \EA\B8\B0\EB\A1\9D\ED\95\98\EC\A7\80 \EC\95\8A\EB\8A\94\EB\8B\A4.\0D\0A\09clip(diffuseAlbedo.a - 0.1f);\0D\0A#endif\0D\0A    \0D\0A    //\EB\B3\B4\EA\B0\84\EB\90\9C \EB\B2\95\EC\84\A0 \EB\B2\A1\ED\84\B0\EB\8A\94 \EA\B8\B8\EC\9D\B4\EA\B0\80 1\EC\9D\B4 \EC\95\84\EB\8B\90 \EC\88\98 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C.\0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A\0D\0A    //\EA\B4\91\EC\9B\90\EC\97\90\EC\84\9C \EC\B9\B4\EB\A9\94\EB\9D\BC\EB\A1\9C \ED\96\A5\ED\95\98\EB\8A\94 \EB\B2\A1\ED\84\B0.\0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    \0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A    \0D\0A#ifdef FOG\0D\0A    float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A    litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A\0D\0A    //\EC\9D\BC\EB\B0\98\EC\A0\81\EC\9C\BC\EB\A1\9C \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\80 \EB\94\94\ED\93\A8\EC\A6\88 \EB\A8\B8\ED\8B\B0\EB\A6\AC\EC\96\BC\EC\9D\98 \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\9C\EB\8B\A4.\0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A    \0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_MirrorBaseFill(VertexOut pin) : SV_Target\0D\0A{\0D\0A    return gDiffuseAlbedo;\0D\0A}"}
!141 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0\E3\84\B4.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrenght = L.Strength * ndotl;\0D\0A    \0D\0A    return BlinnPhong(lightStrenght, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!142 = !{!"FOG=1", !"ALPHA_TEST=1", !"FOG=1", !"ALPHA_TEST=1"}
!143 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDefault.hlsl"}
!144 = !{!"-E", !"PS", !"-T", !"ps_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-D", !"FOG=1", !"-D", !"ALPHA_TEST=1", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CDefault_ps_AlphaTest.cso", !"-D", !"FOG=1", !"-D", !"ALPHA_TEST=1"}
!145 = !{i32 1, i32 0}
!146 = !{i32 1, i32 8}
!147 = !{!"ps", i32 6, i32 0}
!148 = !{!149, null, !152, !155}
!149 = !{!150}
!150 = !{i32 0, %"class.Texture2D<vector<float, 4> >"* undef, !"gDiffuseMap", i32 0, i32 0, i32 1, i32 2, i32 0, !151}
!151 = !{i32 0, i32 9}
!152 = !{!153, !154}
!153 = !{i32 0, %hostlayout.cbMaterial* undef, !"cbMaterial", i32 0, i32 1, i32 1, i32 96, null}
!154 = !{i32 1, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!155 = !{!156}
!156 = !{i32 0, %struct.SamplerState* undef, !"gsamLinear", i32 0, i32 0, i32 1, i32 0, null}
!157 = !{i32 0, %struct.Light undef, !158, %hostlayout.cbMaterial undef, !165, %hostlayout.cbPass undef, !171}
!158 = !{i32 48, !159, !160, !161, !162, !163, !164}
!159 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!160 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!161 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!162 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!163 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!164 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!165 = !{i32 96, !166, !167, !168, !169}
!166 = !{i32 6, !"gDiffuseAlbedo", i32 3, i32 0, i32 7, i32 9}
!167 = !{i32 6, !"gFresnelR0", i32 3, i32 16, i32 7, i32 9}
!168 = !{i32 6, !"gRoughness", i32 3, i32 28, i32 7, i32 9}
!169 = !{i32 6, !"gMatTransform", i32 2, !170, i32 3, i32 32, i32 7, i32 9}
!170 = !{i32 4, i32 4, i32 2}
!171 = !{i32 1248, !172, !173, !174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191}
!172 = !{i32 6, !"gView", i32 2, !170, i32 3, i32 0, i32 7, i32 9}
!173 = !{i32 6, !"gInvView", i32 2, !170, i32 3, i32 64, i32 7, i32 9}
!174 = !{i32 6, !"gProj", i32 2, !170, i32 3, i32 128, i32 7, i32 9}
!175 = !{i32 6, !"gInvProj", i32 2, !170, i32 3, i32 192, i32 7, i32 9}
!176 = !{i32 6, !"gViewProj", i32 2, !170, i32 3, i32 256, i32 7, i32 9}
!177 = !{i32 6, !"gInvViewProj", i32 2, !170, i32 3, i32 320, i32 7, i32 9}
!178 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!179 = !{i32 6, !"cbPerPassPad1", i32 3, i32 396, i32 7, i32 9}
!180 = !{i32 6, !"gRenderTargetSize", i32 3, i32 400, i32 7, i32 9}
!181 = !{i32 6, !"gInvRenderTargetSize", i32 3, i32 408, i32 7, i32 9}
!182 = !{i32 6, !"gNearZ", i32 3, i32 416, i32 7, i32 9}
!183 = !{i32 6, !"gFarZ", i32 3, i32 420, i32 7, i32 9}
!184 = !{i32 6, !"gTotalTime", i32 3, i32 424, i32 7, i32 9}
!185 = !{i32 6, !"gDeltaTime", i32 3, i32 428, i32 7, i32 9}
!186 = !{i32 6, !"gAmbientLight", i32 3, i32 432, i32 7, i32 9}
!187 = !{i32 6, !"gLights", i32 3, i32 448}
!188 = !{i32 6, !"gFogColor", i32 3, i32 1216, i32 7, i32 9}
!189 = !{i32 6, !"gFogStart", i32 3, i32 1232, i32 7, i32 9}
!190 = !{i32 6, !"gFogRange", i32 3, i32 1236, i32 7, i32 9}
!191 = !{i32 6, !"cbPerObjectPad2", i32 3, i32 1240, i32 7, i32 9}
!192 = !{i32 1, void ()* @PS, !193}
!193 = !{!194}
!194 = !{i32 0, !2, !2}
!195 = !{[16 x i32] [i32 14, i32 4, i32 0, i32 0, i32 0, i32 0, i32 7, i32 7, i32 7, i32 0, i32 7, i32 7, i32 7, i32 0, i32 15, i32 15]}
!196 = !{void ()* @PS, !"PS", !197, !148, !209}
!197 = !{!198, !206, null}
!198 = !{!199, !201, !203, !204}
!199 = !{i32 0, !"SV_Position", i8 9, i8 3, !200, i8 4, i32 1, i8 4, i32 0, i8 0, null}
!200 = !{i32 0}
!201 = !{i32 1, !"POSITION", i8 9, i8 0, !200, i8 2, i32 1, i8 3, i32 1, i8 0, !202}
!202 = !{i32 3, i32 7}
!203 = !{i32 2, !"NORMAL", i8 9, i8 0, !200, i8 2, i32 1, i8 3, i32 2, i8 0, !202}
!204 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !200, i8 2, i32 1, i8 2, i32 3, i8 0, !205}
!205 = !{i32 3, i32 3}
!206 = !{!207}
!207 = !{i32 0, !"SV_Target", i8 9, i8 16, !200, i8 0, i32 1, i8 4, i32 0, i8 0, !208}
!208 = !{i32 3, i32 15}
!209 = !{i32 0, i64 1}
!210 = !DILocation(line: 121, column: 28, scope: !17)
!211 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "pin", arg: 1, scope: !17, file: !1, line: 119, type: !20)
!212 = !DIExpression(DW_OP_bit_piece, 320, 32)
!213 = !DILocation(line: 119, column: 21, scope: !17)
!214 = !DIExpression(DW_OP_bit_piece, 352, 32)
!215 = !DIExpression(DW_OP_bit_piece, 224, 32)
!216 = !DIExpression(DW_OP_bit_piece, 256, 32)
!217 = !DIExpression(DW_OP_bit_piece, 288, 32)
!218 = !DIExpression(DW_OP_bit_piece, 128, 32)
!219 = !DIExpression(DW_OP_bit_piece, 160, 32)
!220 = !DIExpression(DW_OP_bit_piece, 192, 32)
!221 = !DILocation(line: 121, column: 71, scope: !17)
!222 = !DILocation(line: 121, column: 69, scope: !17)
!223 = !DILocation(line: 121, column: 12, scope: !17)
!224 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "diffuseAlbedo", scope: !17, file: !1, line: 121, type: !4)
!225 = !DIExpression(DW_OP_bit_piece, 0, 32)
!226 = !DIExpression(DW_OP_bit_piece, 32, 32)
!227 = !DIExpression(DW_OP_bit_piece, 64, 32)
!228 = !DIExpression(DW_OP_bit_piece, 96, 32)
!229 = !DILocation(line: 129, column: 23, scope: !17)
!230 = !DILocation(line: 129, column: 2, scope: !17)
!231 = !DILocation(line: 133, column: 19, scope: !17)
!232 = !DILocation(line: 133, column: 17, scope: !17)
!233 = !DILocation(line: 136, column: 21, scope: !17)
!234 = !DILocation(line: 136, column: 30, scope: !17)
!235 = !DILocation(line: 136, column: 12, scope: !17)
!236 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "toEyeW", scope: !17, file: !1, line: 136, type: !24)
!237 = !DILocation(line: 137, column: 23, scope: !17)
!238 = !DILocation(line: 137, column: 11, scope: !17)
!239 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "distToEye", scope: !17, file: !1, line: 137, type: !8)
!240 = !DIExpression()
!241 = !DILocation(line: 138, column: 12, scope: !17)
!242 = !DILocation(line: 140, column: 22, scope: !17)
!243 = !DILocation(line: 140, column: 36, scope: !17)
!244 = !DILocation(line: 140, column: 12, scope: !17)
!245 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "ambient", scope: !17, file: !1, line: 140, type: !4)
!246 = !DILocation(line: 141, column: 36, scope: !17)
!247 = !DILocation(line: 141, column: 34, scope: !17)
!248 = !DILocation(line: 141, column: 17, scope: !17)
!249 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "shininess", scope: !17, file: !1, line: 141, type: !99)
!250 = !DILocation(line: 142, column: 20, scope: !17)
!251 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "mat", scope: !17, file: !1, line: 142, type: !56)
!252 = !DILocation(line: 142, column: 14, scope: !17)
!253 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 2, scope: !41, file: !42, line: 143, type: !56)
!254 = !DILocation(line: 143, column: 59, scope: !41, inlinedAt: !255)
!255 = distinct !DILocation(line: 145, column: 26, scope: !17)
!256 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 5, scope: !64, file: !42, line: 68, type: !56)
!257 = !DILocation(line: 68, column: 96, scope: !64, inlinedAt: !258)
!258 = distinct !DILocation(line: 94, column: 12, scope: !61, inlinedAt: !259)
!259 = distinct !DILocation(line: 151, column: 37, scope: !260, inlinedAt: !255)
!260 = distinct !DILexicalBlock(scope: !261, file: !42, line: 150, column: 5)
!261 = distinct !DILexicalBlock(scope: !262, file: !42, line: 149, column: 5)
!262 = distinct !DILexicalBlock(scope: !41, file: !42, line: 149, column: 5)
!263 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 2, scope: !61, file: !42, line: 85, type: !56)
!264 = !DILocation(line: 85, column: 50, scope: !61, inlinedAt: !259)
!265 = !DILocation(line: 142, column: 37, scope: !17)
!266 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "R0", arg: 1, scope: !67, file: !42, line: 59, type: !24)
!267 = !DILocation(line: 59, column: 30, scope: !67, inlinedAt: !268)
!268 = distinct !DILocation(line: 74, column: 28, scope: !64, inlinedAt: !258)
!269 = !DILocation(line: 143, column: 12, scope: !17)
!270 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "shadowFactor", scope: !17, file: !1, line: 143, type: !24)
!271 = !DILocation(line: 145, column: 26, scope: !17)
!272 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 5, scope: !41, file: !42, line: 143, type: !24)
!273 = !DILocation(line: 143, column: 98, scope: !41, inlinedAt: !255)
!274 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 4, scope: !41, file: !42, line: 143, type: !24)
!275 = !DILocation(line: 143, column: 83, scope: !41, inlinedAt: !255)
!276 = !DILocation(line: 145, column: 12, scope: !41, inlinedAt: !255)
!277 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "result", scope: !41, file: !42, line: 145, type: !24)
!278 = !DILocation(line: 146, column: 9, scope: !41, inlinedAt: !255)
!279 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !41, file: !42, line: 146, type: !15)
!280 = !DILocation(line: 149, column: 11, scope: !262, inlinedAt: !255)
!281 = !DILocation(line: 149, column: 5, scope: !262, inlinedAt: !255)
!282 = !DILocation(line: 151, column: 19, scope: !260, inlinedAt: !255)
!283 = !DILocation(line: 151, column: 37, scope: !260, inlinedAt: !255)
!284 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 4, scope: !61, file: !42, line: 85, type: !24)
!285 = !DILocation(line: 85, column: 77, scope: !61, inlinedAt: !259)
!286 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 3, scope: !61, file: !42, line: 85, type: !24)
!287 = !DILocation(line: 85, column: 62, scope: !61, inlinedAt: !259)
!288 = !DILocation(line: 88, column: 26, scope: !61, inlinedAt: !259)
!289 = !DILocation(line: 88, column: 23, scope: !61, inlinedAt: !259)
!290 = !DILocation(line: 88, column: 12, scope: !61, inlinedAt: !259)
!291 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "lightVec", scope: !61, file: !42, line: 88, type: !24)
!292 = !DILocation(line: 91, column: 23, scope: !61, inlinedAt: !259)
!293 = !DILocation(line: 91, column: 19, scope: !61, inlinedAt: !259)
!294 = !DILocation(line: 91, column: 11, scope: !61, inlinedAt: !259)
!295 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "ndotl", scope: !61, file: !42, line: 91, type: !8)
!296 = !DILocation(line: 92, column: 30, scope: !61, inlinedAt: !259)
!297 = !DILocation(line: 92, column: 39, scope: !61, inlinedAt: !259)
!298 = !DILocation(line: 92, column: 12, scope: !61, inlinedAt: !259)
!299 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "lightStrenght", scope: !61, file: !42, line: 92, type: !24)
!300 = !DILocation(line: 94, column: 12, scope: !61, inlinedAt: !259)
!301 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 4, scope: !64, file: !42, line: 68, type: !24)
!302 = !DILocation(line: 68, column: 80, scope: !64, inlinedAt: !258)
!303 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 3, scope: !64, file: !42, line: 68, type: !24)
!304 = !DILocation(line: 68, column: 65, scope: !64, inlinedAt: !258)
!305 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightVec", arg: 2, scope: !64, file: !42, line: 68, type: !24)
!306 = !DILocation(line: 68, column: 48, scope: !64, inlinedAt: !258)
!307 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightStrength", arg: 1, scope: !64, file: !42, line: 68, type: !24)
!308 = !DILocation(line: 68, column: 26, scope: !64, inlinedAt: !258)
!309 = !DILocation(line: 70, column: 35, scope: !64, inlinedAt: !258)
!310 = !DILocation(line: 70, column: 17, scope: !64, inlinedAt: !258)
!311 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "m", scope: !64, file: !42, line: 70, type: !99)
!312 = !DILocation(line: 71, column: 38, scope: !64, inlinedAt: !258)
!313 = !DILocation(line: 71, column: 22, scope: !64, inlinedAt: !258)
!314 = !DILocation(line: 71, column: 12, scope: !64, inlinedAt: !258)
!315 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "halfVec", scope: !64, file: !42, line: 71, type: !24)
!316 = !DILocation(line: 73, column: 32, scope: !64, inlinedAt: !258)
!317 = !DILocation(line: 73, column: 50, scope: !64, inlinedAt: !258)
!318 = !DILocation(line: 73, column: 46, scope: !64, inlinedAt: !258)
!319 = !DILocation(line: 73, column: 42, scope: !64, inlinedAt: !258)
!320 = !DILocation(line: 73, column: 40, scope: !64, inlinedAt: !258)
!321 = !DILocation(line: 73, column: 82, scope: !64, inlinedAt: !258)
!322 = !DILocation(line: 73, column: 11, scope: !64, inlinedAt: !258)
!323 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "roughnessFactor", scope: !64, file: !42, line: 73, type: !8)
!324 = !DILocation(line: 74, column: 28, scope: !64, inlinedAt: !258)
!325 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightVec", arg: 3, scope: !67, file: !42, line: 59, type: !24)
!326 = !DILocation(line: 59, column: 56, scope: !67, inlinedAt: !268)
!327 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 2, scope: !67, file: !42, line: 59, type: !24)
!328 = !DILocation(line: 59, column: 41, scope: !67, inlinedAt: !268)
!329 = !DILocation(line: 61, column: 39, scope: !67, inlinedAt: !268)
!330 = !DILocation(line: 61, column: 30, scope: !67, inlinedAt: !268)
!331 = !DILocation(line: 61, column: 11, scope: !67, inlinedAt: !268)
!332 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "cosIncidentAngle", scope: !67, file: !42, line: 61, type: !8)
!333 = !DILocation(line: 62, column: 21, scope: !67, inlinedAt: !268)
!334 = !DILocation(line: 62, column: 11, scope: !67, inlinedAt: !268)
!335 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "f0", scope: !67, file: !42, line: 62, type: !8)
!336 = !DILocation(line: 63, column: 40, scope: !67, inlinedAt: !268)
!337 = !DILocation(line: 63, column: 48, scope: !67, inlinedAt: !268)
!338 = !DILocation(line: 63, column: 46, scope: !67, inlinedAt: !268)
!339 = !DILocation(line: 63, column: 32, scope: !67, inlinedAt: !268)
!340 = !DILocation(line: 63, column: 12, scope: !67, inlinedAt: !268)
!341 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "reflectPercent", scope: !67, file: !42, line: 63, type: !24)
!342 = !DILocation(line: 65, column: 5, scope: !67, inlinedAt: !268)
!343 = !DILocation(line: 74, column: 12, scope: !64, inlinedAt: !258)
!344 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "fresnelFactor", scope: !64, file: !42, line: 74, type: !24)
!345 = !DILocation(line: 76, column: 39, scope: !64, inlinedAt: !258)
!346 = !DILocation(line: 76, column: 12, scope: !64, inlinedAt: !258)
!347 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "specAlbedo", scope: !64, file: !42, line: 76, type: !24)
!348 = !DILocation(line: 80, column: 43, scope: !64, inlinedAt: !258)
!349 = !DILocation(line: 80, column: 29, scope: !64, inlinedAt: !258)
!350 = !DILocation(line: 80, column: 16, scope: !64, inlinedAt: !258)
!351 = !DILocation(line: 82, column: 35, scope: !64, inlinedAt: !258)
!352 = !DILocation(line: 82, column: 49, scope: !64, inlinedAt: !258)
!353 = !DILocation(line: 82, column: 5, scope: !64, inlinedAt: !258)
!354 = !DILocation(line: 94, column: 5, scope: !61, inlinedAt: !259)
!355 = !DILocation(line: 151, column: 35, scope: !260, inlinedAt: !255)
!356 = !DILocation(line: 151, column: 16, scope: !260, inlinedAt: !255)
!357 = !DILocation(line: 149, column: 36, scope: !261, inlinedAt: !255)
!358 = !DILocation(line: 149, column: 18, scope: !261, inlinedAt: !255)
!359 = !DILocation(line: 169, column: 5, scope: !41, inlinedAt: !255)
!360 = !DILocation(line: 145, column: 12, scope: !17)
!361 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "directLight", scope: !17, file: !1, line: 145, type: !4)
!362 = !DILocation(line: 148, column: 31, scope: !17)
!363 = !DILocation(line: 148, column: 12, scope: !17)
!364 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "litColor", scope: !17, file: !1, line: 148, type: !4)
!365 = !DILocation(line: 151, column: 45, scope: !17)
!366 = !DILocation(line: 151, column: 43, scope: !17)
!367 = !DILocation(line: 151, column: 58, scope: !17)
!368 = !DILocation(line: 151, column: 56, scope: !17)
!369 = !DILocation(line: 151, column: 23, scope: !17)
!370 = !DILocation(line: 151, column: 11, scope: !17)
!371 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "fogAmount", scope: !17, file: !1, line: 151, type: !8)
!372 = !DILocation(line: 152, column: 31, scope: !17)
!373 = !DILocation(line: 152, column: 16, scope: !17)
!374 = !DILocation(line: 152, column: 14, scope: !17)
!375 = !DILocation(line: 156, column: 16, scope: !17)
!376 = !DILocation(line: 158, column: 5, scope: !17)
!377 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "shadowFactor", arg: 6, scope: !41, file: !42, line: 143, type: !24)
!378 = !DILocation(line: 143, column: 112, scope: !41, inlinedAt: !255)
