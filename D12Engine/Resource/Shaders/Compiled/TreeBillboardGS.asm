;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   xyz 
; SIZE                     0   xy          1     NONE   float   xy  
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
;
; shader debug name: 9969f129f4e7ec24409992a11ac1808a.pdb
; shader hash: 9969f129f4e7ec24409992a11ac1808a
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Geometry Shader
; InputPrimitive=point
; OutputTopology=triangle
; OutputStreamMask=1
; OutputPositionPresent=1
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 3
; SigOutputElements: 5
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 2
; SigOutputVectors[0]: 5
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: GS
;
;
; Input signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; POSITION                 0                 linear       
; SIZE                     0                 linear       
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
; Number of inputs: 6, outputs per stream: { 17, 0, 0, 0 }
; Outputs for Stream 0 dependent on ViewId: {  }
; Inputs contributing to computation of Outputs for Stream 0:
;   output 0 depends on inputs: { 0, 1, 2, 4, 5 }
;   output 1 depends on inputs: { 0, 1, 2, 4, 5 }
;   output 2 depends on inputs: { 0, 1, 2, 4, 5 }
;   output 3 depends on inputs: { 0, 1, 2, 4, 5 }
;   output 4 depends on inputs: { 0, 2, 4 }
;   output 5 depends on inputs: { 1, 5 }
;   output 6 depends on inputs: { 0, 2, 4 }
;   output 8 depends on inputs: { 0, 2 }
;   output 10 depends on inputs: { 0, 2 }
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.CBufRet.f32 = type { float, float, float, float }
%hostlayout.cbPass = type { [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], [4 x <4 x float>], <3 x float>, float, <2 x float>, <2 x float>, float, float, float, float, <4 x float>, [16 x %struct.Light], <4 x float>, float, float, <2 x float> }
%struct.Light = type { <3 x float>, float, <3 x float>, float, <3 x float>, float }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

define void @GS() {
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 2, i1 false), !dbg !199 ; line:100 col:38  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call i32 @dx.op.primitiveID.i32(i32 108), !dbg !199 ; line:100 col:38  ; PrimitiveID()
  %texC.0 = alloca [4 x float], !dbg !199 ; line:100 col:38
  %texC.1 = alloca [4 x float], !dbg !199 ; line:100 col:38
  %v.0 = alloca [4 x float], !dbg !199 ; line:100 col:38
  %v.1 = alloca [4 x float], !dbg !199 ; line:100 col:38
  %v.2 = alloca [4 x float], !dbg !199 ; line:100 col:38
  %v.3 = alloca [4 x float], !dbg !199 ; line:100 col:38
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !200, metadata !201), !dbg !202 ; var:"primID" !DIExpression() func:"GS"
  %2 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !203 ; line:104 col:12
  call void @llvm.dbg.value(metadata <3 x float> <float 0.000000e+00, float 1.000000e+00, float 0.000000e+00>, i64 0, metadata !204, metadata !201), !dbg !203 ; var:"up" !DIExpression() func:"GS"
  %3 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 24), !dbg !205 ; line:105 col:19  ; CBufferLoadLegacy(handle,regIndex)
  %4 = extractvalue %dx.types.CBufRet.f32 %3, 0, !dbg !205 ; line:105 col:19
  %5 = extractvalue %dx.types.CBufRet.f32 %3, 2, !dbg !205 ; line:105 col:19
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !206 ; line:105 col:37  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !206 ; line:105 col:37  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i0 = fsub fast float %4, %6, !dbg !207 ; line:105 col:28
  %.i2 = fsub fast float %5, %7, !dbg !207 ; line:105 col:28
  %8 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !208 ; line:105 col:12
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !209, metadata !210), !dbg !208 ; var:"look" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !209, metadata !211), !dbg !208 ; var:"look" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  %9 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !212 ; line:106 col:12
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !209, metadata !210), !dbg !208 ; var:"look" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !209, metadata !213), !dbg !208 ; var:"look" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !209, metadata !211), !dbg !208 ; var:"look" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  %10 = call float @dx.op.dot3.f32(i32 55, float %.i0, float 0.000000e+00, float %.i2, float %.i0, float 0.000000e+00, float %.i2), !dbg !214 ; line:107 col:12  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt = call float @dx.op.unary.f32(i32 25, float %10), !dbg !214 ; line:107 col:12  ; Rsqrt(value)
  %.i031 = fmul fast float %.i0, %Rsqrt, !dbg !214 ; line:107 col:12
  %.i234 = fmul fast float %.i2, %Rsqrt, !dbg !214 ; line:107 col:12
  %11 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !215 ; line:107 col:10
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !209, metadata !210), !dbg !208 ; var:"look" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !209, metadata !213), !dbg !208 ; var:"look" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !209, metadata !211), !dbg !208 ; var:"look" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  %12 = fmul fast float 1.000000e+00, %.i234, !dbg !216 ; line:108 col:20
  %13 = fsub fast float %12, 0.000000e+00, !dbg !216 ; line:108 col:20
  %14 = fmul fast float 1.000000e+00, %.i031, !dbg !216 ; line:108 col:20
  %15 = fsub fast float 0.000000e+00, %14, !dbg !216 ; line:108 col:20
  %16 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !217 ; line:108 col:12
  call void @llvm.dbg.value(metadata float %13, i64 0, metadata !218, metadata !210), !dbg !217 ; var:"right" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !218, metadata !213), !dbg !217 ; var:"right" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %15, i64 0, metadata !218, metadata !211), !dbg !217 ; var:"right" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  %17 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 0), !dbg !219 ; line:110 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %18 = fmul fast float 5.000000e-01, %17, !dbg !220 ; line:110 col:28
  %19 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !221 ; line:110 col:11
  call void @llvm.dbg.value(metadata float %18, i64 0, metadata !222, metadata !201), !dbg !221 ; var:"halfWidth" !DIExpression() func:"GS"
  %20 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 0), !dbg !223 ; line:111 col:31  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %21 = fmul fast float 5.000000e-01, %20, !dbg !224 ; line:111 col:29
  %22 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !225 ; line:111 col:11
  call void @llvm.dbg.value(metadata float %21, i64 0, metadata !226, metadata !201), !dbg !225 ; var:"halfHeight" !DIExpression() func:"GS"
  call void @llvm.dbg.declare(metadata [4 x float]* %v.0, metadata !227, metadata !210), !dbg !231, !dx.dbg.varlayout !232 ; var:"v" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.declare(metadata [4 x float]* %v.1, metadata !227, metadata !213), !dbg !231, !dx.dbg.varlayout !233 ; var:"v" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.declare(metadata [4 x float]* %v.2, metadata !227, metadata !211), !dbg !231, !dx.dbg.varlayout !234 ; var:"v" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.declare(metadata [4 x float]* %v.3, metadata !227, metadata !235), !dbg !231, !dx.dbg.varlayout !236 ; var:"v" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %23 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !237 ; line:114 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %24 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !237 ; line:114 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %25 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !237 ; line:114 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i035 = fmul fast float %18, %13, !dbg !238 ; line:114 col:46
  %.i237 = fmul fast float %18, %15, !dbg !238 ; line:114 col:46
  %.i038 = fadd fast float %23, %.i035, !dbg !239 ; line:114 col:34
  %.i139 = fadd fast float %24, 0.000000e+00, !dbg !239 ; line:114 col:34
  %.i240 = fadd fast float %25, %.i237, !dbg !239 ; line:114 col:34
  %.i144 = fmul fast float %21, 1.000000e+00, !dbg !240 ; line:114 col:67
  %.i047 = fsub fast float %.i038, 0.000000e+00, !dbg !241 ; line:114 col:54
  %.i148 = fsub fast float %.i139, %.i144, !dbg !241 ; line:114 col:54
  %.i249 = fsub fast float %.i240, 0.000000e+00, !dbg !241 ; line:114 col:54
  %26 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 0, !dbg !242 ; line:114 col:5
  %27 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 0, !dbg !242 ; line:114 col:5
  %28 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 0, !dbg !242 ; line:114 col:5
  %29 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 0, !dbg !242 ; line:114 col:5
  %30 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !243 ; line:114 col:10
  store float %.i047, float* %26, !dbg !243 ; line:114 col:10
  store float %.i148, float* %27, !dbg !243 ; line:114 col:10
  store float %.i249, float* %28, !dbg !243 ; line:114 col:10
  store float 1.000000e+00, float* %29, !dbg !243 ; line:114 col:10
  %31 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !244 ; line:115 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %32 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !244 ; line:115 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %33 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !244 ; line:115 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i050 = fmul fast float %18, %13, !dbg !245 ; line:115 col:46
  %.i252 = fmul fast float %18, %15, !dbg !245 ; line:115 col:46
  %.i053 = fadd fast float %31, %.i050, !dbg !246 ; line:115 col:34
  %.i154 = fadd fast float %32, 0.000000e+00, !dbg !246 ; line:115 col:34
  %.i255 = fadd fast float %33, %.i252, !dbg !246 ; line:115 col:34
  %.i159 = fmul fast float %21, 1.000000e+00, !dbg !247 ; line:115 col:67
  %.i062 = fadd fast float %.i053, 0.000000e+00, !dbg !248 ; line:115 col:54
  %.i163 = fadd fast float %.i154, %.i159, !dbg !248 ; line:115 col:54
  %.i264 = fadd fast float %.i255, 0.000000e+00, !dbg !248 ; line:115 col:54
  %34 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 1, !dbg !249 ; line:115 col:5
  %35 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 1, !dbg !249 ; line:115 col:5
  %36 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 1, !dbg !249 ; line:115 col:5
  %37 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 1, !dbg !249 ; line:115 col:5
  %38 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !250 ; line:115 col:10
  store float %.i062, float* %34, !dbg !250 ; line:115 col:10
  store float %.i163, float* %35, !dbg !250 ; line:115 col:10
  store float %.i264, float* %36, !dbg !250 ; line:115 col:10
  store float 1.000000e+00, float* %37, !dbg !250 ; line:115 col:10
  %39 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !251 ; line:116 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %40 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !251 ; line:116 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %41 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !251 ; line:116 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i065 = fmul fast float %18, %13, !dbg !252 ; line:116 col:46
  %.i267 = fmul fast float %18, %15, !dbg !252 ; line:116 col:46
  %.i068 = fsub fast float %39, %.i065, !dbg !253 ; line:116 col:34
  %.i169 = fsub fast float %40, 0.000000e+00, !dbg !253 ; line:116 col:34
  %.i270 = fsub fast float %41, %.i267, !dbg !253 ; line:116 col:34
  %.i174 = fmul fast float %21, 1.000000e+00, !dbg !254 ; line:116 col:67
  %.i077 = fsub fast float %.i068, 0.000000e+00, !dbg !255 ; line:116 col:54
  %.i178 = fsub fast float %.i169, %.i174, !dbg !255 ; line:116 col:54
  %.i279 = fsub fast float %.i270, 0.000000e+00, !dbg !255 ; line:116 col:54
  %42 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 2, !dbg !256 ; line:116 col:5
  %43 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 2, !dbg !256 ; line:116 col:5
  %44 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 2, !dbg !256 ; line:116 col:5
  %45 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 2, !dbg !256 ; line:116 col:5
  %46 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !257 ; line:116 col:10
  store float %.i077, float* %42, !dbg !257 ; line:116 col:10
  store float %.i178, float* %43, !dbg !257 ; line:116 col:10
  store float %.i279, float* %44, !dbg !257 ; line:116 col:10
  store float 1.000000e+00, float* %45, !dbg !257 ; line:116 col:10
  %47 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !258 ; line:117 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %48 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !258 ; line:117 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %49 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !258 ; line:117 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i080 = fmul fast float %18, %13, !dbg !259 ; line:117 col:46
  %.i282 = fmul fast float %18, %15, !dbg !259 ; line:117 col:46
  %.i083 = fsub fast float %47, %.i080, !dbg !260 ; line:117 col:34
  %.i184 = fsub fast float %48, 0.000000e+00, !dbg !260 ; line:117 col:34
  %.i285 = fsub fast float %49, %.i282, !dbg !260 ; line:117 col:34
  %.i189 = fmul fast float %21, 1.000000e+00, !dbg !261 ; line:117 col:67
  %.i092 = fadd fast float %.i083, 0.000000e+00, !dbg !262 ; line:117 col:54
  %.i193 = fadd fast float %.i184, %.i189, !dbg !262 ; line:117 col:54
  %.i294 = fadd fast float %.i285, 0.000000e+00, !dbg !262 ; line:117 col:54
  %50 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 3, !dbg !263 ; line:117 col:5
  %51 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 3, !dbg !263 ; line:117 col:5
  %52 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 3, !dbg !263 ; line:117 col:5
  %53 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 3, !dbg !263 ; line:117 col:5
  %54 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !264 ; line:117 col:10
  store float %.i092, float* %50, !dbg !264 ; line:117 col:10
  store float %.i193, float* %51, !dbg !264 ; line:117 col:10
  store float %.i294, float* %52, !dbg !264 ; line:117 col:10
  store float 1.000000e+00, float* %53, !dbg !264 ; line:117 col:10
  call void @llvm.dbg.declare(metadata [4 x float]* %texC.0, metadata !265, metadata !210), !dbg !267, !dx.dbg.varlayout !268 ; var:"texC" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.declare(metadata [4 x float]* %texC.1, metadata !265, metadata !213), !dbg !267, !dx.dbg.varlayout !269 ; var:"texC" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  %55 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 0, !dbg !270 ; line:120 col:5
  %56 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 0, !dbg !270 ; line:120 col:5
  %57 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !270 ; line:120 col:5
  store float 0.000000e+00, float* %55, !dbg !270 ; line:120 col:5
  store float 1.000000e+00, float* %56, !dbg !270 ; line:120 col:5
  %58 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 1, !dbg !270 ; line:120 col:5
  %59 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 1, !dbg !270 ; line:120 col:5
  %60 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !270 ; line:120 col:5
  store float 0.000000e+00, float* %58, !dbg !270 ; line:120 col:5
  store float 0.000000e+00, float* %59, !dbg !270 ; line:120 col:5
  %61 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 2, !dbg !270 ; line:120 col:5
  %62 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 2, !dbg !270 ; line:120 col:5
  %63 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !270 ; line:120 col:5
  store float 1.000000e+00, float* %61, !dbg !270 ; line:120 col:5
  store float 1.000000e+00, float* %62, !dbg !270 ; line:120 col:5
  %64 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 3, !dbg !270 ; line:120 col:5
  %65 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 3, !dbg !270 ; line:120 col:5
  %66 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !270 ; line:120 col:5
  store float 1.000000e+00, float* %64, !dbg !270 ; line:120 col:5
  store float 0.000000e+00, float* %65, !dbg !270 ; line:120 col:5
  %67 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !271 ; line:129 col:14
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !273, metadata !201), !dbg !271 ; var:"i" !DIExpression() func:"GS"
  br label %.lr.ph, !dbg !274 ; line:129 col:5

.lr.ph:                                           ; preds = %0
  br label %68, !dbg !274 ; line:129 col:5

; <label>:68                                      ; preds = %.lr.ph
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !273, metadata !201), !dbg !271 ; var:"i" !DIExpression() func:"GS"
  %69 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %70 = extractvalue %dx.types.CBufRet.f32 %69, 0, !dbg !275 ; line:131 col:31
  %71 = extractvalue %dx.types.CBufRet.f32 %69, 1, !dbg !275 ; line:131 col:31
  %72 = extractvalue %dx.types.CBufRet.f32 %69, 2, !dbg !275 ; line:131 col:31
  %73 = extractvalue %dx.types.CBufRet.f32 %69, 3, !dbg !275 ; line:131 col:31
  %74 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %75 = extractvalue %dx.types.CBufRet.f32 %74, 0, !dbg !275 ; line:131 col:31
  %76 = extractvalue %dx.types.CBufRet.f32 %74, 1, !dbg !275 ; line:131 col:31
  %77 = extractvalue %dx.types.CBufRet.f32 %74, 2, !dbg !275 ; line:131 col:31
  %78 = extractvalue %dx.types.CBufRet.f32 %74, 3, !dbg !275 ; line:131 col:31
  %79 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %80 = extractvalue %dx.types.CBufRet.f32 %79, 0, !dbg !275 ; line:131 col:31
  %81 = extractvalue %dx.types.CBufRet.f32 %79, 1, !dbg !275 ; line:131 col:31
  %82 = extractvalue %dx.types.CBufRet.f32 %79, 2, !dbg !275 ; line:131 col:31
  %83 = extractvalue %dx.types.CBufRet.f32 %79, 3, !dbg !275 ; line:131 col:31
  %84 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %85 = extractvalue %dx.types.CBufRet.f32 %84, 0, !dbg !275 ; line:131 col:31
  %86 = extractvalue %dx.types.CBufRet.f32 %84, 1, !dbg !275 ; line:131 col:31
  %87 = extractvalue %dx.types.CBufRet.f32 %84, 2, !dbg !275 ; line:131 col:31
  %88 = extractvalue %dx.types.CBufRet.f32 %84, 3, !dbg !275 ; line:131 col:31
  %89 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 0, !dbg !278 ; line:131 col:25
  %90 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 0, !dbg !278 ; line:131 col:25
  %91 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 0, !dbg !278 ; line:131 col:25
  %92 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 0, !dbg !278 ; line:131 col:25
  %load7.108 = load float, float* %89, !dbg !278 ; line:131 col:25
  %load9.109 = load float, float* %90, !dbg !278 ; line:131 col:25
  %load11.110 = load float, float* %91, !dbg !278 ; line:131 col:25
  %load13.111 = load float, float* %92, !dbg !278 ; line:131 col:25
  %93 = fmul fast float %load7.108, %70, !dbg !279 ; line:131 col:21
  %FMad29.112 = call float @dx.op.tertiary.f32(i32 46, float %load9.109, float %71, float %93), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad28.113 = call float @dx.op.tertiary.f32(i32 46, float %load11.110, float %72, float %FMad29.112), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad27.114 = call float @dx.op.tertiary.f32(i32 46, float %load13.111, float %73, float %FMad28.113), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %94 = fmul fast float %load7.108, %75, !dbg !279 ; line:131 col:21
  %FMad26.115 = call float @dx.op.tertiary.f32(i32 46, float %load9.109, float %76, float %94), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad25.116 = call float @dx.op.tertiary.f32(i32 46, float %load11.110, float %77, float %FMad26.115), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad24.117 = call float @dx.op.tertiary.f32(i32 46, float %load13.111, float %78, float %FMad25.116), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %95 = fmul fast float %load7.108, %80, !dbg !279 ; line:131 col:21
  %FMad23.118 = call float @dx.op.tertiary.f32(i32 46, float %load9.109, float %81, float %95), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad22.119 = call float @dx.op.tertiary.f32(i32 46, float %load11.110, float %82, float %FMad23.118), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad21.120 = call float @dx.op.tertiary.f32(i32 46, float %load13.111, float %83, float %FMad22.119), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %96 = fmul fast float %load7.108, %85, !dbg !279 ; line:131 col:21
  %FMad20.121 = call float @dx.op.tertiary.f32(i32 46, float %load9.109, float %86, float %96), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad19.122 = call float @dx.op.tertiary.f32(i32 46, float %load11.110, float %87, float %FMad20.121), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad.123 = call float @dx.op.tertiary.f32(i32 46, float %load13.111, float %88, float %FMad19.122), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %97 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !280 ; line:131 col:19
  call void @llvm.dbg.value(metadata float %FMad27.114, i64 0, metadata !281, metadata !210), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.117, i64 0, metadata !281, metadata !213), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.120, i64 0, metadata !281, metadata !211), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.123, i64 0, metadata !281, metadata !235), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %98 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 0, !dbg !283 ; line:132 col:21
  %99 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 0, !dbg !283 ; line:132 col:21
  %100 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 0, !dbg !283 ; line:132 col:21
  %load.124 = load float, float* %98, !dbg !283 ; line:132 col:21
  %load1.125 = load float, float* %99, !dbg !283 ; line:132 col:21
  %load3.126 = load float, float* %100, !dbg !283 ; line:132 col:21
  %101 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:132 col:19
  call void @llvm.dbg.value(metadata float %load.124, i64 0, metadata !281, metadata !285), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.125, i64 0, metadata !281, metadata !286), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.126, i64 0, metadata !281, metadata !287), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  %102 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:133 col:22
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !281, metadata !289), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !281, metadata !290), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !281, metadata !291), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  %103 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 0, !dbg !292 ; line:134 col:21
  %104 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 0, !dbg !292 ; line:134 col:21
  %load15.128 = load float, float* %103, !dbg !292 ; line:134 col:21
  %load17.129 = load float, float* %104, !dbg !292 ; line:134 col:21
  %105 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:134 col:19
  call void @llvm.dbg.value(metadata float %load15.128, i64 0, metadata !281, metadata !294), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.129, i64 0, metadata !281, metadata !295), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  %106 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !296 ; line:135 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !281, metadata !297), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad27.114, i64 0, metadata !298, metadata !210), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.117, i64 0, metadata !298, metadata !213), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.120, i64 0, metadata !298, metadata !211), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.123, i64 0, metadata !298, metadata !235), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad27.114), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad24.117), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad21.120), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.123), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load.124, i64 0, metadata !298, metadata !285), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.125, i64 0, metadata !298, metadata !286), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.126, i64 0, metadata !298, metadata !287), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %load.124), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %load1.125), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %load3.126), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !298, metadata !289), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !298, metadata !290), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !298, metadata !291), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i031), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float 0.000000e+00), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i234), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load15.128, i64 0, metadata !298, metadata !294), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.129, i64 0, metadata !298, metadata !295), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %load15.128), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %load17.129), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !298, metadata !297), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !299 ; line:137 col:9  ; EmitStream(streamId)
  br label %107, !dbg !300 ; line:138 col:5

; <label>:107                                     ; preds = %68
  %108 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !301 ; line:129 col:28
  call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !273, metadata !201), !dbg !271 ; var:"i" !DIExpression() func:"GS"
  br label %109, !dbg !274, !llvm.loop !302 ; line:129 col:5

; <label>:109                                     ; preds = %107
  call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !273, metadata !201), !dbg !271 ; var:"i" !DIExpression() func:"GS"
  %110 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %111 = extractvalue %dx.types.CBufRet.f32 %110, 0, !dbg !275 ; line:131 col:31
  %112 = extractvalue %dx.types.CBufRet.f32 %110, 1, !dbg !275 ; line:131 col:31
  %113 = extractvalue %dx.types.CBufRet.f32 %110, 2, !dbg !275 ; line:131 col:31
  %114 = extractvalue %dx.types.CBufRet.f32 %110, 3, !dbg !275 ; line:131 col:31
  %115 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %116 = extractvalue %dx.types.CBufRet.f32 %115, 0, !dbg !275 ; line:131 col:31
  %117 = extractvalue %dx.types.CBufRet.f32 %115, 1, !dbg !275 ; line:131 col:31
  %118 = extractvalue %dx.types.CBufRet.f32 %115, 2, !dbg !275 ; line:131 col:31
  %119 = extractvalue %dx.types.CBufRet.f32 %115, 3, !dbg !275 ; line:131 col:31
  %120 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %121 = extractvalue %dx.types.CBufRet.f32 %120, 0, !dbg !275 ; line:131 col:31
  %122 = extractvalue %dx.types.CBufRet.f32 %120, 1, !dbg !275 ; line:131 col:31
  %123 = extractvalue %dx.types.CBufRet.f32 %120, 2, !dbg !275 ; line:131 col:31
  %124 = extractvalue %dx.types.CBufRet.f32 %120, 3, !dbg !275 ; line:131 col:31
  %125 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %126 = extractvalue %dx.types.CBufRet.f32 %125, 0, !dbg !275 ; line:131 col:31
  %127 = extractvalue %dx.types.CBufRet.f32 %125, 1, !dbg !275 ; line:131 col:31
  %128 = extractvalue %dx.types.CBufRet.f32 %125, 2, !dbg !275 ; line:131 col:31
  %129 = extractvalue %dx.types.CBufRet.f32 %125, 3, !dbg !275 ; line:131 col:31
  %130 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 1, !dbg !278 ; line:131 col:25
  %131 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 1, !dbg !278 ; line:131 col:25
  %132 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 1, !dbg !278 ; line:131 col:25
  %133 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 1, !dbg !278 ; line:131 col:25
  %load7.131 = load float, float* %130, !dbg !278 ; line:131 col:25
  %load9.132 = load float, float* %131, !dbg !278 ; line:131 col:25
  %load11.133 = load float, float* %132, !dbg !278 ; line:131 col:25
  %load13.134 = load float, float* %133, !dbg !278 ; line:131 col:25
  %134 = fmul fast float %load7.131, %111, !dbg !279 ; line:131 col:21
  %FMad29.135 = call float @dx.op.tertiary.f32(i32 46, float %load9.132, float %112, float %134), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad28.136 = call float @dx.op.tertiary.f32(i32 46, float %load11.133, float %113, float %FMad29.135), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad27.137 = call float @dx.op.tertiary.f32(i32 46, float %load13.134, float %114, float %FMad28.136), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %135 = fmul fast float %load7.131, %116, !dbg !279 ; line:131 col:21
  %FMad26.138 = call float @dx.op.tertiary.f32(i32 46, float %load9.132, float %117, float %135), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad25.139 = call float @dx.op.tertiary.f32(i32 46, float %load11.133, float %118, float %FMad26.138), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad24.140 = call float @dx.op.tertiary.f32(i32 46, float %load13.134, float %119, float %FMad25.139), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %136 = fmul fast float %load7.131, %121, !dbg !279 ; line:131 col:21
  %FMad23.141 = call float @dx.op.tertiary.f32(i32 46, float %load9.132, float %122, float %136), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad22.142 = call float @dx.op.tertiary.f32(i32 46, float %load11.133, float %123, float %FMad23.141), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad21.143 = call float @dx.op.tertiary.f32(i32 46, float %load13.134, float %124, float %FMad22.142), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %137 = fmul fast float %load7.131, %126, !dbg !279 ; line:131 col:21
  %FMad20.144 = call float @dx.op.tertiary.f32(i32 46, float %load9.132, float %127, float %137), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad19.145 = call float @dx.op.tertiary.f32(i32 46, float %load11.133, float %128, float %FMad20.144), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad.146 = call float @dx.op.tertiary.f32(i32 46, float %load13.134, float %129, float %FMad19.145), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %138 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !280 ; line:131 col:19
  call void @llvm.dbg.value(metadata float %FMad27.137, i64 0, metadata !281, metadata !210), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.140, i64 0, metadata !281, metadata !213), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.143, i64 0, metadata !281, metadata !211), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.146, i64 0, metadata !281, metadata !235), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %139 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 1, !dbg !283 ; line:132 col:21
  %140 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 1, !dbg !283 ; line:132 col:21
  %141 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 1, !dbg !283 ; line:132 col:21
  %load.147 = load float, float* %139, !dbg !283 ; line:132 col:21
  %load1.148 = load float, float* %140, !dbg !283 ; line:132 col:21
  %load3.149 = load float, float* %141, !dbg !283 ; line:132 col:21
  %142 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:132 col:19
  call void @llvm.dbg.value(metadata float %load.147, i64 0, metadata !281, metadata !285), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.148, i64 0, metadata !281, metadata !286), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.149, i64 0, metadata !281, metadata !287), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  %143 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:133 col:22
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !281, metadata !289), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !281, metadata !290), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !281, metadata !291), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  %144 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 1, !dbg !292 ; line:134 col:21
  %145 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 1, !dbg !292 ; line:134 col:21
  %load15.151 = load float, float* %144, !dbg !292 ; line:134 col:21
  %load17.152 = load float, float* %145, !dbg !292 ; line:134 col:21
  %146 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:134 col:19
  call void @llvm.dbg.value(metadata float %load15.151, i64 0, metadata !281, metadata !294), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.152, i64 0, metadata !281, metadata !295), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  %147 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !296 ; line:135 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !281, metadata !297), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad27.137, i64 0, metadata !298, metadata !210), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.140, i64 0, metadata !298, metadata !213), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.143, i64 0, metadata !298, metadata !211), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.146, i64 0, metadata !298, metadata !235), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad27.137), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad24.140), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad21.143), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.146), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load.147, i64 0, metadata !298, metadata !285), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.148, i64 0, metadata !298, metadata !286), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.149, i64 0, metadata !298, metadata !287), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %load.147), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %load1.148), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %load3.149), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !298, metadata !289), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !298, metadata !290), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !298, metadata !291), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i031), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float 0.000000e+00), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i234), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load15.151, i64 0, metadata !298, metadata !294), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.152, i64 0, metadata !298, metadata !295), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %load15.151), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %load17.152), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !298, metadata !297), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !299 ; line:137 col:9  ; EmitStream(streamId)
  br label %148, !dbg !300 ; line:138 col:5

; <label>:148                                     ; preds = %109
  %149 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !301 ; line:129 col:28
  call void @llvm.dbg.value(metadata i32 2, i64 0, metadata !273, metadata !201), !dbg !271 ; var:"i" !DIExpression() func:"GS"
  br label %150, !dbg !274, !llvm.loop !302 ; line:129 col:5

; <label>:150                                     ; preds = %148
  call void @llvm.dbg.value(metadata i32 2, i64 0, metadata !273, metadata !201), !dbg !271 ; var:"i" !DIExpression() func:"GS"
  %151 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %152 = extractvalue %dx.types.CBufRet.f32 %151, 0, !dbg !275 ; line:131 col:31
  %153 = extractvalue %dx.types.CBufRet.f32 %151, 1, !dbg !275 ; line:131 col:31
  %154 = extractvalue %dx.types.CBufRet.f32 %151, 2, !dbg !275 ; line:131 col:31
  %155 = extractvalue %dx.types.CBufRet.f32 %151, 3, !dbg !275 ; line:131 col:31
  %156 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %157 = extractvalue %dx.types.CBufRet.f32 %156, 0, !dbg !275 ; line:131 col:31
  %158 = extractvalue %dx.types.CBufRet.f32 %156, 1, !dbg !275 ; line:131 col:31
  %159 = extractvalue %dx.types.CBufRet.f32 %156, 2, !dbg !275 ; line:131 col:31
  %160 = extractvalue %dx.types.CBufRet.f32 %156, 3, !dbg !275 ; line:131 col:31
  %161 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %162 = extractvalue %dx.types.CBufRet.f32 %161, 0, !dbg !275 ; line:131 col:31
  %163 = extractvalue %dx.types.CBufRet.f32 %161, 1, !dbg !275 ; line:131 col:31
  %164 = extractvalue %dx.types.CBufRet.f32 %161, 2, !dbg !275 ; line:131 col:31
  %165 = extractvalue %dx.types.CBufRet.f32 %161, 3, !dbg !275 ; line:131 col:31
  %166 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %167 = extractvalue %dx.types.CBufRet.f32 %166, 0, !dbg !275 ; line:131 col:31
  %168 = extractvalue %dx.types.CBufRet.f32 %166, 1, !dbg !275 ; line:131 col:31
  %169 = extractvalue %dx.types.CBufRet.f32 %166, 2, !dbg !275 ; line:131 col:31
  %170 = extractvalue %dx.types.CBufRet.f32 %166, 3, !dbg !275 ; line:131 col:31
  %171 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 2, !dbg !278 ; line:131 col:25
  %172 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 2, !dbg !278 ; line:131 col:25
  %173 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 2, !dbg !278 ; line:131 col:25
  %174 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 2, !dbg !278 ; line:131 col:25
  %load7.154 = load float, float* %171, !dbg !278 ; line:131 col:25
  %load9.155 = load float, float* %172, !dbg !278 ; line:131 col:25
  %load11.156 = load float, float* %173, !dbg !278 ; line:131 col:25
  %load13.157 = load float, float* %174, !dbg !278 ; line:131 col:25
  %175 = fmul fast float %load7.154, %152, !dbg !279 ; line:131 col:21
  %FMad29.158 = call float @dx.op.tertiary.f32(i32 46, float %load9.155, float %153, float %175), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad28.159 = call float @dx.op.tertiary.f32(i32 46, float %load11.156, float %154, float %FMad29.158), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad27.160 = call float @dx.op.tertiary.f32(i32 46, float %load13.157, float %155, float %FMad28.159), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %176 = fmul fast float %load7.154, %157, !dbg !279 ; line:131 col:21
  %FMad26.161 = call float @dx.op.tertiary.f32(i32 46, float %load9.155, float %158, float %176), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad25.162 = call float @dx.op.tertiary.f32(i32 46, float %load11.156, float %159, float %FMad26.161), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad24.163 = call float @dx.op.tertiary.f32(i32 46, float %load13.157, float %160, float %FMad25.162), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %177 = fmul fast float %load7.154, %162, !dbg !279 ; line:131 col:21
  %FMad23.164 = call float @dx.op.tertiary.f32(i32 46, float %load9.155, float %163, float %177), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad22.165 = call float @dx.op.tertiary.f32(i32 46, float %load11.156, float %164, float %FMad23.164), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad21.166 = call float @dx.op.tertiary.f32(i32 46, float %load13.157, float %165, float %FMad22.165), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %178 = fmul fast float %load7.154, %167, !dbg !279 ; line:131 col:21
  %FMad20.167 = call float @dx.op.tertiary.f32(i32 46, float %load9.155, float %168, float %178), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad19.168 = call float @dx.op.tertiary.f32(i32 46, float %load11.156, float %169, float %FMad20.167), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad.169 = call float @dx.op.tertiary.f32(i32 46, float %load13.157, float %170, float %FMad19.168), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %179 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !280 ; line:131 col:19
  call void @llvm.dbg.value(metadata float %FMad27.160, i64 0, metadata !281, metadata !210), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.163, i64 0, metadata !281, metadata !213), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.166, i64 0, metadata !281, metadata !211), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.169, i64 0, metadata !281, metadata !235), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %180 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 2, !dbg !283 ; line:132 col:21
  %181 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 2, !dbg !283 ; line:132 col:21
  %182 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 2, !dbg !283 ; line:132 col:21
  %load.170 = load float, float* %180, !dbg !283 ; line:132 col:21
  %load1.171 = load float, float* %181, !dbg !283 ; line:132 col:21
  %load3.172 = load float, float* %182, !dbg !283 ; line:132 col:21
  %183 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:132 col:19
  call void @llvm.dbg.value(metadata float %load.170, i64 0, metadata !281, metadata !285), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.171, i64 0, metadata !281, metadata !286), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.172, i64 0, metadata !281, metadata !287), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  %184 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:133 col:22
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !281, metadata !289), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !281, metadata !290), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !281, metadata !291), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  %185 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 2, !dbg !292 ; line:134 col:21
  %186 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 2, !dbg !292 ; line:134 col:21
  %load15.174 = load float, float* %185, !dbg !292 ; line:134 col:21
  %load17.175 = load float, float* %186, !dbg !292 ; line:134 col:21
  %187 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:134 col:19
  call void @llvm.dbg.value(metadata float %load15.174, i64 0, metadata !281, metadata !294), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.175, i64 0, metadata !281, metadata !295), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  %188 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !296 ; line:135 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !281, metadata !297), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad27.160, i64 0, metadata !298, metadata !210), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.163, i64 0, metadata !298, metadata !213), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.166, i64 0, metadata !298, metadata !211), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.169, i64 0, metadata !298, metadata !235), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad27.160), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad24.163), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad21.166), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.169), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load.170, i64 0, metadata !298, metadata !285), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.171, i64 0, metadata !298, metadata !286), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.172, i64 0, metadata !298, metadata !287), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %load.170), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %load1.171), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %load3.172), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !298, metadata !289), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !298, metadata !290), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !298, metadata !291), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i031), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float 0.000000e+00), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i234), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load15.174, i64 0, metadata !298, metadata !294), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.175, i64 0, metadata !298, metadata !295), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %load15.174), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %load17.175), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !298, metadata !297), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !299 ; line:137 col:9  ; EmitStream(streamId)
  br label %189, !dbg !300 ; line:138 col:5

; <label>:189                                     ; preds = %150
  %190 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !301 ; line:129 col:28
  call void @llvm.dbg.value(metadata i32 3, i64 0, metadata !273, metadata !201), !dbg !271 ; var:"i" !DIExpression() func:"GS"
  br label %191, !dbg !274, !llvm.loop !302 ; line:129 col:5

; <label>:191                                     ; preds = %189
  call void @llvm.dbg.value(metadata i32 3, i64 0, metadata !273, metadata !201), !dbg !271 ; var:"i" !DIExpression() func:"GS"
  %192 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %193 = extractvalue %dx.types.CBufRet.f32 %192, 0, !dbg !275 ; line:131 col:31
  %194 = extractvalue %dx.types.CBufRet.f32 %192, 1, !dbg !275 ; line:131 col:31
  %195 = extractvalue %dx.types.CBufRet.f32 %192, 2, !dbg !275 ; line:131 col:31
  %196 = extractvalue %dx.types.CBufRet.f32 %192, 3, !dbg !275 ; line:131 col:31
  %197 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %198 = extractvalue %dx.types.CBufRet.f32 %197, 0, !dbg !275 ; line:131 col:31
  %199 = extractvalue %dx.types.CBufRet.f32 %197, 1, !dbg !275 ; line:131 col:31
  %200 = extractvalue %dx.types.CBufRet.f32 %197, 2, !dbg !275 ; line:131 col:31
  %201 = extractvalue %dx.types.CBufRet.f32 %197, 3, !dbg !275 ; line:131 col:31
  %202 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %203 = extractvalue %dx.types.CBufRet.f32 %202, 0, !dbg !275 ; line:131 col:31
  %204 = extractvalue %dx.types.CBufRet.f32 %202, 1, !dbg !275 ; line:131 col:31
  %205 = extractvalue %dx.types.CBufRet.f32 %202, 2, !dbg !275 ; line:131 col:31
  %206 = extractvalue %dx.types.CBufRet.f32 %202, 3, !dbg !275 ; line:131 col:31
  %207 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !275 ; line:131 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %208 = extractvalue %dx.types.CBufRet.f32 %207, 0, !dbg !275 ; line:131 col:31
  %209 = extractvalue %dx.types.CBufRet.f32 %207, 1, !dbg !275 ; line:131 col:31
  %210 = extractvalue %dx.types.CBufRet.f32 %207, 2, !dbg !275 ; line:131 col:31
  %211 = extractvalue %dx.types.CBufRet.f32 %207, 3, !dbg !275 ; line:131 col:31
  %212 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 3, !dbg !278 ; line:131 col:25
  %213 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 3, !dbg !278 ; line:131 col:25
  %214 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 3, !dbg !278 ; line:131 col:25
  %215 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 3, !dbg !278 ; line:131 col:25
  %load7.177 = load float, float* %212, !dbg !278 ; line:131 col:25
  %load9.178 = load float, float* %213, !dbg !278 ; line:131 col:25
  %load11.179 = load float, float* %214, !dbg !278 ; line:131 col:25
  %load13.180 = load float, float* %215, !dbg !278 ; line:131 col:25
  %216 = fmul fast float %load7.177, %193, !dbg !279 ; line:131 col:21
  %FMad29.181 = call float @dx.op.tertiary.f32(i32 46, float %load9.178, float %194, float %216), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad28.182 = call float @dx.op.tertiary.f32(i32 46, float %load11.179, float %195, float %FMad29.181), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad27.183 = call float @dx.op.tertiary.f32(i32 46, float %load13.180, float %196, float %FMad28.182), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %217 = fmul fast float %load7.177, %198, !dbg !279 ; line:131 col:21
  %FMad26.184 = call float @dx.op.tertiary.f32(i32 46, float %load9.178, float %199, float %217), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad25.185 = call float @dx.op.tertiary.f32(i32 46, float %load11.179, float %200, float %FMad26.184), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad24.186 = call float @dx.op.tertiary.f32(i32 46, float %load13.180, float %201, float %FMad25.185), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %218 = fmul fast float %load7.177, %203, !dbg !279 ; line:131 col:21
  %FMad23.187 = call float @dx.op.tertiary.f32(i32 46, float %load9.178, float %204, float %218), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad22.188 = call float @dx.op.tertiary.f32(i32 46, float %load11.179, float %205, float %FMad23.187), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad21.189 = call float @dx.op.tertiary.f32(i32 46, float %load13.180, float %206, float %FMad22.188), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %219 = fmul fast float %load7.177, %208, !dbg !279 ; line:131 col:21
  %FMad20.190 = call float @dx.op.tertiary.f32(i32 46, float %load9.178, float %209, float %219), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad19.191 = call float @dx.op.tertiary.f32(i32 46, float %load11.179, float %210, float %FMad20.190), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %FMad.192 = call float @dx.op.tertiary.f32(i32 46, float %load13.180, float %211, float %FMad19.191), !dbg !279 ; line:131 col:21  ; FMad(a,b,c)
  %220 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !280 ; line:131 col:19
  call void @llvm.dbg.value(metadata float %FMad27.183, i64 0, metadata !281, metadata !210), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.186, i64 0, metadata !281, metadata !213), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.189, i64 0, metadata !281, metadata !211), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.192, i64 0, metadata !281, metadata !235), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %221 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 3, !dbg !283 ; line:132 col:21
  %222 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 3, !dbg !283 ; line:132 col:21
  %223 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 3, !dbg !283 ; line:132 col:21
  %load.193 = load float, float* %221, !dbg !283 ; line:132 col:21
  %load1.194 = load float, float* %222, !dbg !283 ; line:132 col:21
  %load3.195 = load float, float* %223, !dbg !283 ; line:132 col:21
  %224 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:132 col:19
  call void @llvm.dbg.value(metadata float %load.193, i64 0, metadata !281, metadata !285), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.194, i64 0, metadata !281, metadata !286), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.195, i64 0, metadata !281, metadata !287), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  %225 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:133 col:22
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !281, metadata !289), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !281, metadata !290), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !281, metadata !291), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  %226 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 3, !dbg !292 ; line:134 col:21
  %227 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 3, !dbg !292 ; line:134 col:21
  %load15.197 = load float, float* %226, !dbg !292 ; line:134 col:21
  %load17.198 = load float, float* %227, !dbg !292 ; line:134 col:21
  %228 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !293 ; line:134 col:19
  call void @llvm.dbg.value(metadata float %load15.197, i64 0, metadata !281, metadata !294), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.198, i64 0, metadata !281, metadata !295), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  %229 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !296 ; line:135 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !281, metadata !297), !dbg !282 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad27.183, i64 0, metadata !298, metadata !210), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.186, i64 0, metadata !298, metadata !213), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.189, i64 0, metadata !298, metadata !211), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.192, i64 0, metadata !298, metadata !235), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad27.183), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad24.186), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad21.189), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.192), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load.193, i64 0, metadata !298, metadata !285), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.194, i64 0, metadata !298, metadata !286), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.195, i64 0, metadata !298, metadata !287), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %load.193), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %load1.194), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %load3.195), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !298, metadata !289), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !298, metadata !290), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !298, metadata !291), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i031), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float 0.000000e+00), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i234), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load15.197, i64 0, metadata !298, metadata !294), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.198, i64 0, metadata !298, metadata !295), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %load15.197), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %load17.198), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !298, metadata !297), !dbg !299 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !299 ; line:137 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !299 ; line:137 col:9  ; EmitStream(streamId)
  br label %230, !dbg !300 ; line:138 col:5

; <label>:230                                     ; preds = %191
  %231 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !301 ; line:129 col:28
  call void @llvm.dbg.value(metadata i32 4, i64 0, metadata !273, metadata !201), !dbg !271 ; var:"i" !DIExpression() func:"GS"
  br label %._crit_edge, !dbg !274, !llvm.loop !302 ; line:129 col:5

._crit_edge:                                      ; preds = %230
  br label %232, !dbg !274 ; line:129 col:5

; <label>:232                                     ; preds = %._crit_edge
  %233 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !304 ; line:139 col:1
  ret void, !dbg !304 ; line:139 col:1
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
declare void @dx.op.emitStream(i32, i8) #1

; Function Attrs: nounwind readnone
declare float @dx.op.dot3.f32(i32, float, float, float, float, float, float) #0

; Function Attrs: nounwind readnone
declare float @dx.op.unary.f32(i32, float) #0

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
!llvm.module.flags = !{!133, !134}
!llvm.ident = !{!135}
!dx.source.contents = !{!136, !137}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!138}
!dx.source.args = !{!139}
!dx.version = !{!140}
!dx.valver = !{!141}
!dx.shaderModel = !{!142}
!dx.resources = !{!143}
!dx.typeAnnotations = !{!146, !176}
!dx.viewIdState = !{!179}
!dx.entryPoints = !{!180}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !31, globals: !55)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTreeBillboard.hlsl", directory: "")
!2 = !{}
!3 = !{!4, !15, !24}
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
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 48, baseType: !25)
!25 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 48, size: 64, align: 32, elements: !26, templateParams: !29)
!26 = !{!27, !28}
!27 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !25, file: !1, line: 48, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !25, file: !1, line: 48, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!29 = !{!12, !30}
!30 = !DITemplateValueParameter(name: "element_count", type: !14, value: i32 2)
!31 = !{!32}
!32 = !DISubprogram(name: "GS", scope: !1, file: !1, line: 98, type: !33, isLocal: false, isDefinition: true, scopeLine: 101, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @GS)
!33 = !DISubroutineType(types: !34)
!34 = !{null, !35, !42, !44}
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !36, size: 160, align: 32, elements: !40)
!36 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexOut", file: !1, line: 70, size: 160, align: 32, elements: !37)
!37 = !{!38, !39}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "CenterW", scope: !36, file: !1, line: 72, baseType: !4, size: 96, align: 32)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "SizeW", scope: !36, file: !1, line: 73, baseType: !24, size: 64, align: 32, offset: 96)
!40 = !{!41}
!41 = !DISubrange(count: 1)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 61, baseType: !43)
!43 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!44 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !45)
!45 = !DICompositeType(tag: DW_TAG_class_type, name: "TriangleStream<GeoOut>", file: !1, line: 61, size: 416, align: 32, elements: !2, templateParams: !46)
!46 = !{!47}
!47 = !DITemplateTypeParameter(name: "element", type: !48)
!48 = !DICompositeType(tag: DW_TAG_structure_type, name: "GeoOut", file: !1, line: 76, size: 416, align: 32, elements: !49)
!49 = !{!50, !51, !52, !53, !54}
!50 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !48, file: !1, line: 78, baseType: !15, size: 128, align: 32)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !48, file: !1, line: 79, baseType: !4, size: 96, align: 32, offset: 128)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !48, file: !1, line: 80, baseType: !4, size: 96, align: 32, offset: 224)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !48, file: !1, line: 81, baseType: !24, size: 64, align: 32, offset: 320)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "PrimID", scope: !48, file: !1, line: 82, baseType: !42, size: 32, align: 32, offset: 384)
!55 = !{!56, !80, !81, !83, !85, !87, !88, !89, !90, !91, !92, !93, !94, !95, !96, !98, !99, !100, !101, !102, !103, !104, !118, !119, !120, !121, !122, !126, !128, !129, !130, !131, !132}
!56 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 26, type: !57, isLocal: false, isDefinition: true)
!57 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !58)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 26, baseType: !59)
!59 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 26, size: 512, align: 32, elements: !60, templateParams: !77)
!60 = !{!61, !62, !63, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76}
!61 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !59, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!77 = !{!12, !78, !79}
!78 = !DITemplateValueParameter(name: "row_count", type: !14, value: i32 4)
!79 = !DITemplateValueParameter(name: "col_count", type: !14, value: i32 4)
!80 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 27, type: !57, isLocal: false, isDefinition: true)
!81 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 32, type: !82, isLocal: false, isDefinition: true)
!82 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!83 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 33, type: !84, isLocal: false, isDefinition: true)
!84 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!85 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 34, type: !86, isLocal: false, isDefinition: true)
!86 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!87 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 35, type: !57, isLocal: false, isDefinition: true)
!88 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 40, type: !57, isLocal: false, isDefinition: true)
!89 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 41, type: !57, isLocal: false, isDefinition: true)
!90 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !57, isLocal: false, isDefinition: true)
!91 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 43, type: !57, isLocal: false, isDefinition: true)
!92 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 44, type: !57, isLocal: false, isDefinition: true)
!93 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 45, type: !57, isLocal: false, isDefinition: true)
!94 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 46, type: !84, isLocal: false, isDefinition: true)
!95 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPass@@3MB", scope: !0, file: !1, line: 47, type: !86, isLocal: false, isDefinition: true)
!96 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 48, type: !97, isLocal: false, isDefinition: true)
!97 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!98 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 49, type: !97, isLocal: false, isDefinition: true)
!99 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 50, type: !86, isLocal: false, isDefinition: true)
!100 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 51, type: !86, isLocal: false, isDefinition: true)
!101 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 52, type: !86, isLocal: false, isDefinition: true)
!102 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 53, type: !86, isLocal: false, isDefinition: true)
!103 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 54, type: !82, isLocal: false, isDefinition: true)
!104 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 56, type: !105, isLocal: false, isDefinition: true)
!105 = !DICompositeType(tag: DW_TAG_array_type, baseType: !106, size: 6144, align: 32, elements: !116)
!106 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !107)
!107 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !108, line: 3, size: 384, align: 32, elements: !109)
!108 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!109 = !{!110, !111, !112, !113, !114, !115}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !107, file: !108, line: 5, baseType: !4, size: 96, align: 32)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !107, file: !108, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !107, file: !108, line: 7, baseType: !4, size: 96, align: 32, offset: 128)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !107, file: !108, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !107, file: !108, line: 9, baseType: !4, size: 96, align: 32, offset: 256)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !107, file: !108, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!116 = !{!117}
!117 = !DISubrange(count: 16)
!118 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 58, type: !82, isLocal: false, isDefinition: true)
!119 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 59, type: !86, isLocal: false, isDefinition: true)
!120 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 60, type: !86, isLocal: false, isDefinition: true)
!121 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 61, type: !97, isLocal: false, isDefinition: true)
!122 = !DIGlobalVariable(name: "gTreeMapArray", linkageName: "\01?gTreeMapArray@@3V?$Texture2DArray@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 15, type: !123, isLocal: false, isDefinition: true)
!123 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2DArray<vector<float, 4> >", file: !1, line: 15, size: 160, align: 32, elements: !2, templateParams: !124)
!124 = !{!125}
!125 = !DITemplateTypeParameter(name: "element", type: !16)
!126 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 17, type: !127, isLocal: false, isDefinition: true)
!127 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 17, size: 32, align: 32, elements: !2)
!128 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 18, type: !127, isLocal: false, isDefinition: true)
!129 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 19, type: !127, isLocal: false, isDefinition: true)
!130 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 20, type: !127, isLocal: false, isDefinition: true)
!131 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !127, isLocal: false, isDefinition: true)
!132 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !127, isLocal: false, isDefinition: true)
!133 = !{i32 2, !"Dwarf Version", i32 4}
!134 = !{i32 2, !"Debug Info Version", i32 3}
!135 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!136 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTreeBillboard.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2DArray gTreeMapArray : register(t0);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerObjectPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float2 SizeW : SIZE;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float3 CenterW : POSITION;\0D\0A    float2 SizeW : SIZE;\0D\0A};\0D\0A\0D\0Astruct GeoOut\0D\0A{\0D\0A    float4 PosH : SV_POSITION;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A    uint PrimID : SV_PrimitiveID;\0D\0A};\0D\0A\0D\0A//\B1\D7\B3\C9 \C6\D0\BD\BA\BD\BA\B7\E7 \BC\CE\C0\CC\B4\F5.\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout;\0D\0A    \0D\0A    vout.CenterW = vin.PosW;\0D\0A    vout.SizeW = vin.SizeW;\0D\0A\0D\0A    return vout;\0D\0A}\0D\0A \0D\0A//\C1\A1(CenterW)\B8\A6 \BB\E7\B0\A2\C7\FC(\C1\A1 4\B0\B3)\C0\B8\B7\CE \C8\AE\C0\E5.\0D\0A[maxvertexcount(4)]\0D\0Avoid GS(point VertexOut gin[1],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A\09//\C0\D3\BD\C3 \B7\CE\C4\C3 \C1\C2\C7\A5\B0\E8 -> \BF\F9\B5\E5 \C1\C2\C7\A5\B0\E8\0D\0A    //\BA\F4\BA\B8\B5\E5\B4\C2 y\C3\E0\BF\A1 \C1\A4\B7\C4\B5\C7\B0\ED \BD\C3\BC\B1\C0\BB \C7\E2\C7\D4\0D\0A    float3 up = float3(0.0f, 1.0f, 0.0f);\0D\0A    float3 look = gEyePosW - gin[0].CenterW;\0D\0A    look.y = 0.0f; //project to xz-plane\0D\0A    look = normalize(look);\0D\0A    float3 right = cross(up, look);\0D\0A\0D\0A    float halfWidth = 0.5f * gin[0].SizeW.x;\0D\0A    float halfHeight = 0.5f * gin[0].SizeW.y;\0D\0A\09\0D\0A    float4 v[4];\0D\0A    v[0] = float4(gin[0].CenterW + halfWidth * right - halfHeight * up, 1.0f);\0D\0A    v[1] = float4(gin[0].CenterW + halfWidth * right + halfHeight * up, 1.0f);\0D\0A    v[2] = float4(gin[0].CenterW - halfWidth * right - halfHeight * up, 1.0f);\0D\0A    v[3] = float4(gin[0].CenterW - halfWidth * right + halfHeight * up, 1.0f);\0D\0A    \0D\0A    float2 texC[4] =\0D\0A    {\0D\0A        float2(0.0f, 1.0f),\0D\0A\09\09float2(0.0f, 0.0f),\0D\0A\09\09float2(1.0f, 1.0f),\0D\0A\09\09float2(1.0f, 0.0f)\0D\0A    };\0D\0A\09\0D\0A    GeoOut gout;\0D\0A\09[unroll]\0D\0A    for (int i = 0; i < 4; ++i)\0D\0A    {\0D\0A        gout.PosH = mul(v[i], gViewProj);\0D\0A        gout.PosW = v[i].xyz;\0D\0A        gout.NormalW = look;\0D\0A        gout.TexC = texC[i];\0D\0A        gout.PrimID = primID;\0D\0A\09\09\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A}\0D\0A\0D\0Afloat4 PS(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 uvw = float3(pin.TexC, pin.PrimID % 3);\0D\0A    float4 diffuseAlbedo = gTreeMapArray.Sample(gsamAnisotropicWrap, uvw) * gDiffuseAlbedo;\0D\0A\09\0D\0A#ifdef ALPHA_TEST\0D\0A\09clip(diffuseAlbedo.a - 0.1f);\0D\0A#endif\0D\0A    \0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A    \0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; // normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A#ifdef FOG\0D\0A\09float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A\09litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A    \0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A\0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_Wireframe(GeoOut pin) : SV_Target\0D\0A{\0D\0A    return float4(1.0f, 1.0f, 1.0f, 1.0f);\0D\0A}"}
!137 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0\E3\84\B4.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrenght = L.Strength * ndotl;\0D\0A    \0D\0A    return BlinnPhong(lightStrenght, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!138 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTreeBillboard.hlsl"}
!139 = !{!"-E", !"GS", !"-T", !"gs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CTreeBillboardGS.cso"}
!140 = !{i32 1, i32 0}
!141 = !{i32 1, i32 8}
!142 = !{!"gs", i32 6, i32 0}
!143 = !{null, null, !144, null}
!144 = !{!145}
!145 = !{i32 0, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!146 = !{i32 0, %struct.Light undef, !147, %hostlayout.cbPass undef, !154}
!147 = !{i32 48, !148, !149, !150, !151, !152, !153}
!148 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!149 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!150 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!151 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!152 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!153 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!154 = !{i32 1248, !155, !157, !158, !159, !160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174, !175}
!155 = !{i32 6, !"gView", i32 2, !156, i32 3, i32 0, i32 7, i32 9}
!156 = !{i32 4, i32 4, i32 2}
!157 = !{i32 6, !"gInvView", i32 2, !156, i32 3, i32 64, i32 7, i32 9}
!158 = !{i32 6, !"gProj", i32 2, !156, i32 3, i32 128, i32 7, i32 9}
!159 = !{i32 6, !"gInvProj", i32 2, !156, i32 3, i32 192, i32 7, i32 9}
!160 = !{i32 6, !"gViewProj", i32 2, !156, i32 3, i32 256, i32 7, i32 9}
!161 = !{i32 6, !"gInvViewProj", i32 2, !156, i32 3, i32 320, i32 7, i32 9}
!162 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!163 = !{i32 6, !"cbPerObjectPad1", i32 3, i32 396, i32 7, i32 9}
!164 = !{i32 6, !"gRenderTargetSize", i32 3, i32 400, i32 7, i32 9}
!165 = !{i32 6, !"gInvRenderTargetSize", i32 3, i32 408, i32 7, i32 9}
!166 = !{i32 6, !"gNearZ", i32 3, i32 416, i32 7, i32 9}
!167 = !{i32 6, !"gFarZ", i32 3, i32 420, i32 7, i32 9}
!168 = !{i32 6, !"gTotalTime", i32 3, i32 424, i32 7, i32 9}
!169 = !{i32 6, !"gDeltaTime", i32 3, i32 428, i32 7, i32 9}
!170 = !{i32 6, !"gAmbientLight", i32 3, i32 432, i32 7, i32 9}
!171 = !{i32 6, !"gLights", i32 3, i32 448}
!172 = !{i32 6, !"gFogColor", i32 3, i32 1216, i32 7, i32 9}
!173 = !{i32 6, !"gFogStart", i32 3, i32 1232, i32 7, i32 9}
!174 = !{i32 6, !"gFogRange", i32 3, i32 1236, i32 7, i32 9}
!175 = !{i32 6, !"cbPerObjectPad2", i32 3, i32 1240, i32 7, i32 9}
!176 = !{i32 1, void ()* @GS, !177}
!177 = !{!178}
!178 = !{i32 0, !2, !2}
!179 = !{[11 x i32] [i32 6, i32 17, i32 1375, i32 47, i32 1375, i32 0, i32 95, i32 47, i32 0, i32 0, i32 0]}
!180 = !{void ()* @GS, !"GS", !181, !143, !197}
!181 = !{!182, !189, null}
!182 = !{!183, !186, !188}
!183 = !{i32 0, !"POSITION", i8 9, i8 0, !184, i8 2, i32 1, i8 3, i32 0, i8 0, !185}
!184 = !{i32 0}
!185 = !{i32 3, i32 7}
!186 = !{i32 1, !"SIZE", i8 9, i8 0, !184, i8 2, i32 1, i8 2, i32 1, i8 0, !187}
!187 = !{i32 3, i32 3}
!188 = !{i32 2, !"SV_PrimitiveID", i8 5, i8 10, !184, i8 0, i32 1, i8 1, i32 -1, i8 -1, null}
!189 = !{!190, !192, !193, !194, !195}
!190 = !{i32 0, !"SV_Position", i8 9, i8 3, !184, i8 4, i32 1, i8 4, i32 0, i8 0, !191}
!191 = !{i32 3, i32 15}
!192 = !{i32 1, !"POSITION", i8 9, i8 0, !184, i8 2, i32 1, i8 3, i32 1, i8 0, !185}
!193 = !{i32 2, !"NORMAL", i8 9, i8 0, !184, i8 2, i32 1, i8 3, i32 2, i8 0, !185}
!194 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !184, i8 2, i32 1, i8 2, i32 3, i8 0, !187}
!195 = !{i32 4, !"SV_PrimitiveID", i8 5, i8 10, !184, i8 1, i32 1, i8 1, i32 4, i8 0, !196}
!196 = !{i32 3, i32 1}
!197 = !{i32 0, i64 1, i32 1, !198}
!198 = !{i32 1, i32 4, i32 1, i32 5, i32 1}
!199 = !DILocation(line: 100, column: 38, scope: !32)
!200 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "primID", arg: 2, scope: !32, file: !1, line: 99, type: !42)
!201 = !DIExpression()
!202 = !DILocation(line: 99, column: 14, scope: !32)
!203 = !DILocation(line: 104, column: 12, scope: !32)
!204 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "up", scope: !32, file: !1, line: 104, type: !4)
!205 = !DILocation(line: 105, column: 19, scope: !32)
!206 = !DILocation(line: 105, column: 37, scope: !32)
!207 = !DILocation(line: 105, column: 28, scope: !32)
!208 = !DILocation(line: 105, column: 12, scope: !32)
!209 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "look", scope: !32, file: !1, line: 105, type: !4)
!210 = !DIExpression(DW_OP_bit_piece, 0, 32)
!211 = !DIExpression(DW_OP_bit_piece, 64, 32)
!212 = !DILocation(line: 106, column: 12, scope: !32)
!213 = !DIExpression(DW_OP_bit_piece, 32, 32)
!214 = !DILocation(line: 107, column: 12, scope: !32)
!215 = !DILocation(line: 107, column: 10, scope: !32)
!216 = !DILocation(line: 108, column: 20, scope: !32)
!217 = !DILocation(line: 108, column: 12, scope: !32)
!218 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "right", scope: !32, file: !1, line: 108, type: !4)
!219 = !DILocation(line: 110, column: 30, scope: !32)
!220 = !DILocation(line: 110, column: 28, scope: !32)
!221 = !DILocation(line: 110, column: 11, scope: !32)
!222 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "halfWidth", scope: !32, file: !1, line: 110, type: !8)
!223 = !DILocation(line: 111, column: 31, scope: !32)
!224 = !DILocation(line: 111, column: 29, scope: !32)
!225 = !DILocation(line: 111, column: 11, scope: !32)
!226 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "halfHeight", scope: !32, file: !1, line: 111, type: !8)
!227 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "v", scope: !32, file: !1, line: 113, type: !228)
!228 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 512, align: 32, elements: !229)
!229 = !{!230}
!230 = !DISubrange(count: 4)
!231 = !DILocation(line: 113, column: 12, scope: !32)
!232 = !{i32 0, i32 128, i32 4}
!233 = !{i32 32, i32 128, i32 4}
!234 = !{i32 64, i32 128, i32 4}
!235 = !DIExpression(DW_OP_bit_piece, 96, 32)
!236 = !{i32 96, i32 128, i32 4}
!237 = !DILocation(line: 114, column: 26, scope: !32)
!238 = !DILocation(line: 114, column: 46, scope: !32)
!239 = !DILocation(line: 114, column: 34, scope: !32)
!240 = !DILocation(line: 114, column: 67, scope: !32)
!241 = !DILocation(line: 114, column: 54, scope: !32)
!242 = !DILocation(line: 114, column: 5, scope: !32)
!243 = !DILocation(line: 114, column: 10, scope: !32)
!244 = !DILocation(line: 115, column: 26, scope: !32)
!245 = !DILocation(line: 115, column: 46, scope: !32)
!246 = !DILocation(line: 115, column: 34, scope: !32)
!247 = !DILocation(line: 115, column: 67, scope: !32)
!248 = !DILocation(line: 115, column: 54, scope: !32)
!249 = !DILocation(line: 115, column: 5, scope: !32)
!250 = !DILocation(line: 115, column: 10, scope: !32)
!251 = !DILocation(line: 116, column: 26, scope: !32)
!252 = !DILocation(line: 116, column: 46, scope: !32)
!253 = !DILocation(line: 116, column: 34, scope: !32)
!254 = !DILocation(line: 116, column: 67, scope: !32)
!255 = !DILocation(line: 116, column: 54, scope: !32)
!256 = !DILocation(line: 116, column: 5, scope: !32)
!257 = !DILocation(line: 116, column: 10, scope: !32)
!258 = !DILocation(line: 117, column: 26, scope: !32)
!259 = !DILocation(line: 117, column: 46, scope: !32)
!260 = !DILocation(line: 117, column: 34, scope: !32)
!261 = !DILocation(line: 117, column: 67, scope: !32)
!262 = !DILocation(line: 117, column: 54, scope: !32)
!263 = !DILocation(line: 117, column: 5, scope: !32)
!264 = !DILocation(line: 117, column: 10, scope: !32)
!265 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "texC", scope: !32, file: !1, line: 119, type: !266)
!266 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 256, align: 32, elements: !229)
!267 = !DILocation(line: 119, column: 12, scope: !32)
!268 = !{i32 0, i32 64, i32 4}
!269 = !{i32 32, i32 64, i32 4}
!270 = !DILocation(line: 120, column: 5, scope: !32)
!271 = !DILocation(line: 129, column: 14, scope: !272)
!272 = distinct !DILexicalBlock(scope: !32, file: !1, line: 129, column: 5)
!273 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !272, file: !1, line: 129, type: !14)
!274 = !DILocation(line: 129, column: 5, scope: !272)
!275 = !DILocation(line: 131, column: 31, scope: !276)
!276 = distinct !DILexicalBlock(scope: !277, file: !1, line: 130, column: 5)
!277 = distinct !DILexicalBlock(scope: !272, file: !1, line: 129, column: 5)
!278 = !DILocation(line: 131, column: 25, scope: !276)
!279 = !DILocation(line: 131, column: 21, scope: !276)
!280 = !DILocation(line: 131, column: 19, scope: !276)
!281 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "gout", scope: !32, file: !1, line: 127, type: !48)
!282 = !DILocation(line: 127, column: 12, scope: !32)
!283 = !DILocation(line: 132, column: 21, scope: !276)
!284 = !DILocation(line: 132, column: 19, scope: !276)
!285 = !DIExpression(DW_OP_bit_piece, 128, 32)
!286 = !DIExpression(DW_OP_bit_piece, 160, 32)
!287 = !DIExpression(DW_OP_bit_piece, 192, 32)
!288 = !DILocation(line: 133, column: 22, scope: !276)
!289 = !DIExpression(DW_OP_bit_piece, 224, 32)
!290 = !DIExpression(DW_OP_bit_piece, 256, 32)
!291 = !DIExpression(DW_OP_bit_piece, 288, 32)
!292 = !DILocation(line: 134, column: 21, scope: !276)
!293 = !DILocation(line: 134, column: 19, scope: !276)
!294 = !DIExpression(DW_OP_bit_piece, 320, 32)
!295 = !DIExpression(DW_OP_bit_piece, 352, 32)
!296 = !DILocation(line: 135, column: 21, scope: !276)
!297 = !DIExpression(DW_OP_bit_piece, 384, 32)
!298 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "triStream", arg: 3, scope: !32, file: !1, line: 100, type: !45)
!299 = !DILocation(line: 137, column: 9, scope: !276)
!300 = !DILocation(line: 138, column: 5, scope: !276)
!301 = !DILocation(line: 129, column: 28, scope: !277)
!302 = distinct !{!302, !303}
!303 = !{!"llvm.loop.unroll.full"}
!304 = !DILocation(line: 139, column: 1, scope: !32)
