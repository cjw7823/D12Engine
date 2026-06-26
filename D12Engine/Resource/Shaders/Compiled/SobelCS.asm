;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; no parameters
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; no parameters
; shader debug name: 9641f9583447a86198c806d2bd43d767.pdb
; shader hash: 9641f9583447a86198c806d2bd43d767
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Compute Shader
; NumThreads=(16,16,1)
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 0
; SigOutputElements: 0
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 0
; SigOutputVectors[0]: 0
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: SobelCS
;
;
; Buffer Definitions:
;
;
; Resource Bindings:
;
; Name                                 Type  Format         Dim      ID      HLSL Bind  Count
; ------------------------------ ---------- ------- ----------- ------- -------------- ------
; gInput1                           texture     f32          2d      T0             t0     1
; gOutput                               UAV     f32          2d      U0             u0     1
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.ResRet.f32 = type { float, float, float, float, i32 }
%"class.Texture2D<vector<float, 4> >" = type { <4 x float>, %"class.Texture2D<vector<float, 4> >::mips_type" }
%"class.Texture2D<vector<float, 4> >::mips_type" = type { i32 }
%"class.RWTexture2D<vector<float, 4> >" = type { <4 x float> }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @SobelCS() {
  %gOutput_UAV_2d = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 1, i32 0, i32 0, i1 false), !dbg !74 ; line:26 col:23  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %gInput1_texture_2d = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 0, i32 0, i32 0, i1 false), !dbg !74 ; line:26 col:23  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call i32 @dx.op.threadId.i32(i32 93, i32 0)  ; ThreadId(component)
  %2 = call i32 @dx.op.threadId.i32(i32 93, i32 1)  ; ThreadId(component)
  %3 = alloca [9 x float]
  %4 = alloca [9 x float]
  %5 = alloca [9 x float]
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !81, metadata !82), !dbg !83 ; var:"dispatchThreadID" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata i32 %2, i64 0, metadata !81, metadata !84), !dbg !83 ; var:"dispatchThreadID" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SobelCS"
  call void @llvm.dbg.declare(metadata [9 x float]* %3, metadata !85, metadata !82), !dbg !90, !dx.dbg.varlayout !91 ; var:"c" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SobelCS"
  call void @llvm.dbg.declare(metadata [9 x float]* %4, metadata !85, metadata !84), !dbg !90, !dx.dbg.varlayout !92 ; var:"c" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SobelCS"
  call void @llvm.dbg.declare(metadata [9 x float]* %5, metadata !85, metadata !93), !dbg !90, !dx.dbg.varlayout !94 ; var:"c" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SobelCS"
  %6 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !95 ; line:21 col:14
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !96, metadata !97), !dbg !95 ; var:"i" !DIExpression() func:"SobelCS"
  br label %.lr.ph96, !dbg !98 ; line:21 col:5

.lr.ph96:                                         ; preds = %0
  br label %7, !dbg !98 ; line:21 col:5

; <label>:7                                       ; preds = %33, %.lr.ph96
  %i.0 = phi i32 [ 0, %.lr.ph96 ], [ %34, %33 ]
  call void @llvm.dbg.value(metadata i32 %i.0, i64 0, metadata !96, metadata !97), !dbg !95 ; var:"i" !DIExpression() func:"SobelCS"
  %8 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !99 ; line:23 col:18
  call void @llvm.dbg.value(metadata i32 0, i64 0, metadata !100, metadata !97), !dbg !99 ; var:"j" !DIExpression() func:"SobelCS"
  br label %.lr.ph, !dbg !101 ; line:23 col:9

.lr.ph:                                           ; preds = %7
  br label %9, !dbg !101 ; line:23 col:9

; <label>:9                                       ; preds = %26, %.lr.ph
  %j.0 = phi i32 [ 0, %.lr.ph ], [ %27, %26 ]
  call void @llvm.dbg.value(metadata i32 %j.0, i64 0, metadata !100, metadata !97), !dbg !99 ; var:"j" !DIExpression() func:"SobelCS"
  %10 = add nsw i32 -1, %j.0, !dbg !102 ; line:25 col:53
  %11 = add nsw i32 -1, %i.0, !dbg !103 ; line:25 col:61
  %.i0 = add i32 %1, %10, !dbg !104 ; line:25 col:43
  %.i1 = add i32 %2, %11, !dbg !104 ; line:25 col:43
  %12 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !105 ; line:25 col:18
  call void @llvm.dbg.value(metadata i32 %.i0, i64 0, metadata !106, metadata !82), !dbg !105 ; var:"xy" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata i32 %.i1, i64 0, metadata !106, metadata !84), !dbg !105 ; var:"xy" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SobelCS"
  %TextureLoad = call %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32 66, %dx.types.Handle %gInput1_texture_2d, i32 0, i32 %.i0, i32 %.i1, i32 undef, i32 undef, i32 undef, i32 undef), !dbg !74 ; line:26 col:23  ; TextureLoad(srv,mipLevelOrSampleCount,coord0,coord1,coord2,offset0,offset1,offset2)
  %13 = extractvalue %dx.types.ResRet.f32 %TextureLoad, 0, !dbg !74 ; line:26 col:23
  %14 = extractvalue %dx.types.ResRet.f32 %TextureLoad, 1, !dbg !74 ; line:26 col:23
  %15 = extractvalue %dx.types.ResRet.f32 %TextureLoad, 2, !dbg !74 ; line:26 col:23
  %16 = mul i32 %i.0, 3, !dbg !107 ; line:26 col:13
  %17 = add i32 %j.0, %16, !dbg !107 ; line:26 col:13
  %18 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 %17, !dbg !107 ; line:26 col:13
  %19 = mul i32 %i.0, 3, !dbg !107 ; line:26 col:13
  %20 = add i32 %j.0, %19, !dbg !107 ; line:26 col:13
  %21 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 %20, !dbg !107 ; line:26 col:13
  %22 = mul i32 %i.0, 3, !dbg !107 ; line:26 col:13
  %23 = add i32 %j.0, %22, !dbg !107 ; line:26 col:13
  %24 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 %23, !dbg !107 ; line:26 col:13
  %25 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !108 ; line:26 col:21
  store float %13, float* %18, !dbg !108 ; line:26 col:21
  store float %14, float* %21, !dbg !108 ; line:26 col:21
  store float %15, float* %24, !dbg !108 ; line:26 col:21
  br label %26, !dbg !109 ; line:27 col:9

; <label>:26                                      ; preds = %9
  %27 = add nsw i32 %j.0, 1, !dbg !110 ; line:23 col:33
  %28 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !110 ; line:23 col:33
  call void @llvm.dbg.value(metadata i32 %27, i64 0, metadata !100, metadata !97), !dbg !99 ; var:"j" !DIExpression() func:"SobelCS"
  %29 = icmp slt i32 %27, 3, !dbg !111 ; line:23 col:27
  %30 = icmp ne i1 %29, false, !dbg !111 ; line:23 col:27
  %31 = icmp ne i1 %30, false, !dbg !101 ; line:23 col:9
  br i1 %31, label %9, label %._crit_edge, !dbg !101 ; line:23 col:9

._crit_edge:                                      ; preds = %26
  br label %32, !dbg !101 ; line:23 col:9

; <label>:32                                      ; preds = %._crit_edge
  br label %33, !dbg !112 ; line:28 col:5

; <label>:33                                      ; preds = %32
  %34 = add nsw i32 %i.0, 1, !dbg !113 ; line:21 col:29
  %35 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !113 ; line:21 col:29
  call void @llvm.dbg.value(metadata i32 %34, i64 0, metadata !96, metadata !97), !dbg !95 ; var:"i" !DIExpression() func:"SobelCS"
  %36 = icmp slt i32 %34, 3, !dbg !114 ; line:21 col:23
  %37 = icmp ne i1 %36, false, !dbg !114 ; line:21 col:23
  %38 = icmp ne i1 %37, false, !dbg !98 ; line:21 col:5
  br i1 %38, label %7, label %._crit_edge.97, !dbg !98 ; line:21 col:5

._crit_edge.97:                                   ; preds = %33
  br label %39, !dbg !98 ; line:21 col:5

; <label>:39                                      ; preds = %._crit_edge.97
  %40 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 0, !dbg !115 ; line:31 col:25
  %41 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 0, !dbg !115 ; line:31 col:25
  %42 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 0, !dbg !115 ; line:31 col:25
  %load = load float, float* %40, !dbg !115 ; line:31 col:25
  %load1 = load float, float* %41, !dbg !115 ; line:31 col:25
  %load3 = load float, float* %42, !dbg !115 ; line:31 col:25
  %.i0102 = fmul fast float -1.000000e+00, %load, !dbg !116 ; line:31 col:23
  %.i1104 = fmul fast float -1.000000e+00, %load1, !dbg !116 ; line:31 col:23
  %.i2105 = fmul fast float -1.000000e+00, %load3, !dbg !116 ; line:31 col:23
  %43 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 3, !dbg !117 ; line:31 col:42
  %44 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 3, !dbg !117 ; line:31 col:42
  %45 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 3, !dbg !117 ; line:31 col:42
  %load7 = load float, float* %43, !dbg !117 ; line:31 col:42
  %load9 = load float, float* %44, !dbg !117 ; line:31 col:42
  %load11 = load float, float* %45, !dbg !117 ; line:31 col:42
  %.i0108 = fmul fast float 2.000000e+00, %load7, !dbg !118 ; line:31 col:40
  %.i1110 = fmul fast float 2.000000e+00, %load9, !dbg !118 ; line:31 col:40
  %.i2112 = fmul fast float 2.000000e+00, %load11, !dbg !118 ; line:31 col:40
  %.i0115 = fsub fast float %.i0102, %.i0108, !dbg !119 ; line:31 col:33
  %.i1116 = fsub fast float %.i1104, %.i1110, !dbg !119 ; line:31 col:33
  %.i2117 = fsub fast float %.i2105, %.i2112, !dbg !119 ; line:31 col:33
  %46 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 6, !dbg !120 ; line:31 col:59
  %47 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 6, !dbg !120 ; line:31 col:59
  %48 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 6, !dbg !120 ; line:31 col:59
  %load15 = load float, float* %46, !dbg !120 ; line:31 col:59
  %load17 = load float, float* %47, !dbg !120 ; line:31 col:59
  %load19 = load float, float* %48, !dbg !120 ; line:31 col:59
  %.i0120 = fmul fast float 1.000000e+00, %load15, !dbg !121 ; line:31 col:57
  %.i1122 = fmul fast float 1.000000e+00, %load17, !dbg !121 ; line:31 col:57
  %.i2124 = fmul fast float 1.000000e+00, %load19, !dbg !121 ; line:31 col:57
  %.i0127 = fsub fast float %.i0115, %.i0120, !dbg !122 ; line:31 col:50
  %.i1128 = fsub fast float %.i1116, %.i1122, !dbg !122 ; line:31 col:50
  %.i2129 = fsub fast float %.i2117, %.i2124, !dbg !122 ; line:31 col:50
  %49 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 2, !dbg !123 ; line:31 col:76
  %50 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 2, !dbg !123 ; line:31 col:76
  %51 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 2, !dbg !123 ; line:31 col:76
  %load23 = load float, float* %49, !dbg !123 ; line:31 col:76
  %load25 = load float, float* %50, !dbg !123 ; line:31 col:76
  %load27 = load float, float* %51, !dbg !123 ; line:31 col:76
  %.i0132 = fmul fast float 1.000000e+00, %load23, !dbg !124 ; line:31 col:74
  %.i1134 = fmul fast float 1.000000e+00, %load25, !dbg !124 ; line:31 col:74
  %.i2136 = fmul fast float 1.000000e+00, %load27, !dbg !124 ; line:31 col:74
  %.i0139 = fadd fast float %.i0127, %.i0132, !dbg !125 ; line:31 col:67
  %.i1140 = fadd fast float %.i1128, %.i1134, !dbg !125 ; line:31 col:67
  %.i2141 = fadd fast float %.i2129, %.i2136, !dbg !125 ; line:31 col:67
  %52 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 5, !dbg !126 ; line:31 col:93
  %53 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 5, !dbg !126 ; line:31 col:93
  %54 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 5, !dbg !126 ; line:31 col:93
  %load31 = load float, float* %52, !dbg !126 ; line:31 col:93
  %load33 = load float, float* %53, !dbg !126 ; line:31 col:93
  %load35 = load float, float* %54, !dbg !126 ; line:31 col:93
  %.i0144 = fmul fast float 2.000000e+00, %load31, !dbg !127 ; line:31 col:91
  %.i1146 = fmul fast float 2.000000e+00, %load33, !dbg !127 ; line:31 col:91
  %.i2148 = fmul fast float 2.000000e+00, %load35, !dbg !127 ; line:31 col:91
  %.i0151 = fadd fast float %.i0139, %.i0144, !dbg !128 ; line:31 col:84
  %.i1152 = fadd fast float %.i1140, %.i1146, !dbg !128 ; line:31 col:84
  %.i2153 = fadd fast float %.i2141, %.i2148, !dbg !128 ; line:31 col:84
  %55 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 8, !dbg !129 ; line:31 col:110
  %56 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 8, !dbg !129 ; line:31 col:110
  %57 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 8, !dbg !129 ; line:31 col:110
  %load39 = load float, float* %55, !dbg !129 ; line:31 col:110
  %load41 = load float, float* %56, !dbg !129 ; line:31 col:110
  %load43 = load float, float* %57, !dbg !129 ; line:31 col:110
  %.i0156 = fmul fast float 1.000000e+00, %load39, !dbg !130 ; line:31 col:108
  %.i1158 = fmul fast float 1.000000e+00, %load41, !dbg !130 ; line:31 col:108
  %.i2160 = fmul fast float 1.000000e+00, %load43, !dbg !130 ; line:31 col:108
  %.i0163 = fadd fast float %.i0151, %.i0156, !dbg !131 ; line:31 col:101
  %.i1164 = fadd fast float %.i1152, %.i1158, !dbg !131 ; line:31 col:101
  %.i2165 = fadd fast float %.i2153, %.i2160, !dbg !131 ; line:31 col:101
  %58 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !132 ; line:31 col:12
  call void @llvm.dbg.value(metadata float %.i0163, i64 0, metadata !133, metadata !82), !dbg !132 ; var:"Gx" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata float %.i1164, i64 0, metadata !133, metadata !84), !dbg !132 ; var:"Gx" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata float %.i2165, i64 0, metadata !133, metadata !93), !dbg !132 ; var:"Gx" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SobelCS"
  %59 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 6, !dbg !134 ; line:34 col:25
  %60 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 6, !dbg !134 ; line:34 col:25
  %61 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 6, !dbg !134 ; line:34 col:25
  %load47 = load float, float* %59, !dbg !134 ; line:34 col:25
  %load49 = load float, float* %60, !dbg !134 ; line:34 col:25
  %load51 = load float, float* %61, !dbg !134 ; line:34 col:25
  %.i0168 = fmul fast float -1.000000e+00, %load47, !dbg !135 ; line:34 col:23
  %.i1170 = fmul fast float -1.000000e+00, %load49, !dbg !135 ; line:34 col:23
  %.i2172 = fmul fast float -1.000000e+00, %load51, !dbg !135 ; line:34 col:23
  %62 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 7, !dbg !136 ; line:34 col:42
  %63 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 7, !dbg !136 ; line:34 col:42
  %64 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 7, !dbg !136 ; line:34 col:42
  %load55 = load float, float* %62, !dbg !136 ; line:34 col:42
  %load57 = load float, float* %63, !dbg !136 ; line:34 col:42
  %load59 = load float, float* %64, !dbg !136 ; line:34 col:42
  %.i0176 = fmul fast float 2.000000e+00, %load55, !dbg !137 ; line:34 col:40
  %.i1178 = fmul fast float 2.000000e+00, %load57, !dbg !137 ; line:34 col:40
  %.i2180 = fmul fast float 2.000000e+00, %load59, !dbg !137 ; line:34 col:40
  %.i0183 = fsub fast float %.i0168, %.i0176, !dbg !138 ; line:34 col:33
  %.i1184 = fsub fast float %.i1170, %.i1178, !dbg !138 ; line:34 col:33
  %.i2185 = fsub fast float %.i2172, %.i2180, !dbg !138 ; line:34 col:33
  %65 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 8, !dbg !139 ; line:34 col:59
  %66 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 8, !dbg !139 ; line:34 col:59
  %67 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 8, !dbg !139 ; line:34 col:59
  %load63 = load float, float* %65, !dbg !139 ; line:34 col:59
  %load65 = load float, float* %66, !dbg !139 ; line:34 col:59
  %load67 = load float, float* %67, !dbg !139 ; line:34 col:59
  %.i0188 = fmul fast float 1.000000e+00, %load63, !dbg !140 ; line:34 col:57
  %.i1190 = fmul fast float 1.000000e+00, %load65, !dbg !140 ; line:34 col:57
  %.i2192 = fmul fast float 1.000000e+00, %load67, !dbg !140 ; line:34 col:57
  %.i0195 = fsub fast float %.i0183, %.i0188, !dbg !141 ; line:34 col:50
  %.i1196 = fsub fast float %.i1184, %.i1190, !dbg !141 ; line:34 col:50
  %.i2197 = fsub fast float %.i2185, %.i2192, !dbg !141 ; line:34 col:50
  %68 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 0, !dbg !142 ; line:34 col:76
  %69 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 0, !dbg !142 ; line:34 col:76
  %70 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 0, !dbg !142 ; line:34 col:76
  %load71 = load float, float* %68, !dbg !142 ; line:34 col:76
  %load73 = load float, float* %69, !dbg !142 ; line:34 col:76
  %load75 = load float, float* %70, !dbg !142 ; line:34 col:76
  %.i0200 = fmul fast float 1.000000e+00, %load71, !dbg !143 ; line:34 col:74
  %.i1202 = fmul fast float 1.000000e+00, %load73, !dbg !143 ; line:34 col:74
  %.i2204 = fmul fast float 1.000000e+00, %load75, !dbg !143 ; line:34 col:74
  %.i0207 = fadd fast float %.i0195, %.i0200, !dbg !144 ; line:34 col:67
  %.i1208 = fadd fast float %.i1196, %.i1202, !dbg !144 ; line:34 col:67
  %.i2209 = fadd fast float %.i2197, %.i2204, !dbg !144 ; line:34 col:67
  %71 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 1, !dbg !145 ; line:34 col:93
  %72 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 1, !dbg !145 ; line:34 col:93
  %73 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 1, !dbg !145 ; line:34 col:93
  %load79 = load float, float* %71, !dbg !145 ; line:34 col:93
  %load81 = load float, float* %72, !dbg !145 ; line:34 col:93
  %load83 = load float, float* %73, !dbg !145 ; line:34 col:93
  %.i0212 = fmul fast float 2.000000e+00, %load79, !dbg !146 ; line:34 col:91
  %.i1214 = fmul fast float 2.000000e+00, %load81, !dbg !146 ; line:34 col:91
  %.i2216 = fmul fast float 2.000000e+00, %load83, !dbg !146 ; line:34 col:91
  %.i0219 = fadd fast float %.i0207, %.i0212, !dbg !147 ; line:34 col:84
  %.i1220 = fadd fast float %.i1208, %.i1214, !dbg !147 ; line:34 col:84
  %.i2221 = fadd fast float %.i2209, %.i2216, !dbg !147 ; line:34 col:84
  %74 = getelementptr [9 x float], [9 x float]* %3, i32 0, i32 2, !dbg !148 ; line:34 col:110
  %75 = getelementptr [9 x float], [9 x float]* %4, i32 0, i32 2, !dbg !148 ; line:34 col:110
  %76 = getelementptr [9 x float], [9 x float]* %5, i32 0, i32 2, !dbg !148 ; line:34 col:110
  %load87 = load float, float* %74, !dbg !148 ; line:34 col:110
  %load89 = load float, float* %75, !dbg !148 ; line:34 col:110
  %load91 = load float, float* %76, !dbg !148 ; line:34 col:110
  %.i0224 = fmul fast float 1.000000e+00, %load87, !dbg !149 ; line:34 col:108
  %.i1226 = fmul fast float 1.000000e+00, %load89, !dbg !149 ; line:34 col:108
  %.i2228 = fmul fast float 1.000000e+00, %load91, !dbg !149 ; line:34 col:108
  %.i0231 = fadd fast float %.i0219, %.i0224, !dbg !150 ; line:34 col:101
  %.i1232 = fadd fast float %.i1220, %.i1226, !dbg !150 ; line:34 col:101
  %.i2233 = fadd fast float %.i2221, %.i2228, !dbg !150 ; line:34 col:101
  %77 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !151 ; line:34 col:12
  call void @llvm.dbg.value(metadata float %.i0231, i64 0, metadata !152, metadata !82), !dbg !151 ; var:"Gy" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata float %.i1232, i64 0, metadata !152, metadata !84), !dbg !151 ; var:"Gy" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata float %.i2233, i64 0, metadata !152, metadata !93), !dbg !151 ; var:"Gy" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SobelCS"
  %.i0235 = fmul fast float %.i0163, %.i0163, !dbg !153 ; line:37 col:26
  %.i1236 = fmul fast float %.i1164, %.i1164, !dbg !153 ; line:37 col:26
  %.i2237 = fmul fast float %.i2165, %.i2165, !dbg !153 ; line:37 col:26
  %.i0239 = fadd fast float %.i0235, %.i0231, !dbg !154 ; line:37 col:31
  %.i1240 = fadd fast float %.i1236, %.i1232, !dbg !154 ; line:37 col:31
  %.i2241 = fadd fast float %.i2237, %.i2233, !dbg !154 ; line:37 col:31
  %.i0243 = fadd fast float %.i0239, %.i0231, !dbg !155 ; line:37 col:36
  %.i1244 = fadd fast float %.i1240, %.i1232, !dbg !155 ; line:37 col:36
  %.i2245 = fadd fast float %.i2241, %.i2233, !dbg !155 ; line:37 col:36
  %Sqrt = call float @dx.op.unary.f32(i32 24, float %.i0243), !dbg !156 ; line:37 col:18  ; Sqrt(value)
  %Sqrt98 = call float @dx.op.unary.f32(i32 24, float %.i1244), !dbg !156 ; line:37 col:18  ; Sqrt(value)
  %Sqrt99 = call float @dx.op.unary.f32(i32 24, float %.i2245), !dbg !156 ; line:37 col:18  ; Sqrt(value)
  %78 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !157 ; line:37 col:12
  call void @llvm.dbg.value(metadata float %Sqrt, i64 0, metadata !158, metadata !82), !dbg !157 ; var:"mag" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata float %Sqrt98, i64 0, metadata !158, metadata !84), !dbg !157 ; var:"mag" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata float %Sqrt99, i64 0, metadata !158, metadata !93), !dbg !157 ; var:"mag" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SobelCS"
  %79 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !159 ; line:40 col:27
  call void @llvm.dbg.value(metadata float %Sqrt, i64 0, metadata !160, metadata !82), !dbg !161 ; var:"color" !DIExpression(DW_OP_bit_piece, 0, 32) func:"Calcuminance"
  call void @llvm.dbg.value(metadata float %Sqrt98, i64 0, metadata !160, metadata !84), !dbg !161 ; var:"color" !DIExpression(DW_OP_bit_piece, 32, 32) func:"Calcuminance"
  call void @llvm.dbg.value(metadata float %Sqrt99, i64 0, metadata !160, metadata !93), !dbg !161 ; var:"color" !DIExpression(DW_OP_bit_piece, 64, 32) func:"Calcuminance"
  %80 = call float @dx.op.dot3.f32(i32 55, float %Sqrt, float %Sqrt98, float %Sqrt99, float 0x3FD322D0E0000000, float 0x3FE2C8B440000000, float 0x3FBD2F1AA0000000), !dbg !163 ; line:13 col:12  ; Dot3(ax,ay,az,bx,by,bz)
  %81 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !164 ; line:13 col:5
  %Saturate = call float @dx.op.unary.f32(i32 7, float %80), !dbg !165 ; line:40 col:18  ; Saturate(value)
  %82 = fsub fast float 1.000000e+00, %Saturate, !dbg !166 ; line:40 col:16
  %83 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !167 ; line:40 col:9
  call void @llvm.dbg.value(metadata float %82, i64 0, metadata !158, metadata !82), !dbg !157 ; var:"mag" !DIExpression(DW_OP_bit_piece, 0, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata float %82, i64 0, metadata !158, metadata !84), !dbg !157 ; var:"mag" !DIExpression(DW_OP_bit_piece, 32, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata float %82, i64 0, metadata !158, metadata !93), !dbg !157 ; var:"mag" !DIExpression(DW_OP_bit_piece, 64, 32) func:"SobelCS"
  call void @llvm.dbg.value(metadata float %82, i64 0, metadata !158, metadata !168), !dbg !157 ; var:"mag" !DIExpression(DW_OP_bit_piece, 96, 32) func:"SobelCS"
  call void @dx.op.textureStore.f32(i32 67, %dx.types.Handle %gOutput_UAV_2d, i32 %1, i32 %2, i32 undef, float %82, float %82, float %82, float %82, i8 15), !dbg !169 ; line:42 col:34  ; TextureStore(srv,coord0,coord1,coord2,value0,value1,value2,value3,mask)
  %84 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !170 ; line:43 col:1
  ret void, !dbg !170 ; line:43 col:1
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare i32 @dx.op.threadId.i32(i32, i32) #0

; Function Attrs: nounwind
declare void @dx.op.textureStore.f32(i32, %dx.types.Handle, i32, i32, i32, float, float, float, float, i8) #1

; Function Attrs: nounwind readonly
declare %dx.types.ResRet.f32 @dx.op.textureLoad.f32(i32, %dx.types.Handle, i32, i32, i32, i32, i32, i32, i32) #2

; Function Attrs: nounwind readnone
declare float @dx.op.unary.f32(i32, float) #0

; Function Attrs: nounwind readnone
declare float @dx.op.dot3.f32(i32, float, float, float, float, float, float) #0

; Function Attrs: nounwind readonly
declare %dx.types.Handle @dx.op.createHandle(i32, i8, i32, i32, i1) #2

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }
attributes #2 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!53, !54}
!llvm.ident = !{!55}
!dx.source.contents = !{!56}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!57}
!dx.source.args = !{!58}
!dx.version = !{!59}
!dx.valver = !{!60}
!dx.shaderModel = !{!61}
!dx.resources = !{!62}
!dx.typeAnnotations = !{!68}
!dx.entryPoints = !{!71}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !23, globals: !37)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CSobel.hlsl", directory: "")
!2 = !{}
!3 = !{!4, !13}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "int2", file: !1, line: 25, baseType: !5)
!5 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<int, 2>", file: !1, line: 25, size: 64, align: 32, elements: !6, templateParams: !10)
!6 = !{!7, !9}
!7 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !5, file: !1, line: 25, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!8 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!9 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !5, file: !1, line: 25, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!10 = !{!11, !12}
!11 = !DITemplateTypeParameter(name: "element", type: !8)
!12 = !DITemplateValueParameter(name: "element_count", type: !8, value: i32 2)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 7, baseType: !14)
!14 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 7, size: 96, align: 32, elements: !15, templateParams: !20)
!15 = !{!16, !18, !19}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !14, file: !1, line: 7, baseType: !17, size: 32, align: 32, flags: DIFlagPublic)
!17 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !14, file: !1, line: 7, baseType: !17, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !14, file: !1, line: 7, baseType: !17, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!20 = !{!21, !22}
!21 = !DITemplateTypeParameter(name: "element", type: !17)
!22 = !DITemplateValueParameter(name: "element_count", type: !8, value: i32 3)
!23 = !{!24, !34}
!24 = !DISubprogram(name: "SobelCS", scope: !1, file: !1, line: 17, type: !25, isLocal: false, isDefinition: true, scopeLine: 18, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @SobelCS)
!25 = !DISubroutineType(types: !26)
!26 = !{null, !27}
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "int3", file: !1, baseType: !28)
!28 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<int, 3>", file: !1, size: 96, align: 32, elements: !29, templateParams: !33)
!29 = !{!30, !31, !32}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !28, file: !1, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !28, file: !1, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !28, file: !1, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!33 = !{!11, !22}
!34 = !DISubprogram(name: "Calcuminance", linkageName: "\01?Calcuminance@@YAMV?$vector@M$02@@@Z", scope: !1, file: !1, line: 11, type: !35, isLocal: false, isDefinition: true, scopeLine: 12, flags: DIFlagPrototyped, isOptimized: false)
!35 = !DISubroutineType(types: !36)
!36 = !{!17, !13}
!37 = !{!38, !50, !51}
!38 = !DIGlobalVariable(name: "gInput1", linkageName: "\01?gInput1@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 5, type: !39, isLocal: false, isDefinition: true)
!39 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 5, size: 160, align: 32, elements: !2, templateParams: !40)
!40 = !{!41}
!41 = !DITemplateTypeParameter(name: "element", type: !42)
!42 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 20, size: 128, align: 32, elements: !43, templateParams: !48)
!43 = !{!44, !45, !46, !47}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !42, file: !1, line: 20, baseType: !17, size: 32, align: 32, flags: DIFlagPublic)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !42, file: !1, line: 20, baseType: !17, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !42, file: !1, line: 20, baseType: !17, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !42, file: !1, line: 20, baseType: !17, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!48 = !{!21, !49}
!49 = !DITemplateValueParameter(name: "element_count", type: !8, value: i32 4)
!50 = !DIGlobalVariable(name: "gInput2", linkageName: "\01?gInput2@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 6, type: !39, isLocal: false, isDefinition: true)
!51 = !DIGlobalVariable(name: "gOutput", linkageName: "\01?gOutput@@3V?$RWTexture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 7, type: !52, isLocal: false, isDefinition: true)
!52 = !DICompositeType(tag: DW_TAG_class_type, name: "RWTexture2D<vector<float, 4> >", file: !1, line: 7, size: 128, align: 32, elements: !2, templateParams: !40)
!53 = !{i32 2, !"Dwarf Version", i32 4}
!54 = !{i32 2, !"Debug Info Version", i32 3}
!55 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!56 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CSobel.hlsl", !"/*\0D\0A    \EC\86\8C\EB\B2\A8 \EC\97\B0\EC\82\B0\EC\9E\90\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\98\EC\97\AC \EC\97\90\EC\A7\80 \EA\B2\80\EC\B6\9C\0D\0A*/\0D\0A\0D\0ATexture2D gInput1 : register(t0);\0D\0ATexture2D gInput2 : register(t1);\0D\0ARWTexture2D<float4> gOutput : register(u0);\0D\0A\0D\0A//RGB\EA\B0\92\EC\9C\BC\EB\A1\9C\EB\B6\80\ED\84\B0 \ED\9C\98\EB\8F\84, \EC\A6\89 \EB\B0\9D\EA\B8\B0\EB\A5\BC \EA\B7\BC\EC\82\AC\ED\95\9C\EB\8B\A4.\0D\0A//\EC\9D\B4 \EA\B0\80\EC\A4\91\EC\B9\98\EB\8A\94 \EC\84\9C\EB\A1\9C \EB\8B\A4\EB\A5\B8 \EB\B9\9B\EC\9D\98 \ED\8C\8C\EC\9E\A5\EC\97\90 \EB\8C\80\ED\95\9C \EC\9D\B8\EA\B0\84 \EB\88\88\EC\9D\98 \EB\AF\BC\EA\B0\90\EB\8F\84\EB\A5\BC \EB\B0\94\ED\83\95\EC\9C\BC\EB\A1\9C \EC\8B\A4\ED\97\98\EC\A0\81\EC\9C\BC\EB\A1\9C \EB\8F\84\EC\B6\9C\EB\90\9C \EA\B0\92\EC\9D\B4\EB\8B\A4.\0D\0Afloat Calcuminance(float3 color)\0D\0A{\0D\0A    return dot(color, float3(0.299f, 0.587f, 0.114f));\0D\0A}\0D\0A\0D\0A[numthreads(16, 16, 1)]\0D\0Avoid SobelCS(int3 dispatchThreadID : SV_DispatchThreadID)\0D\0A{\0D\0A    //\ED\98\84\EC\9E\AC \ED\94\BD\EC\85\80 \EC\A3\BC\EB\B3\80\EC\9D\98 \EC\9D\B4\EC\9B\83 \ED\94\BD\EC\85\80\EB\93\A4\EC\9D\84 \EC\83\98\ED\94\8C\EB\A7\81\0D\0A    float4 c[3][3];\0D\0A    for (int i = 0; i < 3; i++)\0D\0A    {\0D\0A        for (int j = 0; j < 3; j++)\0D\0A        {\0D\0A            int2 xy = dispatchThreadID.xy + int2(-1 + j, -1 + i);\0D\0A            c[i][j] = gInput1[xy];\0D\0A        }\0D\0A    }\0D\0A    \0D\0A    //\EA\B0\81 \EC\83\89\EC\83\81 \EC\B1\84\EB\84\90\EC\97\90 \EB\8C\80\ED\95\B4 Sobel \EB\B0\A9\EC\8B\9D\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\98\EC\97\AC x\EB\B0\A9\ED\96\A5 \ED\8E\B8\EB\AF\B8\EB\B6\84\EC\9D\84 \EC\B6\94\EC\A0\95\ED\95\9C\EB\8B\A4.\0D\0A    float4 Gx = -1.0f * c[0][0] - 2.0f * c[1][0] - 1.0f * c[2][0] + 1.0f * c[0][2] + 2.0f * c[1][2] + 1.0f * c[2][2];\0D\0A    \0D\0A    //\EA\B0\81 \EC\83\89\EC\83\81 \EC\B1\84\EB\84\90\EC\97\90 \EB\8C\80\ED\95\B4 Sobel \EB\B0\A9\EC\8B\9D\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\98\EC\97\AC y\EB\B0\A9\ED\96\A5 \ED\8E\B8\EB\AF\B8\EB\B6\84\EC\9D\84 \EC\B6\94\EC\A0\95\ED\95\9C\EB\8B\A4.\0D\0A    float4 Gy = -1.0f * c[2][0] - 2.0f * c[2][1] - 1.0f * c[2][2] + 1.0f * c[0][0] + 2.0f * c[0][1] + 1.0f * c[0][2];\0D\0A    \0D\0A    //\EA\B7\B8\EB\9E\98\EB\94\94\EC\96\B8\ED\8A\B8\EB\8A\94 (Gx, Gy)\EB\8B\A4. \EA\B0\81 \EC\83\89\EC\83\81 \EC\B1\84\EB\84\90\EC\97\90 \EB\8C\80\ED\95\B4 \EA\B7\B8\EB\9E\98\EB\94\94\EC\96\B8\ED\8A\B8\EC\9D\98 \ED\81\AC\EA\B8\B0\EB\A5\BC \EA\B3\84\EC\82\B0\ED\95\98\EC\97\AC \EB\B3\80\ED\99\94\EC\9C\A8\EC\9D\98 \EC\B5\9C\EB\8C\80\EA\B0\92\EC\9D\84 \EA\B5\AC\ED\95\9C\EB\8B\A4.\0D\0A    float4 mag = sqrt(Gx * Gx + Gy + Gy);\0D\0A    \0D\0A    //\EC\97\A3\EC\A7\80\EB\8A\94 \EA\B2\80\EC\9D\80\EC\83\89, \EB\8B\A4\EB\A5\B8 \EB\B6\80\EB\B6\84\EC\9D\80 \ED\9D\B0\EC\83\89\0D\0A    mag = 1.0f - saturate(Calcuminance(mag.rgb));\0D\0A    \0D\0A    gOutput[dispatchThreadID.xy] = mag;\0D\0A}\0D\0A\0D\0A[numthreads(16, 16, 1)]\0D\0Avoid CompositeCS(uint3 tid : SV_DispatchThreadID)\0D\0A{\0D\0A    float4 a = gInput1[tid.xy];\0D\0A    float4 b = gInput2[tid.xy];\0D\0A\0D\0A    gOutput[tid.xy] = a * b;\0D\0A}"}
!57 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CSobel.hlsl"}
!58 = !{!"-E", !"SobelCS", !"-T", !"cs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CSobelCS.cso"}
!59 = !{i32 1, i32 0}
!60 = !{i32 1, i32 8}
!61 = !{!"cs", i32 6, i32 0}
!62 = !{!63, !66, null, null}
!63 = !{!64}
!64 = !{i32 0, %"class.Texture2D<vector<float, 4> >"* undef, !"gInput1", i32 0, i32 0, i32 1, i32 2, i32 0, !65}
!65 = !{i32 0, i32 9}
!66 = !{!67}
!67 = !{i32 0, %"class.RWTexture2D<vector<float, 4> >"* undef, !"gOutput", i32 0, i32 0, i32 1, i32 2, i1 false, i1 false, i1 false, !65}
!68 = !{i32 1, void ()* @SobelCS, !69}
!69 = !{!70}
!70 = !{i32 0, !2, !2}
!71 = !{void ()* @SobelCS, !"SobelCS", null, !62, !72}
!72 = !{i32 0, i64 1, i32 4, !73}
!73 = !{i32 16, i32 16, i32 1}
!74 = !DILocation(line: 26, column: 23, scope: !75)
!75 = distinct !DILexicalBlock(scope: !76, file: !1, line: 24, column: 9)
!76 = distinct !DILexicalBlock(scope: !77, file: !1, line: 23, column: 9)
!77 = distinct !DILexicalBlock(scope: !78, file: !1, line: 23, column: 9)
!78 = distinct !DILexicalBlock(scope: !79, file: !1, line: 22, column: 5)
!79 = distinct !DILexicalBlock(scope: !80, file: !1, line: 21, column: 5)
!80 = distinct !DILexicalBlock(scope: !24, file: !1, line: 21, column: 5)
!81 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "dispatchThreadID", arg: 1, scope: !24, file: !1, line: 17, type: !27)
!82 = !DIExpression(DW_OP_bit_piece, 0, 32)
!83 = !DILocation(line: 17, column: 19, scope: !24)
!84 = !DIExpression(DW_OP_bit_piece, 32, 32)
!85 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "c", scope: !24, file: !1, line: 20, type: !86)
!86 = !DICompositeType(tag: DW_TAG_array_type, baseType: !87, size: 1152, align: 32, elements: !88)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 20, baseType: !42)
!88 = !{!89, !89}
!89 = !DISubrange(count: 3)
!90 = !DILocation(line: 20, column: 12, scope: !24)
!91 = !{i32 0, i32 128, i32 9}
!92 = !{i32 32, i32 128, i32 9}
!93 = !DIExpression(DW_OP_bit_piece, 64, 32)
!94 = !{i32 64, i32 128, i32 9}
!95 = !DILocation(line: 21, column: 14, scope: !80)
!96 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "i", scope: !80, file: !1, line: 21, type: !8)
!97 = !DIExpression()
!98 = !DILocation(line: 21, column: 5, scope: !80)
!99 = !DILocation(line: 23, column: 18, scope: !77)
!100 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "j", scope: !77, file: !1, line: 23, type: !8)
!101 = !DILocation(line: 23, column: 9, scope: !77)
!102 = !DILocation(line: 25, column: 53, scope: !75)
!103 = !DILocation(line: 25, column: 61, scope: !75)
!104 = !DILocation(line: 25, column: 43, scope: !75)
!105 = !DILocation(line: 25, column: 18, scope: !75)
!106 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "xy", scope: !75, file: !1, line: 25, type: !4)
!107 = !DILocation(line: 26, column: 13, scope: !75)
!108 = !DILocation(line: 26, column: 21, scope: !75)
!109 = !DILocation(line: 27, column: 9, scope: !75)
!110 = !DILocation(line: 23, column: 33, scope: !76)
!111 = !DILocation(line: 23, column: 27, scope: !76)
!112 = !DILocation(line: 28, column: 5, scope: !78)
!113 = !DILocation(line: 21, column: 29, scope: !79)
!114 = !DILocation(line: 21, column: 23, scope: !79)
!115 = !DILocation(line: 31, column: 25, scope: !24)
!116 = !DILocation(line: 31, column: 23, scope: !24)
!117 = !DILocation(line: 31, column: 42, scope: !24)
!118 = !DILocation(line: 31, column: 40, scope: !24)
!119 = !DILocation(line: 31, column: 33, scope: !24)
!120 = !DILocation(line: 31, column: 59, scope: !24)
!121 = !DILocation(line: 31, column: 57, scope: !24)
!122 = !DILocation(line: 31, column: 50, scope: !24)
!123 = !DILocation(line: 31, column: 76, scope: !24)
!124 = !DILocation(line: 31, column: 74, scope: !24)
!125 = !DILocation(line: 31, column: 67, scope: !24)
!126 = !DILocation(line: 31, column: 93, scope: !24)
!127 = !DILocation(line: 31, column: 91, scope: !24)
!128 = !DILocation(line: 31, column: 84, scope: !24)
!129 = !DILocation(line: 31, column: 110, scope: !24)
!130 = !DILocation(line: 31, column: 108, scope: !24)
!131 = !DILocation(line: 31, column: 101, scope: !24)
!132 = !DILocation(line: 31, column: 12, scope: !24)
!133 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "Gx", scope: !24, file: !1, line: 31, type: !87)
!134 = !DILocation(line: 34, column: 25, scope: !24)
!135 = !DILocation(line: 34, column: 23, scope: !24)
!136 = !DILocation(line: 34, column: 42, scope: !24)
!137 = !DILocation(line: 34, column: 40, scope: !24)
!138 = !DILocation(line: 34, column: 33, scope: !24)
!139 = !DILocation(line: 34, column: 59, scope: !24)
!140 = !DILocation(line: 34, column: 57, scope: !24)
!141 = !DILocation(line: 34, column: 50, scope: !24)
!142 = !DILocation(line: 34, column: 76, scope: !24)
!143 = !DILocation(line: 34, column: 74, scope: !24)
!144 = !DILocation(line: 34, column: 67, scope: !24)
!145 = !DILocation(line: 34, column: 93, scope: !24)
!146 = !DILocation(line: 34, column: 91, scope: !24)
!147 = !DILocation(line: 34, column: 84, scope: !24)
!148 = !DILocation(line: 34, column: 110, scope: !24)
!149 = !DILocation(line: 34, column: 108, scope: !24)
!150 = !DILocation(line: 34, column: 101, scope: !24)
!151 = !DILocation(line: 34, column: 12, scope: !24)
!152 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "Gy", scope: !24, file: !1, line: 34, type: !87)
!153 = !DILocation(line: 37, column: 26, scope: !24)
!154 = !DILocation(line: 37, column: 31, scope: !24)
!155 = !DILocation(line: 37, column: 36, scope: !24)
!156 = !DILocation(line: 37, column: 18, scope: !24)
!157 = !DILocation(line: 37, column: 12, scope: !24)
!158 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "mag", scope: !24, file: !1, line: 37, type: !87)
!159 = !DILocation(line: 40, column: 27, scope: !24)
!160 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "color", arg: 1, scope: !34, file: !1, line: 11, type: !13)
!161 = !DILocation(line: 11, column: 27, scope: !34, inlinedAt: !162)
!162 = distinct !DILocation(line: 40, column: 27, scope: !24)
!163 = !DILocation(line: 13, column: 12, scope: !34, inlinedAt: !162)
!164 = !DILocation(line: 13, column: 5, scope: !34, inlinedAt: !162)
!165 = !DILocation(line: 40, column: 18, scope: !24)
!166 = !DILocation(line: 40, column: 16, scope: !24)
!167 = !DILocation(line: 40, column: 9, scope: !24)
!168 = !DIExpression(DW_OP_bit_piece, 96, 32)
!169 = !DILocation(line: 42, column: 34, scope: !24)
!170 = !DILocation(line: 43, column: 1, scope: !24)
