;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   x z 
; NORMAL                   0   xyz         1     NONE   float       
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
; shader debug name: fbdb1bd8da7c45c328746c574719e871.pdb
; shader hash: fbdb1bd8da7c45c328746c574719e871
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
;   output 0 depends on inputs: { 0, 2 }
;   output 1 depends on inputs: { 0, 2 }
;   output 2 depends on inputs: { 0, 2 }
;   output 3 depends on inputs: { 0, 2 }
;   output 4 depends on inputs: { 0, 2 }
;   output 5 depends on inputs: { 0, 2 }
;   output 6 depends on inputs: { 0, 2 }
;   output 8 depends on inputs: { 0, 2 }
;   output 9 depends on inputs: { 0, 2 }
;   output 10 depends on inputs: { 0, 2 }
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
  %cbPass_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 2, i32 2, i1 false), !dbg !267 ; line:172 col:44  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbMaterial_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 1, i32 1, i1 false), !dbg !267 ; line:172 col:44  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %cbPerObject_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 0, i1 false), !dbg !267 ; line:172 col:44  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call float @dx.op.domainLocation.f32(i32 105, i8 0), !dbg !267 ; line:172 col:44  ; DomainLocation(component)
  %2 = call float @dx.op.domainLocation.f32(i32 105, i8 1), !dbg !267 ; line:172 col:44  ; DomainLocation(component)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !268, metadata !269), !dbg !270 ; var:"uv" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !268, metadata !271), !dbg !270 ; var:"uv" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 1), !dbg !272 ; line:177 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 1), !dbg !272 ; line:177 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 0), !dbg !273 ; line:177 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 0), !dbg !273 ; line:177 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i0 = fsub fast float %3, %5, !dbg !274 ; line:177 col:17
  %.i2 = fsub fast float %4, %6, !dbg !274 ; line:177 col:17
  %.i066 = fmul fast float %1, %.i0, !dbg !274 ; line:177 col:17
  %.i268 = fmul fast float %1, %.i2, !dbg !274 ; line:177 col:17
  %.i069 = fadd fast float %5, %.i066, !dbg !274 ; line:177 col:17
  %.i271 = fadd fast float %6, %.i268, !dbg !274 ; line:177 col:17
  %7 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !275 ; line:177 col:12
  call void @llvm.dbg.value(metadata float %.i069, i64 0, metadata !276, metadata !269), !dbg !275 ; var:"v1" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i271, i64 0, metadata !276, metadata !277), !dbg !275 ; var:"v1" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 3), !dbg !278 ; line:178 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %9 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 3), !dbg !278 ; line:178 col:44  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %10 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 2), !dbg !279 ; line:178 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %11 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 2), !dbg !279 ; line:178 col:30  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %.i072 = fsub fast float %8, %10, !dbg !280 ; line:178 col:17
  %.i274 = fsub fast float %9, %11, !dbg !280 ; line:178 col:17
  %.i075 = fmul fast float %1, %.i072, !dbg !280 ; line:178 col:17
  %.i277 = fmul fast float %1, %.i274, !dbg !280 ; line:178 col:17
  %.i078 = fadd fast float %10, %.i075, !dbg !280 ; line:178 col:17
  %.i280 = fadd fast float %11, %.i277, !dbg !280 ; line:178 col:17
  %12 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !281 ; line:178 col:12
  call void @llvm.dbg.value(metadata float %.i078, i64 0, metadata !282, metadata !269), !dbg !281 ; var:"v2" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i280, i64 0, metadata !282, metadata !277), !dbg !281 ; var:"v2" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %.i081 = fsub fast float %.i078, %.i069, !dbg !283 ; line:179 col:19
  %.i283 = fsub fast float %.i280, %.i271, !dbg !283 ; line:179 col:19
  %.i084 = fmul fast float %2, %.i081, !dbg !283 ; line:179 col:19
  %.i286 = fmul fast float %2, %.i283, !dbg !283 ; line:179 col:19
  %.i087 = fadd fast float %.i069, %.i084, !dbg !283 ; line:179 col:19
  %.i289 = fadd fast float %.i271, %.i286, !dbg !283 ; line:179 col:19
  %13 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !284 ; line:179 col:12
  call void @llvm.dbg.value(metadata float %.i087, i64 0, metadata !285, metadata !269), !dbg !284 ; var:"posL" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i289, i64 0, metadata !285, metadata !277), !dbg !284 ; var:"posL" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %14 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !286 ; line:181 col:12
  %15 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !287 ; line:182 col:12
  %16 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !288 ; line:183 col:12
  %.i0121 = fmul fast float %1, 1.280000e+02, !dbg !289 ; line:185 col:31
  %.i1123 = fmul fast float %2, 1.280000e+02, !dbg !289 ; line:185 col:31
  %Round_ni = call float @dx.op.unary.f32(i32 27, float %.i0121), !dbg !290 ; line:185 col:22  ; Round_ni(value)
  %Round_ni12 = call float @dx.op.unary.f32(i32 27, float %.i1123), !dbg !290 ; line:185 col:22  ; Round_ni(value)
  %17 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !291 ; line:185 col:15
  call void @llvm.dbg.value(metadata float %Round_ni, i64 0, metadata !292, metadata !269), !dbg !293 ; var:"p" !DIExpression(DW_OP_bit_piece, 0, 32) func:"Hash12"
  call void @llvm.dbg.value(metadata float %Round_ni12, i64 0, metadata !292, metadata !271), !dbg !293 ; var:"p" !DIExpression(DW_OP_bit_piece, 32, 32) func:"Hash12"
  %18 = call float @dx.op.dot2.f32(i32 54, float %Round_ni, float %Round_ni12, float 0x405FC66660000000, float 0x40737B3340000000), !dbg !295 ; line:164 col:21  ; Dot2(ax,ay,bx,by)
  %Sin9 = call float @dx.op.unary.f32(i32 13, float %18), !dbg !296 ; line:164 col:17  ; Sin(value)
  %19 = fmul fast float %Sin9, 0x40E55DD180000000, !dbg !297 ; line:164 col:53
  %Frc = call float @dx.op.unary.f32(i32 22, float %19), !dbg !298 ; line:164 col:12  ; Frc(value)
  %20 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !299 ; line:164 col:5
  %21 = fmul fast float %Frc, 0x3FB99999A0000000, !dbg !300 ; line:185 col:42
  %22 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !301 ; line:185 col:11
  call void @llvm.dbg.value(metadata float %21, i64 0, metadata !302, metadata !303), !dbg !301 ; var:"h" !DIExpression() func:"DS"
  %23 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !304 ; line:191 col:14
  call void @llvm.dbg.value(metadata float %.i289, i64 0, metadata !305, metadata !303), !dbg !306 ; var:"z" !DIExpression() func:"GetHillsHeight"
  call void @llvm.dbg.value(metadata float %.i087, i64 0, metadata !308, metadata !303), !dbg !309 ; var:"x" !DIExpression() func:"GetHillsHeight"
  %24 = fmul fast float 0x3FA99999A0000000, %.i087, !dbg !310 ; line:99 col:34
  %Sin8 = call float @dx.op.unary.f32(i32 13, float %24), !dbg !311 ; line:99 col:24  ; Sin(value)
  %25 = fmul fast float %.i289, %Sin8, !dbg !312 ; line:99 col:22
  %26 = fmul fast float 0x3FB99999A0000000, %.i289, !dbg !313 ; line:99 col:54
  %Cos7 = call float @dx.op.unary.f32(i32 12, float %26), !dbg !314 ; line:99 col:45  ; Cos(value)
  %27 = fmul fast float %.i087, %Cos7, !dbg !315 ; line:99 col:43
  %28 = fadd fast float %25, %27, !dbg !316 ; line:99 col:39
  %29 = fmul fast float 0x3FD3333340000000, %28, !dbg !317 ; line:99 col:17
  %30 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !318 ; line:99 col:5
  %31 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !319 ; line:191 col:12
  call void @llvm.dbg.value(metadata float %.i087, i64 0, metadata !285, metadata !269), !dbg !284 ; var:"posL" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %29, i64 0, metadata !285, metadata !271), !dbg !284 ; var:"posL" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i289, i64 0, metadata !285, metadata !277), !dbg !284 ; var:"posL" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %32 = fmul fast float %21, 1.000000e+01, !dbg !320 ; line:192 col:17
  %33 = fadd fast float %29, %32, !dbg !321 ; line:192 col:12
  %34 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !321 ; line:192 col:12
  call void @llvm.dbg.value(metadata float %.i087, i64 0, metadata !285, metadata !269), !dbg !284 ; var:"posL" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %33, i64 0, metadata !285, metadata !271), !dbg !284 ; var:"posL" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i289, i64 0, metadata !285, metadata !277), !dbg !284 ; var:"posL" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %35 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !322 ; line:193 col:15
  call void @llvm.dbg.value(metadata float %.i289, i64 0, metadata !323, metadata !303), !dbg !324 ; var:"z" !DIExpression() func:"GetHillsNormal"
  call void @llvm.dbg.value(metadata float %.i087, i64 0, metadata !326, metadata !303), !dbg !327 ; var:"x" !DIExpression() func:"GetHillsNormal"
  %36 = fmul fast float 0x3FA99999A0000000, %.i289, !dbg !328 ; line:107 col:33
  %37 = fmul fast float 0x3FA99999A0000000, %.i087, !dbg !329 ; line:107 col:49
  %Cos6 = call float @dx.op.unary.f32(i32 12, float %37), !dbg !330 ; line:107 col:39  ; Cos(value)
  %38 = fmul fast float %36, %Cos6, !dbg !331 ; line:107 col:37
  %39 = fmul fast float 0x3FB99999A0000000, %.i289, !dbg !332 ; line:107 col:65
  %Cos = call float @dx.op.unary.f32(i32 12, float %39), !dbg !333 ; line:107 col:56  ; Cos(value)
  %40 = fadd fast float %38, %Cos, !dbg !334 ; line:107 col:54
  %41 = fmul fast float 0x3FD3333340000000, %40, !dbg !335 ; line:107 col:24
  %42 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !336 ; line:107 col:11
  call void @llvm.dbg.value(metadata float %41, i64 0, metadata !337, metadata !303), !dbg !336 ; var:"df_dx" !DIExpression() func:"GetHillsNormal"
  %43 = fmul fast float 0x3FA99999A0000000, %.i087, !dbg !338 ; line:108 col:37
  %Sin5 = call float @dx.op.unary.f32(i32 13, float %43), !dbg !339 ; line:108 col:27  ; Sin(value)
  %44 = fmul fast float 0x3FB99999A0000000, %.i087, !dbg !340 ; line:108 col:49
  %45 = fmul fast float 0x3FB99999A0000000, %.i289, !dbg !341 ; line:108 col:64
  %Sin = call float @dx.op.unary.f32(i32 13, float %45), !dbg !342 ; line:108 col:55  ; Sin(value)
  %46 = fmul fast float %44, %Sin, !dbg !343 ; line:108 col:53
  %47 = fsub fast float %Sin5, %46, !dbg !344 ; line:108 col:42
  %48 = fmul fast float 0x3FD3333340000000, %47, !dbg !345 ; line:108 col:24
  %49 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !346 ; line:108 col:11
  call void @llvm.dbg.value(metadata float %48, i64 0, metadata !347, metadata !303), !dbg !346 ; var:"df_dz" !DIExpression() func:"GetHillsNormal"
  %50 = fsub fast float -0.000000e+00, %41, !dbg !348 ; line:110 col:29
  %51 = fsub fast float -0.000000e+00, %48, !dbg !349 ; line:110 col:43
  %52 = call float @dx.op.dot3.f32(i32 55, float %50, float 1.000000e+00, float %51, float %50, float 1.000000e+00, float %51), !dbg !350 ; line:110 col:12  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt = call float @dx.op.unary.f32(i32 25, float %52), !dbg !350 ; line:110 col:12  ; Rsqrt(value)
  %.i0124 = fmul fast float %50, %Rsqrt, !dbg !350 ; line:110 col:12
  %.i1125 = fmul fast float 1.000000e+00, %Rsqrt, !dbg !350 ; line:110 col:12
  %.i2126 = fmul fast float %51, %Rsqrt, !dbg !350 ; line:110 col:12
  %53 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !351 ; line:110 col:5
  %54 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !352 ; line:193 col:13
  call void @llvm.dbg.value(metadata float %.i0124, i64 0, metadata !353, metadata !269), !dbg !288 ; var:"normalL" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i1125, i64 0, metadata !353, metadata !271), !dbg !288 ; var:"normalL" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i2126, i64 0, metadata !353, metadata !277), !dbg !288 ; var:"normalL" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %55 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 0), !dbg !354 ; line:197 col:43  ; CBufferLoadLegacy(handle,regIndex)
  %56 = extractvalue %dx.types.CBufRet.f32 %55, 0, !dbg !354 ; line:197 col:43
  %57 = extractvalue %dx.types.CBufRet.f32 %55, 1, !dbg !354 ; line:197 col:43
  %58 = extractvalue %dx.types.CBufRet.f32 %55, 2, !dbg !354 ; line:197 col:43
  %59 = extractvalue %dx.types.CBufRet.f32 %55, 3, !dbg !354 ; line:197 col:43
  %60 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 1), !dbg !354 ; line:197 col:43  ; CBufferLoadLegacy(handle,regIndex)
  %61 = extractvalue %dx.types.CBufRet.f32 %60, 0, !dbg !354 ; line:197 col:43
  %62 = extractvalue %dx.types.CBufRet.f32 %60, 1, !dbg !354 ; line:197 col:43
  %63 = extractvalue %dx.types.CBufRet.f32 %60, 2, !dbg !354 ; line:197 col:43
  %64 = extractvalue %dx.types.CBufRet.f32 %60, 3, !dbg !354 ; line:197 col:43
  %65 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 2), !dbg !354 ; line:197 col:43  ; CBufferLoadLegacy(handle,regIndex)
  %66 = extractvalue %dx.types.CBufRet.f32 %65, 0, !dbg !354 ; line:197 col:43
  %67 = extractvalue %dx.types.CBufRet.f32 %65, 1, !dbg !354 ; line:197 col:43
  %68 = extractvalue %dx.types.CBufRet.f32 %65, 2, !dbg !354 ; line:197 col:43
  %69 = extractvalue %dx.types.CBufRet.f32 %65, 3, !dbg !354 ; line:197 col:43
  %70 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 3), !dbg !354 ; line:197 col:43  ; CBufferLoadLegacy(handle,regIndex)
  %71 = extractvalue %dx.types.CBufRet.f32 %70, 0, !dbg !354 ; line:197 col:43
  %72 = extractvalue %dx.types.CBufRet.f32 %70, 1, !dbg !354 ; line:197 col:43
  %73 = extractvalue %dx.types.CBufRet.f32 %70, 2, !dbg !354 ; line:197 col:43
  %74 = extractvalue %dx.types.CBufRet.f32 %70, 3, !dbg !354 ; line:197 col:43
  %75 = fmul fast float %.i087, %56, !dbg !355 ; line:197 col:19
  %FMad65 = call float @dx.op.tertiary.f32(i32 46, float %33, float %57, float %75), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %FMad64 = call float @dx.op.tertiary.f32(i32 46, float %.i289, float %58, float %FMad65), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %FMad63 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %59, float %FMad64), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %76 = fmul fast float %.i087, %61, !dbg !355 ; line:197 col:19
  %FMad62 = call float @dx.op.tertiary.f32(i32 46, float %33, float %62, float %76), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %FMad61 = call float @dx.op.tertiary.f32(i32 46, float %.i289, float %63, float %FMad62), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %FMad60 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %64, float %FMad61), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %77 = fmul fast float %.i087, %66, !dbg !355 ; line:197 col:19
  %FMad59 = call float @dx.op.tertiary.f32(i32 46, float %33, float %67, float %77), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %FMad58 = call float @dx.op.tertiary.f32(i32 46, float %.i289, float %68, float %FMad59), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %FMad57 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %69, float %FMad58), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %78 = fmul fast float %.i087, %71, !dbg !355 ; line:197 col:19
  %FMad56 = call float @dx.op.tertiary.f32(i32 46, float %33, float %72, float %78), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %FMad55 = call float @dx.op.tertiary.f32(i32 46, float %.i289, float %73, float %FMad56), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %FMad54 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %74, float %FMad55), !dbg !355 ; line:197 col:19  ; FMad(a,b,c)
  %79 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !356 ; line:197 col:12
  call void @llvm.dbg.value(metadata float %FMad63, i64 0, metadata !357, metadata !269), !dbg !356 ; var:"posW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad60, i64 0, metadata !357, metadata !271), !dbg !356 ; var:"posW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad57, i64 0, metadata !357, metadata !277), !dbg !356 ; var:"posW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad54, i64 0, metadata !357, metadata !358), !dbg !356 ; var:"posW" !DIExpression(DW_OP_bit_piece, 96, 32) func:"DS"
  %80 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !359 ; line:198 col:15
  call void @llvm.dbg.value(metadata float %FMad63, i64 0, metadata !360, metadata !361), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad60, i64 0, metadata !360, metadata !363), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad57, i64 0, metadata !360, metadata !364), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"DS"
  %81 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 16), !dbg !365 ; line:200 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %82 = extractvalue %dx.types.CBufRet.f32 %81, 0, !dbg !365 ; line:200 col:27
  %83 = extractvalue %dx.types.CBufRet.f32 %81, 1, !dbg !365 ; line:200 col:27
  %84 = extractvalue %dx.types.CBufRet.f32 %81, 2, !dbg !365 ; line:200 col:27
  %85 = extractvalue %dx.types.CBufRet.f32 %81, 3, !dbg !365 ; line:200 col:27
  %86 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 17), !dbg !365 ; line:200 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %87 = extractvalue %dx.types.CBufRet.f32 %86, 0, !dbg !365 ; line:200 col:27
  %88 = extractvalue %dx.types.CBufRet.f32 %86, 1, !dbg !365 ; line:200 col:27
  %89 = extractvalue %dx.types.CBufRet.f32 %86, 2, !dbg !365 ; line:200 col:27
  %90 = extractvalue %dx.types.CBufRet.f32 %86, 3, !dbg !365 ; line:200 col:27
  %91 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 18), !dbg !365 ; line:200 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %92 = extractvalue %dx.types.CBufRet.f32 %91, 0, !dbg !365 ; line:200 col:27
  %93 = extractvalue %dx.types.CBufRet.f32 %91, 1, !dbg !365 ; line:200 col:27
  %94 = extractvalue %dx.types.CBufRet.f32 %91, 2, !dbg !365 ; line:200 col:27
  %95 = extractvalue %dx.types.CBufRet.f32 %91, 3, !dbg !365 ; line:200 col:27
  %96 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPass_cbuffer, i32 19), !dbg !365 ; line:200 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %97 = extractvalue %dx.types.CBufRet.f32 %96, 0, !dbg !365 ; line:200 col:27
  %98 = extractvalue %dx.types.CBufRet.f32 %96, 1, !dbg !365 ; line:200 col:27
  %99 = extractvalue %dx.types.CBufRet.f32 %96, 2, !dbg !365 ; line:200 col:27
  %100 = extractvalue %dx.types.CBufRet.f32 %96, 3, !dbg !365 ; line:200 col:27
  %101 = fmul fast float %FMad63, %82, !dbg !366 ; line:200 col:17
  %FMad53 = call float @dx.op.tertiary.f32(i32 46, float %FMad60, float %83, float %101), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %FMad52 = call float @dx.op.tertiary.f32(i32 46, float %FMad57, float %84, float %FMad53), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %FMad51 = call float @dx.op.tertiary.f32(i32 46, float %FMad54, float %85, float %FMad52), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %102 = fmul fast float %FMad63, %87, !dbg !366 ; line:200 col:17
  %FMad50 = call float @dx.op.tertiary.f32(i32 46, float %FMad60, float %88, float %102), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %FMad49 = call float @dx.op.tertiary.f32(i32 46, float %FMad57, float %89, float %FMad50), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %FMad48 = call float @dx.op.tertiary.f32(i32 46, float %FMad54, float %90, float %FMad49), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %103 = fmul fast float %FMad63, %92, !dbg !366 ; line:200 col:17
  %FMad47 = call float @dx.op.tertiary.f32(i32 46, float %FMad60, float %93, float %103), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %FMad46 = call float @dx.op.tertiary.f32(i32 46, float %FMad57, float %94, float %FMad47), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %FMad45 = call float @dx.op.tertiary.f32(i32 46, float %FMad54, float %95, float %FMad46), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %104 = fmul fast float %FMad63, %97, !dbg !366 ; line:200 col:17
  %FMad44 = call float @dx.op.tertiary.f32(i32 46, float %FMad60, float %98, float %104), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %FMad43 = call float @dx.op.tertiary.f32(i32 46, float %FMad57, float %99, float %FMad44), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %FMad42 = call float @dx.op.tertiary.f32(i32 46, float %FMad54, float %100, float %FMad43), !dbg !366 ; line:200 col:17  ; FMad(a,b,c)
  %105 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !367 ; line:200 col:15
  call void @llvm.dbg.value(metadata float %FMad51, i64 0, metadata !360, metadata !269), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad48, i64 0, metadata !360, metadata !271), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad45, i64 0, metadata !360, metadata !277), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad42, i64 0, metadata !360, metadata !358), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"DS"
  %106 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 0), !dbg !368 ; line:202 col:56  ; CBufferLoadLegacy(handle,regIndex)
  %107 = extractvalue %dx.types.CBufRet.f32 %106, 0, !dbg !368 ; line:202 col:56
  %108 = extractvalue %dx.types.CBufRet.f32 %106, 1, !dbg !368 ; line:202 col:56
  %109 = extractvalue %dx.types.CBufRet.f32 %106, 2, !dbg !368 ; line:202 col:56
  %110 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 1), !dbg !368 ; line:202 col:56  ; CBufferLoadLegacy(handle,regIndex)
  %111 = extractvalue %dx.types.CBufRet.f32 %110, 0, !dbg !368 ; line:202 col:56
  %112 = extractvalue %dx.types.CBufRet.f32 %110, 1, !dbg !368 ; line:202 col:56
  %113 = extractvalue %dx.types.CBufRet.f32 %110, 2, !dbg !368 ; line:202 col:56
  %114 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 2), !dbg !368 ; line:202 col:56  ; CBufferLoadLegacy(handle,regIndex)
  %115 = extractvalue %dx.types.CBufRet.f32 %114, 0, !dbg !368 ; line:202 col:56
  %116 = extractvalue %dx.types.CBufRet.f32 %114, 1, !dbg !368 ; line:202 col:56
  %117 = extractvalue %dx.types.CBufRet.f32 %114, 2, !dbg !368 ; line:202 col:56
  %118 = fmul fast float %.i0124, %107, !dbg !369 ; line:202 col:32
  %FMad41 = call float @dx.op.tertiary.f32(i32 46, float %.i1125, float %108, float %118), !dbg !369 ; line:202 col:32  ; FMad(a,b,c)
  %FMad40 = call float @dx.op.tertiary.f32(i32 46, float %.i2126, float %109, float %FMad41), !dbg !369 ; line:202 col:32  ; FMad(a,b,c)
  %119 = fmul fast float %.i0124, %111, !dbg !369 ; line:202 col:32
  %FMad39 = call float @dx.op.tertiary.f32(i32 46, float %.i1125, float %112, float %119), !dbg !369 ; line:202 col:32  ; FMad(a,b,c)
  %FMad38 = call float @dx.op.tertiary.f32(i32 46, float %.i2126, float %113, float %FMad39), !dbg !369 ; line:202 col:32  ; FMad(a,b,c)
  %120 = fmul fast float %.i0124, %115, !dbg !369 ; line:202 col:32
  %FMad37 = call float @dx.op.tertiary.f32(i32 46, float %.i1125, float %116, float %120), !dbg !369 ; line:202 col:32  ; FMad(a,b,c)
  %FMad36 = call float @dx.op.tertiary.f32(i32 46, float %.i2126, float %117, float %FMad37), !dbg !369 ; line:202 col:32  ; FMad(a,b,c)
  %121 = call float @dx.op.dot3.f32(i32 55, float %FMad40, float %FMad38, float %FMad36, float %FMad40, float %FMad38, float %FMad36), !dbg !370 ; line:202 col:22  ; Dot3(ax,ay,az,bx,by,bz)
  %Rsqrt11 = call float @dx.op.unary.f32(i32 25, float %121), !dbg !370 ; line:202 col:22  ; Rsqrt(value)
  %.i0127 = fmul fast float %FMad40, %Rsqrt11, !dbg !370 ; line:202 col:22
  %.i1128 = fmul fast float %FMad38, %Rsqrt11, !dbg !370 ; line:202 col:22
  %.i2129 = fmul fast float %FMad36, %Rsqrt11, !dbg !370 ; line:202 col:22
  %122 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !371 ; line:202 col:12
  call void @llvm.dbg.value(metadata float %.i0127, i64 0, metadata !372, metadata !269), !dbg !371 ; var:"normalW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i1128, i64 0, metadata !372, metadata !271), !dbg !371 ; var:"normalW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i2129, i64 0, metadata !372, metadata !277), !dbg !371 ; var:"normalW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  %123 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !373 ; line:203 col:18
  call void @llvm.dbg.value(metadata float %.i0127, i64 0, metadata !360, metadata !374), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i1128, i64 0, metadata !360, metadata !375), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 256, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %.i2129, i64 0, metadata !360, metadata !376), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 288, 32) func:"DS"
  %124 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 4), !dbg !377 ; line:205 col:45  ; CBufferLoadLegacy(handle,regIndex)
  %125 = extractvalue %dx.types.CBufRet.f32 %124, 0, !dbg !377 ; line:205 col:45
  %126 = extractvalue %dx.types.CBufRet.f32 %124, 1, !dbg !377 ; line:205 col:45
  %127 = extractvalue %dx.types.CBufRet.f32 %124, 2, !dbg !377 ; line:205 col:45
  %128 = extractvalue %dx.types.CBufRet.f32 %124, 3, !dbg !377 ; line:205 col:45
  %129 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 5), !dbg !377 ; line:205 col:45  ; CBufferLoadLegacy(handle,regIndex)
  %130 = extractvalue %dx.types.CBufRet.f32 %129, 0, !dbg !377 ; line:205 col:45
  %131 = extractvalue %dx.types.CBufRet.f32 %129, 1, !dbg !377 ; line:205 col:45
  %132 = extractvalue %dx.types.CBufRet.f32 %129, 2, !dbg !377 ; line:205 col:45
  %133 = extractvalue %dx.types.CBufRet.f32 %129, 3, !dbg !377 ; line:205 col:45
  %134 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 6), !dbg !377 ; line:205 col:45  ; CBufferLoadLegacy(handle,regIndex)
  %135 = extractvalue %dx.types.CBufRet.f32 %134, 0, !dbg !377 ; line:205 col:45
  %136 = extractvalue %dx.types.CBufRet.f32 %134, 1, !dbg !377 ; line:205 col:45
  %137 = extractvalue %dx.types.CBufRet.f32 %134, 2, !dbg !377 ; line:205 col:45
  %138 = extractvalue %dx.types.CBufRet.f32 %134, 3, !dbg !377 ; line:205 col:45
  %139 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 7), !dbg !377 ; line:205 col:45  ; CBufferLoadLegacy(handle,regIndex)
  %140 = extractvalue %dx.types.CBufRet.f32 %139, 0, !dbg !377 ; line:205 col:45
  %141 = extractvalue %dx.types.CBufRet.f32 %139, 1, !dbg !377 ; line:205 col:45
  %142 = extractvalue %dx.types.CBufRet.f32 %139, 2, !dbg !377 ; line:205 col:45
  %143 = extractvalue %dx.types.CBufRet.f32 %139, 3, !dbg !377 ; line:205 col:45
  %144 = fmul fast float %1, %125, !dbg !378 ; line:205 col:19
  %FMad35 = call float @dx.op.tertiary.f32(i32 46, float %2, float %126, float %144), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %FMad34 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %127, float %FMad35), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %FMad33 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %128, float %FMad34), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %145 = fmul fast float %1, %130, !dbg !378 ; line:205 col:19
  %FMad32 = call float @dx.op.tertiary.f32(i32 46, float %2, float %131, float %145), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %FMad31 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %132, float %FMad32), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %FMad30 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %133, float %FMad31), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %146 = fmul fast float %1, %135, !dbg !378 ; line:205 col:19
  %FMad29 = call float @dx.op.tertiary.f32(i32 46, float %2, float %136, float %146), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %FMad28 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %137, float %FMad29), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %FMad27 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %138, float %FMad28), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %147 = fmul fast float %1, %140, !dbg !378 ; line:205 col:19
  %FMad26 = call float @dx.op.tertiary.f32(i32 46, float %2, float %141, float %147), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %FMad25 = call float @dx.op.tertiary.f32(i32 46, float 0.000000e+00, float %142, float %FMad26), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %FMad24 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %143, float %FMad25), !dbg !378 ; line:205 col:19  ; FMad(a,b,c)
  %148 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !379 ; line:205 col:12
  call void @llvm.dbg.value(metadata float %FMad33, i64 0, metadata !380, metadata !269), !dbg !379 ; var:"texC" !DIExpression(DW_OP_bit_piece, 0, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad30, i64 0, metadata !380, metadata !271), !dbg !379 ; var:"texC" !DIExpression(DW_OP_bit_piece, 32, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad27, i64 0, metadata !380, metadata !277), !dbg !379 ; var:"texC" !DIExpression(DW_OP_bit_piece, 64, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad24, i64 0, metadata !380, metadata !358), !dbg !379 ; var:"texC" !DIExpression(DW_OP_bit_piece, 96, 32) func:"DS"
  %149 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 2), !dbg !381 ; line:206 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %150 = extractvalue %dx.types.CBufRet.f32 %149, 0, !dbg !381 ; line:206 col:27
  %151 = extractvalue %dx.types.CBufRet.f32 %149, 1, !dbg !381 ; line:206 col:27
  %152 = extractvalue %dx.types.CBufRet.f32 %149, 2, !dbg !381 ; line:206 col:27
  %153 = extractvalue %dx.types.CBufRet.f32 %149, 3, !dbg !381 ; line:206 col:27
  %154 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbMaterial_cbuffer, i32 3), !dbg !381 ; line:206 col:27  ; CBufferLoadLegacy(handle,regIndex)
  %155 = extractvalue %dx.types.CBufRet.f32 %154, 0, !dbg !381 ; line:206 col:27
  %156 = extractvalue %dx.types.CBufRet.f32 %154, 1, !dbg !381 ; line:206 col:27
  %157 = extractvalue %dx.types.CBufRet.f32 %154, 2, !dbg !381 ; line:206 col:27
  %158 = extractvalue %dx.types.CBufRet.f32 %154, 3, !dbg !381 ; line:206 col:27
  %159 = fmul fast float %FMad33, %150, !dbg !382 ; line:206 col:17
  %FMad23 = call float @dx.op.tertiary.f32(i32 46, float %FMad30, float %151, float %159), !dbg !382 ; line:206 col:17  ; FMad(a,b,c)
  %FMad22 = call float @dx.op.tertiary.f32(i32 46, float %FMad27, float %152, float %FMad23), !dbg !382 ; line:206 col:17  ; FMad(a,b,c)
  %FMad21 = call float @dx.op.tertiary.f32(i32 46, float %FMad24, float %153, float %FMad22), !dbg !382 ; line:206 col:17  ; FMad(a,b,c)
  %160 = fmul fast float %FMad33, %155, !dbg !382 ; line:206 col:17
  %FMad20 = call float @dx.op.tertiary.f32(i32 46, float %FMad30, float %156, float %160), !dbg !382 ; line:206 col:17  ; FMad(a,b,c)
  %FMad19 = call float @dx.op.tertiary.f32(i32 46, float %FMad27, float %157, float %FMad20), !dbg !382 ; line:206 col:17  ; FMad(a,b,c)
  %FMad18 = call float @dx.op.tertiary.f32(i32 46, float %FMad24, float %158, float %FMad19), !dbg !382 ; line:206 col:17  ; FMad(a,b,c)
  %161 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !382 ; line:206 col:17
  %162 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !383 ; line:206 col:15
  call void @llvm.dbg.value(metadata float %FMad21, i64 0, metadata !360, metadata !384), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 320, 32) func:"DS"
  call void @llvm.dbg.value(metadata float %FMad18, i64 0, metadata !360, metadata !385), !dbg !362 ; var:"dout" !DIExpression(DW_OP_bit_piece, 352, 32) func:"DS"
  %163 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !386 ; line:208 col:12
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad51), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad48), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad45), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float %FMad42), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %FMad63), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %FMad60), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %FMad57), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %.i0127), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float %.i1128), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 2, float %.i2129), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 0, float %FMad21), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 3, i32 0, i8 1, float %FMad18), !dbg !386 ; line:208 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  %164 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !387 ; line:208 col:5
  ret void, !dbg !387 ; line:208 col:5
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
!llvm.module.flags = !{!184, !185}
!llvm.ident = !{!186}
!dx.source.contents = !{!187, !188}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!189}
!dx.source.args = !{!190}
!dx.version = !{!191}
!dx.valver = !{!192}
!dx.shaderModel = !{!193}
!dx.resources = !{!194}
!dx.typeAnnotations = !{!199, !240}
!dx.viewIdState = !{!243}
!dx.entryPoints = !{!244}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !46, globals: !99)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl", directory: "")
!2 = !{}
!3 = !{!4, !16, !31, !38}
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
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 40, baseType: !39)
!39 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 40, size: 96, align: 32, elements: !40, templateParams: !44)
!40 = !{!41, !42, !43}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !39, file: !1, line: 40, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !39, file: !1, line: 40, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !39, file: !1, line: 40, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!44 = !{!13, !45}
!45 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 3)
!46 = !{!47, !76, !90, !93, !96}
!47 = !DISubprogram(name: "ConstantHS", linkageName: "\01?ConstantHS@@YA?AUPatchTess@@V?$InputPatch@UVertexIn@@$03@@I@Z", scope: !1, file: !1, line: 118, type: !48, isLocal: false, isDefinition: true, scopeLine: 119, flags: DIFlagPrototyped, isOptimized: false)
!48 = !DISubroutineType(types: !49)
!49 = !{!50, !60, !74}
!50 = !DICompositeType(tag: DW_TAG_structure_type, name: "PatchTess", file: !1, line: 83, size: 192, align: 32, elements: !51)
!51 = !{!52, !56}
!52 = !DIDerivedType(tag: DW_TAG_member, name: "EdgeTess", scope: !50, file: !1, line: 85, baseType: !53, size: 128, align: 32)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 128, align: 32, elements: !54)
!54 = !{!55}
!55 = !DISubrange(count: 4)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "InsideTess", scope: !50, file: !1, line: 86, baseType: !57, size: 64, align: 32, offset: 128)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 64, align: 32, elements: !58)
!58 = !{!59}
!59 = !DISubrange(count: 2)
!60 = !DICompositeType(tag: DW_TAG_class_type, name: "InputPatch<VertexIn, 4>", file: !1, line: 73, size: 1024, align: 32, elements: !61, templateParams: !71)
!61 = !{!62, !64}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "Length", scope: !60, file: !1, line: 73, baseType: !63, flags: DIFlagPublic | DIFlagStaticMember, extraData: i32 4)
!63 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "h", scope: !60, file: !1, line: 73, baseType: !65, size: 1024, align: 32)
!65 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 1024, align: 32, elements: !54)
!66 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexIn", file: !1, line: 76, size: 256, align: 32, elements: !67)
!67 = !{!68, !69, !70}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "PosL", scope: !66, file: !1, line: 78, baseType: !38, size: 96, align: 32)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "NormalL", scope: !66, file: !1, line: 79, baseType: !38, size: 96, align: 32, offset: 96)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !66, file: !1, line: 80, baseType: !31, size: 64, align: 32, offset: 192)
!71 = !{!72, !73}
!72 = !DITemplateTypeParameter(name: "element", type: !66)
!73 = !DITemplateValueParameter(name: "count", type: !15, value: i32 4)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 73, baseType: !75)
!75 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!76 = !DISubprogram(name: "DS", scope: !1, file: !1, line: 170, type: !77, isLocal: false, isDefinition: true, scopeLine: 173, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @DS)
!77 = !DISubroutineType(types: !78)
!78 = !{!79, !50, !31, !85}
!79 = !DICompositeType(tag: DW_TAG_structure_type, name: "DomainOut", file: !1, line: 89, size: 384, align: 32, elements: !80)
!80 = !{!81, !82, !83, !84}
!81 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !79, file: !1, line: 91, baseType: !4, size: 128, align: 32)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !79, file: !1, line: 92, baseType: !38, size: 96, align: 32, offset: 128)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !79, file: !1, line: 93, baseType: !38, size: 96, align: 32, offset: 224)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !79, file: !1, line: 94, baseType: !31, size: 64, align: 32, offset: 320)
!85 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !86)
!86 = !DICompositeType(tag: DW_TAG_class_type, name: "OutputPatch<VertexIn, 4>", file: !1, line: 146, size: 1024, align: 32, elements: !87, templateParams: !71)
!87 = !{!88, !89}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "Length", scope: !86, file: !1, line: 146, baseType: !63, flags: DIFlagPublic | DIFlagStaticMember, extraData: i32 4)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "h", scope: !86, file: !1, line: 146, baseType: !65, size: 1024, align: 32)
!90 = !DISubprogram(name: "Hash12", linkageName: "\01?Hash12@@YAMV?$vector@M$01@@@Z", scope: !1, file: !1, line: 162, type: !91, isLocal: false, isDefinition: true, scopeLine: 163, flags: DIFlagPrototyped, isOptimized: false)
!91 = !DISubroutineType(types: !92)
!92 = !{!8, !31}
!93 = !DISubprogram(name: "GetHillsHeight", linkageName: "\01?GetHillsHeight@@YAMMM@Z", scope: !1, file: !1, line: 97, type: !94, isLocal: false, isDefinition: true, scopeLine: 98, flags: DIFlagPrototyped, isOptimized: false)
!94 = !DISubroutineType(types: !95)
!95 = !{!8, !8, !8}
!96 = !DISubprogram(name: "GetHillsNormal", linkageName: "\01?GetHillsNormal@@YA?AV?$vector@M$02@@MM@Z", scope: !1, file: !1, line: 102, type: !97, isLocal: false, isDefinition: true, scopeLine: 103, flags: DIFlagPrototyped, isOptimized: false)
!97 = !DISubroutineType(types: !98)
!98 = !{!38, !8, !8}
!99 = !{!100, !124, !125, !127, !129, !130, !132, !134, !135, !136, !137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149, !150, !151, !165, !166, !167, !168, !169, !170, !171, !175, !176, !177, !179, !180, !181, !182, !183}
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
!126 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !31)
!127 = !DIGlobalVariable(name: "gGridSpatialStep", linkageName: "\01?gGridSpatialStep@cbPerObject@@3MB", scope: !0, file: !1, line: 33, type: !128, isLocal: false, isDefinition: true)
!128 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!129 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPerObject@@3MB", scope: !0, file: !1, line: 34, type: !128, isLocal: false, isDefinition: true)
!130 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 39, type: !131, isLocal: false, isDefinition: true)
!131 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!132 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 40, type: !133, isLocal: false, isDefinition: true)
!133 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
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
!152 = !DICompositeType(tag: DW_TAG_array_type, baseType: !153, size: 6144, align: 32, elements: !163)
!153 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !154)
!154 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !155, line: 3, size: 384, align: 32, elements: !156)
!155 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!156 = !{!157, !158, !159, !160, !161, !162}
!157 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !154, file: !155, line: 5, baseType: !38, size: 96, align: 32)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !154, file: !155, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !154, file: !155, line: 7, baseType: !38, size: 96, align: 32, offset: 128)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !154, file: !155, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !154, file: !155, line: 9, baseType: !38, size: 96, align: 32, offset: 256)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !154, file: !155, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!163 = !{!164}
!164 = !DISubrange(count: 16)
!165 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 70, type: !131, isLocal: false, isDefinition: true)
!166 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 71, type: !128, isLocal: false, isDefinition: true)
!167 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 72, type: !128, isLocal: false, isDefinition: true)
!168 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 73, type: !126, isLocal: false, isDefinition: true)
!169 = !DIGlobalVariable(name: "d0", scope: !47, file: !1, line: 131, type: !128, isLocal: true, isDefinition: true)
!170 = !DIGlobalVariable(name: "d1", scope: !47, file: !1, line: 132, type: !128, isLocal: true, isDefinition: true)
!171 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 17, type: !172, isLocal: false, isDefinition: true)
!172 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 17, size: 160, align: 32, elements: !2, templateParams: !173)
!173 = !{!174}
!174 = !DITemplateTypeParameter(name: "element", type: !5)
!175 = !DIGlobalVariable(name: "gDiffuseMap2", linkageName: "\01?gDiffuseMap2@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 18, type: !172, isLocal: false, isDefinition: true)
!176 = !DIGlobalVariable(name: "gDisplacementMap", linkageName: "\01?gDisplacementMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 19, type: !172, isLocal: false, isDefinition: true)
!177 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !178, isLocal: false, isDefinition: true)
!178 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 21, size: 32, align: 32, elements: !2)
!179 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !178, isLocal: false, isDefinition: true)
!180 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 23, type: !178, isLocal: false, isDefinition: true)
!181 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 24, type: !178, isLocal: false, isDefinition: true)
!182 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 25, type: !178, isLocal: false, isDefinition: true)
!183 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 26, type: !178, isLocal: false, isDefinition: true)
!184 = !{i32 2, !"Dwarf Version", i32 4}
!185 = !{i32 2, !"Debug Info Version", i32 3}
!186 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!187 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A//#define CARTOON\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0ATexture2D gDiffuseMap2 : register(t1);\0D\0ATexture2D gDisplacementMap : register(t2);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A    float2 gDisplacementMapTexelSize;\0D\0A    float gGridSpatialStep;\0D\0A    float cbPerObjectPad1;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerPassPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    // \EC\9D\B8\EB\8D\B1\EC\8A\A4 [0, NUM_DIR_LIGHTS)\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B4\91\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)\EB\8A\94 \EC\A0\90\EA\B4\91\EC\9B\90\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHT + NUM_SPOT_LIGHTS)\EB\8A\94 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\B4\EB\A9\B0, \EA\B0\9D\EC\B2\B4\EB\8B\B9 \EC\B5\9C\EB\8C\80 MaxLights \EA\B0\9C\EC\88\98\EA\B9\8C\EC\A7\80 \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    //\EC\95\B1\EC\9D\B4 \ED\94\84\EB\A0\88\EC\9E\84\EB\8B\B9 \ED\95\9C \EB\B2\88\EC\94\A9 \EC\95\88\EA\B0\9C \EB\A7\A4\EA\B0\9C\EB\B3\80\EC\88\98\EB\A5\BC \EB\B3\80\EA\B2\BD\ED\95\A0 \EC\88\98 \EC\9E\88\EB\8F\84\EB\A1\9D \ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    //\ED\8A\B9\EC\A0\95 \EC\8B\9C\EA\B0\84\EB\8C\80\EC\97\90\EB\A7\8C \EC\95\88\EA\B0\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosL : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct PatchTess\0D\0A{\0D\0A    float EdgeTess[4] : SV_TessFactor;\0D\0A    float InsideTess[2] : SV_InsideTessFactor;\0D\0A};\0D\0A\0D\0Astruct DomainOut\0D\0A{\0D\0A    float4 PosH : SV_Position;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Afloat GetHillsHeight(float x, float z)\0D\0A{\0D\0A    return 0.3f * (z * sin(0.05f * x) + x * cos(0.1f * z));\0D\0A}\0D\0A\0D\0Afloat3 GetHillsNormal(float x, float z)\0D\0A{\0D\0A    // y = f(x, z)\0D\0A    // normal = normalize((-df/dx, 1, -df/dz))\0D\0A\0D\0A    float df_dx = 0.3f * (0.05f * z * cos(0.05f * x) + cos(0.1f * z));\0D\0A    float df_dz = 0.3f * (sin(0.05f * x) - 0.1f * x * sin(0.1f * z));\0D\0A\0D\0A    return normalize(float3(-df_dx, 1.0f, -df_dz));\0D\0A}\0D\0A\0D\0AVertexIn VS(VertexIn vin)\0D\0A{\0D\0A    return vin;\0D\0A}\0D\0A\0D\0APatchTess ConstantHS(InputPatch<VertexIn, 4> patch, uint patchID : SV_PrimitiveID)\0D\0A{\0D\0A    PatchTess pt;\0D\0A    \0D\0A    float3 centerL = 0.25f * (patch[0].PosL + patch[1].PosL + patch[2].PosL + patch[3].PosL);\0D\0A    float3 centerW = mul(float4(centerL, 1.0f), gWorld).xyz;\0D\0A    \0D\0A    float d = distance(centerW, gEyePosW);\0D\0A    \0D\0A    // \EC\8B\9C\EC\A0\90(eye)\EC\9C\BC\EB\A1\9C\EB\B6\80\ED\84\B0\EC\9D\98 \EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\9D\BC \ED\8C\A8\EC\B9\98\EB\A5\BC \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98\ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    // \EC\9D\B4\EB\95\8C \EA\B1\B0\EB\A6\AC\EA\B0\80 d1 \EC\9D\B4\EC\83\81\EC\9D\B4\EB\A9\B4 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98 \EC\88\98\EC\A4\80\EC\9D\80 0\EC\9D\B4 \EB\90\98\EA\B3\A0, d0 \EC\9D\B4\ED\95\98\EC\9D\B4\EB\A9\B4 64\EA\B0\80 \EB\90\A9\EB\8B\88\EB\8B\A4.\0D\0A    // \EA\B5\AC\EA\B0\84 [d0, d1]\EC\9D\80 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98\EC\9D\B4 \EC\88\98\ED\96\89\EB\90\98\EB\8A\94 \EB\B2\94\EC\9C\84\EB\A5\BC \EC\A0\95\EC\9D\98\ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    \0D\0A    const float d0 = 20.0f;\0D\0A    const float d1 = 100.0f;\0D\0A    float tess = 64.0f * saturate((d1 - d) / (d1 - d0));\0D\0A    \0D\0A    //\EA\B7\A0\EC\9D\BC\ED\95\98\EA\B2\8C \ED\8C\A8\EC\B9\98\EB\A5\BC tessellate\0D\0A    \0D\0A    pt.EdgeTess[0] = tess;\0D\0A    pt.EdgeTess[1] = tess;\0D\0A    pt.EdgeTess[2] = tess;\0D\0A    pt.EdgeTess[3] = tess;\0D\0A\09\0D\0A    pt.InsideTess[0] = tess;\0D\0A    pt.InsideTess[1] = tess;\0D\0A\09\0D\0A    return pt;\0D\0A}\0D\0A\0D\0A[domain(\22quad\22)]\0D\0A[partitioning(\22integer\22)]\0D\0A[outputtopology(\22triangle_cw\22)]\0D\0A[outputcontrolpoints(4)]\0D\0A[patchconstantfunc(\22ConstantHS\22)]\0D\0A[maxtessfactor(64.0f)]\0D\0AVertexIn HS(InputPatch<VertexIn, 4> p,\0D\0A           uint i : SV_OutputControlPointID,\0D\0A           uint patchId : SV_PrimitiveID)\0D\0A{\0D\0A    return p[i];\0D\0A}\0D\0A\0D\0A//\EC\9C\A0\EC\82\AC \EB\9E\9C\EB\8D\A4\ED\95\A8\EC\88\98\0D\0Afloat Hash12(float2 p)\0D\0A{\0D\0A    return frac(sin(dot(p, float2(127.1f, 311.7f))) * 43758.5453123f);\0D\0A}\0D\0A\0D\0A// \EB\8F\84\EB\A9\94\EC\9D\B8 \EC\85\B0\EC\9D\B4\EB\8D\94\EB\8A\94 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\ED\84\B0\EA\B0\80 \EC\83\9D\EC\84\B1\ED\95\9C \EB\AA\A8\EB\93\A0 \EC\A0\95\EC\A0\90\EB\A7\88\EB\8B\A4 \ED\98\B8\EC\B6\9C\EB\90\9C\EB\8B\A4.\0D\0A// \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98 \EC\9D\B4\ED\9B\84\EC\9D\98 \EC\A0\95\EC\A0\90 \EC\85\B0\EC\9D\B4\EB\8D\94\EC\99\80 \EB\B9\84\EC\8A\B7\ED\95\9C \EC\97\AD\ED\95\A0\EC\9D\84 \ED\95\9C\EB\8B\A4.\0D\0A[domain(\22quad\22)]\0D\0ADomainOut DS(PatchTess patchTess,\0D\0A            float2 uv : SV_DomainLocation,\0D\0A            const OutputPatch<VertexIn, 4> quad)\0D\0A{\0D\0A    DomainOut dout;\0D\0A    \0D\0A    //\EC\8C\8D\EC\84\A0\ED\98\95 \EB\B3\B4\EA\B0\84\0D\0A    float3 v1 = lerp(quad[0].PosL, quad[1].PosL, uv.x);\0D\0A    float3 v2 = lerp(quad[2].PosL, quad[3].PosL, uv.x);\0D\0A    float3 posL = lerp(v1, v2, uv.y);\0D\0A    \0D\0A    float3 n1 = lerp(quad[0].NormalL, quad[1].NormalL, uv.x);\0D\0A    float3 n2 = lerp(quad[2].NormalL, quad[3].NormalL, uv.x);\0D\0A    float3 normalL = normalize(lerp(n1, n2, uv.y));\0D\0A    \0D\0A    float h = Hash12(floor(uv * 128.0f)) * 0.1f;\0D\0A#ifdef WALL\0D\0A    // \EB\B2\BD\EB\8F\8C \EB\B2\BD: normal \EB\B0\A9\ED\96\A5\EC\9C\BC\EB\A1\9C \EB\B0\80\EA\B8\B0\0D\0A    posL += normalL * h;\0D\0A#else\0D\0A    // \EC\A7\80\ED\98\95: y \EB\86\92\EC\9D\B4\EB\A5\BC \ED\95\A8\EC\88\98\EB\A1\9C \EA\B2\B0\EC\A0\95\0D\0A    posL.y = GetHillsHeight(posL.x, posL.z);\0D\0A    posL.y += h * 10;\0D\0A    normalL = GetHillsNormal(posL.x, posL.z);\0D\0A#endif\0D\0A    \0D\0A    //\EB\B3\80\EC\9C\84 \EB\A7\A4\ED\95\91\0D\0A    float4 posW = mul(float4(posL, 1.0f), gWorld);\0D\0A    dout.PosW = posW.xyz;\0D\0A    \0D\0A    dout.PosH = mul(posW, gViewProj);\0D\0A    \0D\0A    float3 normalW = normalize(mul(normalL, (float3x3) gWorld));\0D\0A    dout.NormalW = normalW;    \0D\0A    \0D\0A    float4 texC = mul(float4(uv, 0.f, 1.f), gTexTransform);\0D\0A    dout.TexC = mul(texC, gMatTransform).xy;\0D\0A    \0D\0A    return dout;\0D\0A}\0D\0A\0D\0Afloat4 PS(DomainOut pin) : SV_Target\0D\0A{\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamLinearWrap, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A    //\EB\B3\B4\EA\B0\84\EB\90\9C \EB\B2\95\EC\84\A0 \EB\B2\A1\ED\84\B0\EB\8A\94 \EA\B8\B8\EC\9D\B4\EA\B0\80 1\EC\9D\B4 \EC\95\84\EB\8B\90 \EC\88\98 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C.\0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A\0D\0A    //\EA\B4\91\EC\9B\90\EC\97\90\EC\84\9C \EC\B9\B4\EB\A9\94\EB\9D\BC\EB\A1\9C \ED\96\A5\ED\95\98\EB\8A\94 \EB\B2\A1\ED\84\B0.\0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    \0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A    //\EC\9D\BC\EB\B0\98\EC\A0\81\EC\9C\BC\EB\A1\9C \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\80 \EB\94\94\ED\93\A8\EC\A6\88 \EB\A8\B8\ED\8B\B0\EB\A6\AC\EC\96\BC\EC\9D\98 \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\9C\EB\8B\A4.\0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A    \0D\0A    return litColor;\0D\0A}"}
!188 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhongToon(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    // 1) kd\0D\0A    float kd = saturate(dot(lightVec, normal));\0D\0A    float kd_q = QuantizeKd(kd);\0D\0A\0D\0A    // 2) ks (Blinn-Phong)\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    float ndoth = saturate(dot(halfVec, normal));\0D\0A\0D\0A    float ks = pow(max(ndoth, 0), m); // \EC\8A\A4\ED\8E\99\ED\81\98\EB\9F\AC \EA\B0\95\EB\8F\84\EC\9D\98 \ED\95\B5\EC\8B\AC\0D\0A    float ks_q = QuantizeKs(ks); // \EC\9D\B4\EC\82\B0\ED\99\94\0D\0A\0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    // fresnel(\EC\83\89) + (\ED\95\84\EC\9A\94\ED\95\98\EB\A9\B4) \EC\A0\95\EA\B7\9C\ED\99\94 \EA\B3\84\EC\88\98\EB\8A\94 \EC\B7\A8\ED\96\A5\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A\0D\0A    // ks_q\EB\A5\BC spec\EC\97\90 \EB\B0\98\EC\98\81\0D\0A    float3 specAlbedo = roughnessFactor * fresnelFactor * ks_q;\0D\0A\0D\0A    // LDR clamp\EB\8A\94 \EC\9C\A0\EC\A7\80 \EA\B0\80\EB\8A\A5\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A\0D\0A    // diffuse\EB\8A\94 kd_q\EB\A5\BC \EB\B0\98\EC\98\81\0D\0A    float3 diffuse = mat.DiffuseAlbedo.rgb * kd_q;\0D\0A    \0D\0A    return (diffuse + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!189 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl"}
!190 = !{!"-E", !"DS", !"-T", !"ds_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CtessDS.cso"}
!191 = !{i32 1, i32 0}
!192 = !{i32 1, i32 8}
!193 = !{!"ds", i32 6, i32 0}
!194 = !{null, null, !195, null}
!195 = !{!196, !197, !198}
!196 = !{i32 0, %hostlayout.cbPerObject* undef, !"cbPerObject", i32 0, i32 0, i32 1, i32 144, null}
!197 = !{i32 1, %hostlayout.cbMaterial* undef, !"cbMaterial", i32 0, i32 1, i32 1, i32 96, null}
!198 = !{i32 2, %hostlayout.cbPass* undef, !"cbPass", i32 0, i32 2, i32 1, i32 1248, null}
!199 = !{i32 0, %struct.Light undef, !200, %hostlayout.cbPerObject undef, !207, %hostlayout.cbMaterial undef, !214, %hostlayout.cbPass undef, !219}
!200 = !{i32 48, !201, !202, !203, !204, !205, !206}
!201 = !{i32 6, !"Strength", i32 3, i32 0, i32 7, i32 9}
!202 = !{i32 6, !"FalloffStart", i32 3, i32 12, i32 7, i32 9}
!203 = !{i32 6, !"Direction", i32 3, i32 16, i32 7, i32 9}
!204 = !{i32 6, !"FalloffEnd", i32 3, i32 28, i32 7, i32 9}
!205 = !{i32 6, !"Position", i32 3, i32 32, i32 7, i32 9}
!206 = !{i32 6, !"SpotPower", i32 3, i32 44, i32 7, i32 9}
!207 = !{i32 144, !208, !210, !211, !212, !213}
!208 = !{i32 6, !"gWorld", i32 2, !209, i32 3, i32 0, i32 7, i32 9}
!209 = !{i32 4, i32 4, i32 2}
!210 = !{i32 6, !"gTexTransform", i32 2, !209, i32 3, i32 64, i32 7, i32 9}
!211 = !{i32 6, !"gDisplacementMapTexelSize", i32 3, i32 128, i32 7, i32 9}
!212 = !{i32 6, !"gGridSpatialStep", i32 3, i32 136, i32 7, i32 9}
!213 = !{i32 6, !"cbPerObjectPad1", i32 3, i32 140, i32 7, i32 9}
!214 = !{i32 96, !215, !216, !217, !218}
!215 = !{i32 6, !"gDiffuseAlbedo", i32 3, i32 0, i32 7, i32 9}
!216 = !{i32 6, !"gFresnelR0", i32 3, i32 16, i32 7, i32 9}
!217 = !{i32 6, !"gRoughness", i32 3, i32 28, i32 7, i32 9}
!218 = !{i32 6, !"gMatTransform", i32 2, !209, i32 3, i32 32, i32 7, i32 9}
!219 = !{i32 1248, !220, !221, !222, !223, !224, !225, !226, !227, !228, !229, !230, !231, !232, !233, !234, !235, !236, !237, !238, !239}
!220 = !{i32 6, !"gView", i32 2, !209, i32 3, i32 0, i32 7, i32 9}
!221 = !{i32 6, !"gInvView", i32 2, !209, i32 3, i32 64, i32 7, i32 9}
!222 = !{i32 6, !"gProj", i32 2, !209, i32 3, i32 128, i32 7, i32 9}
!223 = !{i32 6, !"gInvProj", i32 2, !209, i32 3, i32 192, i32 7, i32 9}
!224 = !{i32 6, !"gViewProj", i32 2, !209, i32 3, i32 256, i32 7, i32 9}
!225 = !{i32 6, !"gInvViewProj", i32 2, !209, i32 3, i32 320, i32 7, i32 9}
!226 = !{i32 6, !"gEyePosW", i32 3, i32 384, i32 7, i32 9}
!227 = !{i32 6, !"cbPerPassPad1", i32 3, i32 396, i32 7, i32 9}
!228 = !{i32 6, !"gRenderTargetSize", i32 3, i32 400, i32 7, i32 9}
!229 = !{i32 6, !"gInvRenderTargetSize", i32 3, i32 408, i32 7, i32 9}
!230 = !{i32 6, !"gNearZ", i32 3, i32 416, i32 7, i32 9}
!231 = !{i32 6, !"gFarZ", i32 3, i32 420, i32 7, i32 9}
!232 = !{i32 6, !"gTotalTime", i32 3, i32 424, i32 7, i32 9}
!233 = !{i32 6, !"gDeltaTime", i32 3, i32 428, i32 7, i32 9}
!234 = !{i32 6, !"gAmbientLight", i32 3, i32 432, i32 7, i32 9}
!235 = !{i32 6, !"gLights", i32 3, i32 448}
!236 = !{i32 6, !"gFogColor", i32 3, i32 1216, i32 7, i32 9}
!237 = !{i32 6, !"gFogStart", i32 3, i32 1232, i32 7, i32 9}
!238 = !{i32 6, !"gFogRange", i32 3, i32 1236, i32 7, i32 9}
!239 = !{i32 6, !"cbPerObjectPad2", i32 3, i32 1240, i32 7, i32 9}
!240 = !{i32 1, void ()* @DS, !241}
!241 = !{!242}
!242 = !{i32 0, !2, !2}
!243 = !{[37 x i32] [i32 10, i32 14, i32 1919, i32 0, i32 1919, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 24, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0]}
!244 = !{void ()* @DS, !"DS", !245, !194, !265}
!245 = !{!246, !252, !260}
!246 = !{!247, !250, !251}
!247 = !{i32 0, !"POSITION", i8 9, i8 0, !248, i8 2, i32 1, i8 3, i32 0, i8 0, !249}
!248 = !{i32 0}
!249 = !{i32 3, i32 5}
!250 = !{i32 1, !"NORMAL", i8 9, i8 0, !248, i8 2, i32 1, i8 3, i32 1, i8 0, null}
!251 = !{i32 2, !"TEXCOORD", i8 9, i8 0, !248, i8 2, i32 1, i8 2, i32 2, i8 0, null}
!252 = !{!253, !255, !257, !258}
!253 = !{i32 0, !"SV_Position", i8 9, i8 3, !248, i8 4, i32 1, i8 4, i32 0, i8 0, !254}
!254 = !{i32 3, i32 15}
!255 = !{i32 1, !"POSITION", i8 9, i8 0, !248, i8 2, i32 1, i8 3, i32 1, i8 0, !256}
!256 = !{i32 3, i32 7}
!257 = !{i32 2, !"NORMAL", i8 9, i8 0, !248, i8 2, i32 1, i8 3, i32 2, i8 0, !256}
!258 = !{i32 3, !"TEXCOORD", i8 9, i8 0, !248, i8 2, i32 1, i8 2, i32 3, i8 0, !259}
!259 = !{i32 3, i32 3}
!260 = !{!261, !263}
!261 = !{i32 0, !"SV_TessFactor", i8 9, i8 25, !262, i8 0, i32 4, i8 1, i32 0, i8 3, null}
!262 = !{i32 0, i32 1, i32 2, i32 3}
!263 = !{i32 1, !"SV_InsideTessFactor", i8 9, i8 26, !264, i8 0, i32 2, i8 1, i32 4, i8 3, null}
!264 = !{i32 0, i32 1}
!265 = !{i32 0, i64 1, i32 2, !266}
!266 = !{i32 3, i32 4}
!267 = !DILocation(line: 172, column: 44, scope: !76)
!268 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "uv", arg: 2, scope: !76, file: !1, line: 171, type: !31)
!269 = !DIExpression(DW_OP_bit_piece, 0, 32)
!270 = !DILocation(line: 171, column: 20, scope: !76)
!271 = !DIExpression(DW_OP_bit_piece, 32, 32)
!272 = !DILocation(line: 177, column: 44, scope: !76)
!273 = !DILocation(line: 177, column: 30, scope: !76)
!274 = !DILocation(line: 177, column: 17, scope: !76)
!275 = !DILocation(line: 177, column: 12, scope: !76)
!276 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "v1", scope: !76, file: !1, line: 177, type: !38)
!277 = !DIExpression(DW_OP_bit_piece, 64, 32)
!278 = !DILocation(line: 178, column: 44, scope: !76)
!279 = !DILocation(line: 178, column: 30, scope: !76)
!280 = !DILocation(line: 178, column: 17, scope: !76)
!281 = !DILocation(line: 178, column: 12, scope: !76)
!282 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "v2", scope: !76, file: !1, line: 178, type: !38)
!283 = !DILocation(line: 179, column: 19, scope: !76)
!284 = !DILocation(line: 179, column: 12, scope: !76)
!285 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "posL", scope: !76, file: !1, line: 179, type: !38)
!286 = !DILocation(line: 181, column: 12, scope: !76)
!287 = !DILocation(line: 182, column: 12, scope: !76)
!288 = !DILocation(line: 183, column: 12, scope: !76)
!289 = !DILocation(line: 185, column: 31, scope: !76)
!290 = !DILocation(line: 185, column: 22, scope: !76)
!291 = !DILocation(line: 185, column: 15, scope: !76)
!292 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "p", arg: 1, scope: !90, file: !1, line: 162, type: !31)
!293 = !DILocation(line: 162, column: 21, scope: !90, inlinedAt: !294)
!294 = distinct !DILocation(line: 185, column: 15, scope: !76)
!295 = !DILocation(line: 164, column: 21, scope: !90, inlinedAt: !294)
!296 = !DILocation(line: 164, column: 17, scope: !90, inlinedAt: !294)
!297 = !DILocation(line: 164, column: 53, scope: !90, inlinedAt: !294)
!298 = !DILocation(line: 164, column: 12, scope: !90, inlinedAt: !294)
!299 = !DILocation(line: 164, column: 5, scope: !90, inlinedAt: !294)
!300 = !DILocation(line: 185, column: 42, scope: !76)
!301 = !DILocation(line: 185, column: 11, scope: !76)
!302 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "h", scope: !76, file: !1, line: 185, type: !8)
!303 = !DIExpression()
!304 = !DILocation(line: 191, column: 14, scope: !76)
!305 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "z", arg: 2, scope: !93, file: !1, line: 97, type: !8)
!306 = !DILocation(line: 97, column: 37, scope: !93, inlinedAt: !307)
!307 = distinct !DILocation(line: 191, column: 14, scope: !76)
!308 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "x", arg: 1, scope: !93, file: !1, line: 97, type: !8)
!309 = !DILocation(line: 97, column: 28, scope: !93, inlinedAt: !307)
!310 = !DILocation(line: 99, column: 34, scope: !93, inlinedAt: !307)
!311 = !DILocation(line: 99, column: 24, scope: !93, inlinedAt: !307)
!312 = !DILocation(line: 99, column: 22, scope: !93, inlinedAt: !307)
!313 = !DILocation(line: 99, column: 54, scope: !93, inlinedAt: !307)
!314 = !DILocation(line: 99, column: 45, scope: !93, inlinedAt: !307)
!315 = !DILocation(line: 99, column: 43, scope: !93, inlinedAt: !307)
!316 = !DILocation(line: 99, column: 39, scope: !93, inlinedAt: !307)
!317 = !DILocation(line: 99, column: 17, scope: !93, inlinedAt: !307)
!318 = !DILocation(line: 99, column: 5, scope: !93, inlinedAt: !307)
!319 = !DILocation(line: 191, column: 12, scope: !76)
!320 = !DILocation(line: 192, column: 17, scope: !76)
!321 = !DILocation(line: 192, column: 12, scope: !76)
!322 = !DILocation(line: 193, column: 15, scope: !76)
!323 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "z", arg: 2, scope: !96, file: !1, line: 102, type: !8)
!324 = !DILocation(line: 102, column: 38, scope: !96, inlinedAt: !325)
!325 = distinct !DILocation(line: 193, column: 15, scope: !76)
!326 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "x", arg: 1, scope: !96, file: !1, line: 102, type: !8)
!327 = !DILocation(line: 102, column: 29, scope: !96, inlinedAt: !325)
!328 = !DILocation(line: 107, column: 33, scope: !96, inlinedAt: !325)
!329 = !DILocation(line: 107, column: 49, scope: !96, inlinedAt: !325)
!330 = !DILocation(line: 107, column: 39, scope: !96, inlinedAt: !325)
!331 = !DILocation(line: 107, column: 37, scope: !96, inlinedAt: !325)
!332 = !DILocation(line: 107, column: 65, scope: !96, inlinedAt: !325)
!333 = !DILocation(line: 107, column: 56, scope: !96, inlinedAt: !325)
!334 = !DILocation(line: 107, column: 54, scope: !96, inlinedAt: !325)
!335 = !DILocation(line: 107, column: 24, scope: !96, inlinedAt: !325)
!336 = !DILocation(line: 107, column: 11, scope: !96, inlinedAt: !325)
!337 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "df_dx", scope: !96, file: !1, line: 107, type: !8)
!338 = !DILocation(line: 108, column: 37, scope: !96, inlinedAt: !325)
!339 = !DILocation(line: 108, column: 27, scope: !96, inlinedAt: !325)
!340 = !DILocation(line: 108, column: 49, scope: !96, inlinedAt: !325)
!341 = !DILocation(line: 108, column: 64, scope: !96, inlinedAt: !325)
!342 = !DILocation(line: 108, column: 55, scope: !96, inlinedAt: !325)
!343 = !DILocation(line: 108, column: 53, scope: !96, inlinedAt: !325)
!344 = !DILocation(line: 108, column: 42, scope: !96, inlinedAt: !325)
!345 = !DILocation(line: 108, column: 24, scope: !96, inlinedAt: !325)
!346 = !DILocation(line: 108, column: 11, scope: !96, inlinedAt: !325)
!347 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "df_dz", scope: !96, file: !1, line: 108, type: !8)
!348 = !DILocation(line: 110, column: 29, scope: !96, inlinedAt: !325)
!349 = !DILocation(line: 110, column: 43, scope: !96, inlinedAt: !325)
!350 = !DILocation(line: 110, column: 12, scope: !96, inlinedAt: !325)
!351 = !DILocation(line: 110, column: 5, scope: !96, inlinedAt: !325)
!352 = !DILocation(line: 193, column: 13, scope: !76)
!353 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "normalL", scope: !76, file: !1, line: 183, type: !38)
!354 = !DILocation(line: 197, column: 43, scope: !76)
!355 = !DILocation(line: 197, column: 19, scope: !76)
!356 = !DILocation(line: 197, column: 12, scope: !76)
!357 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "posW", scope: !76, file: !1, line: 197, type: !4)
!358 = !DIExpression(DW_OP_bit_piece, 96, 32)
!359 = !DILocation(line: 198, column: 15, scope: !76)
!360 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "dout", scope: !76, file: !1, line: 174, type: !79)
!361 = !DIExpression(DW_OP_bit_piece, 128, 32)
!362 = !DILocation(line: 174, column: 15, scope: !76)
!363 = !DIExpression(DW_OP_bit_piece, 160, 32)
!364 = !DIExpression(DW_OP_bit_piece, 192, 32)
!365 = !DILocation(line: 200, column: 27, scope: !76)
!366 = !DILocation(line: 200, column: 17, scope: !76)
!367 = !DILocation(line: 200, column: 15, scope: !76)
!368 = !DILocation(line: 202, column: 56, scope: !76)
!369 = !DILocation(line: 202, column: 32, scope: !76)
!370 = !DILocation(line: 202, column: 22, scope: !76)
!371 = !DILocation(line: 202, column: 12, scope: !76)
!372 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "normalW", scope: !76, file: !1, line: 202, type: !38)
!373 = !DILocation(line: 203, column: 18, scope: !76)
!374 = !DIExpression(DW_OP_bit_piece, 224, 32)
!375 = !DIExpression(DW_OP_bit_piece, 256, 32)
!376 = !DIExpression(DW_OP_bit_piece, 288, 32)
!377 = !DILocation(line: 205, column: 45, scope: !76)
!378 = !DILocation(line: 205, column: 19, scope: !76)
!379 = !DILocation(line: 205, column: 12, scope: !76)
!380 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "texC", scope: !76, file: !1, line: 205, type: !4)
!381 = !DILocation(line: 206, column: 27, scope: !76)
!382 = !DILocation(line: 206, column: 17, scope: !76)
!383 = !DILocation(line: 206, column: 15, scope: !76)
!384 = !DIExpression(DW_OP_bit_piece, 320, 32)
!385 = !DIExpression(DW_OP_bit_piece, 352, 32)
!386 = !DILocation(line: 208, column: 12, scope: !76)
!387 = !DILocation(line: 208, column: 5, scope: !76)
