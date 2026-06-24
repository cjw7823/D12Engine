;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Position              0   xyzw        0      POS   float       
; POSITION                 0   xyz         1     NONE   float   xyz 
; NORMAL                   0   xyz         2     NONE   float   xyz 
; TEXCOORD                 0   xy          3     NONE   float   xy  
; SV_PrimitiveID           0   x           4   PRIMID    uint   x   
;
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Target                0   xyzw        0   TARGET   float   xyzw
;
; shader debug name: ba38ad9301444a89512d1c253b976b91.pdb
; shader hash: ba38ad9301444a89512d1c253b976b91
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
; SigInputElements: 5
; SigOutputElements: 1
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 5
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
; gsamAnisotropicWrap               sampler      NA          NA      S0             s4     1
; gTreeMapArray                     texture     f32     2darray      T0             t0     1
;
;
; ViewId state:
;
; Number of inputs: 17, outputs: 4
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;   output 0 depends on inputs: { 4, 5, 6, 8, 9, 10, 12, 13, 16 }
;   output 1 depends on inputs: { 4, 5, 6, 8, 9, 10, 12, 13, 16 }
;   output 2 depends on inputs: { 4, 5, 6, 8, 9, 10, 12, 13, 16 }
;   output 3 depends on inputs: { 12, 13, 16 }
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.ResRet.f32 = type { float, float, float, float, i32 }
%dx.types.CBufRet.f32 = type { float, float, float, float }
%"class.Texture2DArray<vector<float, 4> >" = type { <4 x float>, %"class.Texture2DArray<vector<float, 4> >::mips_type" }
%"class.Texture2DArray<vector<float, 4> >::mips_type" = type { i32 }
%hostlayout.cbMaterial = type { <4 x float>, <3 x float>, float, [4 x <4 x float>] }
%hostlayout.cbPass = type { [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], <3 x float>, float, <2 x float>, <2 x float>, float, float, float, float, <4 x float>, [16 x %struct.Light], <4 x float>, float, float, <2 x float> }
%struct.Light = type { <3 x float>, float, <3 x float>, float, <3 x float>, float }
%struct.SamplerState = type { i32 }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

define void @PS() {
  %gTreeMapArray_texture_2darray = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 0, i32 0, i32 0, i1 false), !dbg !215 ; line:144 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %gsamAnisotropicWrap_sampler = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 3, i32 0, i32 4, i1 false), !dbg !215 ; line:144 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 1, i32 2, i1 false), !dbg !215 ; line:144 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbMaterial_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 1, i1 false), !dbg !215 ; line:144 col:28  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call i32 @dx.op.loadInput.i32(i32 4, i32 4, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %2 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !216, metadata !217), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"PS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 3, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !216, metadata !219), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 352, 32) func:"PS"
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !216, metadata !220), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !216, metadata !221), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 2, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !216, metadata !222), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !216, metadata !223), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !216, metadata !224), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  %9 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %9, i64 0, metadata !216, metadata !225), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  %10 = alloca [3 x float], align 4
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !216, metadata !223), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !216, metadata !224), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %9, i64 0, metadata !216, metadata !225), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !216, metadata !220), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !216, metadata !221), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !216, metadata !222), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !216, metadata !217), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 320, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !216, metadata !219), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 352, 32) func:"PS"
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !216, metadata !226), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 384, 32) func:"PS"
  %11 = urem i32 %1, 3, !dbg !227 ; line:143 col:46
  %12 = uitofp i32 %11 to float, !dbg !228 ; line:143 col:35
  %13 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !229 ; line:143 col:12
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !230, metadata !231), !dbg !229 ; var:"uvw" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !230, metadata !232), !dbg !229 ; var:"uvw" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %12, i64 0, metadata !230, metadata !233), !dbg !229 ; var:"uvw" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %14 = call %dx.types.ResRet.f32 @dx.op.sample.f32(i32 60, %dx.types.Handle %gTreeMapArray_texture_2darray, %dx.types.Handle %gsamAnisotropicWrap_sampler, float %2, float %3, float %12, float undef, i32 0, i32 0, i32 undef, float undef), !dbg !215 ; line:144 col:28  ; Sample(srv,sampler,coord0,coord1,coord2,coord3,offset0,offset1,offset2,clamp)
  %15 = extractvalue %dx.types.ResRet.f32 %14, 0, !dbg !215 ; line:144 col:28
  %16 = extractvalue %dx.types.ResRet.f32 %14, 1, !dbg !215 ; line:144 col:28
  %17 = extractvalue %dx.types.ResRet.f32 %14, 2, !dbg !215 ; line:144 col:28
  %18 = extractvalue %dx.types.ResRet.f32 %14, 3, !dbg !215 ; line:144 col:28
  %19 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 0), !dbg !234 ; line:144 col:77  ; CBufferLoadLegacy(handle,regIndex)
  %20 = extractvalue %dx.types.CBufRet.f32 %19, 0, !dbg !234 ; line:144 col:77
  %21 = extractvalue %dx.types.CBufRet.f32 %19, 1, !dbg !234 ; line:144 col:77
  %22 = extractvalue %dx.types.CBufRet.f32 %19, 2, !dbg !234 ; line:144 col:77
  %23 = extractvalue %dx.types.CBufRet.f32 %19, 3, !dbg !234 ; line:144 col:77
  %.i0 = fmul fast float %15, %20, !dbg !235 ; line:144 col:75
  %.i1 = fmul fast float %16, %21, !dbg !235 ; line:144 col:75
  %.i2 = fmul fast float %17, %22, !dbg !235 ; line:144 col:75
  %.i3 = fmul fast float %18, %23, !dbg !235 ; line:144 col:75
  %24 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !236 ; line:144 col:12
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !237, metadata !231), !dbg !236 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !237, metadata !232), !dbg !236 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !237, metadata !233), !dbg !236 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !237, metadata !238), !dbg !236 ; var:"diffuseAlbedo" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %25 = fsub fast float %.i3, 0x3FB99999A0000000, !dbg !239 ; line:147 col:23
  %26 = fcmp fast olt float %25, 0.000000e+00, !dbg !240 ; line:147 col:2
  call void @dx.op.discard(i32 82, i1 %26), !dbg !240 ; line:147 col:2  ; Discard(condition)
  %27 = call float @dx.op.dot3.f32(i32 55, float %4, float %5, float %6, float %4, float %5, float %6), !dbg !241 ; line:150 col:19  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt1 = call float @dx.op.unary.f32(i32 25, float %27), !dbg !241 ; line:150 col:19  ; Rsqrt(value)
  %.i06 = fmul fast float %4, %Rsqrt1, !dbg !241 ; line:150 col:19
  %.i17 = fmul fast float %5, %Rsqrt1, !dbg !241 ; line:150 col:19
  %.i28 = fmul fast float %6, %Rsqrt1, !dbg !241 ; line:150 col:19
  %28 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !242 ; line:150 col:17
  call void @llvm.dbg.value(metadata float %.i06, i64 0, metadata !216, metadata !220), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i17, i64 0, metadata !216, metadata !221), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 256, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i28, i64 0, metadata !216, metadata !222), !dbg !218 ; var:"pin" !DIExpression(DW_OP_bit_piece, 288, 32) func:"PS"
  %29 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 24), !dbg !243 ; line:152 col:21  ; CBufferLoadLegacy(handle,regIndex)
  %30 = extractvalue %dx.types.CBufRet.f32 %29, 0, !dbg !243 ; line:152 col:21
  %31 = extractvalue %dx.types.CBufRet.f32 %29, 1, !dbg !243 ; line:152 col:21
  %32 = extractvalue %dx.types.CBufRet.f32 %29, 2, !dbg !243 ; line:152 col:21
  %.i09 = fsub fast float %30, %7, !dbg !244 ; line:152 col:30
  %.i110 = fsub fast float %31, %8, !dbg !244 ; line:152 col:30
  %.i211 = fsub fast float %32, %9, !dbg !244 ; line:152 col:30
  %33 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !245 ; line:152 col:12
  call void @llvm.dbg.value(metadata float %.i09, i64 0, metadata !246, metadata !231), !dbg !245 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i110, i64 0, metadata !246, metadata !232), !dbg !245 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i211, i64 0, metadata !246, metadata !233), !dbg !245 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %34 = fmul fast float %.i09, %.i09, !dbg !247 ; line:153 col:23
  %35 = fmul fast float %.i110, %.i110, !dbg !247 ; line:153 col:23
  %36 = fadd fast float %34, %35, !dbg !247 ; line:153 col:23
  %37 = fmul fast float %.i211, %.i211, !dbg !247 ; line:153 col:23
  %38 = fadd fast float %36, %37, !dbg !247 ; line:153 col:23
  %Sqrt = call float @dx.op.unary.f32(i32 24, float %38), !dbg !247 ; line:153 col:23  ; Sqrt(value)
  %39 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !248 ; line:153 col:11
  call void @llvm.dbg.value(metadata float %Sqrt, i64 0, metadata !249, metadata !250), !dbg !248 ; var:"distToEye" !DIExpression() func:"PS"
  %.i012 = fdiv fast float %.i09, %Sqrt, !dbg !251 ; line:154 col:12
  %.i113 = fdiv fast float %.i110, %Sqrt, !dbg !251 ; line:154 col:12
  %.i214 = fdiv fast float %.i211, %Sqrt, !dbg !251 ; line:154 col:12
  %40 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !251 ; line:154 col:12
  call void @llvm.dbg.value(metadata float %.i012, i64 0, metadata !246, metadata !231), !dbg !245 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i113, i64 0, metadata !246, metadata !232), !dbg !245 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i214, i64 0, metadata !246, metadata !233), !dbg !245 ; var:"toEyeW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %41 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 27), !dbg !252 ; line:156 col:22  ; CBufferLoadLegacy(handle,regIndex)
  %42 = extractvalue %dx.types.CBufRet.f32 %41, 0, !dbg !252 ; line:156 col:22
  %43 = extractvalue %dx.types.CBufRet.f32 %41, 1, !dbg !252 ; line:156 col:22
  %44 = extractvalue %dx.types.CBufRet.f32 %41, 2, !dbg !252 ; line:156 col:22
  %.i015 = fmul fast float %42, %.i0, !dbg !253 ; line:156 col:36
  %.i116 = fmul fast float %43, %.i1, !dbg !253 ; line:156 col:36
  %.i217 = fmul fast float %44, %.i2, !dbg !253 ; line:156 col:36
  %45 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !254 ; line:156 col:12
  call void @llvm.dbg.value(metadata float %.i015, i64 0, metadata !255, metadata !231), !dbg !254 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i116, i64 0, metadata !255, metadata !232), !dbg !254 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i217, i64 0, metadata !255, metadata !233), !dbg !254 ; var:"ambient" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %46 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 1), !dbg !256 ; line:158 col:36  ; CBufferLoadLegacy(handle,regIndex)
  %47 = extractvalue %dx.types.CBufRet.f32 %46, 3, !dbg !256 ; line:158 col:36
  %48 = fsub fast float 1.000000e+00, %47, !dbg !257 ; line:158 col:34
  %49 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !258 ; line:158 col:17
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !259, metadata !250), !dbg !258 ; var:"shininess" !DIExpression() func:"PS"
  %50 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !260 ; line:159 col:20
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !261, metadata !231), !dbg !262 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !261, metadata !232), !dbg !262 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !261, metadata !233), !dbg !262 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !261, metadata !238), !dbg !262 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !263, metadata !231), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !263, metadata !232), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !263, metadata !233), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !263, metadata !238), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !266, metadata !231), !dbg !267 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !266, metadata !232), !dbg !267 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !266, metadata !233), !dbg !267 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !266, metadata !238), !dbg !267 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !273, metadata !231), !dbg !274 ; var:"mat" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !273, metadata !232), !dbg !274 ; var:"mat" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !273, metadata !233), !dbg !274 ; var:"mat" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !273, metadata !238), !dbg !274 ; var:"mat" !DIExpression(DW_OP_bit_piece, 96, 32) func:"ComputeDirectionalLight"
  %51 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 1), !dbg !275 ; line:159 col:37  ; CBufferLoadLegacy(handle,regIndex)
  %52 = extractvalue %dx.types.CBufRet.f32 %51, 0, !dbg !275 ; line:159 col:37
  call void @llvm.dbg.value(metadata float %52, i64 0, metadata !276, metadata !231), !dbg !277 ; var:"R0" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  %53 = extractvalue %dx.types.CBufRet.f32 %51, 1, !dbg !275 ; line:159 col:37
  call void @llvm.dbg.value(metadata float %53, i64 0, metadata !276, metadata !232), !dbg !277 ; var:"R0" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  %54 = extractvalue %dx.types.CBufRet.f32 %51, 2, !dbg !275 ; line:159 col:37
  call void @llvm.dbg.value(metadata float %54, i64 0, metadata !276, metadata !233), !dbg !277 ; var:"R0" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %55 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !260 ; line:159 col:20
  call void @llvm.dbg.value(metadata float %52, i64 0, metadata !261, metadata !223), !dbg !262 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %53, i64 0, metadata !261, metadata !224), !dbg !262 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %54, i64 0, metadata !261, metadata !225), !dbg !262 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %52, i64 0, metadata !263, metadata !223), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %53, i64 0, metadata !263, metadata !224), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %54, i64 0, metadata !263, metadata !225), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %52, i64 0, metadata !266, metadata !223), !dbg !267 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %53, i64 0, metadata !266, metadata !224), !dbg !267 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %54, i64 0, metadata !266, metadata !225), !dbg !267 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %52, i64 0, metadata !273, metadata !223), !dbg !274 ; var:"mat" !DIExpression(DW_OP_bit_piece, 128, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %53, i64 0, metadata !273, metadata !224), !dbg !274 ; var:"mat" !DIExpression(DW_OP_bit_piece, 160, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %54, i64 0, metadata !273, metadata !225), !dbg !274 ; var:"mat" !DIExpression(DW_OP_bit_piece, 192, 32) func:"ComputeDirectionalLight"
  %56 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !260 ; line:159 col:20
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !261, metadata !220), !dbg !262 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !263, metadata !220), !dbg !264 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !266, metadata !220), !dbg !267 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !273, metadata !220), !dbg !274 ; var:"mat" !DIExpression(DW_OP_bit_piece, 224, 32) func:"ComputeDirectionalLight"
  %57 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !279 ; line:160 col:12
  call void @llvm.dbg.value(metadata <3 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, i64 0, metadata !280, metadata !250), !dbg !279 ; var:"shadowFactor" !DIExpression() func:"PS"
  %58 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !281 ; line:161 col:26
  %59 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !281 ; line:161 col:26
  %60 = getelementptr inbounds [3 x float], [3 x float]* %10, i32 0, i32 0, !dbg !281 ; line:161 col:26
  store float 1.000000e+00, float* %60, align 4, !dbg !281 ; line:161 col:26
  %61 = getelementptr inbounds [3 x float], [3 x float]* %10, i32 0, i32 1, !dbg !281 ; line:161 col:26
  store float 1.000000e+00, float* %61, align 4, !dbg !281 ; line:161 col:26
  %62 = getelementptr inbounds [3 x float], [3 x float]* %10, i32 0, i32 2, !dbg !281 ; line:161 col:26
  store float 1.000000e+00, float* %62, align 4, !dbg !281 ; line:161 col:26
  call void @llvm.dbg.value(metadata float %.i012, i64 0, metadata !282, metadata !231), !dbg !283 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i113, i64 0, metadata !282, metadata !232), !dbg !283 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i214, i64 0, metadata !282, metadata !233), !dbg !283 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i06, i64 0, metadata !284, metadata !231), !dbg !285 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i17, i64 0, metadata !284, metadata !232), !dbg !285 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i28, i64 0, metadata !284, metadata !233), !dbg !285 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %63 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !286 ; line:145 col:12
  call void @llvm.dbg.value(metadata <3 x float> zeroinitializer, i64 0, metadata !287, metadata !250), !dbg !286 ; var:"result" !DIExpression() func:"ComputeLighting"
  %64 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:146 col:9
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !289, metadata !250), !dbg !288 ; var:"i" !DIExpression() func:"ComputeLighting"
  %65 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !290 ; line:149 col:11
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !289, metadata !250), !dbg !288 ; var:"i" !DIExpression() func:"ComputeLighting"
  br label %.lr.ph, !dbg !291 ; line:149 col:5

.lr.ph:                                           ; preds = %0
  br label %66, !dbg !291 ; line:149 col:5

; <label>:66                                      ; preds = %66, %.lr.ph
  %result.i.0.i0 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i019, %66 ]
  %result.i.0.i1 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i120, %66 ]
  %result.i.0.i2 = phi float [ 0.000000e+00, %.lr.ph ], [ %.i221, %66 ]
  %i.i.0 = phi i32 [ 0, %.lr.ph ], [ %115, %66 ]
  call void @llvm.dbg.value(metadata i32 %i.i.0, i64 0, metadata !289, metadata !250), !dbg !288 ; var:"i" !DIExpression() func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i0, i64 0, metadata !287, metadata !231), !dbg !286 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i1, i64 0, metadata !287, metadata !232), !dbg !286 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %result.i.0.i2, i64 0, metadata !287, metadata !233), !dbg !286 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %67 = getelementptr [3 x float], [3 x float]* %10, i32 0, i32 %i.i.0, !dbg !292 ; line:151 col:19
  %68 = load float, float* %67, !dbg !292 ; line:151 col:19
  %69 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:151 col:37
  %70 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:151 col:37
  %71 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:151 col:37
  call void @llvm.dbg.value(metadata float %.i012, i64 0, metadata !294, metadata !231), !dbg !295 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i113, i64 0, metadata !294, metadata !232), !dbg !295 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i214, i64 0, metadata !294, metadata !233), !dbg !295 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i06, i64 0, metadata !296, metadata !231), !dbg !297 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i17, i64 0, metadata !296, metadata !232), !dbg !297 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i28, i64 0, metadata !296, metadata !233), !dbg !297 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %72 = mul i32 %i.i.0, 3, !dbg !298 ; line:88 col:26
  %73 = add i32 28, %72, !dbg !298 ; line:88 col:26
  %74 = add i32 %73, 1, !dbg !298 ; line:88 col:26
  %75 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 %74), !dbg !298 ; line:88 col:26  ; CBufferLoadLegacy(handle,regIndex)
  %76 = extractvalue %dx.types.CBufRet.f32 %75, 0, !dbg !298 ; line:88 col:26
  %77 = extractvalue %dx.types.CBufRet.f32 %75, 1, !dbg !298 ; line:88 col:26
  %78 = extractvalue %dx.types.CBufRet.f32 %75, 2, !dbg !298 ; line:88 col:26
  %.i023 = fsub fast float -0.000000e+00, %76, !dbg !299 ; line:88 col:23
  %.i125 = fsub fast float -0.000000e+00, %77, !dbg !299 ; line:88 col:23
  %.i227 = fsub fast float -0.000000e+00, %78, !dbg !299 ; line:88 col:23
  %79 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !300 ; line:88 col:12
  call void @llvm.dbg.value(metadata float %.i023, i64 0, metadata !301, metadata !231), !dbg !300 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i125, i64 0, metadata !301, metadata !232), !dbg !300 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i227, i64 0, metadata !301, metadata !233), !dbg !300 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %80 = call float @dx.op.dot3.f32(i32 55, float %.i023, float %.i125, float %.i227, float %.i06, float %.i17, float %.i28), !dbg !302 ; line:91 col:23  ; Dot3(ax,ay,az,bx,by,bz)
  %FMax5 = call float @dx.op.binary.f32(i32 35, float %80, float 0.000000e+00), !dbg !303 ; line:91 col:19  ; FMax(a,b)
  %81 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !304 ; line:91 col:11
  call void @llvm.dbg.value(metadata float %FMax5, i64 0, metadata !305, metadata !250), !dbg !304 ; var:"ndotl" !DIExpression() func:"ComputeDirectionalLight"
  %82 = mul i32 %i.i.0, 3, !dbg !306 ; line:92 col:30
  %83 = add i32 28, %82, !dbg !306 ; line:92 col:30
  %84 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 %83), !dbg !306 ; line:92 col:30  ; CBufferLoadLegacy(handle,regIndex)
  %85 = extractvalue %dx.types.CBufRet.f32 %84, 0, !dbg !306 ; line:92 col:30
  %86 = extractvalue %dx.types.CBufRet.f32 %84, 1, !dbg !306 ; line:92 col:30
  %87 = extractvalue %dx.types.CBufRet.f32 %84, 2, !dbg !306 ; line:92 col:30
  %.i028 = fmul fast float %85, %FMax5, !dbg !307 ; line:92 col:39
  %.i129 = fmul fast float %86, %FMax5, !dbg !307 ; line:92 col:39
  %.i230 = fmul fast float %87, %FMax5, !dbg !307 ; line:92 col:39
  %88 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !308 ; line:92 col:12
  call void @llvm.dbg.value(metadata float %.i028, i64 0, metadata !309, metadata !231), !dbg !308 ; var:"lightStrenght" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i129, i64 0, metadata !309, metadata !232), !dbg !308 ; var:"lightStrenght" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeDirectionalLight"
  call void @llvm.dbg.value(metadata float %.i230, i64 0, metadata !309, metadata !233), !dbg !308 ; var:"lightStrenght" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeDirectionalLight"
  %89 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !310 ; line:94 col:12
  %90 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !310 ; line:94 col:12
  call void @llvm.dbg.value(metadata float %.i012, i64 0, metadata !311, metadata !231), !dbg !312 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i113, i64 0, metadata !311, metadata !232), !dbg !312 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i214, i64 0, metadata !311, metadata !233), !dbg !312 ; var:"toEye" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i06, i64 0, metadata !313, metadata !231), !dbg !314 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i17, i64 0, metadata !313, metadata !232), !dbg !314 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i28, i64 0, metadata !313, metadata !233), !dbg !314 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i023, i64 0, metadata !315, metadata !231), !dbg !316 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i125, i64 0, metadata !315, metadata !232), !dbg !316 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i227, i64 0, metadata !315, metadata !233), !dbg !316 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i028, i64 0, metadata !317, metadata !231), !dbg !318 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i129, i64 0, metadata !317, metadata !232), !dbg !318 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i230, i64 0, metadata !317, metadata !233), !dbg !318 ; var:"lightStrength" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %91 = fmul fast float %48, 2.560000e+02, !dbg !319 ; line:70 col:35
  %92 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !320 ; line:70 col:17
  call void @llvm.dbg.value(metadata float %91, i64 0, metadata !321, metadata !250), !dbg !320 ; var:"m" !DIExpression() func:"BlinnPhong"
  %.i031 = fadd fast float %.i012, %.i023, !dbg !322 ; line:71 col:38
  %.i132 = fadd fast float %.i113, %.i125, !dbg !322 ; line:71 col:38
  %.i233 = fadd fast float %.i214, %.i227, !dbg !322 ; line:71 col:38
  %93 = call float @dx.op.dot3.f32(i32 55, float %.i031, float %.i132, float %.i233, float %.i031, float %.i132, float %.i233), !dbg !323 ; line:71 col:22  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt = call float @dx.op.unary.f32(i32 25, float %93), !dbg !323 ; line:71 col:22  ; Rsqrt(value)
  %.i034 = fmul fast float %.i031, %Rsqrt, !dbg !323 ; line:71 col:22
  %.i135 = fmul fast float %.i132, %Rsqrt, !dbg !323 ; line:71 col:22
  %.i236 = fmul fast float %.i233, %Rsqrt, !dbg !323 ; line:71 col:22
  %94 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !324 ; line:71 col:12
  call void @llvm.dbg.value(metadata float %.i034, i64 0, metadata !325, metadata !231), !dbg !324 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i135, i64 0, metadata !325, metadata !232), !dbg !324 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i236, i64 0, metadata !325, metadata !233), !dbg !324 ; var:"halfVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %95 = fadd fast float %91, 8.000000e+00, !dbg !326 ; line:73 col:32
  %96 = call float @dx.op.dot3.f32(i32 55, float %.i034, float %.i135, float %.i236, float %.i06, float %.i17, float %.i28), !dbg !327 ; line:73 col:50  ; Dot3(ax,ay,az,bx,by,bz)
  %FMax = call float @dx.op.binary.f32(i32 35, float %96, float 0.000000e+00), !dbg !328 ; line:73 col:46  ; FMax(a,b)
  %Log3 = call float @dx.op.unary.f32(i32 23, float %FMax), !dbg !329 ; line:73 col:42  ; Log(value)
  %97 = fmul fast float %Log3, %91, !dbg !329 ; line:73 col:42
  %Exp4 = call float @dx.op.unary.f32(i32 21, float %97), !dbg !329 ; line:73 col:42  ; Exp(value)
  %98 = fmul fast float %95, %Exp4, !dbg !330 ; line:73 col:40
  %99 = fdiv fast float %98, 8.000000e+00, !dbg !331 ; line:73 col:82
  %100 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !332 ; line:73 col:11
  call void @llvm.dbg.value(metadata float %99, i64 0, metadata !333, metadata !250), !dbg !332 ; var:"roughnessFactor" !DIExpression() func:"BlinnPhong"
  %101 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !334 ; line:74 col:28
  call void @llvm.dbg.value(metadata float %.i023, i64 0, metadata !335, metadata !231), !dbg !336 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i125, i64 0, metadata !335, metadata !232), !dbg !336 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i227, i64 0, metadata !335, metadata !233), !dbg !336 ; var:"lightVec" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i034, i64 0, metadata !337, metadata !231), !dbg !338 ; var:"normal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i135, i64 0, metadata !337, metadata !232), !dbg !338 ; var:"normal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i236, i64 0, metadata !337, metadata !233), !dbg !338 ; var:"normal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %52, i64 0, metadata !276, metadata !231), !dbg !277 ; var:"R0" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %53, i64 0, metadata !276, metadata !232), !dbg !277 ; var:"R0" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %54, i64 0, metadata !276, metadata !233), !dbg !277 ; var:"R0" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %102 = call float @dx.op.dot3.f32(i32 55, float %.i034, float %.i135, float %.i236, float %.i023, float %.i125, float %.i227), !dbg !339 ; line:61 col:39  ; Dot3(ax,ay,az,bx,by,bz)
  %Saturate = call float @dx.op.unary.f32(i32 7, float %102), !dbg !340 ; line:61 col:30  ; Saturate(value)
  %103 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !341 ; line:61 col:11
  call void @llvm.dbg.value(metadata float %Saturate, i64 0, metadata !342, metadata !250), !dbg !341 ; var:"cosIncidentAngle" !DIExpression() func:"SchlickFresnel"
  %104 = fsub fast float 1.000000e+00, %Saturate, !dbg !343 ; line:62 col:21
  %105 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !344 ; line:62 col:11
  call void @llvm.dbg.value(metadata float %104, i64 0, metadata !345, metadata !250), !dbg !344 ; var:"f0" !DIExpression() func:"SchlickFresnel"
  %.i038 = fsub fast float 1.000000e+00, %52, !dbg !346 ; line:63 col:40
  %.i140 = fsub fast float 1.000000e+00, %53, !dbg !346 ; line:63 col:40
  %.i242 = fsub fast float 1.000000e+00, %54, !dbg !346 ; line:63 col:40
  %Log = call float @dx.op.unary.f32(i32 23, float %104), !dbg !347 ; line:63 col:48  ; Log(value)
  %106 = fmul fast float %Log, 5.000000e+00, !dbg !347 ; line:63 col:48
  %Exp = call float @dx.op.unary.f32(i32 21, float %106), !dbg !347 ; line:63 col:48  ; Exp(value)
  %.i043 = fmul fast float %.i038, %Exp, !dbg !348 ; line:63 col:46
  %.i144 = fmul fast float %.i140, %Exp, !dbg !348 ; line:63 col:46
  %.i245 = fmul fast float %.i242, %Exp, !dbg !348 ; line:63 col:46
  %.i046 = fadd fast float %52, %.i043, !dbg !349 ; line:63 col:32
  %.i147 = fadd fast float %53, %.i144, !dbg !349 ; line:63 col:32
  %.i248 = fadd fast float %54, %.i245, !dbg !349 ; line:63 col:32
  %107 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !350 ; line:63 col:12
  call void @llvm.dbg.value(metadata float %.i046, i64 0, metadata !351, metadata !231), !dbg !350 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i147, i64 0, metadata !351, metadata !232), !dbg !350 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SchlickFresnel"
  call void @llvm.dbg.value(metadata float %.i248, i64 0, metadata !351, metadata !233), !dbg !350 ; var:"reflectPercent" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SchlickFresnel"
  %108 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !352 ; line:65 col:5
  %109 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !353 ; line:74 col:12
  call void @llvm.dbg.value(metadata float %.i046, i64 0, metadata !354, metadata !231), !dbg !353 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i147, i64 0, metadata !354, metadata !232), !dbg !353 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i248, i64 0, metadata !354, metadata !233), !dbg !353 ; var:"fresnelFactor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i049 = fmul fast float %.i046, %99, !dbg !355 ; line:76 col:39
  %.i150 = fmul fast float %.i147, %99, !dbg !355 ; line:76 col:39
  %.i251 = fmul fast float %.i248, %99, !dbg !355 ; line:76 col:39
  %110 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !356 ; line:76 col:12
  call void @llvm.dbg.value(metadata float %.i049, i64 0, metadata !357, metadata !231), !dbg !356 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i150, i64 0, metadata !357, metadata !232), !dbg !356 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i251, i64 0, metadata !357, metadata !233), !dbg !356 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i053 = fadd fast float %.i049, 1.000000e+00, !dbg !358 ; line:80 col:43
  %.i155 = fadd fast float %.i150, 1.000000e+00, !dbg !358 ; line:80 col:43
  %.i257 = fadd fast float %.i251, 1.000000e+00, !dbg !358 ; line:80 col:43
  %.i058 = fdiv fast float %.i049, %.i053, !dbg !359 ; line:80 col:29
  %.i159 = fdiv fast float %.i150, %.i155, !dbg !359 ; line:80 col:29
  %.i260 = fdiv fast float %.i251, %.i257, !dbg !359 ; line:80 col:29
  %111 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !360 ; line:80 col:16
  call void @llvm.dbg.value(metadata float %.i058, i64 0, metadata !357, metadata !231), !dbg !356 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 0, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i159, i64 0, metadata !357, metadata !232), !dbg !356 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 32, 32) func:"BlinnPhong"
  call void @llvm.dbg.value(metadata float %.i260, i64 0, metadata !357, metadata !233), !dbg !356 ; var:"specAlbedo" !DIExpression(DW_OP_bit_piece, 64, 32) func:"BlinnPhong"
  %.i061 = fadd fast float %.i0, %.i058, !dbg !361 ; line:82 col:35
  %.i162 = fadd fast float %.i1, %.i159, !dbg !361 ; line:82 col:35
  %.i263 = fadd fast float %.i2, %.i260, !dbg !361 ; line:82 col:35
  %.i064 = fmul fast float %.i061, %.i028, !dbg !362 ; line:82 col:49
  %.i165 = fmul fast float %.i162, %.i129, !dbg !362 ; line:82 col:49
  %.i266 = fmul fast float %.i263, %.i230, !dbg !362 ; line:82 col:49
  %112 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !363 ; line:82 col:5
  %113 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !364 ; line:94 col:5
  %.i067 = fmul fast float %68, %.i064, !dbg !365 ; line:151 col:35
  %.i168 = fmul fast float %68, %.i165, !dbg !365 ; line:151 col:35
  %.i269 = fmul fast float %68, %.i266, !dbg !365 ; line:151 col:35
  %.i019 = fadd fast float %result.i.0.i0, %.i067, !dbg !366 ; line:151 col:16
  %.i120 = fadd fast float %result.i.0.i1, %.i168, !dbg !366 ; line:151 col:16
  %.i221 = fadd fast float %result.i.0.i2, %.i269, !dbg !366 ; line:151 col:16
  %114 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !366 ; line:151 col:16
  call void @llvm.dbg.value(metadata float %.i019, i64 0, metadata !287, metadata !231), !dbg !286 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i120, i64 0, metadata !287, metadata !232), !dbg !286 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i221, i64 0, metadata !287, metadata !233), !dbg !286 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %115 = add nsw i32 %i.i.0, 1, !dbg !367 ; line:149 col:36
  %116 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !367 ; line:149 col:36
  call void @llvm.dbg.value(metadata i32 %115, i64 0, metadata !289, metadata !250), !dbg !288 ; var:"i" !DIExpression() func:"ComputeLighting"
  %117 = icmp slt i32 %115, 3, !dbg !368 ; line:149 col:18
  br i1 %117, label %66, label %".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge", !dbg !291 ; line:149 col:5

".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge": ; preds = %66
  br label %"\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit", !dbg !291 ; line:149 col:5

"\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit": ; preds = %".\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z.exit_crit_edge"
  call void @llvm.dbg.value(metadata float %.i019, i64 0, metadata !287, metadata !231), !dbg !286 ; var:"result" !DIExpression(DW_OP_bit_piece, 0, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i120, i64 0, metadata !287, metadata !232), !dbg !286 ; var:"result" !DIExpression(DW_OP_bit_piece, 32, 32) func:"ComputeLighting"
  call void @llvm.dbg.value(metadata float %.i221, i64 0, metadata !287, metadata !233), !dbg !286 ; var:"result" !DIExpression(DW_OP_bit_piece, 64, 32) func:"ComputeLighting"
  %118 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !369 ; line:169 col:5
  %119 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !370 ; line:161 col:12
  call void @llvm.dbg.value(metadata float %.i019, i64 0, metadata !371, metadata !231), !dbg !370 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i120, i64 0, metadata !371, metadata !232), !dbg !370 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i221, i64 0, metadata !371, metadata !233), !dbg !370 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !371, metadata !238), !dbg !370 ; var:"directLight" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %.i073 = fadd fast float %.i015, %.i019, !dbg !372 ; line:164 col:31
  %.i174 = fadd fast float %.i116, %.i120, !dbg !372 ; line:164 col:31
  %.i275 = fadd fast float %.i217, %.i221, !dbg !372 ; line:164 col:31
  %120 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !373 ; line:164 col:12
  call void @llvm.dbg.value(metadata float %.i073, i64 0, metadata !374, metadata !231), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i174, i64 0, metadata !374, metadata !232), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i275, i64 0, metadata !374, metadata !233), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %121 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 77), !dbg !375 ; line:167 col:42  ; CBufferLoadLegacy(handle,regIndex)
  %122 = extractvalue %dx.types.CBufRet.f32 %121, 0, !dbg !375 ; line:167 col:42
  %123 = fsub fast float %Sqrt, %122, !dbg !376 ; line:167 col:40
  %124 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 77), !dbg !377 ; line:167 col:55  ; CBufferLoadLegacy(handle,regIndex)
  %125 = extractvalue %dx.types.CBufRet.f32 %124, 1, !dbg !377 ; line:167 col:55
  %126 = fdiv fast float %123, %125, !dbg !378 ; line:167 col:53
  %Saturate2 = call float @dx.op.unary.f32(i32 7, float %126), !dbg !379 ; line:167 col:20  ; Saturate(value)
  %127 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !380 ; line:167 col:8
  call void @llvm.dbg.value(metadata float %Saturate2, i64 0, metadata !381, metadata !250), !dbg !380 ; var:"fogAmount" !DIExpression() func:"PS"
  %128 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 76), !dbg !382 ; line:168 col:28  ; CBufferLoadLegacy(handle,regIndex)
  %129 = extractvalue %dx.types.CBufRet.f32 %128, 0, !dbg !382 ; line:168 col:28
  %130 = extractvalue %dx.types.CBufRet.f32 %128, 1, !dbg !382 ; line:168 col:28
  %131 = extractvalue %dx.types.CBufRet.f32 %128, 2, !dbg !382 ; line:168 col:28
  %.i077 = fsub fast float %129, %.i073, !dbg !383 ; line:168 col:13
  %.i178 = fsub fast float %130, %.i174, !dbg !383 ; line:168 col:13
  %.i279 = fsub fast float %131, %.i275, !dbg !383 ; line:168 col:13
  %.i081 = fmul fast float %Saturate2, %.i077, !dbg !383 ; line:168 col:13
  %.i182 = fmul fast float %Saturate2, %.i178, !dbg !383 ; line:168 col:13
  %.i283 = fmul fast float %Saturate2, %.i279, !dbg !383 ; line:168 col:13
  %.i085 = fadd fast float %.i073, %.i081, !dbg !383 ; line:168 col:13
  %.i186 = fadd fast float %.i174, %.i182, !dbg !383 ; line:168 col:13
  %.i287 = fadd fast float %.i275, %.i283, !dbg !383 ; line:168 col:13
  %132 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !384 ; line:168 col:11
  call void @llvm.dbg.value(metadata float %.i085, i64 0, metadata !374, metadata !231), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i186, i64 0, metadata !374, metadata !232), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i287, i64 0, metadata !374, metadata !233), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  %133 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !385 ; line:171 col:16
  call void @llvm.dbg.value(metadata float %.i085, i64 0, metadata !374, metadata !231), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 0, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i186, i64 0, metadata !374, metadata !232), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 32, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i287, i64 0, metadata !374, metadata !233), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 64, 32) func:"PS"
  call void @llvm.dbg.value(metadata float %.i3, i64 0, metadata !374, metadata !238), !dbg !373 ; var:"litColor" !DIExpression(DW_OP_bit_piece, 96, 32) func:"PS"
  %134 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !386 ; line:173 col:5
  call void @llvm.dbg.declare(metadata [3 x float]* %10, metadata !387, metadata !250), !dbg !388 ; var:"shadowFactor" !DIExpression() func:"ComputeLighting"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %.i085), !dbg !386 ; line:173 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %.i186), !dbg !386 ; line:173 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %.i287), !dbg !386 ; line:173 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %.i3), !dbg !386 ; line:173 col:5  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  ret void, !dbg !386 ; line:173 col:5
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
!llvm.module.flags = !{!140, !141}
!llvm.ident = !{!142}
!dx.source.contents = !{!143, !144}
!dx.source.defines = !{!145}
!dx.source.mainFileName = !{!146}
!dx.source.args = !{!147}
!dx.version = !{!148}
!dx.valver = !{!149}
!dx.shaderModel = !{!150}
!dx.resources = !{!151}
!dx.typeAnnotations = !{!160, !195}
!dx.viewIdState = !{!198}
!dx.entryPoints = !{!199}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !24, globals: !73)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CTreeBillboard.hlsl", directory: "")
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
!24 = !{!25, !44, !64, !67, !70}
!25 = !DISubprogram(name: "PS", scope: !1, file: !1, line: 141, type: !26, isLocal: false, isDefinition: true, scopeLine: 142, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @PS)
!26 = !DISubroutineType(types: !27)
!27 = !{!15, !28}
!28 = !DICompositeType(tag: DW_TAG_structure_type, name: "GeoOut", file: !1, line: 76, size: 416, align: 32, elements: !29)
!29 = !{!30, !31, !32, !33, !41}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !28, file: !1, line: 78, baseType: !15, size: 128, align: 32)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !28, file: !1, line: 79, baseType: !4, size: 96, align: 32, offset: 128)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !28, file: !1, line: 80, baseType: !4, size: 96, align: 32, offset: 224)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !28, file: !1, line: 81, baseType: !34, size: 64, align: 32, offset: 320)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 48, baseType: !35)
!35 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 48, size: 64, align: 32, elements: !36, templateParams: !39)
!36 = !{!37, !38}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !35, file: !1, line: 48, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !35, file: !1, line: 48, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!39 = !{!12, !40}
!40 = !DITemplateValueParameter(name: "element_count", type: !14, value: i32 2)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "PrimID", scope: !28, file: !1, line: 82, baseType: !42, size: 32, align: 32, offset: 384)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 61, baseType: !43)
!43 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!44 = !DISubprogram(name: "ComputeLighting", linkageName: "\01?ComputeLighting@@YA?AV?$vector@M$03@@Y0BA@ULight@@UMaterial@@V?$vector@M$02@@222@Z", scope: !45, file: !45, line: 143, type: !46, isLocal: false, isDefinition: true, scopeLine: 144, flags: DIFlagPrototyped, isOptimized: false)
!45 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!46 = !DISubroutineType(types: !47)
!47 = !{!15, !48, !59, !4, !4, !4, !4}
!48 = !DICompositeType(tag: DW_TAG_array_type, baseType: !49, size: 6144, align: 32, elements: !57)
!49 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !45, line: 3, size: 384, align: 32, elements: !50)
!50 = !{!51, !52, !53, !54, !55, !56}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !49, file: !45, line: 5, baseType: !4, size: 96, align: 32)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !49, file: !45, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !49, file: !45, line: 7, baseType: !4, size: 96, align: 32, offset: 128)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !49, file: !45, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !49, file: !45, line: 9, baseType: !4, size: 96, align: 32, offset: 256)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !49, file: !45, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!57 = !{!58}
!58 = !DISubrange(count: 16)
!59 = !DICompositeType(tag: DW_TAG_structure_type, name: "Material", file: !45, line: 13, size: 256, align: 32, elements: !60)
!60 = !{!61, !62, !63}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "DiffuseAlbedo", scope: !59, file: !45, line: 15, baseType: !15, size: 128, align: 32)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "FresnelR0", scope: !59, file: !45, line: 16, baseType: !4, size: 96, align: 32, offset: 128)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "Shininess", scope: !59, file: !45, line: 17, baseType: !8, size: 32, align: 32, offset: 224)
!64 = !DISubprogram(name: "ComputeDirectionalLight", linkageName: "\01?ComputeDirectionalLight@@YA?AV?$vector@M$02@@ULight@@UMaterial@@V1@2@Z", scope: !45, file: !45, line: 85, type: !65, isLocal: false, isDefinition: true, scopeLine: 86, flags: DIFlagPrototyped, isOptimized: false)
!65 = !DISubroutineType(types: !66)
!66 = !{!4, !49, !59, !4, !4}
!67 = !DISubprogram(name: "BlinnPhong", linkageName: "\01?BlinnPhong@@YA?AV?$vector@M$02@@V1@000UMaterial@@@Z", scope: !45, file: !45, line: 68, type: !68, isLocal: false, isDefinition: true, scopeLine: 69, flags: DIFlagPrototyped, isOptimized: false)
!68 = !DISubroutineType(types: !69)
!69 = !{!4, !4, !4, !4, !4, !59}
!70 = !DISubprogram(name: "SchlickFresnel", linkageName: "\01?SchlickFresnel@@YA?AV?$vector@M$02@@V1@00@Z", scope: !45, file: !45, line: 59, type: !71, isLocal: false, isDefinition: true, scopeLine: 60, flags: DIFlagPrototyped, isOptimized: false)
!71 = !DISubroutineType(types: !72)
!72 = !{!4, !4, !4, !4}
!73 = !{!74, !98, !99, !101, !103, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !116, !117, !118, !119, !120, !121, !122, !125, !126, !127, !128, !129, !133, !135, !136, !137, !138, !139}
!74 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 26, type: !75, isLocal: false, isDefinition: true)
!75 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !76)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 26, baseType: !77)
!77 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 26, size: 512, align: 32, elements: !78, templateParams: !95)
!78 = !{!79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !77, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!95 = !{!12, !96, !97}
!96 = !DITemplateValueParameter(name: "row_count", type: !14, value: i32 4)
!97 = !DITemplateValueParameter(name: "col_count", type: !14, value: i32 4)
!98 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 27, type: !75, isLocal: false, isDefinition: true)
!99 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 32, type: !100, isLocal: false, isDefinition: true)
!100 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!101 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 33, type: !102, isLocal: false, isDefinition: true)
!102 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!103 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 34, type: !104, isLocal: false, isDefinition: true)
!104 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!105 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 35, type: !75, isLocal: false, isDefinition: true)
!106 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 40, type: !75, isLocal: false, isDefinition: true)
!107 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 41, type: !75, isLocal: false, isDefinition: true)
!108 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !75, isLocal: false, isDefinition: true)
!109 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 43, type: !75, isLocal: false, isDefinition: true)
!110 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 44, type: !75, isLocal: false, isDefinition: true)
!111 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 45, type: !75, isLocal: false, isDefinition: true)
!112 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 46, type: !102, isLocal: false, isDefinition: true)
!113 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPass@@3MB", scope: !0, file: !1, line: 47, type: !104, isLocal: false, isDefinition: true)
!114 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 48, type: !115, isLocal: false, isDefinition: true)
!115 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!116 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 49, type: !115, isLocal: false, isDefinition: true)
!117 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 50, type: !104, isLocal: false, isDefinition: true)
!118 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 51, type: !104, isLocal: false, isDefinition: true)
!119 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 52, type: !104, isLocal: false, isDefinition: true)
!120 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 53, type: !104, isLocal: false, isDefinition: true)
!121 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 54, type: !100, isLocal: false, isDefinition: true)
!122 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 56, type: !123, isLocal: false, isDefinition: true)
!123 = !DICompositeType(tag: DW_TAG_array_type, baseType: !124, size: 6144, align: 32, elements: !57)
!124 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !49)
!125 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 58, type: !100, isLocal: false, isDefinition: true)
!126 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 59, type: !104, isLocal: false, isDefinition: true)
!127 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 60, type: !104, isLocal: false, isDefinition: true)
!128 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 61, type: !115, isLocal: false, isDefinition: true)
!129 = !DIGlobalVariable(name: "gTreeMapArray", linkageName: "\01?gTreeMapArray@@3V?$Texture2DArray@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 15, type: !130, isLocal: false, isDefinition: true)
!130 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2DArray<vector<float, 4> >", file: !1, line: 15, size: 160, align: 32, elements: !2, templateParams: !131)
!131 = !{!132}
!132 = !DITemplateTypeParameter(name: "element", type: !16)
!133 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 17, type: !134, isLocal: false, isDefinition: true)
!134 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 17, size: 32, align: 32, elements: !2)
!135 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 18, type: !134, isLocal: false, isDefinition: true)
!136 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 19, type: !134, isLocal: false, isDefinition: true)
!137 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 20, type: !134, isLocal: false, isDefinition: true)
!138 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !134, isLocal: false, isDefinition: true)
!139 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !134, isLocal: false, isDefinition: true)
!140 = !{i32 2, !"Dwarf Version", i32 4}
!141 = !{i32 2, !"Debug Info Version", i32 3}
!142 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!143 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CTreeBillboard.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2DArray gTreeMapArray : register(t0);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerObjectPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float2 SizeW : SIZE;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float3 CenterW : POSITION;\0D\0A    float2 SizeW : SIZE;\0D\0A};\0D\0A\0D\0Astruct GeoOut\0D\0A{\0D\0A    float4 PosH : SV_POSITION;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A    uint PrimID : SV_PrimitiveID;\0D\0A};\0D\0A\0D\0A//\B1\D7\B3\C9 \C6\D0\BD\BA\BD\BA\B7\E7 \BC\CE\C0\CC\B4\F5.\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout;\0D\0A    \0D\0A    vout.CenterW = vin.PosW;\0D\0A    vout.SizeW = vin.SizeW;\0D\0A\0D\0A    return vout;\0D\0A}\0D\0A \0D\0A//\C1\A1(CenterW)\B8\A6 \BB\E7\B0\A2\C7\FC(\C1\A1 4\B0\B3)\C0\B8\B7\CE \C8\AE\C0\E5.\0D\0A[maxvertexcount(4)]\0D\0Avoid GS(point VertexOut gin[1],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A\09//\C0\D3\BD\C3 \B7\CE\C4\C3 \C1\C2\C7\A5\B0\E8 -> \BF\F9\B5\E5 \C1\C2\C7\A5\B0\E8\0D\0A    //\BA\F4\BA\B8\B5\E5\B4\C2 y\C3\E0\BF\A1 \C1\A4\B7\C4\B5\C7\B0\ED \BD\C3\BC\B1\C0\BB \C7\E2\C7\D4\0D\0A    float3 up = float3(0.0f, 1.0f, 0.0f);\0D\0A    float3 look = gEyePosW - gin[0].CenterW;\0D\0A    look.y = 0.0f; //project to xz-plane\0D\0A    look = normalize(look);\0D\0A    float3 right = cross(up, look);\0D\0A\0D\0A    float halfWidth = 0.5f * gin[0].SizeW.x;\0D\0A    float halfHeight = 0.5f * gin[0].SizeW.y;\0D\0A\09\0D\0A    float4 v[4];\0D\0A    v[0] = float4(gin[0].CenterW + halfWidth * right - halfHeight * up, 1.0f);\0D\0A    v[1] = float4(gin[0].CenterW + halfWidth * right + halfHeight * up, 1.0f);\0D\0A    v[2] = float4(gin[0].CenterW - halfWidth * right - halfHeight * up, 1.0f);\0D\0A    v[3] = float4(gin[0].CenterW - halfWidth * right + halfHeight * up, 1.0f);\0D\0A    \0D\0A    float2 texC[4] =\0D\0A    {\0D\0A        float2(0.0f, 1.0f),\0D\0A\09\09float2(0.0f, 0.0f),\0D\0A\09\09float2(1.0f, 1.0f),\0D\0A\09\09float2(1.0f, 0.0f)\0D\0A    };\0D\0A\09\0D\0A    GeoOut gout;\0D\0A\09[unroll]\0D\0A    for (int i = 0; i < 4; ++i)\0D\0A    {\0D\0A        gout.PosH = mul(v[i], gViewProj);\0D\0A        gout.PosW = v[i].xyz;\0D\0A        gout.NormalW = look;\0D\0A        gout.TexC = texC[i];\0D\0A        gout.PrimID = primID;\0D\0A\09\09\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A}\0D\0A\0D\0Afloat4 PS(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 uvw = float3(pin.TexC, pin.PrimID % 3);\0D\0A    float4 diffuseAlbedo = gTreeMapArray.Sample(gsamAnisotropicWrap, uvw) * gDiffuseAlbedo;\0D\0A\09\0D\0A#ifdef ALPHA_TEST\0D\0A\09clip(diffuseAlbedo.a - 0.1f);\0D\0A#endif\0D\0A    \0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A    \0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; // normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A#ifdef FOG\0D\0A\09float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A\09litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A    \0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A\0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_Wireframe(GeoOut pin) : SV_Target\0D\0A{\0D\0A    return float4(1.0f, 1.0f, 1.0f, 1.0f);\0D\0A}"}
!144 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0\E3\84\B4.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrenght = L.Strength * ndotl;\0D\0A    \0D\0A    return BlinnPhong(lightStrenght, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!145 = !{!"FOG=1", !"ALPHA_TEST=1", !"FOG=1", !"ALPHA_TEST=1"}
!146 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CTreeBillboard.hlsl"}
!147 = !{!"-E", !"PS", !"-T", !"ps_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-D", !"FOG=1", !"-D", !"ALPHA_TEST=1", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CCompiled\5CTreeBillboardPS.cso", !"-D", !"FOG=1", !"-D", !"ALPHA_TEST=1"}
!148 = !{i32 1, i32 0}
!149 = !{i32 1, i32 8}
!150 = !{!"ps", i32 6, i32 0}
!151 = !{!152, null, !155, !158}
!152 = !{!153}
!153 = !{i32 0, %"class.Texture2DArray<vector<float, 4> >"* undef, !"gTreeMapArray", i32 0, i32 0, i32 1, i32 7, i32 0, !154}
!154 = !{i32 0, i32 9}
!155 = !{!156, !157}
!156 = !{i32 0, %hostlayout.cbMaterial* undef, !"cbMaterial", i32 0, i32 1, i32 1, i32 96, null}
!157 = !{i32 1, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!158 = !{!159}
!159 = !{i32 0, %struct.SamplerState* undef, !"gsamAnisotropicWrap", i32 0, i32 4, i32 1, i32 0, null}
!160 = !{i32 0, %struct.Light undef, !161, %hostlayout.cbMaterial undef, !168, %hostlayout.cbPass undef, !174}
!161 = !{i32 48, !162, !163, !164, !165, !166, !167}
!162 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!163 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!164 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!165 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!166 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!167 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!168 = !{i32 96, !169, !170, !171, !172}
!169 = !{i32 6, !"gDiffuseAlbedo", i32 3, i32 0, i32 7, i32 9}
!170 = !{i32 6, !"gFresnelR0", i32 3, i32 16, i32 7, i32 9}
!171 = !{i32 6, !"gRoughness", i32 3, i32 28, i32 7, i32 9}
!172 = !{i32 6, !"gMatTransform", i32 2, !173, i32 3, i32 32, i32 7, i32 9}
!173 = !{i32 4, i32 4, i32 2}
!174 = !{i32 1248, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194}
!175 = !{i32 6, !"gView", i32 2, !173, i32 3, i32 0, i32 7, i32 9}
!176 = !{i32 6, !"gInvView", i32 2, !173, i32 3, i32 64, i32 7, i32 9}
!177 = !{i32 6, !"gProj", i32 2, !173, i32 3, i32 128, i32 7, i32 9}
!178 = !{i32 6, !"gInvProj", i32 2, !173, i32 3, i32 192, i32 7, i32 9}
!179 = !{i32 6, !"gViewProj", i32 2, !173, i32 3, i32 256, i32 7, i32 9}
!180 = !{i32 6, !"gInvViewProj", i32 2, !173, i32 3, i32 320, i32 7, i32 9}
!181 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!182 = !{i32 6, !"cbPerObjectPad1", i32 3, i32 396, i32 7, i32 9}
!183 = !{i32 6, !"gRenderTargetSize", i32 3, i32 400, i32 7, i32 9}
!184 = !{i32 6, !"gInvRenderTargetSize", i32 3, i32 408, i32 7, i32 9}
!185 = !{i32 6, !"gNearZ", i32 3, i32 416, i32 7, i32 9}
!186 = !{i32 6, !"gFarZ", i32 3, i32 420, i32 7, i32 9}
!187 = !{i32 6, !"gTotalTime", i32 3, i32 424, i32 7, i32 9}
!188 = !{i32 6, !"gDeltaTime", i32 3, i32 428, i32 7, i32 9}
!189 = !{i32 6, !"gAmbientLight", i32 3, i32 432, i32 7, i32 9}
!190 = !{i32 6, !"gLights", i32 3, i32 448}
!191 = !{i32 6, !"gFogColor", i32 3, i32 1216, i32 7, i32 9}
!192 = !{i32 6, !"gFogStart", i32 3, i32 1232, i32 7, i32 9}
!193 = !{i32 6, !"gFogRange", i32 3, i32 1236, i32 7, i32 9}
!194 = !{i32 6, !"cbPerObjectPad2", i32 3, i32 1240, i32 7, i32 9}
!195 = !{i32 1, void ()* @PS, !196}
!196 = !{!197}
!197 = !{i32 0, !2, !2}
!198 = !{[19 x i32] [i32 17, i32 4, i32 0, i32 0, i32 0, i32 0, i32 7, i32 7, i32 7, i32 0, i32 7, i32 7, i32 7, i32 0, i32 15, i32 15, i32 0, i32 0, i32 15]}
!199 = !{void ()* @PS, !"PS", !200, !151, !214}
!200 = !{!201, !211, null}
!201 = !{!202, !204, !206, !207, !209}
!202 = !{i32 0, !"SV_Position", i8 9, i8 3, !203, i8 4, i32 1, i8 4, i32 0, i8 0, null}
!203 = !{i32 0}
!204 = !{i32 1, !"POSITION", i8 9, i8 0, !203, i8 2, i32 1, i8 3, i32 1, i8 0, !205}
!205 = !{i32 3, i32 7}
!206 = !{i32 2, !"NORMAL", i8 9, i8 0, !203, i8 2, i32 1, i8 3, i32 2, i8 0, !205}
!207 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !203, i8 2, i32 1, i8 2, i32 3, i8 0, !208}
!208 = !{i32 3, i32 3}
!209 = !{i32 4, !"SV_PrimitiveID", i8 5, i8 10, !203, i8 1, i32 1, i8 1, i32 4, i8 0, !210}
!210 = !{i32 3, i32 1}
!211 = !{!212}
!212 = !{i32 0, !"SV_Target", i8 9, i8 16, !203, i8 0, i32 1, i8 4, i32 0, i8 0, !213}
!213 = !{i32 3, i32 15}
!214 = !{i32 0, i64 1}
!215 = !DILocation(line: 144, column: 28, scope: !25)
!216 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "pin", arg: 1, scope: !25, file: !1, line: 141, type: !28)
!217 = !DIExpression(DW_OP_bit_piece, 320, 32)
!218 = !DILocation(line: 141, column: 18, scope: !25)
!219 = !DIExpression(DW_OP_bit_piece, 352, 32)
!220 = !DIExpression(DW_OP_bit_piece, 224, 32)
!221 = !DIExpression(DW_OP_bit_piece, 256, 32)
!222 = !DIExpression(DW_OP_bit_piece, 288, 32)
!223 = !DIExpression(DW_OP_bit_piece, 128, 32)
!224 = !DIExpression(DW_OP_bit_piece, 160, 32)
!225 = !DIExpression(DW_OP_bit_piece, 192, 32)
!226 = !DIExpression(DW_OP_bit_piece, 384, 32)
!227 = !DILocation(line: 143, column: 46, scope: !25)
!228 = !DILocation(line: 143, column: 35, scope: !25)
!229 = !DILocation(line: 143, column: 12, scope: !25)
!230 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "uvw", scope: !25, file: !1, line: 143, type: !4)
!231 = !DIExpression(DW_OP_bit_piece, 0, 32)
!232 = !DIExpression(DW_OP_bit_piece, 32, 32)
!233 = !DIExpression(DW_OP_bit_piece, 64, 32)
!234 = !DILocation(line: 144, column: 77, scope: !25)
!235 = !DILocation(line: 144, column: 75, scope: !25)
!236 = !DILocation(line: 144, column: 12, scope: !25)
!237 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "diffuseAlbedo", scope: !25, file: !1, line: 144, type: !15)
!238 = !DIExpression(DW_OP_bit_piece, 96, 32)
!239 = !DILocation(line: 147, column: 23, scope: !25)
!240 = !DILocation(line: 147, column: 2, scope: !25)
!241 = !DILocation(line: 150, column: 19, scope: !25)
!242 = !DILocation(line: 150, column: 17, scope: !25)
!243 = !DILocation(line: 152, column: 21, scope: !25)
!244 = !DILocation(line: 152, column: 30, scope: !25)
!245 = !DILocation(line: 152, column: 12, scope: !25)
!246 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "toEyeW", scope: !25, file: !1, line: 152, type: !4)
!247 = !DILocation(line: 153, column: 23, scope: !25)
!248 = !DILocation(line: 153, column: 11, scope: !25)
!249 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "distToEye", scope: !25, file: !1, line: 153, type: !8)
!250 = !DIExpression()
!251 = !DILocation(line: 154, column: 12, scope: !25)
!252 = !DILocation(line: 156, column: 22, scope: !25)
!253 = !DILocation(line: 156, column: 36, scope: !25)
!254 = !DILocation(line: 156, column: 12, scope: !25)
!255 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "ambient", scope: !25, file: !1, line: 156, type: !15)
!256 = !DILocation(line: 158, column: 36, scope: !25)
!257 = !DILocation(line: 158, column: 34, scope: !25)
!258 = !DILocation(line: 158, column: 17, scope: !25)
!259 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "shininess", scope: !25, file: !1, line: 158, type: !104)
!260 = !DILocation(line: 159, column: 20, scope: !25)
!261 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "mat", scope: !25, file: !1, line: 159, type: !59)
!262 = !DILocation(line: 159, column: 14, scope: !25)
!263 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 2, scope: !44, file: !45, line: 143, type: !59)
!264 = !DILocation(line: 143, column: 59, scope: !44, inlinedAt: !265)
!265 = distinct !DILocation(line: 161, column: 26, scope: !25)
!266 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 5, scope: !67, file: !45, line: 68, type: !59)
!267 = !DILocation(line: 68, column: 96, scope: !67, inlinedAt: !268)
!268 = distinct !DILocation(line: 94, column: 12, scope: !64, inlinedAt: !269)
!269 = distinct !DILocation(line: 151, column: 37, scope: !270, inlinedAt: !265)
!270 = distinct !DILexicalBlock(scope: !271, file: !45, line: 150, column: 5)
!271 = distinct !DILexicalBlock(scope: !272, file: !45, line: 149, column: 5)
!272 = distinct !DILexicalBlock(scope: !44, file: !45, line: 149, column: 5)
!273 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "mat", arg: 2, scope: !64, file: !45, line: 85, type: !59)
!274 = !DILocation(line: 85, column: 50, scope: !64, inlinedAt: !269)
!275 = !DILocation(line: 159, column: 37, scope: !25)
!276 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "R0", arg: 1, scope: !70, file: !45, line: 59, type: !4)
!277 = !DILocation(line: 59, column: 30, scope: !70, inlinedAt: !278)
!278 = distinct !DILocation(line: 74, column: 28, scope: !67, inlinedAt: !268)
!279 = !DILocation(line: 160, column: 12, scope: !25)
!280 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "shadowFactor", scope: !25, file: !1, line: 160, type: !4)
!281 = !DILocation(line: 161, column: 26, scope: !25)
!282 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 5, scope: !44, file: !45, line: 143, type: !4)
!283 = !DILocation(line: 143, column: 98, scope: !44, inlinedAt: !265)
!284 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 4, scope: !44, file: !45, line: 143, type: !4)
!285 = !DILocation(line: 143, column: 83, scope: !44, inlinedAt: !265)
!286 = !DILocation(line: 145, column: 12, scope: !44, inlinedAt: !265)
!287 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "result", scope: !44, file: !45, line: 145, type: !4)
!288 = !DILocation(line: 146, column: 9, scope: !44, inlinedAt: !265)
!289 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !44, file: !45, line: 146, type: !14)
!290 = !DILocation(line: 149, column: 11, scope: !272, inlinedAt: !265)
!291 = !DILocation(line: 149, column: 5, scope: !272, inlinedAt: !265)
!292 = !DILocation(line: 151, column: 19, scope: !270, inlinedAt: !265)
!293 = !DILocation(line: 151, column: 37, scope: !270, inlinedAt: !265)
!294 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 4, scope: !64, file: !45, line: 85, type: !4)
!295 = !DILocation(line: 85, column: 77, scope: !64, inlinedAt: !269)
!296 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 3, scope: !64, file: !45, line: 85, type: !4)
!297 = !DILocation(line: 85, column: 62, scope: !64, inlinedAt: !269)
!298 = !DILocation(line: 88, column: 26, scope: !64, inlinedAt: !269)
!299 = !DILocation(line: 88, column: 23, scope: !64, inlinedAt: !269)
!300 = !DILocation(line: 88, column: 12, scope: !64, inlinedAt: !269)
!301 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "lightVec", scope: !64, file: !45, line: 88, type: !4)
!302 = !DILocation(line: 91, column: 23, scope: !64, inlinedAt: !269)
!303 = !DILocation(line: 91, column: 19, scope: !64, inlinedAt: !269)
!304 = !DILocation(line: 91, column: 11, scope: !64, inlinedAt: !269)
!305 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "ndotl", scope: !64, file: !45, line: 91, type: !8)
!306 = !DILocation(line: 92, column: 30, scope: !64, inlinedAt: !269)
!307 = !DILocation(line: 92, column: 39, scope: !64, inlinedAt: !269)
!308 = !DILocation(line: 92, column: 12, scope: !64, inlinedAt: !269)
!309 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "lightStrenght", scope: !64, file: !45, line: 92, type: !4)
!310 = !DILocation(line: 94, column: 12, scope: !64, inlinedAt: !269)
!311 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "toEye", arg: 4, scope: !67, file: !45, line: 68, type: !4)
!312 = !DILocation(line: 68, column: 80, scope: !67, inlinedAt: !268)
!313 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 3, scope: !67, file: !45, line: 68, type: !4)
!314 = !DILocation(line: 68, column: 65, scope: !67, inlinedAt: !268)
!315 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightVec", arg: 2, scope: !67, file: !45, line: 68, type: !4)
!316 = !DILocation(line: 68, column: 48, scope: !67, inlinedAt: !268)
!317 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightStrength", arg: 1, scope: !67, file: !45, line: 68, type: !4)
!318 = !DILocation(line: 68, column: 26, scope: !67, inlinedAt: !268)
!319 = !DILocation(line: 70, column: 35, scope: !67, inlinedAt: !268)
!320 = !DILocation(line: 70, column: 17, scope: !67, inlinedAt: !268)
!321 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "m", scope: !67, file: !45, line: 70, type: !104)
!322 = !DILocation(line: 71, column: 38, scope: !67, inlinedAt: !268)
!323 = !DILocation(line: 71, column: 22, scope: !67, inlinedAt: !268)
!324 = !DILocation(line: 71, column: 12, scope: !67, inlinedAt: !268)
!325 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "halfVec", scope: !67, file: !45, line: 71, type: !4)
!326 = !DILocation(line: 73, column: 32, scope: !67, inlinedAt: !268)
!327 = !DILocation(line: 73, column: 50, scope: !67, inlinedAt: !268)
!328 = !DILocation(line: 73, column: 46, scope: !67, inlinedAt: !268)
!329 = !DILocation(line: 73, column: 42, scope: !67, inlinedAt: !268)
!330 = !DILocation(line: 73, column: 40, scope: !67, inlinedAt: !268)
!331 = !DILocation(line: 73, column: 82, scope: !67, inlinedAt: !268)
!332 = !DILocation(line: 73, column: 11, scope: !67, inlinedAt: !268)
!333 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "roughnessFactor", scope: !67, file: !45, line: 73, type: !8)
!334 = !DILocation(line: 74, column: 28, scope: !67, inlinedAt: !268)
!335 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "lightVec", arg: 3, scope: !70, file: !45, line: 59, type: !4)
!336 = !DILocation(line: 59, column: 56, scope: !70, inlinedAt: !278)
!337 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "normal", arg: 2, scope: !70, file: !45, line: 59, type: !4)
!338 = !DILocation(line: 59, column: 41, scope: !70, inlinedAt: !278)
!339 = !DILocation(line: 61, column: 39, scope: !70, inlinedAt: !278)
!340 = !DILocation(line: 61, column: 30, scope: !70, inlinedAt: !278)
!341 = !DILocation(line: 61, column: 11, scope: !70, inlinedAt: !278)
!342 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "cosIncidentAngle", scope: !70, file: !45, line: 61, type: !8)
!343 = !DILocation(line: 62, column: 21, scope: !70, inlinedAt: !278)
!344 = !DILocation(line: 62, column: 11, scope: !70, inlinedAt: !278)
!345 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "f0", scope: !70, file: !45, line: 62, type: !8)
!346 = !DILocation(line: 63, column: 40, scope: !70, inlinedAt: !278)
!347 = !DILocation(line: 63, column: 48, scope: !70, inlinedAt: !278)
!348 = !DILocation(line: 63, column: 46, scope: !70, inlinedAt: !278)
!349 = !DILocation(line: 63, column: 32, scope: !70, inlinedAt: !278)
!350 = !DILocation(line: 63, column: 12, scope: !70, inlinedAt: !278)
!351 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "reflectPercent", scope: !70, file: !45, line: 63, type: !4)
!352 = !DILocation(line: 65, column: 5, scope: !70, inlinedAt: !278)
!353 = !DILocation(line: 74, column: 12, scope: !67, inlinedAt: !268)
!354 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "fresnelFactor", scope: !67, file: !45, line: 74, type: !4)
!355 = !DILocation(line: 76, column: 39, scope: !67, inlinedAt: !268)
!356 = !DILocation(line: 76, column: 12, scope: !67, inlinedAt: !268)
!357 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "specAlbedo", scope: !67, file: !45, line: 76, type: !4)
!358 = !DILocation(line: 80, column: 43, scope: !67, inlinedAt: !268)
!359 = !DILocation(line: 80, column: 29, scope: !67, inlinedAt: !268)
!360 = !DILocation(line: 80, column: 16, scope: !67, inlinedAt: !268)
!361 = !DILocation(line: 82, column: 35, scope: !67, inlinedAt: !268)
!362 = !DILocation(line: 82, column: 49, scope: !67, inlinedAt: !268)
!363 = !DILocation(line: 82, column: 5, scope: !67, inlinedAt: !268)
!364 = !DILocation(line: 94, column: 5, scope: !64, inlinedAt: !269)
!365 = !DILocation(line: 151, column: 35, scope: !270, inlinedAt: !265)
!366 = !DILocation(line: 151, column: 16, scope: !270, inlinedAt: !265)
!367 = !DILocation(line: 149, column: 36, scope: !271, inlinedAt: !265)
!368 = !DILocation(line: 149, column: 18, scope: !271, inlinedAt: !265)
!369 = !DILocation(line: 169, column: 5, scope: !44, inlinedAt: !265)
!370 = !DILocation(line: 161, column: 12, scope: !25)
!371 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "directLight", scope: !25, file: !1, line: 161, type: !15)
!372 = !DILocation(line: 164, column: 31, scope: !25)
!373 = !DILocation(line: 164, column: 12, scope: !25)
!374 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "litColor", scope: !25, file: !1, line: 164, type: !15)
!375 = !DILocation(line: 167, column: 42, scope: !25)
!376 = !DILocation(line: 167, column: 40, scope: !25)
!377 = !DILocation(line: 167, column: 55, scope: !25)
!378 = !DILocation(line: 167, column: 53, scope: !25)
!379 = !DILocation(line: 167, column: 20, scope: !25)
!380 = !DILocation(line: 167, column: 8, scope: !25)
!381 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "fogAmount", scope: !25, file: !1, line: 167, type: !8)
!382 = !DILocation(line: 168, column: 28, scope: !25)
!383 = !DILocation(line: 168, column: 13, scope: !25)
!384 = !DILocation(line: 168, column: 11, scope: !25)
!385 = !DILocation(line: 171, column: 16, scope: !25)
!386 = !DILocation(line: 173, column: 5, scope: !25)
!387 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "shadowFactor", arg: 6, scope: !44, file: !45, line: 143, type: !4)
!388 = !DILocation(line: 143, column: 112, scope: !44, inlinedAt: !265)
