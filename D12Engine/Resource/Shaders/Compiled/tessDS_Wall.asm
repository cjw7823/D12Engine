;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   xyz 
; NORMAL                   0   xyz         1     NONE   float   xyz 
; TEXCOORD                 0   xy          2     NONE   float       
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
;
; Patch Constant signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_TessFactor            0      w        0 QUADEDGE   float   xyzw
; SV_TessFactor            1      w        1 QUADEDGE   float   xyzw
; SV_TessFactor            2      w        2 QUADEDGE   float   xyzw
; SV_TessFactor            3      w        3 QUADEDGE   float   xyzw
; SV_InsideTessFactor      0      w        4  QUADINT   float   xyzw
; SV_InsideTessFactor      1      w        5  QUADINT   float   xyzw
;
; shader debug name: 42ab8870d58451adc6255a2391ed07a4.pdb
; shader hash: 42ab8870d58451adc6255a2391ed07a4
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Domain Shader
; InputControlPointCount=4
; OutputPositionPresent=1
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 3
; SigOutputElements: 4
; SigPatchConstOrPrimElements: 2
; SigInputVectors: 3
; SigOutputVectors[0]: 4
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: DS
;
;
; Input signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; POSITION                 0                 linear       
; NORMAL                   0                 linear       
; TEXCOORD                 0                 linear       
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
; Patch Constant signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_TessFactor            0                              
; SV_InsideTessFactor      0                              
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
; Number of inputs: 10, outputs: 14, patchconst: 24
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;   output 0 depends on inputs: { 0, 1, 2, 4, 5, 6 }
;   output 1 depends on inputs: { 0, 1, 2, 4, 5, 6 }
;   output 2 depends on inputs: { 0, 1, 2, 4, 5, 6 }
;   output 3 depends on inputs: { 0, 1, 2, 4, 5, 6 }
;   output 4 depends on inputs: { 0, 1, 2, 4, 5, 6 }
;   output 5 depends on inputs: { 0, 1, 2, 4, 5, 6 }
;   output 6 depends on inputs: { 0, 1, 2, 4, 5, 6 }
;   output 8 depends on inputs: { 4, 5, 6 }
;   output 9 depends on inputs: { 4, 5, 6 }
;   output 10 depends on inputs: { 4, 5, 6 }
; PCInputs contributing to computation of Outputs:
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

define void @DS() {
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 2, i32 2, i1 false), !dbg !261 ; line:172 col:44  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbMaterial_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 1, i32 1, i1 false), !dbg !261 ; line:172 col:44  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbPerObject_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 0, i1 false), !dbg !261 ; line:172 col:44  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call float @dx.op.domainLocation.f32(i32 105, i8 0), !dbg !261 ; line:172 col:44  ; DomainLocation(component)
  %2 = call float @dx.op.domainLocation.f32(i32 105, i8 1), !dbg !261 ; line:172 col:44  ; DomainLocation(component)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !262, metadata !263), !dbg !264 ; var:"uv" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !262, metadata !265), !dbg !264 ; var:"uv" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 1), !dbg !266 ; line:177 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 1), !dbg !266 ; line:177 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 1), !dbg !266 ; line:177 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !267 ; line:177 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 0), !dbg !267 ; line:177 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !267 ; line:177 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i0 = fsub fast float %3, %6, !dbg !268 ; line:177 col:17
  %.i1 = fsub fast float %4, %7, !dbg !268 ; line:177 col:17
  %.i2 = fsub fast float %5, %8, !dbg !268 ; line:177 col:17
  %.i060 = fmul fast float %1, %.i0, !dbg !268 ; line:177 col:17
  %.i161 = fmul fast float %1, %.i1, !dbg !268 ; line:177 col:17
  %.i262 = fmul fast float %1, %.i2, !dbg !268 ; line:177 col:17
  %.i063 = fadd fast float %6, %.i060, !dbg !268 ; line:177 col:17
  %.i164 = fadd fast float %7, %.i161, !dbg !268 ; line:177 col:17
  %.i265 = fadd fast float %8, %.i262, !dbg !268 ; line:177 col:17
  %9 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !269 ; line:177 col:12
  call void @llvm.dbg.value(metadata float %.i063, i64 0, metadata !270, metadata !263), !dbg !269 ; var:"v1" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i164, i64 0, metadata !270, metadata !265), !dbg !269 ; var:"v1" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i265, i64 0, metadata !270, metadata !271), !dbg !269 ; var:"v1" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %10 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 3), !dbg !272 ; line:178 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %11 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 3), !dbg !272 ; line:178 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %12 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 3), !dbg !272 ; line:178 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %13 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 2), !dbg !273 ; line:178 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %14 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 2), !dbg !273 ; line:178 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %15 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 2), !dbg !273 ; line:178 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i066 = fsub fast float %10, %13, !dbg !274 ; line:178 col:17
  %.i167 = fsub fast float %11, %14, !dbg !274 ; line:178 col:17
  %.i268 = fsub fast float %12, %15, !dbg !274 ; line:178 col:17
  %.i069 = fmul fast float %1, %.i066, !dbg !274 ; line:178 col:17
  %.i170 = fmul fast float %1, %.i167, !dbg !274 ; line:178 col:17
  %.i271 = fmul fast float %1, %.i268, !dbg !274 ; line:178 col:17
  %.i072 = fadd fast float %13, %.i069, !dbg !274 ; line:178 col:17
  %.i173 = fadd fast float %14, %.i170, !dbg !274 ; line:178 col:17
  %.i274 = fadd fast float %15, %.i271, !dbg !274 ; line:178 col:17
  %16 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !275 ; line:178 col:12
  call void @llvm.dbg.value(metadata float %.i072, i64 0, metadata !276, metadata !263), !dbg !275 ; var:"v2" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i173, i64 0, metadata !276, metadata !265), !dbg !275 ; var:"v2" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i274, i64 0, metadata !276, metadata !271), !dbg !275 ; var:"v2" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %.i075 = fsub fast float %.i072, %.i063, !dbg !277 ; line:179 col:19
  %.i176 = fsub fast float %.i173, %.i164, !dbg !277 ; line:179 col:19
  %.i277 = fsub fast float %.i274, %.i265, !dbg !277 ; line:179 col:19
  %.i078 = fmul fast float %2, %.i075, !dbg !277 ; line:179 col:19
  %.i179 = fmul fast float %2, %.i176, !dbg !277 ; line:179 col:19
  %.i280 = fmul fast float %2, %.i277, !dbg !277 ; line:179 col:19
  %.i081 = fadd fast float %.i063, %.i078, !dbg !277 ; line:179 col:19
  %.i182 = fadd fast float %.i164, %.i179, !dbg !277 ; line:179 col:19
  %.i283 = fadd fast float %.i265, %.i280, !dbg !277 ; line:179 col:19
  %17 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !278 ; line:179 col:12
  call void @llvm.dbg.value(metadata float %.i081, i64 0, metadata !279, metadata !263), !dbg !278 ; var:"posL" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i182, i64 0, metadata !279, metadata !265), !dbg !278 ; var:"posL" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i283, i64 0, metadata !279, metadata !271), !dbg !278 ; var:"posL" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %18 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 1), !dbg !280 ; line:181 col:47  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %19 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 1), !dbg !280 ; line:181 col:47  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %20 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 1), !dbg !280 ; line:181 col:47  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %21 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 0), !dbg !281 ; line:181 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %22 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 0), !dbg !281 ; line:181 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %23 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 0), !dbg !281 ; line:181 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i084 = fsub fast float %18, %21, !dbg !282 ; line:181 col:17
  %.i185 = fsub fast float %19, %22, !dbg !282 ; line:181 col:17
  %.i286 = fsub fast float %20, %23, !dbg !282 ; line:181 col:17
  %.i087 = fmul fast float %1, %.i084, !dbg !282 ; line:181 col:17
  %.i188 = fmul fast float %1, %.i185, !dbg !282 ; line:181 col:17
  %.i289 = fmul fast float %1, %.i286, !dbg !282 ; line:181 col:17
  %.i090 = fadd fast float %21, %.i087, !dbg !282 ; line:181 col:17
  %.i191 = fadd fast float %22, %.i188, !dbg !282 ; line:181 col:17
  %.i292 = fadd fast float %23, %.i289, !dbg !282 ; line:181 col:17
  %24 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !283 ; line:181 col:12
  call void @llvm.dbg.value(metadata float %.i090, i64 0, metadata !284, metadata !263), !dbg !283 ; var:"n1" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i191, i64 0, metadata !284, metadata !265), !dbg !283 ; var:"n1" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i292, i64 0, metadata !284, metadata !271), !dbg !283 ; var:"n1" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %25 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 3), !dbg !285 ; line:182 col:47  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %26 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 3), !dbg !285 ; line:182 col:47  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %27 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 3), !dbg !285 ; line:182 col:47  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %28 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 2), !dbg !286 ; line:182 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %29 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 2), !dbg !286 ; line:182 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %30 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 2), !dbg !286 ; line:182 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i093 = fsub fast float %25, %28, !dbg !287 ; line:182 col:17
  %.i194 = fsub fast float %26, %29, !dbg !287 ; line:182 col:17
  %.i295 = fsub fast float %27, %30, !dbg !287 ; line:182 col:17
  %.i096 = fmul fast float %1, %.i093, !dbg !287 ; line:182 col:17
  %.i197 = fmul fast float %1, %.i194, !dbg !287 ; line:182 col:17
  %.i298 = fmul fast float %1, %.i295, !dbg !287 ; line:182 col:17
  %.i099 = fadd fast float %28, %.i096, !dbg !287 ; line:182 col:17
  %.i1100 = fadd fast float %29, %.i197, !dbg !287 ; line:182 col:17
  %.i2101 = fadd fast float %30, %.i298, !dbg !287 ; line:182 col:17
  %31 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:182 col:12
  call void @llvm.dbg.value(metadata float %.i099, i64 0, metadata !289, metadata !263), !dbg !288 ; var:"n2" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i1100, i64 0, metadata !289, metadata !265), !dbg !288 ; var:"n2" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i2101, i64 0, metadata !289, metadata !271), !dbg !288 ; var:"n2" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %.i0102 = fsub fast float %.i099, %.i090, !dbg !290 ; line:183 col:32
  %.i1103 = fsub fast float %.i1100, %.i191, !dbg !290 ; line:183 col:32
  %.i2104 = fsub fast float %.i2101, %.i292, !dbg !290 ; line:183 col:32
  %.i0105 = fmul fast float %2, %.i0102, !dbg !290 ; line:183 col:32
  %.i1106 = fmul fast float %2, %.i1103, !dbg !290 ; line:183 col:32
  %.i2107 = fmul fast float %2, %.i2104, !dbg !290 ; line:183 col:32
  %.i0108 = fadd fast float %.i090, %.i0105, !dbg !290 ; line:183 col:32
  %.i1109 = fadd fast float %.i191, %.i1106, !dbg !290 ; line:183 col:32
  %.i2110 = fadd fast float %.i292, %.i2107, !dbg !290 ; line:183 col:32
  %32 = call float @dx.op.dot3.f32(i32 55, float %.i0108, float %.i1109, float %.i2110, float %.i0108, float %.i1109, float %.i2110), !dbg !291 ; line:183 col:22  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt = call float @dx.op.unary.f32(i32 25, float %32), !dbg !291 ; line:183 col:22  ; Rsqrt(value)
  %.i0111 = fmul fast float %.i0108, %Rsqrt, !dbg !291 ; line:183 col:22
  %.i1112 = fmul fast float %.i1109, %Rsqrt, !dbg !291 ; line:183 col:22
  %.i2113 = fmul fast float %.i2110, %Rsqrt, !dbg !291 ; line:183 col:22
  %33 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !292 ; line:183 col:12
  call void @llvm.dbg.value(metadata float %.i0111, i64 0, metadata !293, metadata !263), !dbg !292 ; var:"normalL" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i1112, i64 0, metadata !293, metadata !265), !dbg !292 ; var:"normalL" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i2113, i64 0, metadata !293, metadata !271), !dbg !292 ; var:"normalL" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %.i0115 = fmul fast float %1, 1.280000e+02, !dbg !294 ; line:185 col:31
  %.i1117 = fmul fast float %2, 1.280000e+02, !dbg !294 ; line:185 col:31
  %Round_ni = call float @dx.op.unary.f32(i32 27, float %.i0115), !dbg !295 ; line:185 col:22  ; Round_ni(value)
  %Round_ni6 = call float @dx.op.unary.f32(i32 27, float %.i1117), !dbg !295 ; line:185 col:22  ; Round_ni(value)
  %34 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !296 ; line:185 col:15
  call void @llvm.dbg.value(metadata float %Round_ni, i64 0, metadata !297, metadata !263), !dbg !298 ; var:"p" !DIExpression(DW_OP_bit_piece, 0, 32) func:"Hash12"
  call void @llvm.dbg.value(metadata float %Round_ni6, i64 0, metadata !297, metadata !265), !dbg !298 ; var:"p" !DIExpression(DW_OP_bit_piece, 32, 32) func:"Hash12"
  %35 = call float @dx.op.dot2.f32(i32 54, float %Round_ni, float %Round_ni6, float 0x405FC66660000000, float 0x40737B3340000000), !dbg !300 ; line:164 col:21  ; Dot2(ax,ay,bx,by)
  %Sin = call float @dx.op.unary.f32(i32 13, float %35), !dbg !301 ; line:164 col:17  ; Sin(value)
  %36 = fmul fast float %Sin, 0x40E55DD180000000, !dbg !302 ; line:164 col:53
  %Frc = call float @dx.op.unary.f32(i32 22, float %36), !dbg !303 ; line:164 col:12  ; Frc(value)
  %37 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !304 ; line:164 col:5
  %38 = fmul fast float %Frc, 0x3FB99999A0000000, !dbg !305 ; line:185 col:42
  %39 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !306 ; line:185 col:11
  call void @llvm.dbg.value(metadata float %38, i64 0, metadata !307, metadata !308), !dbg !306 ; var:"h" !DIExpression() func:"DS"
  %.i0118 = fmul fast float %.i0111, %38, !dbg !309 ; line:188 col:21
  %.i1119 = fmul fast float %.i1112, %38, !dbg !309 ; line:188 col:21
  %.i2120 = fmul fast float %.i2113, %38, !dbg !309 ; line:188 col:21
  %.i0121 = fadd fast float %.i081, %.i0118, !dbg !310 ; line:188 col:10
  %.i1122 = fadd fast float %.i182, %.i1119, !dbg !310 ; line:188 col:10
  %.i2123 = fadd fast float %.i283, %.i2120, !dbg !310 ; line:188 col:10
  %40 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !310 ; line:188 col:10
  call void @llvm.dbg.value(metadata float %.i0121, i64 0, metadata !279, metadata !263), !dbg !278 ; var:"posL" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i1122, i64 0, metadata !279, metadata !265), !dbg !278 ; var:"posL" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i2123, i64 0, metadata !279, metadata !271), !dbg !278 ; var:"posL" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %41 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 0), !dbg !311 ; line:197 col:43  ; CBufferLoadLegacy(handle,regIndex)
  %42 = extractvalue %dx.types.CBufRet.f32 %41, 0, !dbg !311 ; line:197 col:43
  %43 = extractvalue %dx.types.CBufRet.f32 %41, 1, !dbg !311 ; line:197 col:43
  %44 = extractvalue %dx.types.CBufRet.f32 %41, 2, !dbg !311 ; line:197 col:43
  %45 = extractvalue %dx.types.CBufRet.f32 %41, 3, !dbg !311 ; line:197 col:43
  %46 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 1), !dbg !311 ; line:197 col:43  ; CBufferLoadLegacy(handle,regIndex)
  %47 = extractvalue %dx.types.CBufRet.f32 %46, 0, !dbg !311 ; line:197 col:43
  %48 = extractvalue %dx.types.CBufRet.f32 %46, 1, !dbg !311 ; line:197 col:43
  %49 = extractvalue %dx.types.CBufRet.f32 %46, 2, !dbg !311 ; line:197 col:43
  %50 = extractvalue %dx.types.CBufRet.f32 %46, 3, !dbg !311 ; line:197 col:43
  %51 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 2), !dbg !311 ; line:197 col:43  ; CBufferLoadLegacy(handle,regIndex)
  %52 = extractvalue %dx.types.CBufRet.f32 %51, 0, !dbg !311 ; line:197 col:43
  %53 = extractvalue %dx.types.CBufRet.f32 %51, 1, !dbg !311 ; line:197 col:43
  %54 = extractvalue %dx.types.CBufRet.f32 %51, 2, !dbg !311 ; line:197 col:43
  %55 = extractvalue %dx.types.CBufRet.f32 %51, 3, !dbg !311 ; line:197 col:43
  %56 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 3), !dbg !311 ; line:197 col:43  ; CBufferLoadLegacy(handle,regIndex)
  %57 = extractvalue %dx.types.CBufRet.f32 %56, 0, !dbg !311 ; line:197 col:43
  %58 = extractvalue %dx.types.CBufRet.f32 %56, 1, !dbg !311 ; line:197 col:43
  %59 = extractvalue %dx.types.CBufRet.f32 %56, 2, !dbg !311 ; line:197 col:43
  %60 = extractvalue %dx.types.CBufRet.f32 %56, 3, !dbg !311 ; line:197 col:43
  %61 = fmul fast float %.i0121, %42, !dbg !312 ; line:197 col:19
  %FMad59 = call float @dx.op.tertiary.f32(i32 46, float %.i1122, float %43, float %61), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %FMad58 = call float @dx.op.tertiary.f32(i32 46, float %.i2123, float %44, float %FMad59), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %FMad57 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %45, float %FMad58), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %62 = fmul fast float %.i0121, %47, !dbg !312 ; line:197 col:19
  %FMad56 = call float @dx.op.tertiary.f32(i32 46, float %.i1122, float %48, float %62), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %FMad55 = call float @dx.op.tertiary.f32(i32 46, float %.i2123, float %49, float %FMad56), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %FMad54 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %50, float %FMad55), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %63 = fmul fast float %.i0121, %52, !dbg !312 ; line:197 col:19
  %FMad53 = call float @dx.op.tertiary.f32(i32 46, float %.i1122, float %53, float %63), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %FMad52 = call float @dx.op.tertiary.f32(i32 46, float %.i2123, float %54, float %FMad53), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %FMad51 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %55, float %FMad52), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %64 = fmul fast float %.i0121, %57, !dbg !312 ; line:197 col:19
  %FMad50 = call float @dx.op.tertiary.f32(i32 46, float %.i1122, float %58, float %64), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %FMad49 = call float @dx.op.tertiary.f32(i32 46, float %.i2123, float %59, float %FMad50), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %FMad48 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %60, float %FMad49), !dbg !312 ; line:197 col:19  ; FMad(a,b,c)
  %65 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !313 ; line:197 col:12
  call void @llvm.dbg.value(metadata float %FMad57, i64 0, metadata !314, metadata !263), !dbg !313 ; var:"posW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad54, i64 0, metadata !314, metadata !265), !dbg !313 ; var:"posW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad51, i64 0, metadata !314, metadata !271), !dbg !313 ; var:"posW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad48, i64 0, metadata !314, metadata !315), !dbg !313 ; var:"posW" !DIExpression(DW_OP_bit_piece, 96, 32) func:"DS"
  %66 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !316 ; line:198 col:15
  call void @llvm.dbg.value(metadata float %FMad57, i64 0, metadata !317, metadata !318), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad54, i64 0, metadata !317, metadata !320), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad51, i64 0, metadata !317, metadata !321), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"DS"
  %67 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !322 ; line:200 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %68 = extractvalue %dx.types.CBufRet.f32 %67, 0, !dbg !322 ; line:200 col:27
  %69 = extractvalue %dx.types.CBufRet.f32 %67, 1, !dbg !322 ; line:200 col:27
  %70 = extractvalue %dx.types.CBufRet.f32 %67, 2, !dbg !322 ; line:200 col:27
  %71 = extractvalue %dx.types.CBufRet.f32 %67, 3, !dbg !322 ; line:200 col:27
  %72 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !322 ; line:200 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %73 = extractvalue %dx.types.CBufRet.f32 %72, 0, !dbg !322 ; line:200 col:27
  %74 = extractvalue %dx.types.CBufRet.f32 %72, 1, !dbg !322 ; line:200 col:27
  %75 = extractvalue %dx.types.CBufRet.f32 %72, 2, !dbg !322 ; line:200 col:27
  %76 = extractvalue %dx.types.CBufRet.f32 %72, 3, !dbg !322 ; line:200 col:27
  %77 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !322 ; line:200 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %78 = extractvalue %dx.types.CBufRet.f32 %77, 0, !dbg !322 ; line:200 col:27
  %79 = extractvalue %dx.types.CBufRet.f32 %77, 1, !dbg !322 ; line:200 col:27
  %80 = extractvalue %dx.types.CBufRet.f32 %77, 2, !dbg !322 ; line:200 col:27
  %81 = extractvalue %dx.types.CBufRet.f32 %77, 3, !dbg !322 ; line:200 col:27
  %82 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !322 ; line:200 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %83 = extractvalue %dx.types.CBufRet.f32 %82, 0, !dbg !322 ; line:200 col:27
  %84 = extractvalue %dx.types.CBufRet.f32 %82, 1, !dbg !322 ; line:200 col:27
  %85 = extractvalue %dx.types.CBufRet.f32 %82, 2, !dbg !322 ; line:200 col:27
  %86 = extractvalue %dx.types.CBufRet.f32 %82, 3, !dbg !322 ; line:200 col:27
  %87 = fmul fast float %FMad57, %68, !dbg !323 ; line:200 col:17
  %FMad47 = call float @dx.op.tertiary.f32(i32 46, float %FMad54, float %69, float %87), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %FMad46 = call float @dx.op.tertiary.f32(i32 46, float %FMad51, float %70, float %FMad47), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %FMad45 = call float @dx.op.tertiary.f32(i32 46, float %FMad48, float %71, float %FMad46), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %88 = fmul fast float %FMad57, %73, !dbg !323 ; line:200 col:17
  %FMad44 = call float @dx.op.tertiary.f32(i32 46, float %FMad54, float %74, float %88), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %FMad43 = call float @dx.op.tertiary.f32(i32 46, float %FMad51, float %75, float %FMad44), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %FMad42 = call float @dx.op.tertiary.f32(i32 46, float %FMad48, float %76, float %FMad43), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %89 = fmul fast float %FMad57, %78, !dbg !323 ; line:200 col:17
  %FMad41 = call float @dx.op.tertiary.f32(i32 46, float %FMad54, float %79, float %89), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %FMad40 = call float @dx.op.tertiary.f32(i32 46, float %FMad51, float %80, float %FMad41), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %FMad39 = call float @dx.op.tertiary.f32(i32 46, float %FMad48, float %81, float %FMad40), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %90 = fmul fast float %FMad57, %83, !dbg !323 ; line:200 col:17
  %FMad38 = call float @dx.op.tertiary.f32(i32 46, float %FMad54, float %84, float %90), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %FMad37 = call float @dx.op.tertiary.f32(i32 46, float %FMad51, float %85, float %FMad38), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %FMad36 = call float @dx.op.tertiary.f32(i32 46, float %FMad48, float %86, float %FMad37), !dbg !323 ; line:200 col:17  ; FMad(a,b,c)
  %91 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !324 ; line:200 col:15
  call void @llvm.dbg.value(metadata float %FMad45, i64 0, metadata !317, metadata !263), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad42, i64 0, metadata !317, metadata !265), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad39, i64 0, metadata !317, metadata !271), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad36, i64 0, metadata !317, metadata !315), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"DS"
  %92 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 0), !dbg !325 ; line:202 col:56  ; CBufferLoadLegacy(handle,regIndex)
  %93 = extractvalue %dx.types.CBufRet.f32 %92, 0, !dbg !325 ; line:202 col:56
  %94 = extractvalue %dx.types.CBufRet.f32 %92, 1, !dbg !325 ; line:202 col:56
  %95 = extractvalue %dx.types.CBufRet.f32 %92, 2, !dbg !325 ; line:202 col:56
  %96 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 1), !dbg !325 ; line:202 col:56  ; CBufferLoadLegacy(handle,regIndex)
  %97 = extractvalue %dx.types.CBufRet.f32 %96, 0, !dbg !325 ; line:202 col:56
  %98 = extractvalue %dx.types.CBufRet.f32 %96, 1, !dbg !325 ; line:202 col:56
  %99 = extractvalue %dx.types.CBufRet.f32 %96, 2, !dbg !325 ; line:202 col:56
  %100 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 2), !dbg !325 ; line:202 col:56  ; CBufferLoadLegacy(handle,regIndex)
  %101 = extractvalue %dx.types.CBufRet.f32 %100, 0, !dbg !325 ; line:202 col:56
  %102 = extractvalue %dx.types.CBufRet.f32 %100, 1, !dbg !325 ; line:202 col:56
  %103 = extractvalue %dx.types.CBufRet.f32 %100, 2, !dbg !325 ; line:202 col:56
  %104 = fmul fast float %.i0111, %93, !dbg !326 ; line:202 col:32
  %FMad35 = call float @dx.op.tertiary.f32(i32 46, float %.i1112, float %94, float %104), !dbg !326 ; line:202 col:32  ; FMad(a,b,c)
  %FMad34 = call float @dx.op.tertiary.f32(i32 46, float %.i2113, float %95, float %FMad35), !dbg !326 ; line:202 col:32  ; FMad(a,b,c)
  %105 = fmul fast float %.i0111, %97, !dbg !326 ; line:202 col:32
  %FMad33 = call float @dx.op.tertiary.f32(i32 46, float %.i1112, float %98, float %105), !dbg !326 ; line:202 col:32  ; FMad(a,b,c)
  %FMad32 = call float @dx.op.tertiary.f32(i32 46, float %.i2113, float %99, float %FMad33), !dbg !326 ; line:202 col:32  ; FMad(a,b,c)
  %106 = fmul fast float %.i0111, %101, !dbg !326 ; line:202 col:32
  %FMad31 = call float @dx.op.tertiary.f32(i32 46, float %.i1112, float %102, float %106), !dbg !326 ; line:202 col:32  ; FMad(a,b,c)
  %FMad30 = call float @dx.op.tertiary.f32(i32 46, float %.i2113, float %103, float %FMad31), !dbg !326 ; line:202 col:32  ; FMad(a,b,c)
  %107 = call float @dx.op.dot3.f32(i32 55, float %FMad34, float %FMad32, float %FMad30, float %FMad34, float %FMad32, float %FMad30), !dbg !327 ; line:202 col:22  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt5 = call float @dx.op.unary.f32(i32 25, float %107), !dbg !327 ; line:202 col:22  ; Rsqrt(value)
  %.i0124 = fmul fast float %FMad34, %Rsqrt5, !dbg !327 ; line:202 col:22
  %.i1125 = fmul fast float %FMad32, %Rsqrt5, !dbg !327 ; line:202 col:22
  %.i2126 = fmul fast float %FMad30, %Rsqrt5, !dbg !327 ; line:202 col:22
  %108 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !328 ; line:202 col:12
  call void @llvm.dbg.value(metadata float %.i0124, i64 0, metadata !329, metadata !263), !dbg !328 ; var:"normalW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i1125, i64 0, metadata !329, metadata !265), !dbg !328 ; var:"normalW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i2126, i64 0, metadata !329, metadata !271), !dbg !328 ; var:"normalW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %109 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !330 ; line:203 col:18
  call void @llvm.dbg.value(metadata float %.i0124, i64 0, metadata !317, metadata !331), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i1125, i64 0, metadata !317, metadata !332), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i2126, i64 0, metadata !317, metadata !333), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"DS"
  %110 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 4), !dbg !334 ; line:205 col:45  ; CBufferLoadLegacy(handle,regIndex)
  %111 = extractvalue %dx.types.CBufRet.f32 %110, 0, !dbg !334 ; line:205 col:45
  %112 = extractvalue %dx.types.CBufRet.f32 %110, 1, !dbg !334 ; line:205 col:45
  %113 = extractvalue %dx.types.CBufRet.f32 %110, 2, !dbg !334 ; line:205 col:45
  %114 = extractvalue %dx.types.CBufRet.f32 %110, 3, !dbg !334 ; line:205 col:45
  %115 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 5), !dbg !334 ; line:205 col:45  ; CBufferLoadLegacy(handle,regIndex)
  %116 = extractvalue %dx.types.CBufRet.f32 %115, 0, !dbg !334 ; line:205 col:45
  %117 = extractvalue %dx.types.CBufRet.f32 %115, 1, !dbg !334 ; line:205 col:45
  %118 = extractvalue %dx.types.CBufRet.f32 %115, 2, !dbg !334 ; line:205 col:45
  %119 = extractvalue %dx.types.CBufRet.f32 %115, 3, !dbg !334 ; line:205 col:45
  %120 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 6), !dbg !334 ; line:205 col:45  ; CBufferLoadLegacy(handle,regIndex)
  %121 = extractvalue %dx.types.CBufRet.f32 %120, 0, !dbg !334 ; line:205 col:45
  %122 = extractvalue %dx.types.CBufRet.f32 %120, 1, !dbg !334 ; line:205 col:45
  %123 = extractvalue %dx.types.CBufRet.f32 %120, 2, !dbg !334 ; line:205 col:45
  %124 = extractvalue %dx.types.CBufRet.f32 %120, 3, !dbg !334 ; line:205 col:45
  %125 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 7), !dbg !334 ; line:205 col:45  ; CBufferLoadLegacy(handle,regIndex)
  %126 = extractvalue %dx.types.CBufRet.f32 %125, 0, !dbg !334 ; line:205 col:45
  %127 = extractvalue %dx.types.CBufRet.f32 %125, 1, !dbg !334 ; line:205 col:45
  %128 = extractvalue %dx.types.CBufRet.f32 %125, 2, !dbg !334 ; line:205 col:45
  %129 = extractvalue %dx.types.CBufRet.f32 %125, 3, !dbg !334 ; line:205 col:45
  %130 = fmul fast float %1, %111, !dbg !335 ; line:205 col:19
  %FMad29 = call float @dx.op.tertiary.f32(i32 46, float %2, float %112, float %130), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %FMad28 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %113, float %FMad29), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %FMad27 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %114, float %FMad28), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %131 = fmul fast float %1, %116, !dbg !335 ; line:205 col:19
  %FMad26 = call float @dx.op.tertiary.f32(i32 46, float %2, float %117, float %131), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %FMad25 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %118, float %FMad26), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %FMad24 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %119, float %FMad25), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %132 = fmul fast float %1, %121, !dbg !335 ; line:205 col:19
  %FMad23 = call float @dx.op.tertiary.f32(i32 46, float %2, float %122, float %132), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %FMad22 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %123, float %FMad23), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %FMad21 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %124, float %FMad22), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %133 = fmul fast float %1, %126, !dbg !335 ; line:205 col:19
  %FMad20 = call float @dx.op.tertiary.f32(i32 46, float %2, float %127, float %133), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %FMad19 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %128, float %FMad20), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %FMad18 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %129, float %FMad19), !dbg !335 ; line:205 col:19  ; FMad(a,b,c)
  %134 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !336 ; line:205 col:12
  call void @llvm.dbg.value(metadata float %FMad27, i64 0, metadata !337, metadata !263), !dbg !336 ; var:"texC" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad24, i64 0, metadata !337, metadata !265), !dbg !336 ; var:"texC" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad21, i64 0, metadata !337, metadata !271), !dbg !336 ; var:"texC" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad18, i64 0, metadata !337, metadata !315), !dbg !336 ; var:"texC" !DIExpression(DW_OP_bit_piece, 96, 32) func:"DS"
  %135 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 2), !dbg !338 ; line:206 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %136 = extractvalue %dx.types.CBufRet.f32 %135, 0, !dbg !338 ; line:206 col:27
  %137 = extractvalue %dx.types.CBufRet.f32 %135, 1, !dbg !338 ; line:206 col:27
  %138 = extractvalue %dx.types.CBufRet.f32 %135, 2, !dbg !338 ; line:206 col:27
  %139 = extractvalue %dx.types.CBufRet.f32 %135, 3, !dbg !338 ; line:206 col:27
  %140 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 3), !dbg !338 ; line:206 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %141 = extractvalue %dx.types.CBufRet.f32 %140, 0, !dbg !338 ; line:206 col:27
  %142 = extractvalue %dx.types.CBufRet.f32 %140, 1, !dbg !338 ; line:206 col:27
  %143 = extractvalue %dx.types.CBufRet.f32 %140, 2, !dbg !338 ; line:206 col:27
  %144 = extractvalue %dx.types.CBufRet.f32 %140, 3, !dbg !338 ; line:206 col:27
  %145 = fmul fast float %FMad27, %136, !dbg !339 ; line:206 col:17
  %FMad17 = call float @dx.op.tertiary.f32(i32 46, float %FMad24, float %137, float %145), !dbg !339 ; line:206 col:17  ; FMad(a,b,c)
  %FMad16 = call float @dx.op.tertiary.f32(i32 46, float %FMad21, float %138, float %FMad17), !dbg !339 ; line:206 col:17  ; FMad(a,b,c)
  %FMad15 = call float @dx.op.tertiary.f32(i32 46, float %FMad18, float %139, float %FMad16), !dbg !339 ; line:206 col:17  ; FMad(a,b,c)
  %146 = fmul fast float %FMad27, %141, !dbg !339 ; line:206 col:17
  %FMad14 = call float @dx.op.tertiary.f32(i32 46, float %FMad24, float %142, float %146), !dbg !339 ; line:206 col:17  ; FMad(a,b,c)
  %FMad13 = call float @dx.op.tertiary.f32(i32 46, float %FMad21, float %143, float %FMad14), !dbg !339 ; line:206 col:17  ; FMad(a,b,c)
  %FMad12 = call float @dx.op.tertiary.f32(i32 46, float %FMad18, float %144, float %FMad13), !dbg !339 ; line:206 col:17  ; FMad(a,b,c)
  %147 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !339 ; line:206 col:17
  %148 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !340 ; line:206 col:15
  call void @llvm.dbg.value(metadata float %FMad15, i64 0, metadata !317, metadata !341), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad12, i64 0, metadata !317, metadata !342), !dbg !319 ; var:"dout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"DS"
  %149 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !343 ; line:208 col:12
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad45), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad42), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad39), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad36), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %FMad57), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %FMad54), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %FMad51), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i0124), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float %.i1125), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i2126), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %FMad15), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %FMad12), !dbg !343 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  %150 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !344 ; line:208 col:5
  ret void, !dbg !344 ; line:208 col:5
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare float @dx.op.domainLocation.f32(i32, i8) #0

; Function Attrs: nounwind readnone
declare float @dx.op.loadInput.f32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #1

; Function Attrs: nounwind readnone
declare float @dx.op.unary.f32(i32, float) #0

; Function Attrs: nounwind readnone
declare float @dx.op.dot3.f32(i32, float, float, float, float, float, float) #0

; Function Attrs: nounwind readnone
declare float @dx.op.dot2.f32(i32, float, float, float, float) #0

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
!llvm.module.flags = !{!178, !179}
!llvm.ident = !{!180}
!dx.source.contents = !{!181, !182}
!dx.source.defines = !{!183}
!dx.source.mainFileName = !{!184}
!dx.source.args = !{!185}
!dx.version = !{!186}
!dx.valver = !{!187}
!dx.shaderModel = !{!188}
!dx.resources = !{!189}
!dx.typeAnnotations = !{!194, !235}
!dx.viewIdState = !{!238}
!dx.entryPoints = !{!239}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !38, globals: !93)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl", directory: "")
!2 = !{}
!3 = !{!4, !16, !31}
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
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3x3", file: !1, line: 202, baseType: !17)
!17 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 3, 3>", file: !1, line: 202, size: 288, align: 32, elements: !18, templateParams: !28)
!18 = !{!19, !20, !21, !22, !23, !24, !25, !26, !27}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !17, file: !1, line: 202, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !17, file: !1, line: 202, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !17, file: !1, line: 202, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !17, file: !1, line: 202, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !17, file: !1, line: 202, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !17, file: !1, line: 202, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !17, file: !1, line: 202, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !17, file: !1, line: 202, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !17, file: !1, line: 202, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!28 = !{!13, !29, !30}
!29 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 3)
!30 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 3)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 32, baseType: !32)
!32 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 32, size: 64, align: 32, elements: !33, templateParams: !36)
!33 = !{!34, !35}
!34 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !32, file: !1, line: 32, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !32, file: !1, line: 32, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!36 = !{!13, !37}
!37 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 2)
!38 = !{!39, !76, !90}
!39 = !DISubprogram(name: "ConstantHS", linkageName: "\01?ConstantHS@@YA?AUPatchTess@@V?$InputPatch@UVertexIn@@$03@@I@Z", scope: !1, file: !1, line: 118, type: !40, isLocal: false, isDefinition: true, scopeLine: 119, flags: DIFlagPrototyped, isOptimized: false)
!40 = !DISubroutineType(types: !41)
!41 = !{!42, !52, !74}
!42 = !DICompositeType(tag: DW_TAG_structure_type, name: "PatchTess", file: !1, line: 83, size: 192, align: 32, elements: !43)
!43 = !{!44, !48}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "EdgeTess", scope: !42, file: !1, line: 85, baseType: !45, size: 128, align: 32)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 128, align: 32, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 4)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "InsideTess", scope: !42, file: !1, line: 86, baseType: !49, size: 64, align: 32, offset: 128)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 64, align: 32, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 2)
!52 = !DICompositeType(tag: DW_TAG_class_type, name: "InputPatch<VertexIn, 4>", file: !1, line: 73, size: 1024, align: 32, elements: !53, templateParams: !71)
!53 = !{!54, !56}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "Length", scope: !52, file: !1, line: 73, baseType: !55, flags: DIFlagPublic | DIFlagStaticMember, extraData: i32 4)
!55 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "h", scope: !52, file: !1, line: 73, baseType: !57, size: 1024, align: 32)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 1024, align: 32, elements: !46)
!58 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexIn", file: !1, line: 76, size: 256, align: 32, elements: !59)
!59 = !{!60, !69, !70}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "PosL", scope: !58, file: !1, line: 78, baseType: !61, size: 96, align: 32)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 40, baseType: !62)
!62 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 40, size: 96, align: 32, elements: !63, templateParams: !67)
!63 = !{!64, !65, !66}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !62, file: !1, line: 40, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !62, file: !1, line: 40, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !62, file: !1, line: 40, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!67 = !{!13, !68}
!68 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 3)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "NormalL", scope: !58, file: !1, line: 79, baseType: !61, size: 96, align: 32, offset: 96)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !58, file: !1, line: 80, baseType: !31, size: 64, align: 32, offset: 192)
!71 = !{!72, !73}
!72 = !DITemplateTypeParameter(name: "element", type: !58)
!73 = !DITemplateValueParameter(name: "count", type: !15, value: i32 4)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 73, baseType: !75)
!75 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!76 = !DISubprogram(name: "DS", scope: !1, file: !1, line: 170, type: !77, isLocal: false, isDefinition: true, scopeLine: 173, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @DS)
!77 = !DISubroutineType(types: !78)
!78 = !{!79, !42, !31, !85}
!79 = !DICompositeType(tag: DW_TAG_structure_type, name: "DomainOut", file: !1, line: 89, size: 384, align: 32, elements: !80)
!80 = !{!81, !82, !83, !84}
!81 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !79, file: !1, line: 91, baseType: !4, size: 128, align: 32)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !79, file: !1, line: 92, baseType: !61, size: 96, align: 32, offset: 128)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !79, file: !1, line: 93, baseType: !61, size: 96, align: 32, offset: 224)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !79, file: !1, line: 94, baseType: !31, size: 64, align: 32, offset: 320)
!85 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !86)
!86 = !DICompositeType(tag: DW_TAG_class_type, name: "OutputPatch<VertexIn, 4>", file: !1, line: 146, size: 1024, align: 32, elements: !87, templateParams: !71)
!87 = !{!88, !89}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "Length", scope: !86, file: !1, line: 146, baseType: !55, flags: DIFlagPublic | DIFlagStaticMember, extraData: i32 4)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "h", scope: !86, file: !1, line: 146, baseType: !57, size: 1024, align: 32)
!90 = !DISubprogram(name: "Hash12", linkageName: "\01?Hash12@@YAMV?$vector@M$01@@@Z", scope: !1, file: !1, line: 162, type: !91, isLocal: false, isDefinition: true, scopeLine: 163, flags: DIFlagPrototyped, isOptimized: false)
!91 = !DISubroutineType(types: !92)
!92 = !{!8, !31}
!93 = !{!94, !118, !119, !121, !123, !124, !126, !128, !129, !130, !131, !132, !133, !134, !135, !136, !137, !138, !139, !140, !141, !142, !143, !144, !145, !159, !160, !161, !162, !163, !164, !165, !169, !170, !171, !173, !174, !175, !176, !177}
!94 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 30, type: !95, isLocal: false, isDefinition: true)
!95 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !96)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 30, baseType: !97)
!97 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 30, size: 512, align: 32, elements: !98, templateParams: !115)
!98 = !{!99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !97, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!115 = !{!13, !116, !117}
!116 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 4)
!117 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 4)
!118 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 31, type: !95, isLocal: false, isDefinition: true)
!119 = !DIGlobalVariable(name: "gDisplacementMapTexelSize", linkageName: "\01?gDisplacementMapTexelSize@cbPerObject@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 32, type: !120, isLocal: false, isDefinition: true)
!120 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !31)
!121 = !DIGlobalVariable(name: "gGridSpatialStep", linkageName: "\01?gGridSpatialStep@cbPerObject@@3MB", scope: !0, file: !1, line: 33, type: !122, isLocal: false, isDefinition: true)
!122 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!123 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPerObject@@3MB", scope: !0, file: !1, line: 34, type: !122, isLocal: false, isDefinition: true)
!124 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 39, type: !125, isLocal: false, isDefinition: true)
!125 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!126 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 40, type: !127, isLocal: false, isDefinition: true)
!127 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !61)
!128 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 41, type: !122, isLocal: false, isDefinition: true)
!129 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !95, isLocal: false, isDefinition: true)
!130 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 47, type: !95, isLocal: false, isDefinition: true)
!131 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 48, type: !95, isLocal: false, isDefinition: true)
!132 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 49, type: !95, isLocal: false, isDefinition: true)
!133 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 50, type: !95, isLocal: false, isDefinition: true)
!134 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 51, type: !95, isLocal: false, isDefinition: true)
!135 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 52, type: !95, isLocal: false, isDefinition: true)
!136 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 53, type: !127, isLocal: false, isDefinition: true)
!137 = !DIGlobalVariable(name: "cbPerPassPad1", linkageName: "\01?cbPerPassPad1@cbPass@@3MB", scope: !0, file: !1, line: 54, type: !122, isLocal: false, isDefinition: true)
!138 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 55, type: !120, isLocal: false, isDefinition: true)
!139 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 56, type: !120, isLocal: false, isDefinition: true)
!140 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 57, type: !122, isLocal: false, isDefinition: true)
!141 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 58, type: !122, isLocal: false, isDefinition: true)
!142 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 59, type: !122, isLocal: false, isDefinition: true)
!143 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 60, type: !122, isLocal: false, isDefinition: true)
!144 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 61, type: !125, isLocal: false, isDefinition: true)
!145 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 66, type: !146, isLocal: false, isDefinition: true)
!146 = !DICompositeType(tag: DW_TAG_array_type, baseType: !147, size: 6144, align: 32, elements: !157)
!147 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !148)
!148 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !149, line: 3, size: 384, align: 32, elements: !150)
!149 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!150 = !{!151, !152, !153, !154, !155, !156}
!151 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !148, file: !149, line: 5, baseType: !61, size: 96, align: 32)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !148, file: !149, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !148, file: !149, line: 7, baseType: !61, size: 96, align: 32, offset: 128)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !148, file: !149, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !148, file: !149, line: 9, baseType: !61, size: 96, align: 32, offset: 256)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !148, file: !149, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!157 = !{!158}
!158 = !DISubrange(count: 16)
!159 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 70, type: !125, isLocal: false, isDefinition: true)
!160 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 71, type: !122, isLocal: false, isDefinition: true)
!161 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 72, type: !122, isLocal: false, isDefinition: true)
!162 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 73, type: !120, isLocal: false, isDefinition: true)
!163 = !DIGlobalVariable(name: "d0", scope: !39, file: !1, line: 131, type: !122, isLocal: true, isDefinition: true)
!164 = !DIGlobalVariable(name: "d1", scope: !39, file: !1, line: 132, type: !122, isLocal: true, isDefinition: true)
!165 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 17, type: !166, isLocal: false, isDefinition: true)
!166 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 17, size: 160, align: 32, elements: !2, templateParams: !167)
!167 = !{!168}
!168 = !DITemplateTypeParameter(name: "element", type: !5)
!169 = !DIGlobalVariable(name: "gDiffuseMap2", linkageName: "\01?gDiffuseMap2@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 18, type: !166, isLocal: false, isDefinition: true)
!170 = !DIGlobalVariable(name: "gDisplacementMap", linkageName: "\01?gDisplacementMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 19, type: !166, isLocal: false, isDefinition: true)
!171 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !172, isLocal: false, isDefinition: true)
!172 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 21, size: 32, align: 32, elements: !2)
!173 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !172, isLocal: false, isDefinition: true)
!174 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 23, type: !172, isLocal: false, isDefinition: true)
!175 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 24, type: !172, isLocal: false, isDefinition: true)
!176 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 25, type: !172, isLocal: false, isDefinition: true)
!177 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 26, type: !172, isLocal: false, isDefinition: true)
!178 = !{i32 2, !"Dwarf Version", i32 4}
!179 = !{i32 2, !"Debug Info Version", i32 3}
!180 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!181 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A//#define CARTOON\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0ATexture2D gDiffuseMap2 : register(t1);\0D\0ATexture2D gDisplacementMap : register(t2);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A    float2 gDisplacementMapTexelSize;\0D\0A    float gGridSpatialStep;\0D\0A    float cbPerObjectPad1;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerPassPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    // \EC\9D\B8\EB\8D\B1\EC\8A\A4 [0, NUM_DIR_LIGHTS)\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B4\91\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)\EB\8A\94 \EC\A0\90\EA\B4\91\EC\9B\90\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHT + NUM_SPOT_LIGHTS)\EB\8A\94 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\B4\EB\A9\B0, \EA\B0\9D\EC\B2\B4\EB\8B\B9 \EC\B5\9C\EB\8C\80 MaxLights \EA\B0\9C\EC\88\98\EA\B9\8C\EC\A7\80 \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    //\EC\95\B1\EC\9D\B4 \ED\94\84\EB\A0\88\EC\9E\84\EB\8B\B9 \ED\95\9C \EB\B2\88\EC\94\A9 \EC\95\88\EA\B0\9C \EB\A7\A4\EA\B0\9C\EB\B3\80\EC\88\98\EB\A5\BC \EB\B3\80\EA\B2\BD\ED\95\A0 \EC\88\98 \EC\9E\88\EB\8F\84\EB\A1\9D \ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    //\ED\8A\B9\EC\A0\95 \EC\8B\9C\EA\B0\84\EB\8C\80\EC\97\90\EB\A7\8C \EC\95\88\EA\B0\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosL : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct PatchTess\0D\0A{\0D\0A    float EdgeTess[4] : SV_TessFactor;\0D\0A    float InsideTess[2] : SV_InsideTessFactor;\0D\0A};\0D\0A\0D\0Astruct DomainOut\0D\0A{\0D\0A    float4 PosH : SV_Position;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Afloat GetHillsHeight(float x, float z)\0D\0A{\0D\0A    return 0.3f * (z * sin(0.05f * x) + x * cos(0.1f * z));\0D\0A}\0D\0A\0D\0Afloat3 GetHillsNormal(float x, float z)\0D\0A{\0D\0A    // y = f(x, z)\0D\0A    // normal = normalize((-df/dx, 1, -df/dz))\0D\0A\0D\0A    float df_dx = 0.3f * (0.05f * z * cos(0.05f * x) + cos(0.1f * z));\0D\0A    float df_dz = 0.3f * (sin(0.05f * x) - 0.1f * x * sin(0.1f * z));\0D\0A\0D\0A    return normalize(float3(-df_dx, 1.0f, -df_dz));\0D\0A}\0D\0A\0D\0AVertexIn VS(VertexIn vin)\0D\0A{\0D\0A    return vin;\0D\0A}\0D\0A\0D\0APatchTess ConstantHS(InputPatch<VertexIn, 4> patch, uint patchID : SV_PrimitiveID)\0D\0A{\0D\0A    PatchTess pt;\0D\0A    \0D\0A    float3 centerL = 0.25f * (patch[0].PosL + patch[1].PosL + patch[2].PosL + patch[3].PosL);\0D\0A    float3 centerW = mul(float4(centerL, 1.0f), gWorld).xyz;\0D\0A    \0D\0A    float d = distance(centerW, gEyePosW);\0D\0A    \0D\0A    // \EC\8B\9C\EC\A0\90(eye)\EC\9C\BC\EB\A1\9C\EB\B6\80\ED\84\B0\EC\9D\98 \EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\9D\BC \ED\8C\A8\EC\B9\98\EB\A5\BC \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98\ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    // \EC\9D\B4\EB\95\8C \EA\B1\B0\EB\A6\AC\EA\B0\80 d1 \EC\9D\B4\EC\83\81\EC\9D\B4\EB\A9\B4 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98 \EC\88\98\EC\A4\80\EC\9D\80 0\EC\9D\B4 \EB\90\98\EA\B3\A0, d0 \EC\9D\B4\ED\95\98\EC\9D\B4\EB\A9\B4 64\EA\B0\80 \EB\90\A9\EB\8B\88\EB\8B\A4.\0D\0A    // \EA\B5\AC\EA\B0\84 [d0, d1]\EC\9D\80 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98\EC\9D\B4 \EC\88\98\ED\96\89\EB\90\98\EB\8A\94 \EB\B2\94\EC\9C\84\EB\A5\BC \EC\A0\95\EC\9D\98\ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    \0D\0A    const float d0 = 20.0f;\0D\0A    const float d1 = 100.0f;\0D\0A    float tess = 64.0f * saturate((d1 - d) / (d1 - d0));\0D\0A    \0D\0A    //\EA\B7\A0\EC\9D\BC\ED\95\98\EA\B2\8C \ED\8C\A8\EC\B9\98\EB\A5\BC tessellate\0D\0A    \0D\0A    pt.EdgeTess[0] = tess;\0D\0A    pt.EdgeTess[1] = tess;\0D\0A    pt.EdgeTess[2] = tess;\0D\0A    pt.EdgeTess[3] = tess;\0D\0A\09\0D\0A    pt.InsideTess[0] = tess;\0D\0A    pt.InsideTess[1] = tess;\0D\0A\09\0D\0A    return pt;\0D\0A}\0D\0A\0D\0A[domain(\22quad\22)]\0D\0A[partitioning(\22integer\22)]\0D\0A[outputtopology(\22triangle_cw\22)]\0D\0A[outputcontrolpoints(4)]\0D\0A[patchconstantfunc(\22ConstantHS\22)]\0D\0A[maxtessfactor(64.0f)]\0D\0AVertexIn HS(InputPatch<VertexIn, 4> p,\0D\0A           uint i : SV_OutputControlPointID,\0D\0A           uint patchId : SV_PrimitiveID)\0D\0A{\0D\0A    return p[i];\0D\0A}\0D\0A\0D\0A//\EC\9C\A0\EC\82\AC \EB\9E\9C\EB\8D\A4\ED\95\A8\EC\88\98\0D\0Afloat Hash12(float2 p)\0D\0A{\0D\0A    return frac(sin(dot(p, float2(127.1f, 311.7f))) * 43758.5453123f);\0D\0A}\0D\0A\0D\0A// \EB\8F\84\EB\A9\94\EC\9D\B8 \EC\85\B0\EC\9D\B4\EB\8D\94\EB\8A\94 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\ED\84\B0\EA\B0\80 \EC\83\9D\EC\84\B1\ED\95\9C \EB\AA\A8\EB\93\A0 \EC\A0\95\EC\A0\90\EB\A7\88\EB\8B\A4 \ED\98\B8\EC\B6\9C\EB\90\9C\EB\8B\A4.\0D\0A// \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98 \EC\9D\B4\ED\9B\84\EC\9D\98 \EC\A0\95\EC\A0\90 \EC\85\B0\EC\9D\B4\EB\8D\94\EC\99\80 \EB\B9\84\EC\8A\B7\ED\95\9C \EC\97\AD\ED\95\A0\EC\9D\84 \ED\95\9C\EB\8B\A4.\0D\0A[domain(\22quad\22)]\0D\0ADomainOut DS(PatchTess patchTess,\0D\0A            float2 uv : SV_DomainLocation,\0D\0A            const OutputPatch<VertexIn, 4> quad)\0D\0A{\0D\0A    DomainOut dout;\0D\0A    \0D\0A    //\EC\8C\8D\EC\84\A0\ED\98\95 \EB\B3\B4\EA\B0\84\0D\0A    float3 v1 = lerp(quad[0].PosL, quad[1].PosL, uv.x);\0D\0A    float3 v2 = lerp(quad[2].PosL, quad[3].PosL, uv.x);\0D\0A    float3 posL = lerp(v1, v2, uv.y);\0D\0A    \0D\0A    float3 n1 = lerp(quad[0].NormalL, quad[1].NormalL, uv.x);\0D\0A    float3 n2 = lerp(quad[2].NormalL, quad[3].NormalL, uv.x);\0D\0A    float3 normalL = normalize(lerp(n1, n2, uv.y));\0D\0A    \0D\0A    float h = Hash12(floor(uv * 128.0f)) * 0.1f;\0D\0A#ifdef WALL\0D\0A    // \EB\B2\BD\EB\8F\8C \EB\B2\BD: normal \EB\B0\A9\ED\96\A5\EC\9C\BC\EB\A1\9C \EB\B0\80\EA\B8\B0\0D\0A    posL += normalL * h;\0D\0A#else\0D\0A    // \EC\A7\80\ED\98\95: y \EB\86\92\EC\9D\B4\EB\A5\BC \ED\95\A8\EC\88\98\EB\A1\9C \EA\B2\B0\EC\A0\95\0D\0A    posL.y = GetHillsHeight(posL.x, posL.z);\0D\0A    posL.y += h * 10;\0D\0A    normalL = GetHillsNormal(posL.x, posL.z);\0D\0A#endif\0D\0A    \0D\0A    //\EB\B3\80\EC\9C\84 \EB\A7\A4\ED\95\91\0D\0A    float4 posW = mul(float4(posL, 1.0f), gWorld);\0D\0A    dout.PosW = posW.xyz;\0D\0A    \0D\0A    dout.PosH = mul(posW, gViewProj);\0D\0A    \0D\0A    float3 normalW = normalize(mul(normalL, (float3x3) gWorld));\0D\0A    dout.NormalW = normalW;    \0D\0A    \0D\0A    float4 texC = mul(float4(uv, 0.f, 1.f), gTexTransform);\0D\0A    dout.TexC = mul(texC, gMatTransform).xy;\0D\0A    \0D\0A    return dout;\0D\0A}\0D\0A\0D\0Afloat4 PS(DomainOut pin) : SV_Target\0D\0A{\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamLinearWrap, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A    //\EB\B3\B4\EA\B0\84\EB\90\9C \EB\B2\95\EC\84\A0 \EB\B2\A1\ED\84\B0\EB\8A\94 \EA\B8\B8\EC\9D\B4\EA\B0\80 1\EC\9D\B4 \EC\95\84\EB\8B\90 \EC\88\98 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C.\0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A\0D\0A    //\EA\B4\91\EC\9B\90\EC\97\90\EC\84\9C \EC\B9\B4\EB\A9\94\EB\9D\BC\EB\A1\9C \ED\96\A5\ED\95\98\EB\8A\94 \EB\B2\A1\ED\84\B0.\0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    \0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A    //\EC\9D\BC\EB\B0\98\EC\A0\81\EC\9C\BC\EB\A1\9C \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\80 \EB\94\94\ED\93\A8\EC\A6\88 \EB\A8\B8\ED\8B\B0\EB\A6\AC\EC\96\BC\EC\9D\98 \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\9C\EB\8B\A4.\0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A    \0D\0A    return litColor;\0D\0A}"}
!182 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhongToon(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    // 1) kd\0D\0A    float kd = saturate(dot(lightVec, normal));\0D\0A    float kd_q = QuantizeKd(kd);\0D\0A\0D\0A    // 2) ks (Blinn-Phong)\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    float ndoth = saturate(dot(halfVec, normal));\0D\0A\0D\0A    float ks = pow(max(ndoth, 0), m); // \EC\8A\A4\ED\8E\99\ED\81\98\EB\9F\AC \EA\B0\95\EB\8F\84\EC\9D\98 \ED\95\B5\EC\8B\AC\0D\0A    float ks_q = QuantizeKs(ks); // \EC\9D\B4\EC\82\B0\ED\99\94\0D\0A\0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    // fresnel(\EC\83\89) + (\ED\95\84\EC\9A\94\ED\95\98\EB\A9\B4) \EC\A0\95\EA\B7\9C\ED\99\94 \EA\B3\84\EC\88\98\EB\8A\94 \EC\B7\A8\ED\96\A5\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A\0D\0A    // ks_q\EB\A5\BC spec\EC\97\90 \EB\B0\98\EC\98\81\0D\0A    float3 specAlbedo = roughnessFactor * fresnelFactor * ks_q;\0D\0A\0D\0A    // LDR clamp\EB\8A\94 \EC\9C\A0\EC\A7\80 \EA\B0\80\EB\8A\A5\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A\0D\0A    // diffuse\EB\8A\94 kd_q\EB\A5\BC \EB\B0\98\EC\98\81\0D\0A    float3 diffuse = mat.DiffuseAlbedo.rgb * kd_q;\0D\0A    \0D\0A    return (diffuse + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!183 = !{!"WALL=1", !"WALL=1"}
!184 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl"}
!185 = !{!"-E", !"DS", !"-T", !"ds_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-D", !"WALL=1", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CtessDS_Wall.cso", !"-D", !"WALL=1"}
!186 = !{i32 1, i32 0}
!187 = !{i32 1, i32 8}
!188 = !{!"ds", i32 6, i32 0}
!189 = !{null, null, !190, null}
!190 = !{!191, !192, !193}
!191 = !{i32 0, %hostlayout.cbPerObject* undef, !"cbPerObject", i32 0, i32 0, i32 1, i32 144, null}
!192 = !{i32 1, %hostlayout.cbMaterial* undef, !"cbMaterial", i32 0, i32 1, i32 1, i32 96, null}
!193 = !{i32 2, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!194 = !{i32 0, %struct.Light undef, !195, %hostlayout.cbPerObject undef, !202, %hostlayout.cbMaterial undef, !209, %hostlayout.cbPass undef, !214}
!195 = !{i32 48, !196, !197, !198, !199, !200, !201}
!196 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!197 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!198 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!199 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!200 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!201 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!202 = !{i32 144, !203, !205, !206, !207, !208}
!203 = !{i32 6, !"gWorld", i32 2, !204, i32 3, i32 0, i32 7, i32 9}
!204 = !{i32 4, i32 4, i32 2}
!205 = !{i32 6, !"gTexTransform", i32 2, !204, i32 3, i32 64, i32 7, i32 9}
!206 = !{i32 6, !"gDisplacementMapTexelSize", i32 3, i32 128, i32 7, i32 9}
!207 = !{i32 6, !"gGridSpatialStep", i32 3, i32 136, i32 7, i32 9}
!208 = !{i32 6, !"cbPerObjectPad1", i32 3, i32 140, i32 7, i32 9}
!209 = !{i32 96, !210, !211, !212, !213}
!210 = !{i32 6, !"gDiffuseAlbedo", i32 3, i32 0, i32 7, i32 9}
!211 = !{i32 6, !"gFresnelR0", i32 3, i32 16, i32 7, i32 9}
!212 = !{i32 6, !"gRoughness", i32 3, i32 28, i32 7, i32 9}
!213 = !{i32 6, !"gMatTransform", i32 2, !204, i32 3, i32 32, i32 7, i32 9}
!214 = !{i32 1248, !215, !216, !217, !218, !219, !220, !221, !222, !223, !224, !225, !226, !227, !228, !229, !230, !231, !232, !233, !234}
!215 = !{i32 6, !"gView", i32 2, !204, i32 3, i32 0, i32 7, i32 9}
!216 = !{i32 6, !"gInvView", i32 2, !204, i32 3, i32 64, i32 7, i32 9}
!217 = !{i32 6, !"gProj", i32 2, !204, i32 3, i32 128, i32 7, i32 9}
!218 = !{i32 6, !"gInvProj", i32 2, !204, i32 3, i32 192, i32 7, i32 9}
!219 = !{i32 6, !"gViewProj", i32 2, !204, i32 3, i32 256, i32 7, i32 9}
!220 = !{i32 6, !"gInvViewProj", i32 2, !204, i32 3, i32 320, i32 7, i32 9}
!221 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!222 = !{i32 6, !"cbPerPassPad1", i32 3, i32 396, i32 7, i32 9}
!223 = !{i32 6, !"gRenderTargetSize", i32 3, i32 400, i32 7, i32 9}
!224 = !{i32 6, !"gInvRenderTargetSize", i32 3, i32 408, i32 7, i32 9}
!225 = !{i32 6, !"gNearZ", i32 3, i32 416, i32 7, i32 9}
!226 = !{i32 6, !"gFarZ", i32 3, i32 420, i32 7, i32 9}
!227 = !{i32 6, !"gTotalTime", i32 3, i32 424, i32 7, i32 9}
!228 = !{i32 6, !"gDeltaTime", i32 3, i32 428, i32 7, i32 9}
!229 = !{i32 6, !"gAmbientLight", i32 3, i32 432, i32 7, i32 9}
!230 = !{i32 6, !"gLights", i32 3, i32 448}
!231 = !{i32 6, !"gFogColor", i32 3, i32 1216, i32 7, i32 9}
!232 = !{i32 6, !"gFogStart", i32 3, i32 1232, i32 7, i32 9}
!233 = !{i32 6, !"gFogRange", i32 3, i32 1236, i32 7, i32 9}
!234 = !{i32 6, !"cbPerObjectPad2", i32 3, i32 1240, i32 7, i32 9}
!235 = !{i32 1, void ()* @DS, !236}
!236 = !{!237}
!237 = !{i32 0, !2, !2}
!238 = !{[37 x i32] [i32 10, i32 14, i32 127, i32 127, i32 127, i32 0, i32 1919, i32 1919, i32 1919, i32 0, i32 0, i32 0, i32 24, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0]}
!239 = !{void ()* @DS, !"DS", !240, !189, !259}
!240 = !{!241, !247, !254}
!241 = !{!242, !245, !246}
!242 = !{i32 0, !"POSITION", i8 9, i8 0, !243, i8 2, i32 1, i8 3, i32 0, i8 0, !244}
!243 = !{i32 0}
!244 = !{i32 3, i32 7}
!245 = !{i32 1, !"NORMAL", i8 9, i8 0, !243, i8 2, i32 1, i8 3, i32 1, i8 0, !244}
!246 = !{i32 2, !"TEXCOORD", i8 9, i8 0, !243, i8 2, i32 1, i8 2, i32 2, i8 0, null}
!247 = !{!248, !250, !251, !252}
!248 = !{i32 0, !"SV_Position", i8 9, i8 3, !243, i8 4, i32 1, i8 4, i32 0, i8 0, !249}
!249 = !{i32 3, i32 15}
!250 = !{i32 1, !"POSITION", i8 9, i8 0, !243, i8 2, i32 1, i8 3, i32 1, i8 0, !244}
!251 = !{i32 2, !"NORMAL", i8 9, i8 0, !243, i8 2, i32 1, i8 3, i32 2, i8 0, !244}
!252 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !243, i8 2, i32 1, i8 2, i32 3, i8 0, !253}
!253 = !{i32 3, i32 3}
!254 = !{!255, !257}
!255 = !{i32 0, !"SV_TessFactor", i8 9, i8 25, !256, i8 0, i32 4, i8 1, i32 0, i8 3, null}
!256 = !{i32 0, i32 1, i32 2, i32 3}
!257 = !{i32 1, !"SV_InsideTessFactor", i8 9, i8 26, !258, i8 0, i32 2, i8 1, i32 4, i8 3, null}
!258 = !{i32 0, i32 1}
!259 = !{i32 0, i64 1, i32 2, !260}
!260 = !{i32 3, i32 4}
!261 = !DILocation(line: 172, column: 44, scope: !76)
!262 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "uv", arg: 2, scope: !76, file: !1, line: 171, type: !31)
!263 = !DIExpression(DW_OP_bit_piece, 0, 32)
!264 = !DILocation(line: 171, column: 20, scope: !76)
!265 = !DIExpression(DW_OP_bit_piece, 32, 32)
!266 = !DILocation(line: 177, column: 44, scope: !76)
!267 = !DILocation(line: 177, column: 30, scope: !76)
!268 = !DILocation(line: 177, column: 17, scope: !76)
!269 = !DILocation(line: 177, column: 12, scope: !76)
!270 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "v1", scope: !76, file: !1, line: 177, type: !61)
!271 = !DIExpression(DW_OP_bit_piece, 64, 32)
!272 = !DILocation(line: 178, column: 44, scope: !76)
!273 = !DILocation(line: 178, column: 30, scope: !76)
!274 = !DILocation(line: 178, column: 17, scope: !76)
!275 = !DILocation(line: 178, column: 12, scope: !76)
!276 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "v2", scope: !76, file: !1, line: 178, type: !61)
!277 = !DILocation(line: 179, column: 19, scope: !76)
!278 = !DILocation(line: 179, column: 12, scope: !76)
!279 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "posL", scope: !76, file: !1, line: 179, type: !61)
!280 = !DILocation(line: 181, column: 47, scope: !76)
!281 = !DILocation(line: 181, column: 30, scope: !76)
!282 = !DILocation(line: 181, column: 17, scope: !76)
!283 = !DILocation(line: 181, column: 12, scope: !76)
!284 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "n1", scope: !76, file: !1, line: 181, type: !61)
!285 = !DILocation(line: 182, column: 47, scope: !76)
!286 = !DILocation(line: 182, column: 30, scope: !76)
!287 = !DILocation(line: 182, column: 17, scope: !76)
!288 = !DILocation(line: 182, column: 12, scope: !76)
!289 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "n2", scope: !76, file: !1, line: 182, type: !61)
!290 = !DILocation(line: 183, column: 32, scope: !76)
!291 = !DILocation(line: 183, column: 22, scope: !76)
!292 = !DILocation(line: 183, column: 12, scope: !76)
!293 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "normalL", scope: !76, file: !1, line: 183, type: !61)
!294 = !DILocation(line: 185, column: 31, scope: !76)
!295 = !DILocation(line: 185, column: 22, scope: !76)
!296 = !DILocation(line: 185, column: 15, scope: !76)
!297 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "p", arg: 1, scope: !90, file: !1, line: 162, type: !31)
!298 = !DILocation(line: 162, column: 21, scope: !90, inlinedAt: !299)
!299 = distinct !DILocation(line: 185, column: 15, scope: !76)
!300 = !DILocation(line: 164, column: 21, scope: !90, inlinedAt: !299)
!301 = !DILocation(line: 164, column: 17, scope: !90, inlinedAt: !299)
!302 = !DILocation(line: 164, column: 53, scope: !90, inlinedAt: !299)
!303 = !DILocation(line: 164, column: 12, scope: !90, inlinedAt: !299)
!304 = !DILocation(line: 164, column: 5, scope: !90, inlinedAt: !299)
!305 = !DILocation(line: 185, column: 42, scope: !76)
!306 = !DILocation(line: 185, column: 11, scope: !76)
!307 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "h", scope: !76, file: !1, line: 185, type: !8)
!308 = !DIExpression()
!309 = !DILocation(line: 188, column: 21, scope: !76)
!310 = !DILocation(line: 188, column: 10, scope: !76)
!311 = !DILocation(line: 197, column: 43, scope: !76)
!312 = !DILocation(line: 197, column: 19, scope: !76)
!313 = !DILocation(line: 197, column: 12, scope: !76)
!314 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "posW", scope: !76, file: !1, line: 197, type: !4)
!315 = !DIExpression(DW_OP_bit_piece, 96, 32)
!316 = !DILocation(line: 198, column: 15, scope: !76)
!317 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "dout", scope: !76, file: !1, line: 174, type: !79)
!318 = !DIExpression(DW_OP_bit_piece, 128, 32)
!319 = !DILocation(line: 174, column: 15, scope: !76)
!320 = !DIExpression(DW_OP_bit_piece, 160, 32)
!321 = !DIExpression(DW_OP_bit_piece, 192, 32)
!322 = !DILocation(line: 200, column: 27, scope: !76)
!323 = !DILocation(line: 200, column: 17, scope: !76)
!324 = !DILocation(line: 200, column: 15, scope: !76)
!325 = !DILocation(line: 202, column: 56, scope: !76)
!326 = !DILocation(line: 202, column: 32, scope: !76)
!327 = !DILocation(line: 202, column: 22, scope: !76)
!328 = !DILocation(line: 202, column: 12, scope: !76)
!329 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "normalW", scope: !76, file: !1, line: 202, type: !61)
!330 = !DILocation(line: 203, column: 18, scope: !76)
!331 = !DIExpression(DW_OP_bit_piece, 224, 32)
!332 = !DIExpression(DW_OP_bit_piece, 256, 32)
!333 = !DIExpression(DW_OP_bit_piece, 288, 32)
!334 = !DILocation(line: 205, column: 45, scope: !76)
!335 = !DILocation(line: 205, column: 19, scope: !76)
!336 = !DILocation(line: 205, column: 12, scope: !76)
!337 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "texC", scope: !76, file: !1, line: 205, type: !4)
!338 = !DILocation(line: 206, column: 27, scope: !76)
!339 = !DILocation(line: 206, column: 17, scope: !76)
!340 = !DILocation(line: 206, column: 15, scope: !76)
!341 = !DIExpression(DW_OP_bit_piece, 320, 32)
!342 = !DIExpression(DW_OP_bit_piece, 352, 32)
!343 = !DILocation(line: 208, column: 12, scope: !76)
!344 = !DILocation(line: 208, column: 5, scope: !76)
