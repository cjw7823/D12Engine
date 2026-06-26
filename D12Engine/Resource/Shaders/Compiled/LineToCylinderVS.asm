;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   xyz 
; NORMAL                   0   xyz         1     NONE   float   xyz 
; TEXCOORD                 0   xy          2     NONE   float   xy  
;
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   xyz 
; NORMAL                   0   xyz         1     NONE   float   xyz 
; TEXCOORD                 0   xy          2     NONE   float   xy  
;
; shader debug name: bda23ac68649fe3e4bb0bffc7d030f95.pdb
; shader hash: bda23ac68649fe3e4bb0bffc7d030f95
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Vertex Shader
; OutputPositionPresent=0
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 3
; SigOutputElements: 3
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 3
; SigOutputVectors[0]: 3
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
; TEXCOORD                 0                              
;
; Output signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
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
;   
;   } cbPerObject;                                    ; Offset:    0 Size:   128
;
; }
;
;
; Resource Bindings:
;
; Name                                 Type  Format         Dim      ID      HLSL Bind  Count
; ------------------------------ ---------- ------- ----------- ------- -------------- ------
; cbPerObject                       cbuffer      NA          NA     CB0            cb0     1
;
;
; ViewId state:
;
; Number of inputs: 10, outputs: 10
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;   output 0 depends on inputs: { 0, 1, 2 }
;   output 1 depends on inputs: { 0, 1, 2 }
;   output 2 depends on inputs: { 0, 1, 2 }
;   output 4 depends on inputs: { 4, 5, 6 }
;   output 5 depends on inputs: { 4, 5, 6 }
;   output 6 depends on inputs: { 4, 5, 6 }
;   output 8 depends on inputs: { 8 }
;   output 9 depends on inputs: { 9 }
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

%dx.types.Handle = type { i8* }
%dx.types.CBufRet.f32 = type { float, float, float, float }
%hostlayout.cbPerObject = type { [4 x <4 x float>], [4 x <4 x float>] }

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @VS() {
  %cbPerObject_cbuffer = call %dx.types.Handle @dx.op.createHandle(i32 57, i8 2, i32 0, i32 0, i1 false), !dbg !174 ; line:153 col:23  ; CreateHandle(resourceClass,rangeId,index,nonUniformIndex)
  %1 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 0, i32 undef), !dbg !174 ; line:153 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !175, metadata !176), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"VS"
  %2 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 1, i32 undef), !dbg !174 ; line:153 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !175, metadata !178), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"VS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 undef), !dbg !174 ; line:153 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !179, metadata !180), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 undef), !dbg !174 ; line:153 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !179, metadata !181), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 undef), !dbg !174 ; line:153 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !179, metadata !182), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"VS"
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 undef), !dbg !174 ; line:153 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !179, metadata !183), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 undef), !dbg !174 ; line:153 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !179, metadata !184), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 undef), !dbg !174 ; line:153 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !179, metadata !176), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !179, metadata !178), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !179, metadata !180), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !179, metadata !181), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !179, metadata !182), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !179, metadata !183), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !179, metadata !184), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !179, metadata !185), !dbg !174 ; var:"vin" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  %9 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 0), !dbg !186 ; line:157 col:47  ; CBufferLoadLegacy(handle,regIndex)
  %10 = extractvalue %dx.types.CBufRet.f32 %9, 0, !dbg !186 ; line:157 col:47
  %11 = extractvalue %dx.types.CBufRet.f32 %9, 1, !dbg !186 ; line:157 col:47
  %12 = extractvalue %dx.types.CBufRet.f32 %9, 2, !dbg !186 ; line:157 col:47
  %13 = extractvalue %dx.types.CBufRet.f32 %9, 3, !dbg !186 ; line:157 col:47
  %14 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 1), !dbg !186 ; line:157 col:47  ; CBufferLoadLegacy(handle,regIndex)
  %15 = extractvalue %dx.types.CBufRet.f32 %14, 0, !dbg !186 ; line:157 col:47
  %16 = extractvalue %dx.types.CBufRet.f32 %14, 1, !dbg !186 ; line:157 col:47
  %17 = extractvalue %dx.types.CBufRet.f32 %14, 2, !dbg !186 ; line:157 col:47
  %18 = extractvalue %dx.types.CBufRet.f32 %14, 3, !dbg !186 ; line:157 col:47
  %19 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 2), !dbg !186 ; line:157 col:47  ; CBufferLoadLegacy(handle,regIndex)
  %20 = extractvalue %dx.types.CBufRet.f32 %19, 0, !dbg !186 ; line:157 col:47
  %21 = extractvalue %dx.types.CBufRet.f32 %19, 1, !dbg !186 ; line:157 col:47
  %22 = extractvalue %dx.types.CBufRet.f32 %19, 2, !dbg !186 ; line:157 col:47
  %23 = extractvalue %dx.types.CBufRet.f32 %19, 3, !dbg !186 ; line:157 col:47
  %24 = fmul fast float %6, %10, !dbg !187 ; line:157 col:19
  %FMad18 = call float @dx.op.tertiary.f32(i32 46, float %7, float %11, float %24), !dbg !187 ; line:157 col:19  ; FMad(a,b,c)
  %FMad17 = call float @dx.op.tertiary.f32(i32 46, float %8, float %12, float %FMad18), !dbg !187 ; line:157 col:19  ; FMad(a,b,c)
  %FMad16 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %13, float %FMad17), !dbg !187 ; line:157 col:19  ; FMad(a,b,c)
  %25 = fmul fast float %6, %15, !dbg !187 ; line:157 col:19
  %FMad15 = call float @dx.op.tertiary.f32(i32 46, float %7, float %16, float %25), !dbg !187 ; line:157 col:19  ; FMad(a,b,c)
  %FMad14 = call float @dx.op.tertiary.f32(i32 46, float %8, float %17, float %FMad15), !dbg !187 ; line:157 col:19  ; FMad(a,b,c)
  %FMad13 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %18, float %FMad14), !dbg !187 ; line:157 col:19  ; FMad(a,b,c)
  %26 = fmul fast float %6, %20, !dbg !187 ; line:157 col:19
  %FMad12 = call float @dx.op.tertiary.f32(i32 46, float %7, float %21, float %26), !dbg !187 ; line:157 col:19  ; FMad(a,b,c)
  %FMad11 = call float @dx.op.tertiary.f32(i32 46, float %8, float %22, float %FMad12), !dbg !187 ; line:157 col:19  ; FMad(a,b,c)
  %FMad10 = call float @dx.op.tertiary.f32(i32 46, float 1.000000e+00, float %23, float %FMad11), !dbg !187 ; line:157 col:19  ; FMad(a,b,c)
  %27 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !188 ; line:157 col:12
  call void @llvm.dbg.value(metadata float %FMad16, i64 0, metadata !189, metadata !183), !dbg !188 ; var:"posW" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad13, i64 0, metadata !189, metadata !184), !dbg !188 ; var:"posW" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad10, i64 0, metadata !189, metadata !185), !dbg !188 ; var:"posW" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  %28 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !190 ; line:158 col:15
  call void @llvm.dbg.value(metadata float %FMad16, i64 0, metadata !175, metadata !183), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad13, i64 0, metadata !175, metadata !184), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad10, i64 0, metadata !175, metadata !185), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  %29 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 0), !dbg !191 ; line:159 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %30 = extractvalue %dx.types.CBufRet.f32 %29, 0, !dbg !191 ; line:159 col:48
  %31 = extractvalue %dx.types.CBufRet.f32 %29, 1, !dbg !191 ; line:159 col:48
  %32 = extractvalue %dx.types.CBufRet.f32 %29, 2, !dbg !191 ; line:159 col:48
  %33 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 1), !dbg !191 ; line:159 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %34 = extractvalue %dx.types.CBufRet.f32 %33, 0, !dbg !191 ; line:159 col:48
  %35 = extractvalue %dx.types.CBufRet.f32 %33, 1, !dbg !191 ; line:159 col:48
  %36 = extractvalue %dx.types.CBufRet.f32 %33, 2, !dbg !191 ; line:159 col:48
  %37 = call %dx.types.CBufRet.f32 @dx.op.cbufferLoadLegacy.f32(i32 59, %dx.types.Handle %cbPerObject_cbuffer, i32 2), !dbg !191 ; line:159 col:48  ; CBufferLoadLegacy(handle,regIndex)
  %38 = extractvalue %dx.types.CBufRet.f32 %37, 0, !dbg !191 ; line:159 col:48
  %39 = extractvalue %dx.types.CBufRet.f32 %37, 1, !dbg !191 ; line:159 col:48
  %40 = extractvalue %dx.types.CBufRet.f32 %37, 2, !dbg !191 ; line:159 col:48
  %41 = fmul fast float %3, %30, !dbg !192 ; line:159 col:20
  %FMad6 = call float @dx.op.tertiary.f32(i32 46, float %4, float %31, float %41), !dbg !192 ; line:159 col:20  ; FMad(a,b,c)
  %FMad5 = call float @dx.op.tertiary.f32(i32 46, float %5, float %32, float %FMad6), !dbg !192 ; line:159 col:20  ; FMad(a,b,c)
  %42 = fmul fast float %3, %34, !dbg !192 ; line:159 col:20
  %FMad4 = call float @dx.op.tertiary.f32(i32 46, float %4, float %35, float %42), !dbg !192 ; line:159 col:20  ; FMad(a,b,c)
  %FMad3 = call float @dx.op.tertiary.f32(i32 46, float %5, float %36, float %FMad4), !dbg !192 ; line:159 col:20  ; FMad(a,b,c)
  %43 = fmul fast float %3, %38, !dbg !192 ; line:159 col:20
  %FMad2 = call float @dx.op.tertiary.f32(i32 46, float %4, float %39, float %43), !dbg !192 ; line:159 col:20  ; FMad(a,b,c)
  %FMad = call float @dx.op.tertiary.f32(i32 46, float %5, float %40, float %FMad2), !dbg !192 ; line:159 col:20  ; FMad(a,b,c)
  %44 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !193 ; line:159 col:18
  call void @llvm.dbg.value(metadata float %FMad5, i64 0, metadata !175, metadata !180), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad3, i64 0, metadata !175, metadata !181), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %FMad, i64 0, metadata !175, metadata !182), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 160, 32) func:"VS"
  %45 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !194 ; line:160 col:15
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !175, metadata !176), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 192, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !175, metadata !178), !dbg !177 ; var:"vout" !DIExpression(DW_OP_bit_piece, 224, 32) func:"VS"
  %46 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !195 ; line:162 col:12
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %FMad16), !dbg !195 ; line:162 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %FMad13), !dbg !195 ; line:162 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %FMad10), !dbg !195 ; line:162 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %FMad5), !dbg !195 ; line:162 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %FMad3), !dbg !195 ; line:162 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %FMad), !dbg !195 ; line:162 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %1), !dbg !195 ; line:162 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float %2), !dbg !195 ; line:162 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  %47 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !196 ; line:162 col:5
  ret void, !dbg !196 ; line:162 col:5
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
!llvm.module.flags = !{!138, !139}
!llvm.ident = !{!140}
!dx.source.contents = !{!141, !142}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!143}
!dx.source.args = !{!144}
!dx.version = !{!145}
!dx.valver = !{!146}
!dx.shaderModel = !{!147}
!dx.resources = !{!148}
!dx.typeAnnotations = !{!151, !156}
!dx.viewIdState = !{!159}
!dx.entryPoints = !{!160}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !31, globals: !60)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTask_GS.hlsl", directory: "")
!2 = !{}
!3 = !{!4, !16}
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
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3x3", file: !1, line: 159, baseType: !17)
!17 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 3, 3>", file: !1, line: 159, size: 288, align: 32, elements: !18, templateParams: !28)
!18 = !{!19, !20, !21, !22, !23, !24, !25, !26, !27}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !17, file: !1, line: 159, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !17, file: !1, line: 159, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !17, file: !1, line: 159, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !17, file: !1, line: 159, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !17, file: !1, line: 159, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !17, file: !1, line: 159, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !17, file: !1, line: 159, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !17, file: !1, line: 159, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !17, file: !1, line: 159, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!28 = !{!13, !29, !30}
!29 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 3)
!30 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 3)
!31 = !{!32}
!32 = !DISubprogram(name: "VS", scope: !1, file: !1, line: 153, type: !33, isLocal: false, isDefinition: true, scopeLine: 154, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @VS)
!33 = !DISubroutineType(types: !34)
!34 = !{!35, !55}
!35 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexOut", file: !1, line: 71, size: 256, align: 32, elements: !36)
!36 = !{!37, !46, !47}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !35, file: !1, line: 73, baseType: !38, size: 96, align: 32)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 33, baseType: !39)
!39 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 33, size: 96, align: 32, elements: !40, templateParams: !44)
!40 = !{!41, !42, !43}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !39, file: !1, line: 33, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !39, file: !1, line: 33, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !39, file: !1, line: 33, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!44 = !{!13, !45}
!45 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 3)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "NormalW", scope: !35, file: !1, line: 74, baseType: !38, size: 96, align: 32, offset: 96)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !35, file: !1, line: 75, baseType: !48, size: 64, align: 32, offset: 192)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 48, baseType: !49)
!49 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 48, size: 64, align: 32, elements: !50, templateParams: !53)
!50 = !{!51, !52}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !49, file: !1, line: 48, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !49, file: !1, line: 48, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!53 = !{!13, !54}
!54 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 2)
!55 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexIn", file: !1, line: 64, size: 256, align: 32, elements: !56)
!56 = !{!57, !58, !59}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !55, file: !1, line: 66, baseType: !38, size: 96, align: 32)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "NormalL", scope: !55, file: !1, line: 67, baseType: !38, size: 96, align: 32, offset: 96)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !55, file: !1, line: 68, baseType: !48, size: 64, align: 32, offset: 192)
!60 = !{!61, !85, !86, !88, !90, !92, !93, !94, !95, !96, !97, !98, !99, !100, !101, !103, !104, !105, !106, !107, !108, !109, !123, !124, !125, !126, !127, !131, !133, !134, !135, !136, !137}
!61 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 26, type: !62, isLocal: false, isDefinition: true)
!62 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !63)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 26, baseType: !64)
!64 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 26, size: 512, align: 32, elements: !65, templateParams: !82)
!65 = !{!66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81}
!66 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !64, file: !1, line: 26, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!82 = !{!13, !83, !84}
!83 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 4)
!84 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 4)
!85 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 27, type: !62, isLocal: false, isDefinition: true)
!86 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 32, type: !87, isLocal: false, isDefinition: true)
!87 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!88 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 33, type: !89, isLocal: false, isDefinition: true)
!89 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !38)
!90 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 34, type: !91, isLocal: false, isDefinition: true)
!91 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!92 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 35, type: !62, isLocal: false, isDefinition: true)
!93 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 40, type: !62, isLocal: false, isDefinition: true)
!94 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 41, type: !62, isLocal: false, isDefinition: true)
!95 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !62, isLocal: false, isDefinition: true)
!96 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 43, type: !62, isLocal: false, isDefinition: true)
!97 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 44, type: !62, isLocal: false, isDefinition: true)
!98 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 45, type: !62, isLocal: false, isDefinition: true)
!99 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 46, type: !89, isLocal: false, isDefinition: true)
!100 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPass@@3MB", scope: !0, file: !1, line: 47, type: !91, isLocal: false, isDefinition: true)
!101 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 48, type: !102, isLocal: false, isDefinition: true)
!102 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !48)
!103 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 49, type: !102, isLocal: false, isDefinition: true)
!104 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 50, type: !91, isLocal: false, isDefinition: true)
!105 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 51, type: !91, isLocal: false, isDefinition: true)
!106 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 52, type: !91, isLocal: false, isDefinition: true)
!107 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 53, type: !91, isLocal: false, isDefinition: true)
!108 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 54, type: !87, isLocal: false, isDefinition: true)
!109 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 56, type: !110, isLocal: false, isDefinition: true)
!110 = !DICompositeType(tag: DW_TAG_array_type, baseType: !111, size: 6144, align: 32, elements: !121)
!111 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !112)
!112 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !113, line: 3, size: 384, align: 32, elements: !114)
!113 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!114 = !{!115, !116, !117, !118, !119, !120}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !112, file: !113, line: 5, baseType: !38, size: 96, align: 32)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !112, file: !113, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !112, file: !113, line: 7, baseType: !38, size: 96, align: 32, offset: 128)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !112, file: !113, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !112, file: !113, line: 9, baseType: !38, size: 96, align: 32, offset: 256)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !112, file: !113, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!121 = !{!122}
!122 = !DISubrange(count: 16)
!123 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 58, type: !87, isLocal: false, isDefinition: true)
!124 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 59, type: !91, isLocal: false, isDefinition: true)
!125 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 60, type: !91, isLocal: false, isDefinition: true)
!126 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 61, type: !102, isLocal: false, isDefinition: true)
!127 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 15, type: !128, isLocal: false, isDefinition: true)
!128 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 15, size: 160, align: 32, elements: !2, templateParams: !129)
!129 = !{!130}
!130 = !DITemplateTypeParameter(name: "element", type: !5)
!131 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 17, type: !132, isLocal: false, isDefinition: true)
!132 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 17, size: 32, align: 32, elements: !2)
!133 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 18, type: !132, isLocal: false, isDefinition: true)
!134 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 19, type: !132, isLocal: false, isDefinition: true)
!135 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 20, type: !132, isLocal: false, isDefinition: true)
!136 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !132, isLocal: false, isDefinition: true)
!137 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !132, isLocal: false, isDefinition: true)
!138 = !{i32 2, !"Dwarf Version", i32 4}
!139 = !{i32 2, !"Debug Info Version", i32 3}
!140 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!141 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTask_GS.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerObjectPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct SubVertex\0D\0A{\0D\0A    float3 PosW;\0D\0A    float3 NormalW;\0D\0A    float2 TexC;\0D\0A};\0D\0A\0D\0Astruct GeoOut\0D\0A{\0D\0A    float4 PosH : SV_POSITION;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A    uint PrimID : SV_PrimitiveID;\0D\0A    nointerpolation uint LODLevel : TEXCOORD1;\0D\0A};\0D\0A\0D\0ASubVertex MakeMidVertex(SubVertex a, SubVertex b, float3 centerW, float radius)\0D\0A{\0D\0A    SubVertex r;\0D\0A\0D\0A    float3 p = 0.5f * (a.PosW + b.PosW);\0D\0A    p = centerW + normalize(p - centerW) * radius;\0D\0A\0D\0A    r.PosW = p;\0D\0A    r.NormalW = normalize(r.PosW - centerW);\0D\0A    r.TexC = 0.5f * (a.TexC + b.TexC);\0D\0A\0D\0A    return r;\0D\0A}\0D\0A\0D\0Avoid EmitTriangle(SubVertex a, SubVertex b, SubVertex c, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    GeoOut gout;\0D\0A\0D\0A    gout.PosW = a.PosW;\0D\0A    gout.PosH = mul(float4(a.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = a.NormalW;\0D\0A    gout.TexC = a.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    gout.PosW = b.PosW;\0D\0A    gout.PosH = mul(float4(b.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = b.NormalW;\0D\0A    gout.TexC = b.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    gout.PosW = c.PosW;\0D\0A    gout.PosH = mul(float4(c.PosW, 1.0f), gViewProj);\0D\0A    gout.NormalW = c.NormalW;\0D\0A    gout.TexC = c.TexC;\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = lodLevel;\0D\0A    triStream.Append(gout);\0D\0A\0D\0A    triStream.RestartStrip();\0D\0A}\0D\0A\0D\0Avoid SubdivideOnce(SubVertex v0, SubVertex v1, SubVertex v2, float3 centerW, float radius, uint primID, uint lodLevel, inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);\0D\0A    SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);\0D\0A    SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);\0D\0A\0D\0A    EmitTriangle(v0, m0, m2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m0, m1, m2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m2, m1, v2, primID, lodLevel, triStream);\0D\0A    EmitTriangle(m0, v1, m1, primID, lodLevel, triStream);\0D\0A}\0D\0A\0D\0A//\B1\D7\B3\C9 \C6\D0\BD\BA\BD\BA\B7\E7 \BC\CE\C0\CC\B4\F5.\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout;\0D\0A    \0D\0A    float4 posW = mul(float4(vin.PosW, 1.0f), gWorld);\0D\0A    vout.PosW = posW.xyz;\0D\0A    vout.NormalW = mul(vin.NormalL, (float3x3) gWorld);\0D\0A    vout.TexC = vin.TexC;\0D\0A\0D\0A    return vout;\0D\0A}\0D\0A \0D\0A[maxvertexcount(4)]\0D\0Avoid GS(line VertexOut gin[2],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    float3 up = float3(0.0f, 1.0f, 0.0f);\0D\0A    float3 look = gEyePosW - gin[0].PosW;\0D\0A    look.y = 0.0f; //project to xz-plane\0D\0A    look = normalize(look);\0D\0A    float3 right = cross(up, look);\0D\0A\0D\0A    //float halfWidth = 0.5f * gin[0].SizeW.x;\0D\0A    //float halfHeight = 0.5f * gin[0].SizeW.y;\0D\0A\09\0D\0A    float4 v[4];\0D\0A    v[0] = float4(gin[0].PosW, 1.0f);\0D\0A    v[1] = float4(gin[1].PosW, 1.0f);\0D\0A    v[2] = float4(gin[0].PosW + up * 3.0f, 1.0f);\0D\0A    v[3] = float4(gin[1].PosW + up * 3.0f, 1.0f);\0D\0A    \0D\0A    float2 texC[4] =\0D\0A    {\0D\0A        float2(0.0f, 1.0f),\0D\0A\09\09float2(0.0f, 0.0f),\0D\0A\09\09float2(1.0f, 1.0f),\0D\0A\09\09float2(1.0f, 0.0f)\0D\0A    };\0D\0A\09\0D\0A    GeoOut gout;\0D\0A\09[unroll]//\C4\C4\C6\C4\C0\CF\C7\D2 \B6\A7 \B7\E7\C7\C1\B8\A6 \C7\AE\BE\EE\BC\AD \B0\A2 \B9\DD\BA\B9\B8\B6\B4\D9 \BA\B0\B5\B5\C0\C7 \B8\ED\B7\C9\BE\EE\B7\CE \B8\B8\B5\E9\BE\EE\C1\D8\B4\D9. \C0\CC\B7\B8\B0\D4 \C7\CF\B8\E9 GPU\B0\A1 \B8\ED\B7\C9\BE\EE\B8\A6 \B4\F5 \C8\BF\C0\B2\C0\FB\C0\B8\B7\CE \BD\C7\C7\E0\C7\D2 \BC\F6 \C0\D6\B4\D9.\0D\0A    for (int i = 0; i < 4; ++i)\0D\0A    {\0D\0A        gout.PosH = mul(v[i], gViewProj);\0D\0A        gout.PosW = v[i].xyz;\0D\0A        gout.NormalW = look;\0D\0A        gout.TexC = texC[i];\0D\0A        gout.PrimID = primID;\0D\0A        gout.LODLevel = 0;\0D\0A\09\09\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A}\0D\0A\0D\0A\0D\0A[maxvertexcount(48)]\0D\0Avoid GS_LOD(triangle VertexOut gin[3],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A    float3 center = (gin[0].PosW + gin[1].PosW + gin[2].PosW) / 3.0f;\0D\0A    float distToEye = distance(gEyePosW, center);\0D\0A    \0D\0A    float3 centerW = mul(float4(0, 0, 0, 1), gWorld).xyz; // \B1\B8 \C1\DF\BD\C9\C0\C7 \BF\F9\B5\E5\C1\C2\C7\A5\0D\0A    float radius = length(gin[0].PosW - centerW);\0D\0A    \0D\0A    SubVertex v0, v1, v2;\0D\0A    v0.PosW = gin[0].PosW;\0D\0A    v0.NormalW = gin[0].NormalW;\0D\0A    v0.TexC = gin[0].TexC;\0D\0A    v1.PosW = gin[1].PosW;\0D\0A    v1.NormalW = gin[1].NormalW;\0D\0A    v1.TexC = gin[1].TexC;\0D\0A    v2.PosW = gin[2].PosW;\0D\0A    v2.NormalW = gin[2].NormalW;\0D\0A    v2.TexC = gin[2].TexC;\0D\0A    \0D\0A    if(distToEye < 15)\0D\0A    {\0D\0A        //1\C2\F7 \BC\BC\BA\D0\C8\AD\BF\A1 \C7\CA\BF\E4\C7\D1 \C1\DF\C1\A1\B5\E9\0D\0A        SubVertex m0 = MakeMidVertex(v0, v1, centerW, radius);\0D\0A        SubVertex m1 = MakeMidVertex(v1, v2, centerW, radius);\0D\0A        SubVertex m2 = MakeMidVertex(v2, v0, centerW, radius);\0D\0A\0D\0A        //1\C2\F7 \BC\BC\BA\D0\C8\AD\B7\CE \B3\AA\BF\C2 4\B0\B3 \BB\EF\B0\A2\C7\FC\C0\BB \B0\A2\B0\A2 \B4\D9\BD\C3 \BC\BC\BA\D0\C8\AD (2\C2\F7 \BC\BC\BA\D0\C8\AD)\0D\0A        SubdivideOnce(v0, m0, m2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m0, m1, m2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m2, m1, v2, centerW, radius, primID, 2, triStream);\0D\0A        SubdivideOnce(m0, v1, m1, centerW, radius, primID, 2, triStream);\0D\0A    }\0D\0A    else if (distToEye >= 15 && distToEye < 25)\0D\0A    {\0D\0A        SubdivideOnce(v0, v1, v2, centerW, radius, primID, 1, triStream);\0D\0A    }\0D\0A    else //distToEye >= 25\0D\0A    {\0D\0A        int vertexNum = 3;\0D\0A        GeoOut gout;\0D\0A\09    [unroll]\0D\0A        for (int i = 0; i < vertexNum; ++i)\0D\0A        {\0D\0A            gout.PosH = mul(float4(gin[i].PosW, 1.0f), gViewProj);\0D\0A            gout.PosW = gin[i].PosW;\0D\0A            gout.NormalW = gin[i].NormalW;\0D\0A            gout.TexC = gin[i].TexC;\0D\0A            gout.PrimID = primID;\0D\0A            gout.LODLevel = 0;\0D\0A\09\09\0D\0A            triStream.Append(gout);\0D\0A        }\0D\0A    }\0D\0A}\0D\0A\0D\0A[maxvertexcount(4)]\0D\0Avoid GS_Explode(triangle VertexOut gin[3],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{    \0D\0A    float rand = frac(sin(primID * 12.9898f) * 758.5453f);\0D\0A    float t = frac(gTotalTime + rand * 0.13f);\0D\0A    \0D\0A    float explodeAmount;\0D\0A    float explodeDuration = 0.95f; // \C6\F8\B9\DF\C0\CC \BF\CF\C0\FC\C8\F7 \C1\F8\C7\E0\B5\C7\B4\C2 \BD\C3\B0\A3\0D\0A    if (t < explodeDuration)\0D\0A    {\0D\0A        float localT = t / explodeDuration; // 0~1\B7\CE \C0\E7\C1\A4\B1\D4\C8\AD\0D\0A        explodeAmount = pow(localT, 18.0f);\0D\0A    }\0D\0A    else\0D\0A        explodeAmount = 1.0f;\0D\0A    \0D\0A    float3 e0 = gin[1].PosW - gin[0].PosW;\0D\0A    float3 e1 = gin[2].PosW - gin[0].PosW;\0D\0A    float3 faceNormal = normalize(cross(e0, e1)) * 2.0f;\0D\0A    \0D\0A    float3 explodeVector = explodeAmount * faceNormal;\0D\0A    \0D\0A    [unroll]\0D\0A    for (int i = 0; i < 3; ++i)\0D\0A    {\0D\0A        GeoOut gout;\0D\0A\0D\0A        float3 newPosW = gin[i].PosW + explodeVector;\0D\0A\0D\0A        gout.PosW = newPosW;\0D\0A        gout.NormalW = faceNormal;\0D\0A        gout.TexC = gin[i].TexC;\0D\0A        gout.PosH = mul(float4(newPosW, 1.0f), gViewProj);\0D\0A        gout.PrimID = primID;\0D\0A        gout.LODLevel = 0;\0D\0A\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A\0D\0A    triStream.RestartStrip();\0D\0A}\0D\0A\0D\0A[maxvertexcount(2)]\0D\0Avoid GS_Debugging(point VertexOut gin[1],\0D\0A                  uint primID : SV_PrimitiveID,\0D\0A                  inout LineStream<GeoOut> lineStream)\0D\0A{\0D\0A    GeoOut gout;\0D\0A\0D\0A    float NormalLength = 0.2f;\0D\0A    float3 p0 = gin[0].PosW;\0D\0A    float3 p1 = gin[0].PosW + gin[0].NormalW * NormalLength;\0D\0A\0D\0A    // \BD\C3\C0\DB\C1\A1\0D\0A    gout.PosW = p0;\0D\0A    gout.NormalW = gin[0].NormalW;\0D\0A    gout.TexC = gin[0].TexC;\0D\0A    gout.PosH = mul(float4(p0, 1.0f), gViewProj);\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = 0;\0D\0A    lineStream.Append(gout);\0D\0A\0D\0A    // \B3\A1\C1\A1\0D\0A    gout.PosW = p1;\0D\0A    gout.NormalW = gin[0].NormalW;\0D\0A    gout.TexC = gin[0].TexC;\0D\0A    gout.PosH = mul(float4(p1, 1.0f), gViewProj);\0D\0A    gout.PrimID = primID;\0D\0A    gout.LODLevel = 0;\0D\0A    lineStream.Append(gout);\0D\0A\0D\0A    lineStream.RestartStrip();\0D\0A}\0D\0A\0D\0Afloat4 PS(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 uvw = float3(pin.TexC, pin.PrimID % 3);\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamAnisotropicClamp, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A    if (pin.LODLevel == 2)\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(1.15f, 0.95f, 0.95f); // \BA\D3\C0\BA\B1\E2\0D\0A    }\0D\0A    else if (pin.LODLevel == 1)\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(0.95f, 1.15f, 0.95f); // \C3\CA\B7\CF\B1\E2\0D\0A    }\0D\0A    else\0D\0A    {\0D\0A        diffuseAlbedo.rgb *= float3(0.95f, 0.95f, 1.15f); // \C7\AA\B8\A5\B1\E2\0D\0A    }\0D\0A    \0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A    \0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A#ifdef FOG\0D\0A\09float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A\09litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A    \0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A\0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_VertexNormal(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 normalColor = pin.NormalW * 0.5f + 0.5f;\0D\0A    return float4(normalColor, 1.0f);\0D\0A}"}
!142 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhongToon(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    // 1) kd\0D\0A    float kd = saturate(dot(lightVec, normal));\0D\0A    float kd_q = QuantizeKd(kd);\0D\0A\0D\0A    // 2) ks (Blinn-Phong)\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    float ndoth = saturate(dot(halfVec, normal));\0D\0A\0D\0A    float ks = pow(max(ndoth, 0), m); // \EC\8A\A4\ED\8E\99\ED\81\98\EB\9F\AC \EA\B0\95\EB\8F\84\EC\9D\98 \ED\95\B5\EC\8B\AC\0D\0A    float ks_q = QuantizeKs(ks); // \EC\9D\B4\EC\82\B0\ED\99\94\0D\0A\0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    // fresnel(\EC\83\89) + (\ED\95\84\EC\9A\94\ED\95\98\EB\A9\B4) \EC\A0\95\EA\B7\9C\ED\99\94 \EA\B3\84\EC\88\98\EB\8A\94 \EC\B7\A8\ED\96\A5\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A\0D\0A    // ks_q\EB\A5\BC spec\EC\97\90 \EB\B0\98\EC\98\81\0D\0A    float3 specAlbedo = roughnessFactor * fresnelFactor * ks_q;\0D\0A\0D\0A    // LDR clamp\EB\8A\94 \EC\9C\A0\EC\A7\80 \EA\B0\80\EB\8A\A5\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A\0D\0A    // diffuse\EB\8A\94 kd_q\EB\A5\BC \EB\B0\98\EC\98\81\0D\0A    float3 diffuse = mat.DiffuseAlbedo.rgb * kd_q;\0D\0A    \0D\0A    return (diffuse + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!143 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTask_GS.hlsl"}
!144 = !{!"-E", !"VS", !"-T", !"vs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CLineToCylinderVS.cso"}
!145 = !{i32 1, i32 0}
!146 = !{i32 1, i32 8}
!147 = !{!"vs", i32 6, i32 0}
!148 = !{null, null, !149, null}
!149 = !{!150}
!150 = !{i32 0, %hostlayout.cbPerObject* undef, !"cbPerObject", i32 0, i32 0, i32 1, i32 128, null}
!151 = !{i32 0, %hostlayout.cbPerObject undef, !152}
!152 = !{i32 128, !153, !155}
!153 = !{i32 6, !"gWorld", i32 2, !154, i32 3, i32 0, i32 7, i32 9}
!154 = !{i32 4, i32 4, i32 2}
!155 = !{i32 6, !"gTexTransform", i32 2, !154, i32 3, i32 64, i32 7, i32 9}
!156 = !{i32 1, void ()* @VS, !157}
!157 = !{!158}
!158 = !{i32 0, !2, !2}
!159 = !{[12 x i32] [i32 10, i32 10, i32 7, i32 7, i32 7, i32 0, i32 112, i32 112, i32 112, i32 0, i32 256, i32 512]}
!160 = !{void ()* @VS, !"VS", !161, !148, !173}
!161 = !{!162, !169, null}
!162 = !{!163, !166, !167}
!163 = !{i32 0, !"POSITION", i8 9, i8 0, !164, i8 0, i32 1, i8 3, i32 0, i8 0, !165}
!164 = !{i32 0}
!165 = !{i32 3, i32 7}
!166 = !{i32 1, !"NORMAL", i8 9, i8 0, !164, i8 0, i32 1, i8 3, i32 1, i8 0, !165}
!167 = !{i32 2, !"TEXCOORD", i8 9, i8 0, !164, i8 0, i32 1, i8 2, i32 2, i8 0, !168}
!168 = !{i32 3, i32 3}
!169 = !{!170, !171, !172}
!170 = !{i32 0, !"POSITION", i8 9, i8 0, !164, i8 2, i32 1, i8 3, i32 0, i8 0, !165}
!171 = !{i32 1, !"NORMAL", i8 9, i8 0, !164, i8 2, i32 1, i8 3, i32 1, i8 0, !165}
!172 = !{i32 2, !"TEXCOORD", i8 9, i8 0, !164, i8 2, i32 1, i8 2, i32 2, i8 0, !168}
!173 = !{i32 0, i64 1}
!174 = !DILocation(line: 153, column: 23, scope: !32)
!175 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "vout", scope: !32, file: !1, line: 155, type: !35)
!176 = !DIExpression(DW_OP_bit_piece, 192, 32)
!177 = !DILocation(line: 155, column: 15, scope: !32)
!178 = !DIExpression(DW_OP_bit_piece, 224, 32)
!179 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "vin", arg: 1, scope: !32, file: !1, line: 153, type: !55)
!180 = !DIExpression(DW_OP_bit_piece, 96, 32)
!181 = !DIExpression(DW_OP_bit_piece, 128, 32)
!182 = !DIExpression(DW_OP_bit_piece, 160, 32)
!183 = !DIExpression(DW_OP_bit_piece, 0, 32)
!184 = !DIExpression(DW_OP_bit_piece, 32, 32)
!185 = !DIExpression(DW_OP_bit_piece, 64, 32)
!186 = !DILocation(line: 157, column: 47, scope: !32)
!187 = !DILocation(line: 157, column: 19, scope: !32)
!188 = !DILocation(line: 157, column: 12, scope: !32)
!189 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "posW", scope: !32, file: !1, line: 157, type: !4)
!190 = !DILocation(line: 158, column: 15, scope: !32)
!191 = !DILocation(line: 159, column: 48, scope: !32)
!192 = !DILocation(line: 159, column: 20, scope: !32)
!193 = !DILocation(line: 159, column: 18, scope: !32)
!194 = !DILocation(line: 160, column: 15, scope: !32)
!195 = !DILocation(line: 162, column: 12, scope: !32)
!196 = !DILocation(line: 162, column: 5, scope: !32)
