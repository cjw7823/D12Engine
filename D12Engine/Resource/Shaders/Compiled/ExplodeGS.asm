;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   xyz 
; NORMAL                   0   xyz         1     NONE   float       
; TEXCOORD                 0   xy          2     NONE   float   xy  
; SV_PrimitiveID           0    N/A   primID   PRIMID    uint     NO
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
; SV_PrimitiveID           0   x           4   PRIMID    uint   x   
; TEXCOORD                 1   x           5     NONE    uint   x   
;
; shader debug name: ef0cd26e83d381cfa9f2e6125a190208.pdb
; shader hash: ef0cd26e83d381cfa9f2e6125a190208
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Geometry Shader
; InputPrimitive=triangle
; OutputTopology=triangle
; OutputStreamMask=1
; OutputPositionPresent=1
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 4
; SigOutputElements: 6
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 3
; SigOutputVectors[0]: 6
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: GS_Explode
;
;
; Input signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; POSITION                 0                 linear       
; NORMAL                   0                 linear       
; TEXCOORD                 0                 linear       
; SV_PrimitiveID           0                              
;
; Output signature:
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
; Buffer Definitions:
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
; cbPass                            cbuffer      NA          NA     CB0            cb2     1
;
;
; ViewId state:
;
; Number of inputs: 10, outputs per stream: { 21, 0, 0, 0 }
; Outputs for Stream 0 dependent on ViewId: {  }
; Inputs contributing to computation of Outputs for Stream 0:
;   output 0 depends on inputs: { 0, 1, 2 }
;   output 1 depends on inputs: { 0, 1, 2 }
;   output 2 depends on inputs: { 0, 1, 2 }
;   output 3 depends on inputs: { 0, 1, 2 }
;   output 4 depends on inputs: { 0, 1, 2 }
;   output 5 depends on inputs: { 0, 1, 2 }
;   output 6 depends on inputs: { 0, 1, 2 }
;   output 8 depends on inputs: { 0, 1, 2 }
;   output 9 depends on inputs: { 0, 1, 2 }
;   output 10 depends on inputs: { 0, 1, 2 }
;   output 12 depends on inputs: { 8 }
;   output 13 depends on inputs: { 9 }
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.CBufRet.f32 = type { float, float, float, float }
%hostlayout.cbPass = type { [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], <3 x float>, float, <2 x float>, <2 x float>, float, float, float, float, <4 x float>, [16 x %struct.Light], <4 x float>, float, float, <2 x float> }
%struct.Light = type { <3 x float>, float, <3 x float>, float, <3 x float>, float }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @GS_Explode() {
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 2, i1 false), !dbg !205 ; line:268 col:36  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call i32 @dx.op.primitiveID.i32(i32 108), !dbg !205 ; line:268 col:36  ; PrimitiveID()
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !206, metadata !207), !dbg !208 ; var:"primID" !DIExpression() func:"GS_Explode"
  %2 = uitofp i32 %1 to float, !dbg !209 ; line:272 col:27
  %3 = fmul fast float %2, 0x4029FAC720000000, !dbg !210 ; line:272 col:34
  %Sin = call float @dx.op.unary.f32(i32 13, float %3), !dbg !211 ; line:272 col:23  ; Sin(value)
  %4 = fmul fast float %Sin, 0x4087B45CC0000000, !dbg !212 ; line:272 col:46
  %Frc = call float @dx.op.unary.f32(i32 22, float %4), !dbg !213 ; line:272 col:18  ; Frc(value)
  %5 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !214 ; line:272 col:11
  call void @llvm.dbg.value(metadata float %Frc, i64 0, metadata !215, metadata !207), !dbg !214 ; var:"rand" !DIExpression() func:"GS_Explode"
  %6 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 26), !dbg !216 ; line:273 col:20  ; CBufferLoadLegacy(handle,regIndex)
  %7 = extractvalue %dx.types.CBufRet.f32 %6, 2, !dbg !216 ; line:273 col:20
  %8 = fmul fast float %Frc, 0x3FC0A3D700000000, !dbg !217 ; line:273 col:38
  %9 = fadd fast float %7, %8, !dbg !218 ; line:273 col:31
  %Frc1 = call float @dx.op.unary.f32(i32 22, float %9), !dbg !219 ; line:273 col:15  ; Frc(value)
  %10 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !220 ; line:273 col:11
  call void @llvm.dbg.value(metadata float %Frc1, i64 0, metadata !221, metadata !207), !dbg !220 ; var:"t" !DIExpression() func:"GS_Explode"
  %11 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !222 ; line:276 col:11
  call void @llvm.dbg.value(metadata float 0x3FEE666660000000, i64 0, metadata !223, metadata !207), !dbg !222 ; var:"explodeDuration" !DIExpression() func:"GS_Explode"
  %12 = fcmp fast olt float %Frc1, 0x3FEE666660000000, !dbg !224 ; line:277 col:11
  %13 = icmp ne i1 %12, false, !dbg !224 ; line:277 col:11
  %14 = icmp ne i1 %13, false, !dbg !224 ; line:277 col:11
  br i1 %14, label %15, label %20, !dbg !226 ; line:277 col:9

; <label>:15                                      ; preds = %0
  %16 = fdiv fast float %Frc1, 0x3FEE666660000000, !dbg !227 ; line:279 col:26
  %17 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !229 ; line:279 col:15
  call void @llvm.dbg.value(metadata float %16, i64 0, metadata !230, metadata !207), !dbg !229 ; var:"localT" !DIExpression() func:"GS_Explode"
  %Log = call float @dx.op.unary.f32(i32 23, float %16), !dbg !231 ; line:280 col:25  ; Log(value)
  %18 = fmul fast float %Log, 1.800000e+01, !dbg !231 ; line:280 col:25
  %Exp = call float @dx.op.unary.f32(i32 21, float %18), !dbg !231 ; line:280 col:25  ; Exp(value)
  %19 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !232 ; line:280 col:23
  call void @llvm.dbg.value(metadata float %Exp, i64 0, metadata !233, metadata !207), !dbg !234 ; var:"explodeAmount" !DIExpression() func:"GS_Explode"
  br label %22, !dbg !235 ; line:281 col:5

; <label>:20                                      ; preds = %0
  %21 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !236 ; line:283 col:23
  call void @llvm.dbg.value(metadata float 1.000000e+00, i64 0, metadata !233, metadata !207), !dbg !234 ; var:"explodeAmount" !DIExpression() func:"GS_Explode"
  br label %22

; <label>:22                                      ; preds = %20, %15
  %explodeAmount.0 = phi float [ %Exp, %15 ], [ 1.000000e+00, %20 ]
  call void @llvm.dbg.value(metadata float %explodeAmount.0, i64 0, metadata !233, metadata !207), !dbg !234 ; var:"explodeAmount" !DIExpression() func:"GS_Explode"
  %23 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 1), !dbg !237 ; line:285 col:24  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %24 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 1), !dbg !237 ; line:285 col:24  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %25 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 1), !dbg !237 ; line:285 col:24  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %26 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !238 ; line:285 col:38  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %27 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !238 ; line:285 col:38  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %28 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !238 ; line:285 col:38  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i0 = fsub fast float %23, %26, !dbg !239 ; line:285 col:29
  %.i1 = fsub fast float %24, %27, !dbg !239 ; line:285 col:29
  %.i2 = fsub fast float %25, %28, !dbg !239 ; line:285 col:29
  %29 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !240 ; line:285 col:12
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !241, metadata !242), !dbg !240 ; var:"e0" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i1, i64 0, metadata !241, metadata !243), !dbg !240 ; var:"e0" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !241, metadata !244), !dbg !240 ; var:"e0" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  %30 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 2), !dbg !245 ; line:286 col:24  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %31 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 2), !dbg !245 ; line:286 col:24  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %32 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 2), !dbg !245 ; line:286 col:24  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %33 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !246 ; line:286 col:38  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %34 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !246 ; line:286 col:38  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %35 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !246 ; line:286 col:38  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i013 = fsub fast float %30, %33, !dbg !247 ; line:286 col:29
  %.i114 = fsub fast float %31, %34, !dbg !247 ; line:286 col:29
  %.i215 = fsub fast float %32, %35, !dbg !247 ; line:286 col:29
  %36 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !248 ; line:286 col:12
  call void @llvm.dbg.value(metadata float %.i013, i64 0, metadata !249, metadata !242), !dbg !248 ; var:"e1" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i114, i64 0, metadata !249, metadata !243), !dbg !248 ; var:"e1" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i215, i64 0, metadata !249, metadata !244), !dbg !248 ; var:"e1" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  %37 = fmul fast float %.i1, %.i215, !dbg !250 ; line:287 col:35
  %38 = fmul fast float %.i2, %.i114, !dbg !250 ; line:287 col:35
  %39 = fsub fast float %37, %38, !dbg !250 ; line:287 col:35
  %40 = fmul fast float %.i2, %.i013, !dbg !250 ; line:287 col:35
  %41 = fmul fast float %.i0, %.i215, !dbg !250 ; line:287 col:35
  %42 = fsub fast float %40, %41, !dbg !250 ; line:287 col:35
  %43 = fmul fast float %.i0, %.i114, !dbg !250 ; line:287 col:35
  %44 = fmul fast float %.i1, %.i013, !dbg !250 ; line:287 col:35
  %45 = fsub fast float %43, %44, !dbg !250 ; line:287 col:35
  %46 = call float @dx.op.dot3.f32(i32 55, float %39, float %42, float %45, float %39, float %42, float %45), !dbg !251 ; line:287 col:25  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt = call float @dx.op.unary.f32(i32 25, float %46), !dbg !251 ; line:287 col:25  ; Rsqrt(value)
  %.i016 = fmul fast float %39, %Rsqrt, !dbg !251 ; line:287 col:25
  %.i117 = fmul fast float %42, %Rsqrt, !dbg !251 ; line:287 col:25
  %.i218 = fmul fast float %45, %Rsqrt, !dbg !251 ; line:287 col:25
  %.i020 = fmul fast float %.i016, 2.000000e+00, !dbg !252 ; line:287 col:50
  %.i122 = fmul fast float %.i117, 2.000000e+00, !dbg !252 ; line:287 col:50
  %.i224 = fmul fast float %.i218, 2.000000e+00, !dbg !252 ; line:287 col:50
  %47 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !253 ; line:287 col:12
  call void @llvm.dbg.value(metadata float %.i020, i64 0, metadata !254, metadata !242), !dbg !253 ; var:"faceNormal" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i122, i64 0, metadata !254, metadata !243), !dbg !253 ; var:"faceNormal" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i224, i64 0, metadata !254, metadata !244), !dbg !253 ; var:"faceNormal" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  %.i025 = fmul fast float %explodeAmount.0, %.i020, !dbg !255 ; line:289 col:42
  %.i126 = fmul fast float %explodeAmount.0, %.i122, !dbg !255 ; line:289 col:42
  %.i227 = fmul fast float %explodeAmount.0, %.i224, !dbg !255 ; line:289 col:42
  %48 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !256 ; line:289 col:12
  call void @llvm.dbg.value(metadata float %.i025, i64 0, metadata !257, metadata !242), !dbg !256 ; var:"explodeVector" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i126, i64 0, metadata !257, metadata !243), !dbg !256 ; var:"explodeVector" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i227, i64 0, metadata !257, metadata !244), !dbg !256 ; var:"explodeVector" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  %49 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !258 ; line:292 col:14
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !260, metadata !207), !dbg !258 ; var:"i" !DIExpression() func:"GS_Explode"
  br label %.lr.ph, !dbg !261 ; line:292 col:5

.lr.ph:                                           ; preds = %22
  br label %50, !dbg !261 ; line:292 col:5

; <label>:50                                      ; preds = %.lr.ph
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !260, metadata !207), !dbg !258 ; var:"i" !DIExpression() func:"GS_Explode"
  %51 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !262 ; line:296 col:33  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %52 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !262 ; line:296 col:33  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %53 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !262 ; line:296 col:33  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i028.38 = fadd fast float %51, %.i025, !dbg !265 ; line:296 col:38
  %.i129.39 = fadd fast float %52, %.i126, !dbg !265 ; line:296 col:38
  %.i230.40 = fadd fast float %53, %.i227, !dbg !265 ; line:296 col:38
  %54 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !266 ; line:296 col:16
  call void @llvm.dbg.value(metadata float %.i028.38, i64 0, metadata !267, metadata !242), !dbg !266 ; var:"newPosW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i129.39, i64 0, metadata !267, metadata !243), !dbg !266 ; var:"newPosW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i230.40, i64 0, metadata !267, metadata !244), !dbg !266 ; var:"newPosW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  %55 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !268 ; line:298 col:19
  call void @llvm.dbg.value(metadata float %.i028.38, i64 0, metadata !269, metadata !270), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i129.39, i64 0, metadata !269, metadata !272), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i230.40, i64 0, metadata !269, metadata !273), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS_Explode"
  %56 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !274 ; line:299 col:22
  call void @llvm.dbg.value(metadata float %.i020, i64 0, metadata !269, metadata !275), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i122, i64 0, metadata !269, metadata !276), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i224, i64 0, metadata !269, metadata !277), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS_Explode"
  %57 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 0, i32 0), !dbg !278 ; line:300 col:28  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %58 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 1, i32 0), !dbg !278 ; line:300 col:28  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %59 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !279 ; line:300 col:19
  call void @llvm.dbg.value(metadata float %57, i64 0, metadata !269, metadata !280), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %58, i64 0, metadata !269, metadata !281), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS_Explode"
  %60 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %61 = extractvalue %dx.types.CBufRet.f32 %60, 0, !dbg !282 ; line:301 col:48
  %62 = extractvalue %dx.types.CBufRet.f32 %60, 1, !dbg !282 ; line:301 col:48
  %63 = extractvalue %dx.types.CBufRet.f32 %60, 2, !dbg !282 ; line:301 col:48
  %64 = extractvalue %dx.types.CBufRet.f32 %60, 3, !dbg !282 ; line:301 col:48
  %65 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %66 = extractvalue %dx.types.CBufRet.f32 %65, 0, !dbg !282 ; line:301 col:48
  %67 = extractvalue %dx.types.CBufRet.f32 %65, 1, !dbg !282 ; line:301 col:48
  %68 = extractvalue %dx.types.CBufRet.f32 %65, 2, !dbg !282 ; line:301 col:48
  %69 = extractvalue %dx.types.CBufRet.f32 %65, 3, !dbg !282 ; line:301 col:48
  %70 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %71 = extractvalue %dx.types.CBufRet.f32 %70, 0, !dbg !282 ; line:301 col:48
  %72 = extractvalue %dx.types.CBufRet.f32 %70, 1, !dbg !282 ; line:301 col:48
  %73 = extractvalue %dx.types.CBufRet.f32 %70, 2, !dbg !282 ; line:301 col:48
  %74 = extractvalue %dx.types.CBufRet.f32 %70, 3, !dbg !282 ; line:301 col:48
  %75 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %76 = extractvalue %dx.types.CBufRet.f32 %75, 0, !dbg !282 ; line:301 col:48
  %77 = extractvalue %dx.types.CBufRet.f32 %75, 1, !dbg !282 ; line:301 col:48
  %78 = extractvalue %dx.types.CBufRet.f32 %75, 2, !dbg !282 ; line:301 col:48
  %79 = extractvalue %dx.types.CBufRet.f32 %75, 3, !dbg !282 ; line:301 col:48
  %80 = fmul fast float %.i028.38, %61, !dbg !283 ; line:301 col:21
  %FMad12.41 = call float @dx.op.tertiary.f32(i32 46, float %.i129.39, float %62, float %80), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad11.42 = call float @dx.op.tertiary.f32(i32 46, float %.i230.40, float %63, float %FMad12.41), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad10.43 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %64, float %FMad11.42), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %81 = fmul fast float %.i028.38, %66, !dbg !283 ; line:301 col:21
  %FMad9.44 = call float @dx.op.tertiary.f32(i32 46, float %.i129.39, float %67, float %81), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad8.45 = call float @dx.op.tertiary.f32(i32 46, float %.i230.40, float %68, float %FMad9.44), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad7.46 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %69, float %FMad8.45), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %82 = fmul fast float %.i028.38, %71, !dbg !283 ; line:301 col:21
  %FMad6.47 = call float @dx.op.tertiary.f32(i32 46, float %.i129.39, float %72, float %82), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad5.48 = call float @dx.op.tertiary.f32(i32 46, float %.i230.40, float %73, float %FMad6.47), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad4.49 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %74, float %FMad5.48), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %83 = fmul fast float %.i028.38, %76, !dbg !283 ; line:301 col:21
  %FMad3.50 = call float @dx.op.tertiary.f32(i32 46, float %.i129.39, float %77, float %83), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad2.51 = call float @dx.op.tertiary.f32(i32 46, float %.i230.40, float %78, float %FMad3.50), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad.52 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %79, float %FMad2.51), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %84 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:301 col:19
  call void @llvm.dbg.value(metadata float %FMad10.43, i64 0, metadata !269, metadata !242), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad7.46, i64 0, metadata !269, metadata !243), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad4.49, i64 0, metadata !269, metadata !244), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad.52, i64 0, metadata !269, metadata !285), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS_Explode"
  %85 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !286 ; line:302 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !269, metadata !287), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS_Explode"
  %86 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:303 col:23
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !269, metadata !289), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad10.43, i64 0, metadata !290, metadata !242), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad7.46, i64 0, metadata !290, metadata !243), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad4.49, i64 0, metadata !290, metadata !244), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad.52, i64 0, metadata !290, metadata !285), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad10.43), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad7.46), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad4.49), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.52), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i028.38, i64 0, metadata !290, metadata !270), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i129.39, i64 0, metadata !290, metadata !272), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i230.40, i64 0, metadata !290, metadata !273), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %.i028.38), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %.i129.39), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %.i230.40), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i020, i64 0, metadata !290, metadata !275), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i122, i64 0, metadata !290, metadata !276), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i224, i64 0, metadata !290, metadata !277), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i020), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float %.i122), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i224), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %57, i64 0, metadata !290, metadata !280), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %58, i64 0, metadata !290, metadata !281), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %57), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %58), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !290, metadata !287), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !290, metadata !289), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.i32(i32 5, i32 5, i32 0, i8 0, i32 0), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !291 ; line:305 col:9  ; EmitStream(streamId)
  br label %87, !dbg !292 ; line:306 col:5

; <label>:87                                      ; preds = %50
  %88 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:292 col:28
  call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !260, metadata !207), !dbg !258 ; var:"i" !DIExpression() func:"GS_Explode"
  br label %89, !dbg !261, !llvm.loop !294 ; line:292 col:5

; <label>:89                                      ; preds = %87
  call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !260, metadata !207), !dbg !258 ; var:"i" !DIExpression() func:"GS_Explode"
  %90 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 1), !dbg !262 ; line:296 col:33  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %91 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 1), !dbg !262 ; line:296 col:33  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %92 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 1), !dbg !262 ; line:296 col:33  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i028.54 = fadd fast float %90, %.i025, !dbg !265 ; line:296 col:38
  %.i129.55 = fadd fast float %91, %.i126, !dbg !265 ; line:296 col:38
  %.i230.56 = fadd fast float %92, %.i227, !dbg !265 ; line:296 col:38
  %93 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !266 ; line:296 col:16
  call void @llvm.dbg.value(metadata float %.i028.54, i64 0, metadata !267, metadata !242), !dbg !266 ; var:"newPosW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i129.55, i64 0, metadata !267, metadata !243), !dbg !266 ; var:"newPosW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i230.56, i64 0, metadata !267, metadata !244), !dbg !266 ; var:"newPosW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  %94 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !268 ; line:298 col:19
  call void @llvm.dbg.value(metadata float %.i028.54, i64 0, metadata !269, metadata !270), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i129.55, i64 0, metadata !269, metadata !272), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i230.56, i64 0, metadata !269, metadata !273), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS_Explode"
  %95 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !274 ; line:299 col:22
  call void @llvm.dbg.value(metadata float %.i020, i64 0, metadata !269, metadata !275), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i122, i64 0, metadata !269, metadata !276), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i224, i64 0, metadata !269, metadata !277), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS_Explode"
  %96 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 0, i32 1), !dbg !278 ; line:300 col:28  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %97 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 1, i32 1), !dbg !278 ; line:300 col:28  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %98 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !279 ; line:300 col:19
  call void @llvm.dbg.value(metadata float %96, i64 0, metadata !269, metadata !280), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %97, i64 0, metadata !269, metadata !281), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS_Explode"
  %99 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %100 = extractvalue %dx.types.CBufRet.f32 %99, 0, !dbg !282 ; line:301 col:48
  %101 = extractvalue %dx.types.CBufRet.f32 %99, 1, !dbg !282 ; line:301 col:48
  %102 = extractvalue %dx.types.CBufRet.f32 %99, 2, !dbg !282 ; line:301 col:48
  %103 = extractvalue %dx.types.CBufRet.f32 %99, 3, !dbg !282 ; line:301 col:48
  %104 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %105 = extractvalue %dx.types.CBufRet.f32 %104, 0, !dbg !282 ; line:301 col:48
  %106 = extractvalue %dx.types.CBufRet.f32 %104, 1, !dbg !282 ; line:301 col:48
  %107 = extractvalue %dx.types.CBufRet.f32 %104, 2, !dbg !282 ; line:301 col:48
  %108 = extractvalue %dx.types.CBufRet.f32 %104, 3, !dbg !282 ; line:301 col:48
  %109 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %110 = extractvalue %dx.types.CBufRet.f32 %109, 0, !dbg !282 ; line:301 col:48
  %111 = extractvalue %dx.types.CBufRet.f32 %109, 1, !dbg !282 ; line:301 col:48
  %112 = extractvalue %dx.types.CBufRet.f32 %109, 2, !dbg !282 ; line:301 col:48
  %113 = extractvalue %dx.types.CBufRet.f32 %109, 3, !dbg !282 ; line:301 col:48
  %114 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %115 = extractvalue %dx.types.CBufRet.f32 %114, 0, !dbg !282 ; line:301 col:48
  %116 = extractvalue %dx.types.CBufRet.f32 %114, 1, !dbg !282 ; line:301 col:48
  %117 = extractvalue %dx.types.CBufRet.f32 %114, 2, !dbg !282 ; line:301 col:48
  %118 = extractvalue %dx.types.CBufRet.f32 %114, 3, !dbg !282 ; line:301 col:48
  %119 = fmul fast float %.i028.54, %100, !dbg !283 ; line:301 col:21
  %FMad12.57 = call float @dx.op.tertiary.f32(i32 46, float %.i129.55, float %101, float %119), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad11.58 = call float @dx.op.tertiary.f32(i32 46, float %.i230.56, float %102, float %FMad12.57), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad10.59 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %103, float %FMad11.58), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %120 = fmul fast float %.i028.54, %105, !dbg !283 ; line:301 col:21
  %FMad9.60 = call float @dx.op.tertiary.f32(i32 46, float %.i129.55, float %106, float %120), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad8.61 = call float @dx.op.tertiary.f32(i32 46, float %.i230.56, float %107, float %FMad9.60), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad7.62 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %108, float %FMad8.61), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %121 = fmul fast float %.i028.54, %110, !dbg !283 ; line:301 col:21
  %FMad6.63 = call float @dx.op.tertiary.f32(i32 46, float %.i129.55, float %111, float %121), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad5.64 = call float @dx.op.tertiary.f32(i32 46, float %.i230.56, float %112, float %FMad6.63), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad4.65 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %113, float %FMad5.64), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %122 = fmul fast float %.i028.54, %115, !dbg !283 ; line:301 col:21
  %FMad3.66 = call float @dx.op.tertiary.f32(i32 46, float %.i129.55, float %116, float %122), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad2.67 = call float @dx.op.tertiary.f32(i32 46, float %.i230.56, float %117, float %FMad3.66), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad.68 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %118, float %FMad2.67), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %123 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:301 col:19
  call void @llvm.dbg.value(metadata float %FMad10.59, i64 0, metadata !269, metadata !242), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad7.62, i64 0, metadata !269, metadata !243), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad4.65, i64 0, metadata !269, metadata !244), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad.68, i64 0, metadata !269, metadata !285), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS_Explode"
  %124 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !286 ; line:302 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !269, metadata !287), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS_Explode"
  %125 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:303 col:23
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !269, metadata !289), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad10.59, i64 0, metadata !290, metadata !242), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad7.62, i64 0, metadata !290, metadata !243), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad4.65, i64 0, metadata !290, metadata !244), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad.68, i64 0, metadata !290, metadata !285), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad10.59), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad7.62), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad4.65), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.68), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i028.54, i64 0, metadata !290, metadata !270), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i129.55, i64 0, metadata !290, metadata !272), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i230.56, i64 0, metadata !290, metadata !273), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %.i028.54), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %.i129.55), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %.i230.56), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i020, i64 0, metadata !290, metadata !275), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i122, i64 0, metadata !290, metadata !276), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i224, i64 0, metadata !290, metadata !277), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i020), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float %.i122), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i224), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %96, i64 0, metadata !290, metadata !280), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %97, i64 0, metadata !290, metadata !281), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %96), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %97), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !290, metadata !287), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !290, metadata !289), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.i32(i32 5, i32 5, i32 0, i8 0, i32 0), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !291 ; line:305 col:9  ; EmitStream(streamId)
  br label %126, !dbg !292 ; line:306 col:5

; <label>:126                                     ; preds = %89
  %127 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:292 col:28
  call void @llvm.dbg.value(metadata i32 2, i64 0, metadata !260, metadata !207), !dbg !258 ; var:"i" !DIExpression() func:"GS_Explode"
  br label %128, !dbg !261, !llvm.loop !294 ; line:292 col:5

; <label>:128                                     ; preds = %126
  call void @llvm.dbg.value(metadata i32 2, i64 0, metadata !260, metadata !207), !dbg !258 ; var:"i" !DIExpression() func:"GS_Explode"
  %129 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 2), !dbg !262 ; line:296 col:33  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %130 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 2), !dbg !262 ; line:296 col:33  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %131 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 2), !dbg !262 ; line:296 col:33  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i028.70 = fadd fast float %129, %.i025, !dbg !265 ; line:296 col:38
  %.i129.71 = fadd fast float %130, %.i126, !dbg !265 ; line:296 col:38
  %.i230.72 = fadd fast float %131, %.i227, !dbg !265 ; line:296 col:38
  %132 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !266 ; line:296 col:16
  call void @llvm.dbg.value(metadata float %.i028.70, i64 0, metadata !267, metadata !242), !dbg !266 ; var:"newPosW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i129.71, i64 0, metadata !267, metadata !243), !dbg !266 ; var:"newPosW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i230.72, i64 0, metadata !267, metadata !244), !dbg !266 ; var:"newPosW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  %133 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !268 ; line:298 col:19
  call void @llvm.dbg.value(metadata float %.i028.70, i64 0, metadata !269, metadata !270), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i129.71, i64 0, metadata !269, metadata !272), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i230.72, i64 0, metadata !269, metadata !273), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS_Explode"
  %134 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !274 ; line:299 col:22
  call void @llvm.dbg.value(metadata float %.i020, i64 0, metadata !269, metadata !275), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i122, i64 0, metadata !269, metadata !276), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i224, i64 0, metadata !269, metadata !277), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS_Explode"
  %135 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 0, i32 2), !dbg !278 ; line:300 col:28  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %136 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 1, i32 2), !dbg !278 ; line:300 col:28  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %137 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !279 ; line:300 col:19
  call void @llvm.dbg.value(metadata float %135, i64 0, metadata !269, metadata !280), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %136, i64 0, metadata !269, metadata !281), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS_Explode"
  %138 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %139 = extractvalue %dx.types.CBufRet.f32 %138, 0, !dbg !282 ; line:301 col:48
  %140 = extractvalue %dx.types.CBufRet.f32 %138, 1, !dbg !282 ; line:301 col:48
  %141 = extractvalue %dx.types.CBufRet.f32 %138, 2, !dbg !282 ; line:301 col:48
  %142 = extractvalue %dx.types.CBufRet.f32 %138, 3, !dbg !282 ; line:301 col:48
  %143 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %144 = extractvalue %dx.types.CBufRet.f32 %143, 0, !dbg !282 ; line:301 col:48
  %145 = extractvalue %dx.types.CBufRet.f32 %143, 1, !dbg !282 ; line:301 col:48
  %146 = extractvalue %dx.types.CBufRet.f32 %143, 2, !dbg !282 ; line:301 col:48
  %147 = extractvalue %dx.types.CBufRet.f32 %143, 3, !dbg !282 ; line:301 col:48
  %148 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %149 = extractvalue %dx.types.CBufRet.f32 %148, 0, !dbg !282 ; line:301 col:48
  %150 = extractvalue %dx.types.CBufRet.f32 %148, 1, !dbg !282 ; line:301 col:48
  %151 = extractvalue %dx.types.CBufRet.f32 %148, 2, !dbg !282 ; line:301 col:48
  %152 = extractvalue %dx.types.CBufRet.f32 %148, 3, !dbg !282 ; line:301 col:48
  %153 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !282 ; line:301 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %154 = extractvalue %dx.types.CBufRet.f32 %153, 0, !dbg !282 ; line:301 col:48
  %155 = extractvalue %dx.types.CBufRet.f32 %153, 1, !dbg !282 ; line:301 col:48
  %156 = extractvalue %dx.types.CBufRet.f32 %153, 2, !dbg !282 ; line:301 col:48
  %157 = extractvalue %dx.types.CBufRet.f32 %153, 3, !dbg !282 ; line:301 col:48
  %158 = fmul fast float %.i028.70, %139, !dbg !283 ; line:301 col:21
  %FMad12.73 = call float @dx.op.tertiary.f32(i32 46, float %.i129.71, float %140, float %158), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad11.74 = call float @dx.op.tertiary.f32(i32 46, float %.i230.72, float %141, float %FMad12.73), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad10.75 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %142, float %FMad11.74), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %159 = fmul fast float %.i028.70, %144, !dbg !283 ; line:301 col:21
  %FMad9.76 = call float @dx.op.tertiary.f32(i32 46, float %.i129.71, float %145, float %159), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad8.77 = call float @dx.op.tertiary.f32(i32 46, float %.i230.72, float %146, float %FMad9.76), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad7.78 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %147, float %FMad8.77), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %160 = fmul fast float %.i028.70, %149, !dbg !283 ; line:301 col:21
  %FMad6.79 = call float @dx.op.tertiary.f32(i32 46, float %.i129.71, float %150, float %160), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad5.80 = call float @dx.op.tertiary.f32(i32 46, float %.i230.72, float %151, float %FMad6.79), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad4.81 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %152, float %FMad5.80), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %161 = fmul fast float %.i028.70, %154, !dbg !283 ; line:301 col:21
  %FMad3.82 = call float @dx.op.tertiary.f32(i32 46, float %.i129.71, float %155, float %161), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad2.83 = call float @dx.op.tertiary.f32(i32 46, float %.i230.72, float %156, float %FMad3.82), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %FMad.84 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %157, float %FMad2.83), !dbg !283 ; line:301 col:21  ; FMad(a,b,c)
  %162 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:301 col:19
  call void @llvm.dbg.value(metadata float %FMad10.75, i64 0, metadata !269, metadata !242), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad7.78, i64 0, metadata !269, metadata !243), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad4.81, i64 0, metadata !269, metadata !244), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad.84, i64 0, metadata !269, metadata !285), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS_Explode"
  %163 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !286 ; line:302 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !269, metadata !287), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS_Explode"
  %164 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:303 col:23
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !269, metadata !289), !dbg !271 ; var:"gout" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad10.75, i64 0, metadata !290, metadata !242), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad7.78, i64 0, metadata !290, metadata !243), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad4.81, i64 0, metadata !290, metadata !244), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %FMad.84, i64 0, metadata !290, metadata !285), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad10.75), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad7.78), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad4.81), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.84), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i028.70, i64 0, metadata !290, metadata !270), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i129.71, i64 0, metadata !290, metadata !272), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i230.72, i64 0, metadata !290, metadata !273), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %.i028.70), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %.i129.71), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %.i230.72), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i020, i64 0, metadata !290, metadata !275), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i122, i64 0, metadata !290, metadata !276), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %.i224, i64 0, metadata !290, metadata !277), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i020), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float %.i122), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i224), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %135, i64 0, metadata !290, metadata !280), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS_Explode"
  call void @llvm.dbg.value(metadata float %136, i64 0, metadata !290, metadata !281), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %135), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %136), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !290, metadata !287), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !290, metadata !289), !dbg !291 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS_Explode"
  call void @dx.op.storeOutput.i32(i32 5, i32 5, i32 0, i8 0, i32 0), !dbg !291 ; line:305 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !291 ; line:305 col:9  ; EmitStream(streamId)
  br label %165, !dbg !292 ; line:306 col:5

; <label>:165                                     ; preds = %128
  %166 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:292 col:28
  call void @llvm.dbg.value(metadata i32 3, i64 0, metadata !260, metadata !207), !dbg !258 ; var:"i" !DIExpression() func:"GS_Explode"
  br label %._crit_edge, !dbg !261, !llvm.loop !294 ; line:292 col:5

._crit_edge:                                      ; preds = %165
  br label %167, !dbg !261 ; line:292 col:5

; <label>:167                                     ; preds = %._crit_edge
  call void @dx.op.cutStream(i32 98, i8 0), !dbg !296 ; line:308 col:5  ; CutStream(streamId)
  %168 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !297 ; line:309 col:1
  ret void, !dbg !297 ; line:309 col:1
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare i32 @dx.op.primitiveID.i32(i32) #0

; Function Attrs: nounwind readnone
declare float @dx.op.loadInput.f32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #1

; Function Attrs: nounwind
declare void @dx.op.storeOutput.i32(i32, i32, i32, i8, i32) #1

; Function Attrs: nounwind
declare void @dx.op.cutStream(i32, i8) #1

; Function Attrs: nounwind
declare void @dx.op.emitStream(i32, i8) #1

; Function Attrs: nounwind readnone
declare float @dx.op.unary.f32(i32, float) #0

; Function Attrs: nounwind readnone
declare float @dx.op.dot3.f32(i32, float, float, float, float, float, float) #0

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
!llvm.module.flags = !{!135, !136}
!llvm.ident = !{!137}
!dx.source.contents = !{!138, !139}
!dx.source.defines = !{!140}
!dx.source.mainFileName = !{!141}
!dx.source.args = !{!142}
!dx.version = !{!143}
!dx.valver = !{!144}
!dx.shaderModel = !{!145}
!dx.resources = !{!146}
!dx.typeAnnotations = !{!149, !179}
!dx.viewIdState = !{!182}
!dx.entryPoints = !{!183}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !16, globals: !57)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CTask_GS.hlsl", directory: "")
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
!16 = !{!17}
!17 = !DISubprogram(name: "GS_Explode", scope: !1, file: !1, line: 268, type: !18, isLocal: false, isDefinition: true, scopeLine: 271, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @GS_Explode)
!18 = !DISubroutineType(types: !19)
!19 = !{null, !20, !43, !45}
!20 = !DICompositeType(tag: DW_TAG_array_type, baseType: !21, size: 768, align: 32, elements: !41)
!21 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexOut", file: !1, line: 71, size: 256, align: 32, elements: !22)
!22 = !{!23, !32, !33}
!23 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !21, file: !1, line: 73, baseType: !24, size: 96, align: 32)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 33, baseType: !25)
!25 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 33, size: 96, align: 32, elements: !26, templateParams: !30)
!26 = !{!27, !28, !29}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !25, file: !1, line: 33, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !25, file: !1, line: 33, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !25, file: !1, line: 33, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!30 = !{!13, !31}
!31 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 3)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !21, file: !1, line: 74, baseType: !24, size: 96, align: 32, offset: 96)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !21, file: !1, line: 75, baseType: !34, size: 64, align: 32, offset: 192)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 48, baseType: !35)
!35 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 48, size: 64, align: 32, elements: !36, templateParams: !39)
!36 = !{!37, !38}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !35, file: !1, line: 48, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !35, file: !1, line: 48, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!39 = !{!13, !40}
!40 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 2)
!41 = !{!42}
!42 = !DISubrange(count: 3)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 61, baseType: !44)
!44 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!45 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !46)
!46 = !DICompositeType(tag: DW_TAG_class_type, name: "TriangleStream<GeoOut>", file: !1, line: 61, size: 448, align: 32, elements: !2, templateParams: !47)
!47 = !{!48}
!48 = !DITemplateTypeParameter(name: "element", type: !49)
!49 = !DICompositeType(tag: DW_TAG_structure_type, name: "GeoOut", file: !1, line: 85, size: 448, align: 32, elements: !50)
!50 = !{!51, !52, !53, !54, !55, !56}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !49, file: !1, line: 87, baseType: !4, size: 128, align: 32)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !49, file: !1, line: 88, baseType: !24, size: 96, align: 32, offset: 128)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !49, file: !1, line: 89, baseType: !24, size: 96, align: 32, offset: 224)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !49, file: !1, line: 90, baseType: !34, size: 64, align: 32, offset: 320)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "PrimID", scope: !49, file: !1, line: 91, baseType: !43, size: 32, align: 32, offset: 384)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "LODLevel", scope: !49, file: !1, line: 92, baseType: !43, size: 32, align: 32, offset: 416)
!57 = !{!58, !82, !83, !85, !87, !89, !90, !91, !92, !93, !94, !95, !96, !97, !98, !100, !101, !102, !103, !104, !105, !106, !120, !121, !122, !123, !124, !128, !130, !131, !132, !133, !134}
!58 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 26, type: !59, isLocal: false, isDefinition: true)
!59 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !60)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 26, baseType: !61)
!61 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 26, size: 512, align: 32, elements: !62, templateParams: !79)
!62 = !{!63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !61, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!79 = !{!13, !80, !81}
!80 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 4)
!81 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 4)
!82 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 27, type: !59, isLocal: false, isDefinition: true)
!83 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 32, type: !84, isLocal: false, isDefinition: true)
!84 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!85 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 33, type: !86, isLocal: false, isDefinition: true)
!86 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!87 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 34, type: !88, isLocal: false, isDefinition: true)
!88 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!89 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 35, type: !59, isLocal: false, isDefinition: true)
!90 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 40, type: !59, isLocal: false, isDefinition: true)
!91 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 41, type: !59, isLocal: false, isDefinition: true)
!92 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !59, isLocal: false, isDefinition: true)
!93 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 43, type: !59, isLocal: false, isDefinition: true)
!94 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 44, type: !59, isLocal: false, isDefinition: true)
!95 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 45, type: !59, isLocal: false, isDefinition: true)
!96 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 46, type: !86, isLocal: false, isDefinition: true)
!97 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPass@@3MB", scope: !0, file: !1, line: 47, type: !88, isLocal: false, isDefinition: true)
!98 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 48, type: !99, isLocal: false, isDefinition: true)
!99 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !34)
!100 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 49, type: !99, isLocal: false, isDefinition: true)
!101 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 50, type: !88, isLocal: false, isDefinition: true)
!102 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 51, type: !88, isLocal: false, isDefinition: true)
!103 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 52, type: !88, isLocal: false, isDefinition: true)
!104 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 53, type: !88, isLocal: false, isDefinition: true)
!105 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 54, type: !84, isLocal: false, isDefinition: true)
!106 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 56, type: !107, isLocal: false, isDefinition: true)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !108, size: 6144, align: 32, elements: !118)
!108 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !109)
!109 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !110, line: 3, size: 384, align: 32, elements: !111)
!110 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!111 = !{!112, !113, !114, !115, !116, !117}
!112 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !109, file: !110, line: 5, baseType: !24, size: 96, align: 32)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !109, file: !110, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !109, file: !110, line: 7, baseType: !24, size: 96, align: 32, offset: 128)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !109, file: !110, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !109, file: !110, line: 9, baseType: !24, size: 96, align: 32, offset: 256)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !109, file: !110, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!118 = !{!119}
!119 = !DISubrange(count: 16)
!120 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 58, type: !84, isLocal: false, isDefinition: true)
!121 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 59, type: !88, isLocal: false, isDefinition: true)
!122 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 60, type: !88, isLocal: false, isDefinition: true)
!123 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 61, type: !99, isLocal: false, isDefinition: true)
!124 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 15, type: !125, isLocal: false, isDefinition: true)
!125 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 15, size: 160, align: 32, elements: !2, templateParams: !126)
!126 = !{!127}
!127 = !DITemplateTypeParameter(name: "element", type: !5)
!128 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 17, type: !129, isLocal: false, isDefinition: true)
!129 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 17, size: 32, align: 32, elements: !2)
!130 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 18, type: !129, isLocal: false, isDefinition: true)
!131 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 19, type: !129, isLocal: false, isDefinition: true)
!132 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 20, type: !129, isLocal: false, isDefinition: true)
!133 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !129, isLocal: false, isDefinition: true)
!134 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !129, isLocal: false, isDefinition: true)
!135 = !{i32 2, !"Dwarf Version", i32 4}
!136 = !{i32 2, !"Debug Info Version", i32 3}
!137 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!138 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CTask_GS.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerObjectPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct SubVertex\0D\0A{\0D\0A    float3 PosW;\0D\0A    float3 NormalW;\0D\0A    float2 TexC;\0D\0A};\0D\0A\0D\0Astruct GeoOut\0D\0A{\0D\0A    float4 PosH : SV_POSITION;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A    uint PrimID : SV_PrimitiveID;\0D\0A    nointerpolation uint LODLevel : TEXCOORD1;\0D\0A};\0D\0A\0D\0ASubVertex MakeMidVertex(SubVertex a, SubVertex b, float3 centerW, float radius)\0D\0A{\0D\0A    SubVertex r;\0D\0A\0D\0A    float3 p = 0.5f * (a.PosW + b.PosW);\0D\0A    p = centerW + normalize(p - centerW) * radius;\0D\0A\0D\0A    r.PosW = p;\0D\0A    r.NormalW = normalize(r.PosW - centerW);\0D\0A    r.TexC = 0.5f * (a.TexC + b.TexC);\0D\0A\0D\0A    return r;\0D\0A}\0D\0A\0D\0Avoid EmitTriangle(SubVertex a, SubVertex b, SubVertex c, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    GeoOut gout;\0D\0A\0D\0A    gout.PosW = a.PosW;\0D\0A    gout.PosH = mul(float4(a.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = a.NormalW;\0D\0A    gout.TexC = a.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    gout.PosW = b.PosW;\0D\0A    gout.PosH = mul(float4(b.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = b.NormalW;\0D\0A    gout.TexC = b.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    gout.PosW = c.PosW;\0D\0A    gout.PosH = mul(float4(c.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = c.NormalW;\0D\0A    gout.TexC = c.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    triStream.RestartStrip();\0D\0A}\0D\0A\0D\0Avoid SubdivideOnce(SubVertex v0, SubVertex v1, SubVertex v2, float3 centerW, float radius, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);\0D\0A    SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);\0D\0A    SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);\0D\0A\0D\0A    EmitTriangle(v0, m0, m2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m0, m1, m2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m2, m1, v2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m0, v1, m1, primID, lodLevel, triStream);\0D\0A}\0D\0A\0D\0A//\B1\D7\B3\C9 \C6\D0\BD\BA\BD\BA\B7\E7 \BC\CE\C0\CC\B4\F5.\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout;\0D\0A    \0D\0A    float4 posW = mul(float4(vin.PosW, 1.0f), gWorld);\0D\0A    vout.PosW = posW.xyz;\0D\0A    vout.NormalW = mul(vin.NormalL, (float3x3) gWorld);\0D\0A    vout.TexC = vin.TexC;\0D\0A\0D\0A    return vout;\0D\0A}\0D\0A \0D\0A[maxvertexcount(4)]\0D\0Avoid GS(line VertexOut gin[2],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    float3 up = float3(0.0f, 1.0f, 0.0f);\0D\0A    float3 look = gEyePosW - gin[0].PosW;\0D\0A    look.y = 0.0f; //project to xz-plane\0D\0A    look = normalize(look);\0D\0A    float3 right = cross(up, look);\0D\0A\0D\0A    //float halfWidth = 0.5f * gin[0].SizeW.x;\0D\0A    //float halfHeight = 0.5f * gin[0].SizeW.y;\0D\0A\09\0D\0A    float4 v[4];\0D\0A    v[0] = float4(gin[0].PosW, 1.0f);\0D\0A    v[1] = float4(gin[1].PosW, 1.0f);\0D\0A    v[2] = float4(gin[0].PosW + up * 3.0f, 1.0f);\0D\0A    v[3] = float4(gin[1].PosW + up * 3.0f, 1.0f);\0D\0A    \0D\0A    float2 texC[4] =\0D\0A    {\0D\0A        float2(0.0f, 1.0f),\0D\0A\09\09float2(0.0f, 0.0f),\0D\0A\09\09float2(1.0f, 1.0f),\0D\0A\09\09float2(1.0f, 0.0f)\0D\0A    };\0D\0A\09\0D\0A    GeoOut gout;\0D\0A\09[unroll]//\C4\C4\C6\C4\C0\CF\C7\D2 \B6\A7 \B7\E7\C7\C1\B8\A6 \C7\AE\BE\EE\BC\AD \B0\A2 \B9\DD\BA\B9\B8\B6\B4\D9 \BA\B0\B5\B5\C0\C7 \B8\ED\B7\C9\BE\EE\B7\CE \B8\B8\B5\E9\BE\EE\C1\D8\B4\D9. \C0\CC\B7\B8\B0\D4 \C7\CF\B8\E9 GPU\B0\A1 \B8\ED\B7\C9\BE\EE\B8\A6 \B4\F5 \C8\BF\C0\B2\C0\FB\C0\B8\B7\CE \BD\C7\C7\E0\C7\D2 \BC\F6 \C0\D6\B4\D9.\0D\0A    for (int i = 0; i < 4; ++i)\0D\0A    {\0D\0A        gout.PosH = mul(v[i], gViewProj);\0D\0A        gout.PosW = v[i].xyz;\0D\0A        gout.NormalW = look;\0D\0A        gout.TexC = texC[i];\0D\0A        gout.PrimID = primID;\0D\0A        gout.LODLevel = 0;\0D\0A\09\09\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A}\0D\0A\0D\0A\0D\0A[maxvertexcount(48)]\0D\0Avoid GS_LOD(triangle VertexOut gin[3],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    float3 center = (gin[0].PosW + gin[1].PosW + gin[2].PosW) / 3.0f;\0D\0A    float distToEye = distance(gEyePosW, center);\0D\0A    \0D\0A    float3 centerW = mul(float4(0, 0, 0, 1), gWorld).xyz; // \B1\B8 \C1\DF\BD\C9\C0\C7 \BF\F9\B5\E5\C1\C2\C7\A5\0D\0A    float radius = length(gin[0].PosW - centerW);\0D\0A    \0D\0A    SubVertex v0, v1, v2;\0D\0A    v0.PosW = gin[0].PosW;\0D\0A    v0.NormalW = gin[0].NormalW;\0D\0A    v0.TexC = gin[0].TexC;\0D\0A    v1.PosW = gin[1].PosW;\0D\0A    v1.NormalW = gin[1].NormalW;\0D\0A    v1.TexC = gin[1].TexC;\0D\0A    v2.PosW = gin[2].PosW;\0D\0A    v2.NormalW = gin[2].NormalW;\0D\0A    v2.TexC = gin[2].TexC;\0D\0A    \0D\0A    if(distToEye < 15)\0D\0A    {\0D\0A        //1\C2\F7 \BC\BC\BA\D0\C8\AD\BF\A1 \C7\CA\BF\E4\C7\D1 \C1\DF\C1\A1\B5\E9\0D\0A        SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);\0D\0A        SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);\0D\0A        SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);\0D\0A\0D\0A        //1\C2\F7 \BC\BC\BA\D0\C8\AD\B7\CE \B3\AA\BF\C2 4\B0\B3 \BB\EF\B0\A2\C7\FC\C0\BB \B0\A2\B0\A2 \B4\D9\BD\C3 \BC\BC\BA\D0\C8\AD (2\C2\F7 \BC\BC\BA\D0\C8\AD)\0D\0A        SubdivideOnce(v0, m0, m2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m0, m1, m2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m2, m1, v2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m0, v1, m1, centerW, radius, primID, 2, triStream);\0D\0A    }\0D\0A    else if (distToEye >= 15 && distToEye < 25)\0D\0A    {\0D\0A        SubdivideOnce(v0, v1, v2, centerW, radius, primID, 1, triStream);\0D\0A    }\0D\0A    else //distToEye >= 25\0D\0A    {\0D\0A        int vertexNum = 3;\0D\0A        GeoOut gout;\0D\0A\09    [unroll]\0D\0A        for (int i = 0; i < vertexNum; ++i)\0D\0A        {\0D\0A            gout.PosH = mul(float4(gin[i].PosW, 1.0f), gViewProj);\0D\0A            gout.PosW = gin[i].PosW;\0D\0A            gout.NormalW = gin[i].NormalW;\0D\0A            gout.TexC = gin[i].TexC;\0D\0A            gout.PrimID = primID;\0D\0A            gout.LODLevel = 0;\0D\0A\09\09\0D\0A            triStream.Append(gout);\0D\0A        }\0D\0A    }\0D\0A}\0D\0A\0D\0A[maxvertexcount(4)]\0D\0Avoid GS_Explode(triangle VertexOut gin[3],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{    \0D\0A    float rand = frac(sin(primID * 12.9898f) * 758.5453f);\0D\0A    float t = frac(gTotalTime + rand * 0.13f);\0D\0A    \0D\0A    float explodeAmount;\0D\0A    float explodeDuration = 0.95f; // \C6\F8\B9\DF\C0\CC \BF\CF\C0\FC\C8\F7 \C1\F8\C7\E0\B5\C7\B4\C2 \BD\C3\B0\A3\0D\0A    if (t < explodeDuration)\0D\0A    {\0D\0A        float localT = t / explodeDuration; // 0~1\B7\CE \C0\E7\C1\A4\B1\D4\C8\AD\0D\0A        explodeAmount = pow(localT, 18.0f);\0D\0A    }\0D\0A    else\0D\0A        explodeAmount = 1.0f;\0D\0A    \0D\0A    float3 e0 = gin[1].PosW - gin[0].PosW;\0D\0A    float3 e1 = gin[2].PosW - gin[0].PosW;\0D\0A    float3 faceNormal = normalize(cross(e0, e1)) * 2.0f;\0D\0A    \0D\0A    float3 explodeVector = explodeAmount * faceNormal;\0D\0A    \0D\0A    [unroll]\0D\0A    for (int i = 0; i < 3; ++i)\0D\0A    {\0D\0A        GeoOut gout;\0D\0A\0D\0A        float3 newPosW = gin[i].PosW + explodeVector;\0D\0A\0D\0A        gout.PosW = newPosW;\0D\0A        gout.NormalW = faceNormal;\0D\0A        gout.TexC = gin[i].TexC;\0D\0A        gout.PosH = mul(float4(newPosW, 1.0f), gViewProj);\0D\0A        gout.PrimID = primID;\0D\0A        gout.LODLevel = 0;\0D\0A\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A\0D\0A    triStream.RestartStrip();\0D\0A}\0D\0A\0D\0A[maxvertexcount(2)]\0D\0Avoid GS_Debugging(point VertexOut gin[1],\0D\0A                  uint primID : SV_PrimitiveID,\0D\0A                  inout LineStream<GeoOut> lineStream)\0D\0A{\0D\0A    GeoOut gout;\0D\0A\0D\0A    float NormalLength = 0.2f;\0D\0A    float3 p0 = gin[0].PosW;\0D\0A    float3 p1 = gin[0].PosW + gin[0].NormalW * NormalLength;\0D\0A\0D\0A    // \BD\C3\C0\DB\C1\A1\0D\0A    gout.PosW = p0;\0D\0A    gout.NormalW = gin[0].NormalW;\0D\0A    gout.TexC = gin[0].TexC;\0D\0A    gout.PosH = mul(float4(p0, 1.0f), gViewProj);\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = 0;\0D\0A    lineStream.Append(gout);\0D\0A\0D\0A    // \B3\A1\C1\A1\0D\0A    gout.PosW = p1;\0D\0A    gout.NormalW = gin[0].NormalW;\0D\0A    gout.TexC = gin[0].TexC;\0D\0A    gout.PosH = mul(float4(p1, 1.0f), gViewProj);\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = 0;\0D\0A    lineStream.Append(gout);\0D\0A\0D\0A    lineStream.RestartStrip();\0D\0A}\0D\0A\0D\0Afloat4 PS(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 uvw = float3(pin.TexC, pin.PrimID % 3);\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamAnisotropicClamp, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A    if (pin.LODLevel == 2)\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(1.15f, 0.95f, 0.95f); // \BA\D3\C0\BA\B1\E2\0D\0A    }\0D\0A    else if (pin.LODLevel == 1)\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(0.95f, 1.15f, 0.95f); // \C3\CA\B7\CF\B1\E2\0D\0A    }\0D\0A    else\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(0.95f, 0.95f, 1.15f); // \C7\AA\B8\A5\B1\E2\0D\0A    }\0D\0A    \0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A    \0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A#ifdef FOG\0D\0A\09float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A\09litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A    \0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A\0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_VertexNormal(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 normalColor = pin.NormalW * 0.5f + 0.5f;\0D\0A    return float4(normalColor, 1.0f);\0D\0A}"}
!139 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0\E3\84\B4.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrenght = L.Strength * ndotl;\0D\0A    \0D\0A    return BlinnPhong(lightStrenght, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!140 = !{!"FOG=1", !"ALPHA_TEST=1", !"FOG=1", !"ALPHA_TEST=1"}
!141 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CTask_GS.hlsl"}
!142 = !{!"-E", !"GS_Explode", !"-T", !"gs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-D", !"FOG=1", !"-D", !"ALPHA_TEST=1", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CCopyDX\5CCopyDX\5CResource\5CShaders\5CCompiled\5CExplodeGS.cso", !"-D", !"FOG=1", !"-D", !"ALPHA_TEST=1"}
!143 = !{i32 1, i32 0}
!144 = !{i32 1, i32 8}
!145 = !{!"gs", i32 6, i32 0}
!146 = !{null, null, !147, null}
!147 = !{!148}
!148 = !{i32 0, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!149 = !{i32 0, %struct.Light undef, !150, %hostlayout.cbPass undef, !157}
!150 = !{i32 48, !151, !152, !153, !154, !155, !156}
!151 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!152 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!153 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!154 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!155 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!156 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!157 = !{i32 1248, !158, !160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176, !177, !178}
!158 = !{i32 6, !"gView", i32 2, !159, i32 3, i32 0, i32 7, i32 9}
!159 = !{i32 4, i32 4, i32 2}
!160 = !{i32 6, !"gInvView", i32 2, !159, i32 3, i32 64, i32 7, i32 9}
!161 = !{i32 6, !"gProj", i32 2, !159, i32 3, i32 128, i32 7, i32 9}
!162 = !{i32 6, !"gInvProj", i32 2, !159, i32 3, i32 192, i32 7, i32 9}
!163 = !{i32 6, !"gViewProj", i32 2, !159, i32 3, i32 256, i32 7, i32 9}
!164 = !{i32 6, !"gInvViewProj", i32 2, !159, i32 3, i32 320, i32 7, i32 9}
!165 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!166 = !{i32 6, !"cbPerObjectPad1", i32 3, i32 396, i32 7, i32 9}
!167 = !{i32 6, !"gRenderTargetSize", i32 3, i32 400, i32 7, i32 9}
!168 = !{i32 6, !"gInvRenderTargetSize", i32 3, i32 408, i32 7, i32 9}
!169 = !{i32 6, !"gNearZ", i32 3, i32 416, i32 7, i32 9}
!170 = !{i32 6, !"gFarZ", i32 3, i32 420, i32 7, i32 9}
!171 = !{i32 6, !"gTotalTime", i32 3, i32 424, i32 7, i32 9}
!172 = !{i32 6, !"gDeltaTime", i32 3, i32 428, i32 7, i32 9}
!173 = !{i32 6, !"gAmbientLight", i32 3, i32 432, i32 7, i32 9}
!174 = !{i32 6, !"gLights", i32 3, i32 448}
!175 = !{i32 6, !"gFogColor", i32 3, i32 1216, i32 7, i32 9}
!176 = !{i32 6, !"gFogStart", i32 3, i32 1232, i32 7, i32 9}
!177 = !{i32 6, !"gFogRange", i32 3, i32 1236, i32 7, i32 9}
!178 = !{i32 6, !"cbPerObjectPad2", i32 3, i32 1240, i32 7, i32 9}
!179 = !{i32 1, void ()* @GS_Explode, !180}
!180 = !{!181}
!181 = !{i32 0, !2, !2}
!182 = !{[15 x i32] [i32 10, i32 21, i32 1919, i32 1919, i32 1919, i32 0, i32 0, i32 0, i32 0, i32 0, i32 4096, i32 8192, i32 0, i32 0, i32 0]}
!183 = !{void ()* @GS_Explode, !"GS_Explode", !184, !146, !203}
!184 = !{!185, !193, null}
!185 = !{!186, !189, !190, !192}
!186 = !{i32 0, !"POSITION", i8 9, i8 0, !187, i8 2, i32 1, i8 3, i32 0, i8 0, !188}
!187 = !{i32 0}
!188 = !{i32 3, i32 7}
!189 = !{i32 1, !"NORMAL", i8 9, i8 0, !187, i8 2, i32 1, i8 3, i32 1, i8 0, null}
!190 = !{i32 2, !"TEXCOORD", i8 9, i8 0, !187, i8 2, i32 1, i8 2, i32 2, i8 0, !191}
!191 = !{i32 3, i32 3}
!192 = !{i32 3, !"SV_PrimitiveID", i8 5, i8 10, !187, i8 0, i32 1, i8 1, i32 -1, i8 -1, null}
!193 = !{!194, !196, !197, !198, !199, !201}
!194 = !{i32 0, !"SV_Position", i8 9, i8 3, !187, i8 4, i32 1, i8 4, i32 0, i8 0, !195}
!195 = !{i32 3, i32 15}
!196 = !{i32 1, !"POSITION", i8 9, i8 0, !187, i8 2, i32 1, i8 3, i32 1, i8 0, !188}
!197 = !{i32 2, !"NORMAL", i8 9, i8 0, !187, i8 2, i32 1, i8 3, i32 2, i8 0, !188}
!198 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !187, i8 2, i32 1, i8 2, i32 3, i8 0, !191}
!199 = !{i32 4, !"SV_PrimitiveID", i8 5, i8 10, !187, i8 1, i32 1, i8 1, i32 4, i8 0, !200}
!200 = !{i32 3, i32 1}
!201 = !{i32 5, !"TEXCOORD", i8 5, i8 0, !202, i8 1, i32 1, i8 1, i32 5, i8 0, !200}
!202 = !{i32 1}
!203 = !{i32 0, i64 1, i32 1, !204}
!204 = !{i32 3, i32 4, i32 1, i32 5, i32 1}
!205 = !DILocation(line: 268, column: 36, scope: !17)
!206 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "primID", arg: 2, scope: !17, file: !1, line: 269, type: !43)
!207 = !DIExpression()
!208 = !DILocation(line: 269, column: 14, scope: !17)
!209 = !DILocation(line: 272, column: 27, scope: !17)
!210 = !DILocation(line: 272, column: 34, scope: !17)
!211 = !DILocation(line: 272, column: 23, scope: !17)
!212 = !DILocation(line: 272, column: 46, scope: !17)
!213 = !DILocation(line: 272, column: 18, scope: !17)
!214 = !DILocation(line: 272, column: 11, scope: !17)
!215 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "rand", scope: !17, file: !1, line: 272, type: !8)
!216 = !DILocation(line: 273, column: 20, scope: !17)
!217 = !DILocation(line: 273, column: 38, scope: !17)
!218 = !DILocation(line: 273, column: 31, scope: !17)
!219 = !DILocation(line: 273, column: 15, scope: !17)
!220 = !DILocation(line: 273, column: 11, scope: !17)
!221 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "t", scope: !17, file: !1, line: 273, type: !8)
!222 = !DILocation(line: 276, column: 11, scope: !17)
!223 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "explodeDuration", scope: !17, file: !1, line: 276, type: !8)
!224 = !DILocation(line: 277, column: 11, scope: !225)
!225 = distinct !DILexicalBlock(scope: !17, file: !1, line: 277, column: 9)
!226 = !DILocation(line: 277, column: 9, scope: !17)
!227 = !DILocation(line: 279, column: 26, scope: !228)
!228 = distinct !DILexicalBlock(scope: !225, file: !1, line: 278, column: 5)
!229 = !DILocation(line: 279, column: 15, scope: !228)
!230 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "localT", scope: !228, file: !1, line: 279, type: !8)
!231 = !DILocation(line: 280, column: 25, scope: !228)
!232 = !DILocation(line: 280, column: 23, scope: !228)
!233 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "explodeAmount", scope: !17, file: !1, line: 275, type: !8)
!234 = !DILocation(line: 275, column: 11, scope: !17)
!235 = !DILocation(line: 281, column: 5, scope: !228)
!236 = !DILocation(line: 283, column: 23, scope: !225)
!237 = !DILocation(line: 285, column: 24, scope: !17)
!238 = !DILocation(line: 285, column: 38, scope: !17)
!239 = !DILocation(line: 285, column: 29, scope: !17)
!240 = !DILocation(line: 285, column: 12, scope: !17)
!241 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "e0", scope: !17, file: !1, line: 285, type: !24)
!242 = !DIExpression(DW_OP_bit_piece, 0, 32)
!243 = !DIExpression(DW_OP_bit_piece, 32, 32)
!244 = !DIExpression(DW_OP_bit_piece, 64, 32)
!245 = !DILocation(line: 286, column: 24, scope: !17)
!246 = !DILocation(line: 286, column: 38, scope: !17)
!247 = !DILocation(line: 286, column: 29, scope: !17)
!248 = !DILocation(line: 286, column: 12, scope: !17)
!249 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "e1", scope: !17, file: !1, line: 286, type: !24)
!250 = !DILocation(line: 287, column: 35, scope: !17)
!251 = !DILocation(line: 287, column: 25, scope: !17)
!252 = !DILocation(line: 287, column: 50, scope: !17)
!253 = !DILocation(line: 287, column: 12, scope: !17)
!254 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "faceNormal", scope: !17, file: !1, line: 287, type: !24)
!255 = !DILocation(line: 289, column: 42, scope: !17)
!256 = !DILocation(line: 289, column: 12, scope: !17)
!257 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "explodeVector", scope: !17, file: !1, line: 289, type: !24)
!258 = !DILocation(line: 292, column: 14, scope: !259)
!259 = distinct !DILexicalBlock(scope: !17, file: !1, line: 292, column: 5)
!260 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !259, file: !1, line: 292, type: !15)
!261 = !DILocation(line: 292, column: 5, scope: !259)
!262 = !DILocation(line: 296, column: 33, scope: !263)
!263 = distinct !DILexicalBlock(scope: !264, file: !1, line: 293, column: 5)
!264 = distinct !DILexicalBlock(scope: !259, file: !1, line: 292, column: 5)
!265 = !DILocation(line: 296, column: 38, scope: !263)
!266 = !DILocation(line: 296, column: 16, scope: !263)
!267 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "newPosW", scope: !263, file: !1, line: 296, type: !24)
!268 = !DILocation(line: 298, column: 19, scope: !263)
!269 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "gout", scope: !263, file: !1, line: 294, type: !49)
!270 = !DIExpression(DW_OP_bit_piece, 128, 32)
!271 = !DILocation(line: 294, column: 16, scope: !263)
!272 = !DIExpression(DW_OP_bit_piece, 160, 32)
!273 = !DIExpression(DW_OP_bit_piece, 192, 32)
!274 = !DILocation(line: 299, column: 22, scope: !263)
!275 = !DIExpression(DW_OP_bit_piece, 224, 32)
!276 = !DIExpression(DW_OP_bit_piece, 256, 32)
!277 = !DIExpression(DW_OP_bit_piece, 288, 32)
!278 = !DILocation(line: 300, column: 28, scope: !263)
!279 = !DILocation(line: 300, column: 19, scope: !263)
!280 = !DIExpression(DW_OP_bit_piece, 320, 32)
!281 = !DIExpression(DW_OP_bit_piece, 352, 32)
!282 = !DILocation(line: 301, column: 48, scope: !263)
!283 = !DILocation(line: 301, column: 21, scope: !263)
!284 = !DILocation(line: 301, column: 19, scope: !263)
!285 = !DIExpression(DW_OP_bit_piece, 96, 32)
!286 = !DILocation(line: 302, column: 21, scope: !263)
!287 = !DIExpression(DW_OP_bit_piece, 384, 32)
!288 = !DILocation(line: 303, column: 23, scope: !263)
!289 = !DIExpression(DW_OP_bit_piece, 416, 32)
!290 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "triStream", arg: 3, scope: !17, file: !1, line: 270, type: !46)
!291 = !DILocation(line: 305, column: 9, scope: !263)
!292 = !DILocation(line: 306, column: 5, scope: !263)
!293 = !DILocation(line: 292, column: 28, scope: !264)
!294 = distinct !{!294, !295}
!295 = !{!"llvm.loop.unroll.full"}
!296 = !DILocation(line: 308, column: 5, scope: !17)
!297 = !DILocation(line: 309, column: 1, scope: !17)
