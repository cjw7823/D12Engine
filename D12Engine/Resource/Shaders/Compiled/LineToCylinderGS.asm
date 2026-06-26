;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   xyz 
; NORMAL                   0   xyz         1     NONE   float       
; TEXCOORD                 0   xy          2     NONE   float       
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
; shader debug name: d262e92625311a22d9b339ef41306df0.pdb
; shader hash: d262e92625311a22d9b339ef41306df0
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Geometry Shader
; InputPrimitive=line
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
; EntryFunctionName: GS
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
;   output 4 depends on inputs: { 0 }
;   output 5 depends on inputs: { 1 }
;   output 6 depends on inputs: { 2 }
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
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 2, i1 false), !dbg !204 ; line:168 col:38  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call i32 @dx.op.primitiveID.i32(i32 108), !dbg !204 ; line:168 col:38  ; PrimitiveID()
  %texC.0 = alloca [4 x float], !dbg !204 ; line:168 col:38
  %texC.1 = alloca [4 x float], !dbg !204 ; line:168 col:38
  %v.0 = alloca [4 x float], !dbg !204 ; line:168 col:38
  %v.1 = alloca [4 x float], !dbg !204 ; line:168 col:38
  %v.2 = alloca [4 x float], !dbg !204 ; line:168 col:38
  %v.3 = alloca [4 x float], !dbg !204 ; line:168 col:38
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !205, metadata !206), !dbg !207 ; var:"primID" !DIExpression() func:"GS"
  %2 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !208 ; line:170 col:12
  call void @llvm.dbg.value(metadata <3 x float> <float 0.000000e+00, float 1.000000e+00, float 0.000000e+00>, i64 0, metadata !209, metadata !206), !dbg !208 ; var:"up" !DIExpression() func:"GS"
  %3 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 24), !dbg !210 ; line:171 col:19  ; CBufferLoadLegacy(handle,regIndex)
  %4 = extractvalue %dx.types.CBufRet.f32 %3, 0, !dbg !210 ; line:171 col:19
  %5 = extractvalue %dx.types.CBufRet.f32 %3, 2, !dbg !210 ; line:171 col:19
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !211 ; line:171 col:37  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !211 ; line:171 col:37  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i0 = fsub fast float %4, %6, !dbg !212 ; line:171 col:28
  %.i2 = fsub fast float %5, %7, !dbg !212 ; line:171 col:28
  %8 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !213 ; line:171 col:12
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !214, metadata !215), !dbg !213 ; var:"look" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !214, metadata !216), !dbg !213 ; var:"look" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  %9 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !217 ; line:172 col:12
  call void @llvm.dbg.value(metadata float %.i0, i64 0, metadata !214, metadata !215), !dbg !213 ; var:"look" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !214, metadata !218), !dbg !213 ; var:"look" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i2, i64 0, metadata !214, metadata !216), !dbg !213 ; var:"look" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  %10 = call float @dx.op.dot3.f32(i32 55, float %.i0, float 0.000000e+00, float %.i2, float %.i0, float 0.000000e+00, float %.i2), !dbg !219 ; line:173 col:12  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt = call float @dx.op.unary.f32(i32 25, float %10), !dbg !219 ; line:173 col:12  ; Rsqrt(value)
  %.i031 = fmul fast float %.i0, %Rsqrt, !dbg !219 ; line:173 col:12
  %.i234 = fmul fast float %.i2, %Rsqrt, !dbg !219 ; line:173 col:12
  %11 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !220 ; line:173 col:10
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !214, metadata !215), !dbg !213 ; var:"look" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !214, metadata !218), !dbg !213 ; var:"look" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !214, metadata !216), !dbg !213 ; var:"look" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  %12 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !221 ; line:174 col:12
  call void @llvm.dbg.declare(metadata [4 x float]* %v.0, metadata !222, metadata !215), !dbg !226, !dx.dbg.varlayout !227 ; var:"v" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.declare(metadata [4 x float]* %v.1, metadata !222, metadata !218), !dbg !226, !dx.dbg.varlayout !228 ; var:"v" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.declare(metadata [4 x float]* %v.2, metadata !222, metadata !216), !dbg !226, !dx.dbg.varlayout !229 ; var:"v" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.declare(metadata [4 x float]* %v.3, metadata !222, metadata !230), !dbg !226, !dx.dbg.varlayout !231 ; var:"v" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %13 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !232 ; line:180 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %14 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !232 ; line:180 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %15 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !232 ; line:180 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %16 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 0, !dbg !233 ; line:180 col:5
  %17 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 0, !dbg !233 ; line:180 col:5
  %18 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 0, !dbg !233 ; line:180 col:5
  %19 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 0, !dbg !233 ; line:180 col:5
  %20 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !234 ; line:180 col:10
  store float %13, float* %16, !dbg !234 ; line:180 col:10
  store float %14, float* %17, !dbg !234 ; line:180 col:10
  store float %15, float* %18, !dbg !234 ; line:180 col:10
  store float 1.000000e+00, float* %19, !dbg !234 ; line:180 col:10
  %21 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 1), !dbg !235 ; line:181 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %22 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 1), !dbg !235 ; line:181 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %23 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 1), !dbg !235 ; line:181 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %24 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 1, !dbg !236 ; line:181 col:5
  %25 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 1, !dbg !236 ; line:181 col:5
  %26 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 1, !dbg !236 ; line:181 col:5
  %27 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 1, !dbg !236 ; line:181 col:5
  %28 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !237 ; line:181 col:10
  store float %21, float* %24, !dbg !237 ; line:181 col:10
  store float %22, float* %25, !dbg !237 ; line:181 col:10
  store float %23, float* %26, !dbg !237 ; line:181 col:10
  store float 1.000000e+00, float* %27, !dbg !237 ; line:181 col:10
  %29 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !238 ; line:182 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %30 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !238 ; line:182 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %31 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !238 ; line:182 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i044 = fadd fast float %29, 0.000000e+00, !dbg !239 ; line:182 col:31
  %.i145 = fadd fast float %30, 3.000000e+00, !dbg !239 ; line:182 col:31
  %.i246 = fadd fast float %31, 0.000000e+00, !dbg !239 ; line:182 col:31
  %32 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 2, !dbg !240 ; line:182 col:5
  %33 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 2, !dbg !240 ; line:182 col:5
  %34 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 2, !dbg !240 ; line:182 col:5
  %35 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 2, !dbg !240 ; line:182 col:5
  %36 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !241 ; line:182 col:10
  store float %.i044, float* %32, !dbg !241 ; line:182 col:10
  store float %.i145, float* %33, !dbg !241 ; line:182 col:10
  store float %.i246, float* %34, !dbg !241 ; line:182 col:10
  store float 1.000000e+00, float* %35, !dbg !241 ; line:182 col:10
  %37 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 1), !dbg !242 ; line:183 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %38 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 1), !dbg !242 ; line:183 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %39 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 1), !dbg !242 ; line:183 col:26  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i056 = fadd fast float %37, 0.000000e+00, !dbg !243 ; line:183 col:31
  %.i157 = fadd fast float %38, 3.000000e+00, !dbg !243 ; line:183 col:31
  %.i258 = fadd fast float %39, 0.000000e+00, !dbg !243 ; line:183 col:31
  %40 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 3, !dbg !244 ; line:183 col:5
  %41 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 3, !dbg !244 ; line:183 col:5
  %42 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 3, !dbg !244 ; line:183 col:5
  %43 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 3, !dbg !244 ; line:183 col:5
  %44 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !245 ; line:183 col:10
  store float %.i056, float* %40, !dbg !245 ; line:183 col:10
  store float %.i157, float* %41, !dbg !245 ; line:183 col:10
  store float %.i258, float* %42, !dbg !245 ; line:183 col:10
  store float 1.000000e+00, float* %43, !dbg !245 ; line:183 col:10
  call void @llvm.dbg.declare(metadata [4 x float]* %texC.0, metadata !246, metadata !215), !dbg !248, !dx.dbg.varlayout !249 ; var:"texC" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.declare(metadata [4 x float]* %texC.1, metadata !246, metadata !218), !dbg !248, !dx.dbg.varlayout !250 ; var:"texC" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  %45 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 0, !dbg !251 ; line:186 col:5
  %46 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 0, !dbg !251 ; line:186 col:5
  %47 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !251 ; line:186 col:5
  store float 0.000000e+00, float* %45, !dbg !251 ; line:186 col:5
  store float 1.000000e+00, float* %46, !dbg !251 ; line:186 col:5
  %48 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 1, !dbg !251 ; line:186 col:5
  %49 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 1, !dbg !251 ; line:186 col:5
  %50 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !251 ; line:186 col:5
  store float 0.000000e+00, float* %48, !dbg !251 ; line:186 col:5
  store float 0.000000e+00, float* %49, !dbg !251 ; line:186 col:5
  %51 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 2, !dbg !251 ; line:186 col:5
  %52 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 2, !dbg !251 ; line:186 col:5
  %53 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !251 ; line:186 col:5
  store float 1.000000e+00, float* %51, !dbg !251 ; line:186 col:5
  store float 1.000000e+00, float* %52, !dbg !251 ; line:186 col:5
  %54 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 3, !dbg !251 ; line:186 col:5
  %55 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 3, !dbg !251 ; line:186 col:5
  %56 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !251 ; line:186 col:5
  store float 1.000000e+00, float* %54, !dbg !251 ; line:186 col:5
  store float 0.000000e+00, float* %55, !dbg !251 ; line:186 col:5
  %57 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !252 ; line:195 col:14
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !254, metadata !206), !dbg !252 ; var:"i" !DIExpression() func:"GS"
  br label %.lr.ph, !dbg !255 ; line:195 col:5

.lr.ph:                                           ; preds = %0
  br label %58, !dbg !255 ; line:195 col:5

; <label>:58                                      ; preds = %.lr.ph
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !254, metadata !206), !dbg !252 ; var:"i" !DIExpression() func:"GS"
  %59 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %60 = extractvalue %dx.types.CBufRet.f32 %59, 0, !dbg !256 ; line:197 col:31
  %61 = extractvalue %dx.types.CBufRet.f32 %59, 1, !dbg !256 ; line:197 col:31
  %62 = extractvalue %dx.types.CBufRet.f32 %59, 2, !dbg !256 ; line:197 col:31
  %63 = extractvalue %dx.types.CBufRet.f32 %59, 3, !dbg !256 ; line:197 col:31
  %64 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %65 = extractvalue %dx.types.CBufRet.f32 %64, 0, !dbg !256 ; line:197 col:31
  %66 = extractvalue %dx.types.CBufRet.f32 %64, 1, !dbg !256 ; line:197 col:31
  %67 = extractvalue %dx.types.CBufRet.f32 %64, 2, !dbg !256 ; line:197 col:31
  %68 = extractvalue %dx.types.CBufRet.f32 %64, 3, !dbg !256 ; line:197 col:31
  %69 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %70 = extractvalue %dx.types.CBufRet.f32 %69, 0, !dbg !256 ; line:197 col:31
  %71 = extractvalue %dx.types.CBufRet.f32 %69, 1, !dbg !256 ; line:197 col:31
  %72 = extractvalue %dx.types.CBufRet.f32 %69, 2, !dbg !256 ; line:197 col:31
  %73 = extractvalue %dx.types.CBufRet.f32 %69, 3, !dbg !256 ; line:197 col:31
  %74 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %75 = extractvalue %dx.types.CBufRet.f32 %74, 0, !dbg !256 ; line:197 col:31
  %76 = extractvalue %dx.types.CBufRet.f32 %74, 1, !dbg !256 ; line:197 col:31
  %77 = extractvalue %dx.types.CBufRet.f32 %74, 2, !dbg !256 ; line:197 col:31
  %78 = extractvalue %dx.types.CBufRet.f32 %74, 3, !dbg !256 ; line:197 col:31
  %79 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 0, !dbg !259 ; line:197 col:25
  %80 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 0, !dbg !259 ; line:197 col:25
  %81 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 0, !dbg !259 ; line:197 col:25
  %82 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 0, !dbg !259 ; line:197 col:25
  %load7.68 = load float, float* %79, !dbg !259 ; line:197 col:25
  %load9.69 = load float, float* %80, !dbg !259 ; line:197 col:25
  %load11.70 = load float, float* %81, !dbg !259 ; line:197 col:25
  %load13.71 = load float, float* %82, !dbg !259 ; line:197 col:25
  %83 = fmul fast float %load7.68, %60, !dbg !260 ; line:197 col:21
  %FMad29.72 = call float @dx.op.tertiary.f32(i32 46, float %load9.69, float %61, float %83), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad28.73 = call float @dx.op.tertiary.f32(i32 46, float %load11.70, float %62, float %FMad29.72), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad27.74 = call float @dx.op.tertiary.f32(i32 46, float %load13.71, float %63, float %FMad28.73), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %84 = fmul fast float %load7.68, %65, !dbg !260 ; line:197 col:21
  %FMad26.75 = call float @dx.op.tertiary.f32(i32 46, float %load9.69, float %66, float %84), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad25.76 = call float @dx.op.tertiary.f32(i32 46, float %load11.70, float %67, float %FMad26.75), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad24.77 = call float @dx.op.tertiary.f32(i32 46, float %load13.71, float %68, float %FMad25.76), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %85 = fmul fast float %load7.68, %70, !dbg !260 ; line:197 col:21
  %FMad23.78 = call float @dx.op.tertiary.f32(i32 46, float %load9.69, float %71, float %85), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad22.79 = call float @dx.op.tertiary.f32(i32 46, float %load11.70, float %72, float %FMad23.78), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad21.80 = call float @dx.op.tertiary.f32(i32 46, float %load13.71, float %73, float %FMad22.79), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %86 = fmul fast float %load7.68, %75, !dbg !260 ; line:197 col:21
  %FMad20.81 = call float @dx.op.tertiary.f32(i32 46, float %load9.69, float %76, float %86), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad19.82 = call float @dx.op.tertiary.f32(i32 46, float %load11.70, float %77, float %FMad20.81), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad.83 = call float @dx.op.tertiary.f32(i32 46, float %load13.71, float %78, float %FMad19.82), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %87 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !261 ; line:197 col:19
  call void @llvm.dbg.value(metadata float %FMad27.74, i64 0, metadata !262, metadata !215), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.77, i64 0, metadata !262, metadata !218), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.80, i64 0, metadata !262, metadata !216), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.83, i64 0, metadata !262, metadata !230), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %88 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 0, !dbg !264 ; line:198 col:21
  %89 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 0, !dbg !264 ; line:198 col:21
  %90 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 0, !dbg !264 ; line:198 col:21
  %load.84 = load float, float* %88, !dbg !264 ; line:198 col:21
  %load1.85 = load float, float* %89, !dbg !264 ; line:198 col:21
  %load3.86 = load float, float* %90, !dbg !264 ; line:198 col:21
  %91 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !265 ; line:198 col:19
  call void @llvm.dbg.value(metadata float %load.84, i64 0, metadata !262, metadata !266), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.85, i64 0, metadata !262, metadata !267), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.86, i64 0, metadata !262, metadata !268), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  %92 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !269 ; line:199 col:22
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !262, metadata !270), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !262, metadata !271), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !262, metadata !272), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  %93 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 0, !dbg !273 ; line:200 col:21
  %94 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 0, !dbg !273 ; line:200 col:21
  %load15.88 = load float, float* %93, !dbg !273 ; line:200 col:21
  %load17.89 = load float, float* %94, !dbg !273 ; line:200 col:21
  %95 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !274 ; line:200 col:19
  call void @llvm.dbg.value(metadata float %load15.88, i64 0, metadata !262, metadata !275), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.89, i64 0, metadata !262, metadata !276), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  %96 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !277 ; line:201 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !262, metadata !278), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  %97 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !279 ; line:202 col:23
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !262, metadata !280), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad27.74, i64 0, metadata !281, metadata !215), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.77, i64 0, metadata !281, metadata !218), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.80, i64 0, metadata !281, metadata !216), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.83, i64 0, metadata !281, metadata !230), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad27.74), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad24.77), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad21.80), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.83), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load.84, i64 0, metadata !281, metadata !266), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.85, i64 0, metadata !281, metadata !267), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.86, i64 0, metadata !281, metadata !268), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %load.84), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %load1.85), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %load3.86), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !281, metadata !270), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !281, metadata !271), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !281, metadata !272), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i031), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float 0.000000e+00), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i234), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load15.88, i64 0, metadata !281, metadata !275), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.89, i64 0, metadata !281, metadata !276), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %load15.88), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %load17.89), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !281, metadata !278), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !281, metadata !280), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 5, i32 0, i8 0, i32 0), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !282 ; line:204 col:9  ; EmitStream(streamId)
  br label %98, !dbg !283 ; line:205 col:5

; <label>:98                                      ; preds = %58
  %99 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:195 col:28
  call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !254, metadata !206), !dbg !252 ; var:"i" !DIExpression() func:"GS"
  br label %100, !dbg !255, !llvm.loop !285 ; line:195 col:5

; <label>:100                                     ; preds = %98
  call void @llvm.dbg.value(metadata i32 1, i64 0, metadata !254, metadata !206), !dbg !252 ; var:"i" !DIExpression() func:"GS"
  %101 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %102 = extractvalue %dx.types.CBufRet.f32 %101, 0, !dbg !256 ; line:197 col:31
  %103 = extractvalue %dx.types.CBufRet.f32 %101, 1, !dbg !256 ; line:197 col:31
  %104 = extractvalue %dx.types.CBufRet.f32 %101, 2, !dbg !256 ; line:197 col:31
  %105 = extractvalue %dx.types.CBufRet.f32 %101, 3, !dbg !256 ; line:197 col:31
  %106 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %107 = extractvalue %dx.types.CBufRet.f32 %106, 0, !dbg !256 ; line:197 col:31
  %108 = extractvalue %dx.types.CBufRet.f32 %106, 1, !dbg !256 ; line:197 col:31
  %109 = extractvalue %dx.types.CBufRet.f32 %106, 2, !dbg !256 ; line:197 col:31
  %110 = extractvalue %dx.types.CBufRet.f32 %106, 3, !dbg !256 ; line:197 col:31
  %111 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %112 = extractvalue %dx.types.CBufRet.f32 %111, 0, !dbg !256 ; line:197 col:31
  %113 = extractvalue %dx.types.CBufRet.f32 %111, 1, !dbg !256 ; line:197 col:31
  %114 = extractvalue %dx.types.CBufRet.f32 %111, 2, !dbg !256 ; line:197 col:31
  %115 = extractvalue %dx.types.CBufRet.f32 %111, 3, !dbg !256 ; line:197 col:31
  %116 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %117 = extractvalue %dx.types.CBufRet.f32 %116, 0, !dbg !256 ; line:197 col:31
  %118 = extractvalue %dx.types.CBufRet.f32 %116, 1, !dbg !256 ; line:197 col:31
  %119 = extractvalue %dx.types.CBufRet.f32 %116, 2, !dbg !256 ; line:197 col:31
  %120 = extractvalue %dx.types.CBufRet.f32 %116, 3, !dbg !256 ; line:197 col:31
  %121 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 1, !dbg !259 ; line:197 col:25
  %122 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 1, !dbg !259 ; line:197 col:25
  %123 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 1, !dbg !259 ; line:197 col:25
  %124 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 1, !dbg !259 ; line:197 col:25
  %load7.91 = load float, float* %121, !dbg !259 ; line:197 col:25
  %load9.92 = load float, float* %122, !dbg !259 ; line:197 col:25
  %load11.93 = load float, float* %123, !dbg !259 ; line:197 col:25
  %load13.94 = load float, float* %124, !dbg !259 ; line:197 col:25
  %125 = fmul fast float %load7.91, %102, !dbg !260 ; line:197 col:21
  %FMad29.95 = call float @dx.op.tertiary.f32(i32 46, float %load9.92, float %103, float %125), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad28.96 = call float @dx.op.tertiary.f32(i32 46, float %load11.93, float %104, float %FMad29.95), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad27.97 = call float @dx.op.tertiary.f32(i32 46, float %load13.94, float %105, float %FMad28.96), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %126 = fmul fast float %load7.91, %107, !dbg !260 ; line:197 col:21
  %FMad26.98 = call float @dx.op.tertiary.f32(i32 46, float %load9.92, float %108, float %126), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad25.99 = call float @dx.op.tertiary.f32(i32 46, float %load11.93, float %109, float %FMad26.98), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad24.100 = call float @dx.op.tertiary.f32(i32 46, float %load13.94, float %110, float %FMad25.99), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %127 = fmul fast float %load7.91, %112, !dbg !260 ; line:197 col:21
  %FMad23.101 = call float @dx.op.tertiary.f32(i32 46, float %load9.92, float %113, float %127), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad22.102 = call float @dx.op.tertiary.f32(i32 46, float %load11.93, float %114, float %FMad23.101), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad21.103 = call float @dx.op.tertiary.f32(i32 46, float %load13.94, float %115, float %FMad22.102), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %128 = fmul fast float %load7.91, %117, !dbg !260 ; line:197 col:21
  %FMad20.104 = call float @dx.op.tertiary.f32(i32 46, float %load9.92, float %118, float %128), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad19.105 = call float @dx.op.tertiary.f32(i32 46, float %load11.93, float %119, float %FMad20.104), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad.106 = call float @dx.op.tertiary.f32(i32 46, float %load13.94, float %120, float %FMad19.105), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %129 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !261 ; line:197 col:19
  call void @llvm.dbg.value(metadata float %FMad27.97, i64 0, metadata !262, metadata !215), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.100, i64 0, metadata !262, metadata !218), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.103, i64 0, metadata !262, metadata !216), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.106, i64 0, metadata !262, metadata !230), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %130 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 1, !dbg !264 ; line:198 col:21
  %131 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 1, !dbg !264 ; line:198 col:21
  %132 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 1, !dbg !264 ; line:198 col:21
  %load.107 = load float, float* %130, !dbg !264 ; line:198 col:21
  %load1.108 = load float, float* %131, !dbg !264 ; line:198 col:21
  %load3.109 = load float, float* %132, !dbg !264 ; line:198 col:21
  %133 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !265 ; line:198 col:19
  call void @llvm.dbg.value(metadata float %load.107, i64 0, metadata !262, metadata !266), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.108, i64 0, metadata !262, metadata !267), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.109, i64 0, metadata !262, metadata !268), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  %134 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !269 ; line:199 col:22
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !262, metadata !270), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !262, metadata !271), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !262, metadata !272), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  %135 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 1, !dbg !273 ; line:200 col:21
  %136 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 1, !dbg !273 ; line:200 col:21
  %load15.111 = load float, float* %135, !dbg !273 ; line:200 col:21
  %load17.112 = load float, float* %136, !dbg !273 ; line:200 col:21
  %137 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !274 ; line:200 col:19
  call void @llvm.dbg.value(metadata float %load15.111, i64 0, metadata !262, metadata !275), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.112, i64 0, metadata !262, metadata !276), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  %138 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !277 ; line:201 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !262, metadata !278), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  %139 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !279 ; line:202 col:23
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !262, metadata !280), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad27.97, i64 0, metadata !281, metadata !215), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.100, i64 0, metadata !281, metadata !218), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.103, i64 0, metadata !281, metadata !216), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.106, i64 0, metadata !281, metadata !230), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad27.97), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad24.100), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad21.103), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.106), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load.107, i64 0, metadata !281, metadata !266), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.108, i64 0, metadata !281, metadata !267), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.109, i64 0, metadata !281, metadata !268), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %load.107), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %load1.108), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %load3.109), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !281, metadata !270), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !281, metadata !271), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !281, metadata !272), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i031), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float 0.000000e+00), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i234), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load15.111, i64 0, metadata !281, metadata !275), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.112, i64 0, metadata !281, metadata !276), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %load15.111), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %load17.112), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !281, metadata !278), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !281, metadata !280), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 5, i32 0, i8 0, i32 0), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !282 ; line:204 col:9  ; EmitStream(streamId)
  br label %140, !dbg !283 ; line:205 col:5

; <label>:140                                     ; preds = %100
  %141 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:195 col:28
  call void @llvm.dbg.value(metadata i32 2, i64 0, metadata !254, metadata !206), !dbg !252 ; var:"i" !DIExpression() func:"GS"
  br label %142, !dbg !255, !llvm.loop !285 ; line:195 col:5

; <label>:142                                     ; preds = %140
  call void @llvm.dbg.value(metadata i32 2, i64 0, metadata !254, metadata !206), !dbg !252 ; var:"i" !DIExpression() func:"GS"
  %143 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %144 = extractvalue %dx.types.CBufRet.f32 %143, 0, !dbg !256 ; line:197 col:31
  %145 = extractvalue %dx.types.CBufRet.f32 %143, 1, !dbg !256 ; line:197 col:31
  %146 = extractvalue %dx.types.CBufRet.f32 %143, 2, !dbg !256 ; line:197 col:31
  %147 = extractvalue %dx.types.CBufRet.f32 %143, 3, !dbg !256 ; line:197 col:31
  %148 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %149 = extractvalue %dx.types.CBufRet.f32 %148, 0, !dbg !256 ; line:197 col:31
  %150 = extractvalue %dx.types.CBufRet.f32 %148, 1, !dbg !256 ; line:197 col:31
  %151 = extractvalue %dx.types.CBufRet.f32 %148, 2, !dbg !256 ; line:197 col:31
  %152 = extractvalue %dx.types.CBufRet.f32 %148, 3, !dbg !256 ; line:197 col:31
  %153 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %154 = extractvalue %dx.types.CBufRet.f32 %153, 0, !dbg !256 ; line:197 col:31
  %155 = extractvalue %dx.types.CBufRet.f32 %153, 1, !dbg !256 ; line:197 col:31
  %156 = extractvalue %dx.types.CBufRet.f32 %153, 2, !dbg !256 ; line:197 col:31
  %157 = extractvalue %dx.types.CBufRet.f32 %153, 3, !dbg !256 ; line:197 col:31
  %158 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %159 = extractvalue %dx.types.CBufRet.f32 %158, 0, !dbg !256 ; line:197 col:31
  %160 = extractvalue %dx.types.CBufRet.f32 %158, 1, !dbg !256 ; line:197 col:31
  %161 = extractvalue %dx.types.CBufRet.f32 %158, 2, !dbg !256 ; line:197 col:31
  %162 = extractvalue %dx.types.CBufRet.f32 %158, 3, !dbg !256 ; line:197 col:31
  %163 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 2, !dbg !259 ; line:197 col:25
  %164 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 2, !dbg !259 ; line:197 col:25
  %165 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 2, !dbg !259 ; line:197 col:25
  %166 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 2, !dbg !259 ; line:197 col:25
  %load7.114 = load float, float* %163, !dbg !259 ; line:197 col:25
  %load9.115 = load float, float* %164, !dbg !259 ; line:197 col:25
  %load11.116 = load float, float* %165, !dbg !259 ; line:197 col:25
  %load13.117 = load float, float* %166, !dbg !259 ; line:197 col:25
  %167 = fmul fast float %load7.114, %144, !dbg !260 ; line:197 col:21
  %FMad29.118 = call float @dx.op.tertiary.f32(i32 46, float %load9.115, float %145, float %167), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad28.119 = call float @dx.op.tertiary.f32(i32 46, float %load11.116, float %146, float %FMad29.118), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad27.120 = call float @dx.op.tertiary.f32(i32 46, float %load13.117, float %147, float %FMad28.119), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %168 = fmul fast float %load7.114, %149, !dbg !260 ; line:197 col:21
  %FMad26.121 = call float @dx.op.tertiary.f32(i32 46, float %load9.115, float %150, float %168), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad25.122 = call float @dx.op.tertiary.f32(i32 46, float %load11.116, float %151, float %FMad26.121), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad24.123 = call float @dx.op.tertiary.f32(i32 46, float %load13.117, float %152, float %FMad25.122), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %169 = fmul fast float %load7.114, %154, !dbg !260 ; line:197 col:21
  %FMad23.124 = call float @dx.op.tertiary.f32(i32 46, float %load9.115, float %155, float %169), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad22.125 = call float @dx.op.tertiary.f32(i32 46, float %load11.116, float %156, float %FMad23.124), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad21.126 = call float @dx.op.tertiary.f32(i32 46, float %load13.117, float %157, float %FMad22.125), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %170 = fmul fast float %load7.114, %159, !dbg !260 ; line:197 col:21
  %FMad20.127 = call float @dx.op.tertiary.f32(i32 46, float %load9.115, float %160, float %170), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad19.128 = call float @dx.op.tertiary.f32(i32 46, float %load11.116, float %161, float %FMad20.127), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad.129 = call float @dx.op.tertiary.f32(i32 46, float %load13.117, float %162, float %FMad19.128), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %171 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !261 ; line:197 col:19
  call void @llvm.dbg.value(metadata float %FMad27.120, i64 0, metadata !262, metadata !215), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.123, i64 0, metadata !262, metadata !218), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.126, i64 0, metadata !262, metadata !216), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.129, i64 0, metadata !262, metadata !230), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %172 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 2, !dbg !264 ; line:198 col:21
  %173 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 2, !dbg !264 ; line:198 col:21
  %174 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 2, !dbg !264 ; line:198 col:21
  %load.130 = load float, float* %172, !dbg !264 ; line:198 col:21
  %load1.131 = load float, float* %173, !dbg !264 ; line:198 col:21
  %load3.132 = load float, float* %174, !dbg !264 ; line:198 col:21
  %175 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !265 ; line:198 col:19
  call void @llvm.dbg.value(metadata float %load.130, i64 0, metadata !262, metadata !266), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.131, i64 0, metadata !262, metadata !267), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.132, i64 0, metadata !262, metadata !268), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  %176 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !269 ; line:199 col:22
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !262, metadata !270), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !262, metadata !271), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !262, metadata !272), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  %177 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 2, !dbg !273 ; line:200 col:21
  %178 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 2, !dbg !273 ; line:200 col:21
  %load15.134 = load float, float* %177, !dbg !273 ; line:200 col:21
  %load17.135 = load float, float* %178, !dbg !273 ; line:200 col:21
  %179 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !274 ; line:200 col:19
  call void @llvm.dbg.value(metadata float %load15.134, i64 0, metadata !262, metadata !275), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.135, i64 0, metadata !262, metadata !276), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  %180 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !277 ; line:201 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !262, metadata !278), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  %181 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !279 ; line:202 col:23
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !262, metadata !280), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad27.120, i64 0, metadata !281, metadata !215), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.123, i64 0, metadata !281, metadata !218), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.126, i64 0, metadata !281, metadata !216), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.129, i64 0, metadata !281, metadata !230), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad27.120), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad24.123), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad21.126), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.129), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load.130, i64 0, metadata !281, metadata !266), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.131, i64 0, metadata !281, metadata !267), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.132, i64 0, metadata !281, metadata !268), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %load.130), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %load1.131), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %load3.132), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !281, metadata !270), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !281, metadata !271), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !281, metadata !272), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i031), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float 0.000000e+00), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i234), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load15.134, i64 0, metadata !281, metadata !275), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.135, i64 0, metadata !281, metadata !276), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %load15.134), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %load17.135), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !281, metadata !278), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !281, metadata !280), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 5, i32 0, i8 0, i32 0), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !282 ; line:204 col:9  ; EmitStream(streamId)
  br label %182, !dbg !283 ; line:205 col:5

; <label>:182                                     ; preds = %142
  %183 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:195 col:28
  call void @llvm.dbg.value(metadata i32 3, i64 0, metadata !254, metadata !206), !dbg !252 ; var:"i" !DIExpression() func:"GS"
  br label %184, !dbg !255, !llvm.loop !285 ; line:195 col:5

; <label>:184                                     ; preds = %182
  call void @llvm.dbg.value(metadata i32 3, i64 0, metadata !254, metadata !206), !dbg !252 ; var:"i" !DIExpression() func:"GS"
  %185 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %186 = extractvalue %dx.types.CBufRet.f32 %185, 0, !dbg !256 ; line:197 col:31
  %187 = extractvalue %dx.types.CBufRet.f32 %185, 1, !dbg !256 ; line:197 col:31
  %188 = extractvalue %dx.types.CBufRet.f32 %185, 2, !dbg !256 ; line:197 col:31
  %189 = extractvalue %dx.types.CBufRet.f32 %185, 3, !dbg !256 ; line:197 col:31
  %190 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %191 = extractvalue %dx.types.CBufRet.f32 %190, 0, !dbg !256 ; line:197 col:31
  %192 = extractvalue %dx.types.CBufRet.f32 %190, 1, !dbg !256 ; line:197 col:31
  %193 = extractvalue %dx.types.CBufRet.f32 %190, 2, !dbg !256 ; line:197 col:31
  %194 = extractvalue %dx.types.CBufRet.f32 %190, 3, !dbg !256 ; line:197 col:31
  %195 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %196 = extractvalue %dx.types.CBufRet.f32 %195, 0, !dbg !256 ; line:197 col:31
  %197 = extractvalue %dx.types.CBufRet.f32 %195, 1, !dbg !256 ; line:197 col:31
  %198 = extractvalue %dx.types.CBufRet.f32 %195, 2, !dbg !256 ; line:197 col:31
  %199 = extractvalue %dx.types.CBufRet.f32 %195, 3, !dbg !256 ; line:197 col:31
  %200 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !256 ; line:197 col:31  ; CBufferLoadLegacy(handle,regIndex)
  %201 = extractvalue %dx.types.CBufRet.f32 %200, 0, !dbg !256 ; line:197 col:31
  %202 = extractvalue %dx.types.CBufRet.f32 %200, 1, !dbg !256 ; line:197 col:31
  %203 = extractvalue %dx.types.CBufRet.f32 %200, 2, !dbg !256 ; line:197 col:31
  %204 = extractvalue %dx.types.CBufRet.f32 %200, 3, !dbg !256 ; line:197 col:31
  %205 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 3, !dbg !259 ; line:197 col:25
  %206 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 3, !dbg !259 ; line:197 col:25
  %207 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 3, !dbg !259 ; line:197 col:25
  %208 = getelementptr [4 x float], [4 x float]* %v.3, i32 0, i32 3, !dbg !259 ; line:197 col:25
  %load7.137 = load float, float* %205, !dbg !259 ; line:197 col:25
  %load9.138 = load float, float* %206, !dbg !259 ; line:197 col:25
  %load11.139 = load float, float* %207, !dbg !259 ; line:197 col:25
  %load13.140 = load float, float* %208, !dbg !259 ; line:197 col:25
  %209 = fmul fast float %load7.137, %186, !dbg !260 ; line:197 col:21
  %FMad29.141 = call float @dx.op.tertiary.f32(i32 46, float %load9.138, float %187, float %209), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad28.142 = call float @dx.op.tertiary.f32(i32 46, float %load11.139, float %188, float %FMad29.141), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad27.143 = call float @dx.op.tertiary.f32(i32 46, float %load13.140, float %189, float %FMad28.142), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %210 = fmul fast float %load7.137, %191, !dbg !260 ; line:197 col:21
  %FMad26.144 = call float @dx.op.tertiary.f32(i32 46, float %load9.138, float %192, float %210), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad25.145 = call float @dx.op.tertiary.f32(i32 46, float %load11.139, float %193, float %FMad26.144), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad24.146 = call float @dx.op.tertiary.f32(i32 46, float %load13.140, float %194, float %FMad25.145), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %211 = fmul fast float %load7.137, %196, !dbg !260 ; line:197 col:21
  %FMad23.147 = call float @dx.op.tertiary.f32(i32 46, float %load9.138, float %197, float %211), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad22.148 = call float @dx.op.tertiary.f32(i32 46, float %load11.139, float %198, float %FMad23.147), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad21.149 = call float @dx.op.tertiary.f32(i32 46, float %load13.140, float %199, float %FMad22.148), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %212 = fmul fast float %load7.137, %201, !dbg !260 ; line:197 col:21
  %FMad20.150 = call float @dx.op.tertiary.f32(i32 46, float %load9.138, float %202, float %212), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad19.151 = call float @dx.op.tertiary.f32(i32 46, float %load11.139, float %203, float %FMad20.150), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %FMad.152 = call float @dx.op.tertiary.f32(i32 46, float %load13.140, float %204, float %FMad19.151), !dbg !260 ; line:197 col:21  ; FMad(a,b,c)
  %213 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !261 ; line:197 col:19
  call void @llvm.dbg.value(metadata float %FMad27.143, i64 0, metadata !262, metadata !215), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.146, i64 0, metadata !262, metadata !218), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.149, i64 0, metadata !262, metadata !216), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.152, i64 0, metadata !262, metadata !230), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  %214 = getelementptr [4 x float], [4 x float]* %v.0, i32 0, i32 3, !dbg !264 ; line:198 col:21
  %215 = getelementptr [4 x float], [4 x float]* %v.1, i32 0, i32 3, !dbg !264 ; line:198 col:21
  %216 = getelementptr [4 x float], [4 x float]* %v.2, i32 0, i32 3, !dbg !264 ; line:198 col:21
  %load.153 = load float, float* %214, !dbg !264 ; line:198 col:21
  %load1.154 = load float, float* %215, !dbg !264 ; line:198 col:21
  %load3.155 = load float, float* %216, !dbg !264 ; line:198 col:21
  %217 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !265 ; line:198 col:19
  call void @llvm.dbg.value(metadata float %load.153, i64 0, metadata !262, metadata !266), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.154, i64 0, metadata !262, metadata !267), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.155, i64 0, metadata !262, metadata !268), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  %218 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !269 ; line:199 col:22
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !262, metadata !270), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !262, metadata !271), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !262, metadata !272), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  %219 = getelementptr [4 x float], [4 x float]* %texC.0, i32 0, i32 3, !dbg !273 ; line:200 col:21
  %220 = getelementptr [4 x float], [4 x float]* %texC.1, i32 0, i32 3, !dbg !273 ; line:200 col:21
  %load15.157 = load float, float* %219, !dbg !273 ; line:200 col:21
  %load17.158 = load float, float* %220, !dbg !273 ; line:200 col:21
  %221 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !274 ; line:200 col:19
  call void @llvm.dbg.value(metadata float %load15.157, i64 0, metadata !262, metadata !275), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.158, i64 0, metadata !262, metadata !276), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  %222 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !277 ; line:201 col:21
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !262, metadata !278), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  %223 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !279 ; line:202 col:23
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !262, metadata !280), !dbg !263 ; var:"gout" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad27.143, i64 0, metadata !281, metadata !215), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 0, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad24.146, i64 0, metadata !281, metadata !218), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 32, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad21.149, i64 0, metadata !281, metadata !216), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 64, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %FMad.152, i64 0, metadata !281, metadata !230), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 96, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad27.143), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad24.146), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad21.149), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad.152), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load.153, i64 0, metadata !281, metadata !266), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 128, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load1.154, i64 0, metadata !281, metadata !267), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 160, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load3.155, i64 0, metadata !281, metadata !268), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 192, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %load.153), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %load1.154), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %load3.155), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %.i031, i64 0, metadata !281, metadata !270), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 224, 32) func:"GS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !281, metadata !271), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 256, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %.i234, i64 0, metadata !281, metadata !272), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 288, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i031), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float 0.000000e+00), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i234), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata float %load15.157, i64 0, metadata !281, metadata !275), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 320, 32) func:"GS"
  call void @llvm.dbg.value(metadata float %load17.158, i64 0, metadata !281, metadata !276), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 352, 32) func:"GS"
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %load15.157), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %load17.158), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !281, metadata !278), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 384, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 4, i32 0, i8 0, i32 %1), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !281, metadata !280), !dbg !282 ; var:"triStream" !DIExpression(DW_OP_bit_piece, 416, 32) func:"GS"
  call void @dx.op.storeOutput.i32(i32 5, i32 5, i32 0, i8 0, i32 0), !dbg !282 ; line:204 col:9  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.emitStream(i32 97, i8 0), !dbg !282 ; line:204 col:9  ; EmitStream(streamId)
  br label %224, !dbg !283 ; line:205 col:5

; <label>:224                                     ; preds = %184
  %225 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:195 col:28
  call void @llvm.dbg.value(metadata i32 4, i64 0, metadata !254, metadata !206), !dbg !252 ; var:"i" !DIExpression() func:"GS"
  br label %._crit_edge, !dbg !255, !llvm.loop !285 ; line:195 col:5

._crit_edge:                                      ; preds = %224
  br label %226, !dbg !255 ; line:195 col:5

; <label>:226                                     ; preds = %._crit_edge
  %227 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !287 ; line:206 col:1
  ret void, !dbg !287 ; line:206 col:1
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
!llvm.module.flags = !{!135, !136}
!llvm.ident = !{!137}
!dx.source.contents = !{!138, !139}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!140}
!dx.source.args = !{!141}
!dx.version = !{!142}
!dx.valver = !{!143}
!dx.shaderModel = !{!144}
!dx.resources = !{!145}
!dx.typeAnnotations = !{!148, !178}
!dx.viewIdState = !{!181}
!dx.entryPoints = !{!182}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !31, globals: !57)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTask_GS.hlsl", directory: "")
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
!32 = !DISubprogram(name: "GS", scope: !1, file: !1, line: 166, type: !33, isLocal: false, isDefinition: true, scopeLine: 169, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @GS)
!33 = !DISubroutineType(types: !34)
!34 = !{null, !35, !43, !45}
!35 = !DICompositeType(tag: DW_TAG_array_type, baseType: !36, size: 512, align: 32, elements: !41)
!36 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexOut", file: !1, line: 71, size: 256, align: 32, elements: !37)
!37 = !{!38, !39, !40}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !36, file: !1, line: 73, baseType: !4, size: 96, align: 32)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !36, file: !1, line: 74, baseType: !4, size: 96, align: 32, offset: 96)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !36, file: !1, line: 75, baseType: !24, size: 64, align: 32, offset: 192)
!41 = !{!42}
!42 = !DISubrange(count: 2)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 61, baseType: !44)
!44 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!45 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !46)
!46 = !DICompositeType(tag: DW_TAG_class_type, name: "TriangleStream<GeoOut>", file: !1, line: 61, size: 448, align: 32, elements: !2, templateParams: !47)
!47 = !{!48}
!48 = !DITemplateTypeParameter(name: "element", type: !49)
!49 = !DICompositeType(tag: DW_TAG_structure_type, name: "GeoOut", file: !1, line: 85, size: 448, align: 32, elements: !50)
!50 = !{!51, !52, !53, !54, !55, !56}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !49, file: !1, line: 87, baseType: !15, size: 128, align: 32)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !49, file: !1, line: 88, baseType: !4, size: 96, align: 32, offset: 128)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !49, file: !1, line: 89, baseType: !4, size: 96, align: 32, offset: 224)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !49, file: !1, line: 90, baseType: !24, size: 64, align: 32, offset: 320)
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
!79 = !{!12, !80, !81}
!80 = !DITemplateValueParameter(name: "row_count", type: !14, value: i32 4)
!81 = !DITemplateValueParameter(name: "col_count", type: !14, value: i32 4)
!82 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 27, type: !59, isLocal: false, isDefinition: true)
!83 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 32, type: !84, isLocal: false, isDefinition: true)
!84 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!85 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 33, type: !86, isLocal: false, isDefinition: true)
!86 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
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
!99 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
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
!110 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!111 = !{!112, !113, !114, !115, !116, !117}
!112 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !109, file: !110, line: 5, baseType: !4, size: 96, align: 32)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !109, file: !110, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !109, file: !110, line: 7, baseType: !4, size: 96, align: 32, offset: 128)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !109, file: !110, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !109, file: !110, line: 9, baseType: !4, size: 96, align: 32, offset: 256)
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
!127 = !DITemplateTypeParameter(name: "element", type: !16)
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
!138 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTask_GS.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerObjectPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct SubVertex\0D\0A{\0D\0A    float3 PosW;\0D\0A    float3 NormalW;\0D\0A    float2 TexC;\0D\0A};\0D\0A\0D\0Astruct GeoOut\0D\0A{\0D\0A    float4 PosH : SV_POSITION;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A    uint PrimID : SV_PrimitiveID;\0D\0A    nointerpolation uint LODLevel : TEXCOORD1;\0D\0A};\0D\0A\0D\0ASubVertex MakeMidVertex(SubVertex a, SubVertex b, float3 centerW, float radius)\0D\0A{\0D\0A    SubVertex r;\0D\0A\0D\0A    float3 p = 0.5f * (a.PosW + b.PosW);\0D\0A    p = centerW + normalize(p - centerW) * radius;\0D\0A\0D\0A    r.PosW = p;\0D\0A    r.NormalW = normalize(r.PosW - centerW);\0D\0A    r.TexC = 0.5f * (a.TexC + b.TexC);\0D\0A\0D\0A    return r;\0D\0A}\0D\0A\0D\0Avoid EmitTriangle(SubVertex a, SubVertex b, SubVertex c, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    GeoOut gout;\0D\0A\0D\0A    gout.PosW = a.PosW;\0D\0A    gout.PosH = mul(float4(a.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = a.NormalW;\0D\0A    gout.TexC = a.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    gout.PosW = b.PosW;\0D\0A    gout.PosH = mul(float4(b.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = b.NormalW;\0D\0A    gout.TexC = b.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    gout.PosW = c.PosW;\0D\0A    gout.PosH = mul(float4(c.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = c.NormalW;\0D\0A    gout.TexC = c.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    triStream.RestartStrip();\0D\0A}\0D\0A\0D\0Avoid SubdivideOnce(SubVertex v0, SubVertex v1, SubVertex v2, float3 centerW, float radius, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);\0D\0A    SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);\0D\0A    SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);\0D\0A\0D\0A    EmitTriangle(v0, m0, m2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m0, m1, m2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m2, m1, v2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m0, v1, m1, primID, lodLevel, triStream);\0D\0A}\0D\0A\0D\0A//\B1\D7\B3\C9 \C6\D0\BD\BA\BD\BA\B7\E7 \BC\CE\C0\CC\B4\F5.\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout;\0D\0A    \0D\0A    float4 posW = mul(float4(vin.PosW, 1.0f), gWorld);\0D\0A    vout.PosW = posW.xyz;\0D\0A    vout.NormalW = mul(vin.NormalL, (float3x3) gWorld);\0D\0A    vout.TexC = vin.TexC;\0D\0A\0D\0A    return vout;\0D\0A}\0D\0A \0D\0A[maxvertexcount(4)]\0D\0Avoid GS(line VertexOut gin[2],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    float3 up = float3(0.0f, 1.0f, 0.0f);\0D\0A    float3 look = gEyePosW - gin[0].PosW;\0D\0A    look.y = 0.0f; //project to xz-plane\0D\0A    look = normalize(look);\0D\0A    float3 right = cross(up, look);\0D\0A\0D\0A    //float halfWidth = 0.5f * gin[0].SizeW.x;\0D\0A    //float halfHeight = 0.5f * gin[0].SizeW.y;\0D\0A\09\0D\0A    float4 v[4];\0D\0A    v[0] = float4(gin[0].PosW, 1.0f);\0D\0A    v[1] = float4(gin[1].PosW, 1.0f);\0D\0A    v[2] = float4(gin[0].PosW + up * 3.0f, 1.0f);\0D\0A    v[3] = float4(gin[1].PosW + up * 3.0f, 1.0f);\0D\0A    \0D\0A    float2 texC[4] =\0D\0A    {\0D\0A        float2(0.0f, 1.0f),\0D\0A\09\09float2(0.0f, 0.0f),\0D\0A\09\09float2(1.0f, 1.0f),\0D\0A\09\09float2(1.0f, 0.0f)\0D\0A    };\0D\0A\09\0D\0A    GeoOut gout;\0D\0A\09[unroll]//\C4\C4\C6\C4\C0\CF\C7\D2 \B6\A7 \B7\E7\C7\C1\B8\A6 \C7\AE\BE\EE\BC\AD \B0\A2 \B9\DD\BA\B9\B8\B6\B4\D9 \BA\B0\B5\B5\C0\C7 \B8\ED\B7\C9\BE\EE\B7\CE \B8\B8\B5\E9\BE\EE\C1\D8\B4\D9. \C0\CC\B7\B8\B0\D4 \C7\CF\B8\E9 GPU\B0\A1 \B8\ED\B7\C9\BE\EE\B8\A6 \B4\F5 \C8\BF\C0\B2\C0\FB\C0\B8\B7\CE \BD\C7\C7\E0\C7\D2 \BC\F6 \C0\D6\B4\D9.\0D\0A    for (int i = 0; i < 4; ++i)\0D\0A    {\0D\0A        gout.PosH = mul(v[i], gViewProj);\0D\0A        gout.PosW = v[i].xyz;\0D\0A        gout.NormalW = look;\0D\0A        gout.TexC = texC[i];\0D\0A        gout.PrimID = primID;\0D\0A        gout.LODLevel = 0;\0D\0A\09\09\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A}\0D\0A\0D\0A\0D\0A[maxvertexcount(48)]\0D\0Avoid GS_LOD(triangle VertexOut gin[3],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    float3 center = (gin[0].PosW + gin[1].PosW + gin[2].PosW) / 3.0f;\0D\0A    float distToEye = distance(gEyePosW, center);\0D\0A    \0D\0A    float3 centerW = mul(float4(0, 0, 0, 1), gWorld).xyz; // \B1\B8 \C1\DF\BD\C9\C0\C7 \BF\F9\B5\E5\C1\C2\C7\A5\0D\0A    float radius = length(gin[0].PosW - centerW);\0D\0A    \0D\0A    SubVertex v0, v1, v2;\0D\0A    v0.PosW = gin[0].PosW;\0D\0A    v0.NormalW = gin[0].NormalW;\0D\0A    v0.TexC = gin[0].TexC;\0D\0A    v1.PosW = gin[1].PosW;\0D\0A    v1.NormalW = gin[1].NormalW;\0D\0A    v1.TexC = gin[1].TexC;\0D\0A    v2.PosW = gin[2].PosW;\0D\0A    v2.NormalW = gin[2].NormalW;\0D\0A    v2.TexC = gin[2].TexC;\0D\0A    \0D\0A    if(distToEye < 15)\0D\0A    {\0D\0A        //1\C2\F7 \BC\BC\BA\D0\C8\AD\BF\A1 \C7\CA\BF\E4\C7\D1 \C1\DF\C1\A1\B5\E9\0D\0A        SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);\0D\0A        SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);\0D\0A        SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);\0D\0A\0D\0A        //1\C2\F7 \BC\BC\BA\D0\C8\AD\B7\CE \B3\AA\BF\C2 4\B0\B3 \BB\EF\B0\A2\C7\FC\C0\BB \B0\A2\B0\A2 \B4\D9\BD\C3 \BC\BC\BA\D0\C8\AD (2\C2\F7 \BC\BC\BA\D0\C8\AD)\0D\0A        SubdivideOnce(v0, m0, m2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m0, m1, m2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m2, m1, v2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m0, v1, m1, centerW, radius, primID, 2, triStream);\0D\0A    }\0D\0A    else if (distToEye >= 15 && distToEye < 25)\0D\0A    {\0D\0A        SubdivideOnce(v0, v1, v2, centerW, radius, primID, 1, triStream);\0D\0A    }\0D\0A    else //distToEye >= 25\0D\0A    {\0D\0A        int vertexNum = 3;\0D\0A        GeoOut gout;\0D\0A\09    [unroll]\0D\0A        for (int i = 0; i < vertexNum; ++i)\0D\0A        {\0D\0A            gout.PosH = mul(float4(gin[i].PosW, 1.0f), gViewProj);\0D\0A            gout.PosW = gin[i].PosW;\0D\0A            gout.NormalW = gin[i].NormalW;\0D\0A            gout.TexC = gin[i].TexC;\0D\0A            gout.PrimID = primID;\0D\0A            gout.LODLevel = 0;\0D\0A\09\09\0D\0A            triStream.Append(gout);\0D\0A        }\0D\0A    }\0D\0A}\0D\0A\0D\0A[maxvertexcount(4)]\0D\0Avoid GS_Explode(triangle VertexOut gin[3],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{    \0D\0A    float rand = frac(sin(primID * 12.9898f) * 758.5453f);\0D\0A    float t = frac(gTotalTime + rand * 0.13f);\0D\0A    \0D\0A    float explodeAmount;\0D\0A    float explodeDuration = 0.95f; // \C6\F8\B9\DF\C0\CC \BF\CF\C0\FC\C8\F7 \C1\F8\C7\E0\B5\C7\B4\C2 \BD\C3\B0\A3\0D\0A    if (t < explodeDuration)\0D\0A    {\0D\0A        float localT = t / explodeDuration; // 0~1\B7\CE \C0\E7\C1\A4\B1\D4\C8\AD\0D\0A        explodeAmount = pow(localT, 18.0f);\0D\0A    }\0D\0A    else\0D\0A        explodeAmount = 1.0f;\0D\0A    \0D\0A    float3 e0 = gin[1].PosW - gin[0].PosW;\0D\0A    float3 e1 = gin[2].PosW - gin[0].PosW;\0D\0A    float3 faceNormal = normalize(cross(e0, e1)) * 2.0f;\0D\0A    \0D\0A    float3 explodeVector = explodeAmount * faceNormal;\0D\0A    \0D\0A    [unroll]\0D\0A    for (int i = 0; i < 3; ++i)\0D\0A    {\0D\0A        GeoOut gout;\0D\0A\0D\0A        float3 newPosW = gin[i].PosW + explodeVector;\0D\0A\0D\0A        gout.PosW = newPosW;\0D\0A        gout.NormalW = faceNormal;\0D\0A        gout.TexC = gin[i].TexC;\0D\0A        gout.PosH = mul(float4(newPosW, 1.0f), gViewProj);\0D\0A        gout.PrimID = primID;\0D\0A        gout.LODLevel = 0;\0D\0A\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A\0D\0A    triStream.RestartStrip();\0D\0A}\0D\0A\0D\0A[maxvertexcount(2)]\0D\0Avoid GS_Debugging(point VertexOut gin[1],\0D\0A                  uint primID : SV_PrimitiveID,\0D\0A                  inout LineStream<GeoOut> lineStream)\0D\0A{\0D\0A    GeoOut gout;\0D\0A\0D\0A    float NormalLength = 0.2f;\0D\0A    float3 p0 = gin[0].PosW;\0D\0A    float3 p1 = gin[0].PosW + gin[0].NormalW * NormalLength;\0D\0A\0D\0A    // \BD\C3\C0\DB\C1\A1\0D\0A    gout.PosW = p0;\0D\0A    gout.NormalW = gin[0].NormalW;\0D\0A    gout.TexC = gin[0].TexC;\0D\0A    gout.PosH = mul(float4(p0, 1.0f), gViewProj);\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = 0;\0D\0A    lineStream.Append(gout);\0D\0A\0D\0A    // \B3\A1\C1\A1\0D\0A    gout.PosW = p1;\0D\0A    gout.NormalW = gin[0].NormalW;\0D\0A    gout.TexC = gin[0].TexC;\0D\0A    gout.PosH = mul(float4(p1, 1.0f), gViewProj);\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = 0;\0D\0A    lineStream.Append(gout);\0D\0A\0D\0A    lineStream.RestartStrip();\0D\0A}\0D\0A\0D\0Afloat4 PS(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 uvw = float3(pin.TexC, pin.PrimID % 3);\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamAnisotropicClamp, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A    if (pin.LODLevel == 2)\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(1.15f, 0.95f, 0.95f); // \BA\D3\C0\BA\B1\E2\0D\0A    }\0D\0A    else if (pin.LODLevel == 1)\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(0.95f, 1.15f, 0.95f); // \C3\CA\B7\CF\B1\E2\0D\0A    }\0D\0A    else\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(0.95f, 0.95f, 1.15f); // \C7\AA\B8\A5\B1\E2\0D\0A    }\0D\0A    \0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A    \0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A#ifdef FOG\0D\0A\09float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A\09litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A    \0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A\0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_VertexNormal(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 normalColor = pin.NormalW * 0.5f + 0.5f;\0D\0A    return float4(normalColor, 1.0f);\0D\0A}"}
!139 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhongToon(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    // 1) kd\0D\0A    float kd = saturate(dot(lightVec, normal));\0D\0A    float kd_q = QuantizeKd(kd);\0D\0A\0D\0A    // 2) ks (Blinn-Phong)\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    float ndoth = saturate(dot(halfVec, normal));\0D\0A\0D\0A    float ks = pow(max(ndoth, 0), m); // \EC\8A\A4\ED\8E\99\ED\81\98\EB\9F\AC \EA\B0\95\EB\8F\84\EC\9D\98 \ED\95\B5\EC\8B\AC\0D\0A    float ks_q = QuantizeKs(ks); // \EC\9D\B4\EC\82\B0\ED\99\94\0D\0A\0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    // fresnel(\EC\83\89) + (\ED\95\84\EC\9A\94\ED\95\98\EB\A9\B4) \EC\A0\95\EA\B7\9C\ED\99\94 \EA\B3\84\EC\88\98\EB\8A\94 \EC\B7\A8\ED\96\A5\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A\0D\0A    // ks_q\EB\A5\BC spec\EC\97\90 \EB\B0\98\EC\98\81\0D\0A    float3 specAlbedo = roughnessFactor * fresnelFactor * ks_q;\0D\0A\0D\0A    // LDR clamp\EB\8A\94 \EC\9C\A0\EC\A7\80 \EA\B0\80\EB\8A\A5\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A\0D\0A    // diffuse\EB\8A\94 kd_q\EB\A5\BC \EB\B0\98\EC\98\81\0D\0A    float3 diffuse = mat.DiffuseAlbedo.rgb * kd_q;\0D\0A    \0D\0A    return (diffuse + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!140 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTask_GS.hlsl"}
!141 = !{!"-E", !"GS", !"-T", !"gs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CLineToCylinderGS.cso"}
!142 = !{i32 1, i32 0}
!143 = !{i32 1, i32 8}
!144 = !{!"gs", i32 6, i32 0}
!145 = !{null, null, !146, null}
!146 = !{!147}
!147 = !{i32 0, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!148 = !{i32 0, %struct.Light undef, !149, %hostlayout.cbPass undef, !156}
!149 = !{i32 48, !150, !151, !152, !153, !154, !155}
!150 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!151 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!152 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!153 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!154 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!155 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!156 = !{i32 1248, !157, !159, !160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176, !177}
!157 = !{i32 6, !"gView", i32 2, !158, i32 3, i32 0, i32 7, i32 9}
!158 = !{i32 4, i32 4, i32 2}
!159 = !{i32 6, !"gInvView", i32 2, !158, i32 3, i32 64, i32 7, i32 9}
!160 = !{i32 6, !"gProj", i32 2, !158, i32 3, i32 128, i32 7, i32 9}
!161 = !{i32 6, !"gInvProj", i32 2, !158, i32 3, i32 192, i32 7, i32 9}
!162 = !{i32 6, !"gViewProj", i32 2, !158, i32 3, i32 256, i32 7, i32 9}
!163 = !{i32 6, !"gInvViewProj", i32 2, !158, i32 3, i32 320, i32 7, i32 9}
!164 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!165 = !{i32 6, !"cbPerObjectPad1", i32 3, i32 396, i32 7, i32 9}
!166 = !{i32 6, !"gRenderTargetSize", i32 3, i32 400, i32 7, i32 9}
!167 = !{i32 6, !"gInvRenderTargetSize", i32 3, i32 408, i32 7, i32 9}
!168 = !{i32 6, !"gNearZ", i32 3, i32 416, i32 7, i32 9}
!169 = !{i32 6, !"gFarZ", i32 3, i32 420, i32 7, i32 9}
!170 = !{i32 6, !"gTotalTime", i32 3, i32 424, i32 7, i32 9}
!171 = !{i32 6, !"gDeltaTime", i32 3, i32 428, i32 7, i32 9}
!172 = !{i32 6, !"gAmbientLight", i32 3, i32 432, i32 7, i32 9}
!173 = !{i32 6, !"gLights", i32 3, i32 448}
!174 = !{i32 6, !"gFogColor", i32 3, i32 1216, i32 7, i32 9}
!175 = !{i32 6, !"gFogStart", i32 3, i32 1232, i32 7, i32 9}
!176 = !{i32 6, !"gFogRange", i32 3, i32 1236, i32 7, i32 9}
!177 = !{i32 6, !"cbPerObjectPad2", i32 3, i32 1240, i32 7, i32 9}
!178 = !{i32 1, void ()* @GS, !179}
!179 = !{!180}
!180 = !{i32 0, !2, !2}
!181 = !{[15 x i32] [i32 10, i32 21, i32 1311, i32 47, i32 1359, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0]}
!182 = !{void ()* @GS, !"GS", !183, !145, !202}
!183 = !{!184, !191, null}
!184 = !{!185, !188, !189, !190}
!185 = !{i32 0, !"POSITION", i8 9, i8 0, !186, i8 2, i32 1, i8 3, i32 0, i8 0, !187}
!186 = !{i32 0}
!187 = !{i32 3, i32 7}
!188 = !{i32 1, !"NORMAL", i8 9, i8 0, !186, i8 2, i32 1, i8 3, i32 1, i8 0, null}
!189 = !{i32 2, !"TEXCOORD", i8 9, i8 0, !186, i8 2, i32 1, i8 2, i32 2, i8 0, null}
!190 = !{i32 3, !"SV_PrimitiveID", i8 5, i8 10, !186, i8 0, i32 1, i8 1, i32 -1, i8 -1, null}
!191 = !{!192, !194, !195, !196, !198, !200}
!192 = !{i32 0, !"SV_Position", i8 9, i8 3, !186, i8 4, i32 1, i8 4, i32 0, i8 0, !193}
!193 = !{i32 3, i32 15}
!194 = !{i32 1, !"POSITION", i8 9, i8 0, !186, i8 2, i32 1, i8 3, i32 1, i8 0, !187}
!195 = !{i32 2, !"NORMAL", i8 9, i8 0, !186, i8 2, i32 1, i8 3, i32 2, i8 0, !187}
!196 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !186, i8 2, i32 1, i8 2, i32 3, i8 0, !197}
!197 = !{i32 3, i32 3}
!198 = !{i32 4, !"SV_PrimitiveID", i8 5, i8 10, !186, i8 1, i32 1, i8 1, i32 4, i8 0, !199}
!199 = !{i32 3, i32 1}
!200 = !{i32 5, !"TEXCOORD", i8 5, i8 0, !201, i8 1, i32 1, i8 1, i32 5, i8 0, !199}
!201 = !{i32 1}
!202 = !{i32 0, i64 1, i32 1, !203}
!203 = !{i32 2, i32 4, i32 1, i32 5, i32 1}
!204 = !DILocation(line: 168, column: 38, scope: !32)
!205 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "primID", arg: 2, scope: !32, file: !1, line: 167, type: !43)
!206 = !DIExpression()
!207 = !DILocation(line: 167, column: 14, scope: !32)
!208 = !DILocation(line: 170, column: 12, scope: !32)
!209 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "up", scope: !32, file: !1, line: 170, type: !4)
!210 = !DILocation(line: 171, column: 19, scope: !32)
!211 = !DILocation(line: 171, column: 37, scope: !32)
!212 = !DILocation(line: 171, column: 28, scope: !32)
!213 = !DILocation(line: 171, column: 12, scope: !32)
!214 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "look", scope: !32, file: !1, line: 171, type: !4)
!215 = !DIExpression(DW_OP_bit_piece, 0, 32)
!216 = !DIExpression(DW_OP_bit_piece, 64, 32)
!217 = !DILocation(line: 172, column: 12, scope: !32)
!218 = !DIExpression(DW_OP_bit_piece, 32, 32)
!219 = !DILocation(line: 173, column: 12, scope: !32)
!220 = !DILocation(line: 173, column: 10, scope: !32)
!221 = !DILocation(line: 174, column: 12, scope: !32)
!222 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "v", scope: !32, file: !1, line: 179, type: !223)
!223 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 512, align: 32, elements: !224)
!224 = !{!225}
!225 = !DISubrange(count: 4)
!226 = !DILocation(line: 179, column: 12, scope: !32)
!227 = !{i32 0, i32 128, i32 4}
!228 = !{i32 32, i32 128, i32 4}
!229 = !{i32 64, i32 128, i32 4}
!230 = !DIExpression(DW_OP_bit_piece, 96, 32)
!231 = !{i32 96, i32 128, i32 4}
!232 = !DILocation(line: 180, column: 26, scope: !32)
!233 = !DILocation(line: 180, column: 5, scope: !32)
!234 = !DILocation(line: 180, column: 10, scope: !32)
!235 = !DILocation(line: 181, column: 26, scope: !32)
!236 = !DILocation(line: 181, column: 5, scope: !32)
!237 = !DILocation(line: 181, column: 10, scope: !32)
!238 = !DILocation(line: 182, column: 26, scope: !32)
!239 = !DILocation(line: 182, column: 31, scope: !32)
!240 = !DILocation(line: 182, column: 5, scope: !32)
!241 = !DILocation(line: 182, column: 10, scope: !32)
!242 = !DILocation(line: 183, column: 26, scope: !32)
!243 = !DILocation(line: 183, column: 31, scope: !32)
!244 = !DILocation(line: 183, column: 5, scope: !32)
!245 = !DILocation(line: 183, column: 10, scope: !32)
!246 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "texC", scope: !32, file: !1, line: 185, type: !247)
!247 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 256, align: 32, elements: !224)
!248 = !DILocation(line: 185, column: 12, scope: !32)
!249 = !{i32 0, i32 64, i32 4}
!250 = !{i32 32, i32 64, i32 4}
!251 = !DILocation(line: 186, column: 5, scope: !32)
!252 = !DILocation(line: 195, column: 14, scope: !253)
!253 = distinct !DILexicalBlock(scope: !32, file: !1, line: 195, column: 5)
!254 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !253, file: !1, line: 195, type: !14)
!255 = !DILocation(line: 195, column: 5, scope: !253)
!256 = !DILocation(line: 197, column: 31, scope: !257)
!257 = distinct !DILexicalBlock(scope: !258, file: !1, line: 196, column: 5)
!258 = distinct !DILexicalBlock(scope: !253, file: !1, line: 195, column: 5)
!259 = !DILocation(line: 197, column: 25, scope: !257)
!260 = !DILocation(line: 197, column: 21, scope: !257)
!261 = !DILocation(line: 197, column: 19, scope: !257)
!262 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "gout", scope: !32, file: !1, line: 193, type: !49)
!263 = !DILocation(line: 193, column: 12, scope: !32)
!264 = !DILocation(line: 198, column: 21, scope: !257)
!265 = !DILocation(line: 198, column: 19, scope: !257)
!266 = !DIExpression(DW_OP_bit_piece, 128, 32)
!267 = !DIExpression(DW_OP_bit_piece, 160, 32)
!268 = !DIExpression(DW_OP_bit_piece, 192, 32)
!269 = !DILocation(line: 199, column: 22, scope: !257)
!270 = !DIExpression(DW_OP_bit_piece, 224, 32)
!271 = !DIExpression(DW_OP_bit_piece, 256, 32)
!272 = !DIExpression(DW_OP_bit_piece, 288, 32)
!273 = !DILocation(line: 200, column: 21, scope: !257)
!274 = !DILocation(line: 200, column: 19, scope: !257)
!275 = !DIExpression(DW_OP_bit_piece, 320, 32)
!276 = !DIExpression(DW_OP_bit_piece, 352, 32)
!277 = !DILocation(line: 201, column: 21, scope: !257)
!278 = !DIExpression(DW_OP_bit_piece, 384, 32)
!279 = !DILocation(line: 202, column: 23, scope: !257)
!280 = !DIExpression(DW_OP_bit_piece, 416, 32)
!281 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "triStream", arg: 3, scope: !32, file: !1, line: 168, type: !46)
!282 = !DILocation(line: 204, column: 9, scope: !257)
!283 = !DILocation(line: 205, column: 5, scope: !257)
!284 = !DILocation(line: 195, column: 28, scope: !258)
!285 = distinct !{!285, !286}
!286 = !{!"llvm.loop.unroll.full"}
!287 = !DILocation(line: 206, column: 1, scope: !32)
