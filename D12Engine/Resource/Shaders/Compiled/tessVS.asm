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
; shader debug name: f2555422efb3954246942be056d7ade1.pdb
; shader hash: f2555422efb3954246942be056d7ade1
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
;
; Resource Bindings:
;
; Name                                 Type  Format         Dim      ID      HLSL Bind  Count
; ------------------------------ ---------- ------- ----------- ------- -------------- ------
;
;
; ViewId state:
;
; Number of inputs: 10, outputs: 10
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;   output 0 depends on inputs: { 0 }
;   output 1 depends on inputs: { 1 }
;   output 2 depends on inputs: { 2 }
;   output 4 depends on inputs: { 4 }
;   output 5 depends on inputs: { 5 }
;   output 6 depends on inputs: { 6 }
;   output 8 depends on inputs: { 8 }
;   output 9 depends on inputs: { 9 }
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @VS() {
  %1 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 0, i32 undef), !dbg !177 ; line:113 col:22  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !178, metadata !179), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"VS"
  %2 = call float @dx.op.loadInput.f32(i32 4, i32 2, i32 0, i8 1, i32 undef), !dbg !177 ; line:113 col:22  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !178, metadata !180), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"VS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 undef), !dbg !177 ; line:113 col:22  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !178, metadata !181), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 undef), !dbg !177 ; line:113 col:22  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !178, metadata !182), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 2, i32 undef), !dbg !177 ; line:113 col:22  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !178, metadata !183), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"VS"
  %6 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 undef), !dbg !177 ; line:113 col:22  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !178, metadata !184), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  %7 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 undef), !dbg !177 ; line:113 col:22  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !178, metadata !185), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  %8 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 undef), !dbg !177 ; line:113 col:22  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !178, metadata !179), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 192, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !178, metadata !180), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 224, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !178, metadata !181), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !178, metadata !182), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !178, metadata !183), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 160, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %6, i64 0, metadata !178, metadata !184), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %7, i64 0, metadata !178, metadata !185), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %8, i64 0, metadata !178, metadata !186), !dbg !177 ; var:"vin" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  %9 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !187 ; line:115 col:12
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %6), !dbg !187 ; line:115 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %7), !dbg !187 ; line:115 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %8), !dbg !187 ; line:115 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %3), !dbg !187 ; line:115 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %4), !dbg !187 ; line:115 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 2, float %5), !dbg !187 ; line:115 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 0, float %1), !dbg !187 ; line:115 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 2, i32 0, i8 1, float %2), !dbg !187 ; line:115 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  %10 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !188 ; line:115 col:5
  ret void, !dbg !188 ; line:115 col:5
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare float @dx.op.loadInput.f32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #1

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!149, !150}
!llvm.ident = !{!151}
!dx.source.contents = !{!152, !153}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!154}
!dx.source.args = !{!155}
!dx.version = !{!156}
!dx.valver = !{!157}
!dx.shaderModel = !{!158}
!dx.typeAnnotations = !{!159}
!dx.viewIdState = !{!162}
!dx.entryPoints = !{!163}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !16, globals: !64)
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
!16 = !{!17, !40}
!17 = !DISubprogram(name: "VS", scope: !1, file: !1, line: 113, type: !18, isLocal: false, isDefinition: true, scopeLine: 114, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @VS)
!18 = !DISubroutineType(types: !19)
!19 = !{!20, !20}
!20 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexIn", file: !1, line: 76, size: 256, align: 32, elements: !21)
!21 = !{!22, !31, !32}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "PosL", scope: !20, file: !1, line: 78, baseType: !23, size: 96, align: 32)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 40, baseType: !24)
!24 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 40, size: 96, align: 32, elements: !25, templateParams: !29)
!25 = !{!26, !27, !28}
!26 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !24, file: !1, line: 40, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !24, file: !1, line: 40, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !24, file: !1, line: 40, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!29 = !{!13, !30}
!30 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 3)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "NormalL", scope: !20, file: !1, line: 79, baseType: !23, size: 96, align: 32, offset: 96)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "TexC", scope: !20, file: !1, line: 80, baseType: !33, size: 64, align: 32, offset: 192)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 32, baseType: !34)
!34 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 32, size: 64, align: 32, elements: !35, templateParams: !38)
!35 = !{!36, !37}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !34, file: !1, line: 32, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !34, file: !1, line: 32, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!38 = !{!13, !39}
!39 = !DITemplateValueParameter(name: "element_count", type: !15, value: i32 2)
!40 = !DISubprogram(name: "ConstantHS", linkageName: "\01?ConstantHS@@YA?AUPatchTess@@V?$InputPatch@UVertexIn@@$03@@I@Z", scope: !1, file: !1, line: 118, type: !41, isLocal: false, isDefinition: true, scopeLine: 119, flags: DIFlagPrototyped, isOptimized: false)
!41 = !DISubroutineType(types: !42)
!42 = !{!43, !53, !62}
!43 = !DICompositeType(tag: DW_TAG_structure_type, name: "PatchTess", file: !1, line: 83, size: 192, align: 32, elements: !44)
!44 = !{!45, !49}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "EdgeTess", scope: !43, file: !1, line: 85, baseType: !46, size: 128, align: 32)
!46 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 128, align: 32, elements: !47)
!47 = !{!48}
!48 = !DISubrange(count: 4)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "InsideTess", scope: !43, file: !1, line: 86, baseType: !50, size: 64, align: 32, offset: 128)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 64, align: 32, elements: !51)
!51 = !{!52}
!52 = !DISubrange(count: 2)
!53 = !DICompositeType(tag: DW_TAG_class_type, name: "InputPatch<VertexIn, 4>", file: !1, line: 116, size: 1024, align: 32, elements: !54, templateParams: !59)
!54 = !{!55, !57}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "Length", scope: !53, file: !1, line: 116, baseType: !56, flags: DIFlagPublic | DIFlagStaticMember, extraData: i32 4)
!56 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "h", scope: !53, file: !1, line: 116, baseType: !58, size: 1024, align: 32)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !20, size: 1024, align: 32, elements: !47)
!59 = !{!60, !61}
!60 = !DITemplateTypeParameter(name: "element", type: !20)
!61 = !DITemplateValueParameter(name: "count", type: !15, value: i32 4)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 116, baseType: !63)
!63 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!64 = !{!65, !89, !90, !92, !94, !95, !97, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !130, !131, !132, !133, !134, !135, !136, !140, !141, !142, !144, !145, !146, !147, !148}
!65 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 30, type: !66, isLocal: false, isDefinition: true)
!66 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !67)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 30, baseType: !68)
!68 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 30, size: 512, align: 32, elements: !69, templateParams: !86)
!69 = !{!70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !85}
!70 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !68, file: !1, line: 30, baseType: !8, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!86 = !{!13, !87, !88}
!87 = !DITemplateValueParameter(name: "row_count", type: !15, value: i32 4)
!88 = !DITemplateValueParameter(name: "col_count", type: !15, value: i32 4)
!89 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 31, type: !66, isLocal: false, isDefinition: true)
!90 = !DIGlobalVariable(name: "gDisplacementMapTexelSize", linkageName: "\01?gDisplacementMapTexelSize@cbPerObject@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 32, type: !91, isLocal: false, isDefinition: true)
!91 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!92 = !DIGlobalVariable(name: "gGridSpatialStep", linkageName: "\01?gGridSpatialStep@cbPerObject@@3MB", scope: !0, file: !1, line: 33, type: !93, isLocal: false, isDefinition: true)
!93 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !8)
!94 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPerObject@@3MB", scope: !0, file: !1, line: 34, type: !93, isLocal: false, isDefinition: true)
!95 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 39, type: !96, isLocal: false, isDefinition: true)
!96 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!97 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 40, type: !98, isLocal: false, isDefinition: true)
!98 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!99 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 41, type: !93, isLocal: false, isDefinition: true)
!100 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !66, isLocal: false, isDefinition: true)
!101 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 47, type: !66, isLocal: false, isDefinition: true)
!102 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 48, type: !66, isLocal: false, isDefinition: true)
!103 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 49, type: !66, isLocal: false, isDefinition: true)
!104 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 50, type: !66, isLocal: false, isDefinition: true)
!105 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 51, type: !66, isLocal: false, isDefinition: true)
!106 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 52, type: !66, isLocal: false, isDefinition: true)
!107 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 53, type: !98, isLocal: false, isDefinition: true)
!108 = !DIGlobalVariable(name: "cbPerPassPad1", linkageName: "\01?cbPerPassPad1@cbPass@@3MB", scope: !0, file: !1, line: 54, type: !93, isLocal: false, isDefinition: true)
!109 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 55, type: !91, isLocal: false, isDefinition: true)
!110 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 56, type: !91, isLocal: false, isDefinition: true)
!111 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 57, type: !93, isLocal: false, isDefinition: true)
!112 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 58, type: !93, isLocal: false, isDefinition: true)
!113 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 59, type: !93, isLocal: false, isDefinition: true)
!114 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 60, type: !93, isLocal: false, isDefinition: true)
!115 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 61, type: !96, isLocal: false, isDefinition: true)
!116 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 66, type: !117, isLocal: false, isDefinition: true)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !118, size: 6144, align: 32, elements: !128)
!118 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !119)
!119 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !120, line: 3, size: 384, align: 32, elements: !121)
!120 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!121 = !{!122, !123, !124, !125, !126, !127}
!122 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !119, file: !120, line: 5, baseType: !23, size: 96, align: 32)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !119, file: !120, line: 6, baseType: !8, size: 32, align: 32, offset: 96)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !119, file: !120, line: 7, baseType: !23, size: 96, align: 32, offset: 128)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !119, file: !120, line: 8, baseType: !8, size: 32, align: 32, offset: 224)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !119, file: !120, line: 9, baseType: !23, size: 96, align: 32, offset: 256)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !119, file: !120, line: 10, baseType: !8, size: 32, align: 32, offset: 352)
!128 = !{!129}
!129 = !DISubrange(count: 16)
!130 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 70, type: !96, isLocal: false, isDefinition: true)
!131 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 71, type: !93, isLocal: false, isDefinition: true)
!132 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 72, type: !93, isLocal: false, isDefinition: true)
!133 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 73, type: !91, isLocal: false, isDefinition: true)
!134 = !DIGlobalVariable(name: "d0", scope: !40, file: !1, line: 131, type: !93, isLocal: true, isDefinition: true)
!135 = !DIGlobalVariable(name: "d1", scope: !40, file: !1, line: 132, type: !93, isLocal: true, isDefinition: true)
!136 = !DIGlobalVariable(name: "gDiffuseMap", linkageName: "\01?gDiffuseMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 17, type: !137, isLocal: false, isDefinition: true)
!137 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2D<vector<float, 4> >", file: !1, line: 17, size: 160, align: 32, elements: !2, templateParams: !138)
!138 = !{!139}
!139 = !DITemplateTypeParameter(name: "element", type: !5)
!140 = !DIGlobalVariable(name: "gDiffuseMap2", linkageName: "\01?gDiffuseMap2@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 18, type: !137, isLocal: false, isDefinition: true)
!141 = !DIGlobalVariable(name: "gDisplacementMap", linkageName: "\01?gDisplacementMap@@3V?$Texture2D@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 19, type: !137, isLocal: false, isDefinition: true)
!142 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !143, isLocal: false, isDefinition: true)
!143 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 21, size: 32, align: 32, elements: !2)
!144 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !143, isLocal: false, isDefinition: true)
!145 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 23, type: !143, isLocal: false, isDefinition: true)
!146 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 24, type: !143, isLocal: false, isDefinition: true)
!147 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 25, type: !143, isLocal: false, isDefinition: true)
!148 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 26, type: !143, isLocal: false, isDefinition: true)
!149 = !{i32 2, !"Dwarf Version", i32 4}
!150 = !{i32 2, !"Debug Info Version", i32 3}
!151 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!152 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A//#define CARTOON\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2D gDiffuseMap : register(t0);\0D\0ATexture2D gDiffuseMap2 : register(t1);\0D\0ATexture2D gDisplacementMap : register(t2);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A    float2 gDisplacementMapTexelSize;\0D\0A    float gGridSpatialStep;\0D\0A    float cbPerObjectPad1;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerPassPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    // \EC\9D\B8\EB\8D\B1\EC\8A\A4 [0, NUM_DIR_LIGHTS)\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B4\91\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHTS)\EB\8A\94 \EC\A0\90\EA\B4\91\EC\9B\90\EC\9E\85\EB\8B\88\EB\8B\A4.\0D\0A\09// \EC\9D\B8\EB\8D\B1\EC\8A\A4[NUM_DIR_LIGHTS + NUM_POINT_LIGHTS, NUM_DIR_LIGHTS + NUM_POINT_LIGHT + NUM_SPOT_LIGHTS)\EB\8A\94 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\B4\EB\A9\B0, \EA\B0\9D\EC\B2\B4\EB\8B\B9 \EC\B5\9C\EB\8C\80 MaxLights \EA\B0\9C\EC\88\98\EA\B9\8C\EC\A7\80 \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    //\EC\95\B1\EC\9D\B4 \ED\94\84\EB\A0\88\EC\9E\84\EB\8B\B9 \ED\95\9C \EB\B2\88\EC\94\A9 \EC\95\88\EA\B0\9C \EB\A7\A4\EA\B0\9C\EB\B3\80\EC\88\98\EB\A5\BC \EB\B3\80\EA\B2\BD\ED\95\A0 \EC\88\98 \EC\9E\88\EB\8F\84\EB\A1\9D \ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    //\ED\8A\B9\EC\A0\95 \EC\8B\9C\EA\B0\84\EB\8C\80\EC\97\90\EB\A7\8C \EC\95\88\EA\B0\9C\EB\A5\BC \EC\82\AC\EC\9A\A9\ED\95\A0 \EC\88\98 \EC\9E\88\EC\8A\B5\EB\8B\88\EB\8B\A4.\0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosL : POSITION;\0D\0A    float3 NormalL : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Astruct PatchTess\0D\0A{\0D\0A    float EdgeTess[4] : SV_TessFactor;\0D\0A    float InsideTess[2] : SV_InsideTessFactor;\0D\0A};\0D\0A\0D\0Astruct DomainOut\0D\0A{\0D\0A    float4 PosH : SV_Position;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A};\0D\0A\0D\0Afloat GetHillsHeight(float x, float z)\0D\0A{\0D\0A    return 0.3f * (z * sin(0.05f * x) + x * cos(0.1f * z));\0D\0A}\0D\0A\0D\0Afloat3 GetHillsNormal(float x, float z)\0D\0A{\0D\0A    // y = f(x, z)\0D\0A    // normal = normalize((-df/dx, 1, -df/dz))\0D\0A\0D\0A    float df_dx = 0.3f * (0.05f * z * cos(0.05f * x) + cos(0.1f * z));\0D\0A    float df_dz = 0.3f * (sin(0.05f * x) - 0.1f * x * sin(0.1f * z));\0D\0A\0D\0A    return normalize(float3(-df_dx, 1.0f, -df_dz));\0D\0A}\0D\0A\0D\0AVertexIn VS(VertexIn vin)\0D\0A{\0D\0A    return vin;\0D\0A}\0D\0A\0D\0APatchTess ConstantHS(InputPatch<VertexIn, 4> patch, uint patchID : SV_PrimitiveID)\0D\0A{\0D\0A    PatchTess pt;\0D\0A    \0D\0A    float3 centerL = 0.25f * (patch[0].PosL + patch[1].PosL + patch[2].PosL + patch[3].PosL);\0D\0A    float3 centerW = mul(float4(centerL, 1.0f), gWorld).xyz;\0D\0A    \0D\0A    float d = distance(centerW, gEyePosW);\0D\0A    \0D\0A    // \EC\8B\9C\EC\A0\90(eye)\EC\9C\BC\EB\A1\9C\EB\B6\80\ED\84\B0\EC\9D\98 \EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\9D\BC \ED\8C\A8\EC\B9\98\EB\A5\BC \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98\ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    // \EC\9D\B4\EB\95\8C \EA\B1\B0\EB\A6\AC\EA\B0\80 d1 \EC\9D\B4\EC\83\81\EC\9D\B4\EB\A9\B4 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98 \EC\88\98\EC\A4\80\EC\9D\80 0\EC\9D\B4 \EB\90\98\EA\B3\A0, d0 \EC\9D\B4\ED\95\98\EC\9D\B4\EB\A9\B4 64\EA\B0\80 \EB\90\A9\EB\8B\88\EB\8B\A4.\0D\0A    // \EA\B5\AC\EA\B0\84 [d0, d1]\EC\9D\80 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98\EC\9D\B4 \EC\88\98\ED\96\89\EB\90\98\EB\8A\94 \EB\B2\94\EC\9C\84\EB\A5\BC \EC\A0\95\EC\9D\98\ED\95\A9\EB\8B\88\EB\8B\A4.\0D\0A    \0D\0A    const float d0 = 20.0f;\0D\0A    const float d1 = 100.0f;\0D\0A    float tess = 64.0f * saturate((d1 - d) / (d1 - d0));\0D\0A    \0D\0A    //\EA\B7\A0\EC\9D\BC\ED\95\98\EA\B2\8C \ED\8C\A8\EC\B9\98\EB\A5\BC tessellate\0D\0A    \0D\0A    pt.EdgeTess[0] = tess;\0D\0A    pt.EdgeTess[1] = tess;\0D\0A    pt.EdgeTess[2] = tess;\0D\0A    pt.EdgeTess[3] = tess;\0D\0A\09\0D\0A    pt.InsideTess[0] = tess;\0D\0A    pt.InsideTess[1] = tess;\0D\0A\09\0D\0A    return pt;\0D\0A}\0D\0A\0D\0A[domain(\22quad\22)]\0D\0A[partitioning(\22integer\22)]\0D\0A[outputtopology(\22triangle_cw\22)]\0D\0A[outputcontrolpoints(4)]\0D\0A[patchconstantfunc(\22ConstantHS\22)]\0D\0A[maxtessfactor(64.0f)]\0D\0AVertexIn HS(InputPatch<VertexIn, 4> p,\0D\0A           uint i : SV_OutputControlPointID,\0D\0A           uint patchId : SV_PrimitiveID)\0D\0A{\0D\0A    return p[i];\0D\0A}\0D\0A\0D\0A//\EC\9C\A0\EC\82\AC \EB\9E\9C\EB\8D\A4\ED\95\A8\EC\88\98\0D\0Afloat Hash12(float2 p)\0D\0A{\0D\0A    return frac(sin(dot(p, float2(127.1f, 311.7f))) * 43758.5453123f);\0D\0A}\0D\0A\0D\0A// \EB\8F\84\EB\A9\94\EC\9D\B8 \EC\85\B0\EC\9D\B4\EB\8D\94\EB\8A\94 \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\ED\84\B0\EA\B0\80 \EC\83\9D\EC\84\B1\ED\95\9C \EB\AA\A8\EB\93\A0 \EC\A0\95\EC\A0\90\EB\A7\88\EB\8B\A4 \ED\98\B8\EC\B6\9C\EB\90\9C\EB\8B\A4.\0D\0A// \ED\85\8C\EC\85\80\EB\A0\88\EC\9D\B4\EC\85\98 \EC\9D\B4\ED\9B\84\EC\9D\98 \EC\A0\95\EC\A0\90 \EC\85\B0\EC\9D\B4\EB\8D\94\EC\99\80 \EB\B9\84\EC\8A\B7\ED\95\9C \EC\97\AD\ED\95\A0\EC\9D\84 \ED\95\9C\EB\8B\A4.\0D\0A[domain(\22quad\22)]\0D\0ADomainOut DS(PatchTess patchTess,\0D\0A            float2 uv : SV_DomainLocation,\0D\0A            const OutputPatch<VertexIn, 4> quad)\0D\0A{\0D\0A    DomainOut dout;\0D\0A    \0D\0A    //\EC\8C\8D\EC\84\A0\ED\98\95 \EB\B3\B4\EA\B0\84\0D\0A    float3 v1 = lerp(quad[0].PosL, quad[1].PosL, uv.x);\0D\0A    float3 v2 = lerp(quad[2].PosL, quad[3].PosL, uv.x);\0D\0A    float3 posL = lerp(v1, v2, uv.y);\0D\0A    \0D\0A    float3 n1 = lerp(quad[0].NormalL, quad[1].NormalL, uv.x);\0D\0A    float3 n2 = lerp(quad[2].NormalL, quad[3].NormalL, uv.x);\0D\0A    float3 normalL = normalize(lerp(n1, n2, uv.y));\0D\0A    \0D\0A    float h = Hash12(floor(uv * 128.0f)) * 0.1f;\0D\0A#ifdef WALL\0D\0A    // \EB\B2\BD\EB\8F\8C \EB\B2\BD: normal \EB\B0\A9\ED\96\A5\EC\9C\BC\EB\A1\9C \EB\B0\80\EA\B8\B0\0D\0A    posL += normalL * h;\0D\0A#else\0D\0A    // \EC\A7\80\ED\98\95: y \EB\86\92\EC\9D\B4\EB\A5\BC \ED\95\A8\EC\88\98\EB\A1\9C \EA\B2\B0\EC\A0\95\0D\0A    posL.y = GetHillsHeight(posL.x, posL.z);\0D\0A    posL.y += h * 10;\0D\0A    normalL = GetHillsNormal(posL.x, posL.z);\0D\0A#endif\0D\0A    \0D\0A    //\EB\B3\80\EC\9C\84 \EB\A7\A4\ED\95\91\0D\0A    float4 posW = mul(float4(posL, 1.0f), gWorld);\0D\0A    dout.PosW = posW.xyz;\0D\0A    \0D\0A    dout.PosH = mul(posW, gViewProj);\0D\0A    \0D\0A    float3 normalW = normalize(mul(normalL, (float3x3) gWorld));\0D\0A    dout.NormalW = normalW;    \0D\0A    \0D\0A    float4 texC = mul(float4(uv, 0.f, 1.f), gTexTransform);\0D\0A    dout.TexC = mul(texC, gMatTransform).xy;\0D\0A    \0D\0A    return dout;\0D\0A}\0D\0A\0D\0Afloat4 PS(DomainOut pin) : SV_Target\0D\0A{\0D\0A    float4 diffuseAlbedo = gDiffuseMap.Sample(gsamLinearWrap, pin.TexC) * gDiffuseAlbedo;\0D\0A    \0D\0A    //\EB\B3\B4\EA\B0\84\EB\90\9C \EB\B2\95\EC\84\A0 \EB\B2\A1\ED\84\B0\EB\8A\94 \EA\B8\B8\EC\9D\B4\EA\B0\80 1\EC\9D\B4 \EC\95\84\EB\8B\90 \EC\88\98 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C.\0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A\0D\0A    //\EA\B4\91\EC\9B\90\EC\97\90\EC\84\9C \EC\B9\B4\EB\A9\94\EB\9D\BC\EB\A1\9C \ED\96\A5\ED\95\98\EB\8A\94 \EB\B2\A1\ED\84\B0.\0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; //normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    \0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A    //\EC\9D\BC\EB\B0\98\EC\A0\81\EC\9C\BC\EB\A1\9C \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\80 \EB\94\94\ED\93\A8\EC\A6\88 \EB\A8\B8\ED\8B\B0\EB\A6\AC\EC\96\BC\EC\9D\98 \EC\95\8C\ED\8C\8C \EA\B0\92\EC\9D\84 \EC\82\AC\EC\9A\A9\ED\95\9C\EB\8B\A4.\0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A    \0D\0A    return litColor;\0D\0A}"}
!153 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhongToon(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    // 1) kd\0D\0A    float kd = saturate(dot(lightVec, normal));\0D\0A    float kd_q = QuantizeKd(kd);\0D\0A\0D\0A    // 2) ks (Blinn-Phong)\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    float ndoth = saturate(dot(halfVec, normal));\0D\0A\0D\0A    float ks = pow(max(ndoth, 0), m); // \EC\8A\A4\ED\8E\99\ED\81\98\EB\9F\AC \EA\B0\95\EB\8F\84\EC\9D\98 \ED\95\B5\EC\8B\AC\0D\0A    float ks_q = QuantizeKs(ks); // \EC\9D\B4\EC\82\B0\ED\99\94\0D\0A\0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    // fresnel(\EC\83\89) + (\ED\95\84\EC\9A\94\ED\95\98\EB\A9\B4) \EC\A0\95\EA\B7\9C\ED\99\94 \EA\B3\84\EC\88\98\EB\8A\94 \EC\B7\A8\ED\96\A5\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A\0D\0A    // ks_q\EB\A5\BC spec\EC\97\90 \EB\B0\98\EC\98\81\0D\0A    float3 specAlbedo = roughnessFactor * fresnelFactor * ks_q;\0D\0A\0D\0A    // LDR clamp\EB\8A\94 \EC\9C\A0\EC\A7\80 \EA\B0\80\EB\8A\A5\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A\0D\0A    // diffuse\EB\8A\94 kd_q\EB\A5\BC \EB\B0\98\EC\98\81\0D\0A    float3 diffuse = mat.DiffuseAlbedo.rgb * kd_q;\0D\0A    \0D\0A    return (diffuse + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A#ifdef CARTOON\0D\0A    float3 lightStrength = L.Strength;\0D\0A#else\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A#endif\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A#ifdef CARTOON\0D\0A    return BlinnPhongToon(lightStrength, lightVec, normal, toEye, mat);\0D\0A#else\0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A#endif\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!154 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTessellation.hlsl"}
!155 = !{!"-E", !"VS", !"-T", !"vs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CtessVS.cso"}
!156 = !{i32 1, i32 0}
!157 = !{i32 1, i32 8}
!158 = !{!"vs", i32 6, i32 0}
!159 = !{i32 1, void ()* @VS, !160}
!160 = !{!161}
!161 = !{i32 0, !2, !2}
!162 = !{[12 x i32] [i32 10, i32 10, i32 1, i32 2, i32 4, i32 0, i32 16, i32 32, i32 64, i32 0, i32 256, i32 512]}
!163 = !{void ()* @VS, !"VS", !164, null, !176}
!164 = !{!165, !172, null}
!165 = !{!166, !169, !170}
!166 = !{i32 0, !"POSITION", i8 9, i8 0, !167, i8 0, i32 1, i8 3, i32 0, i8 0, !168}
!167 = !{i32 0}
!168 = !{i32 3, i32 7}
!169 = !{i32 1, !"NORMAL", i8 9, i8 0, !167, i8 0, i32 1, i8 3, i32 1, i8 0, !168}
!170 = !{i32 2, !"TEXCOORD", i8 9, i8 0, !167, i8 0, i32 1, i8 2, i32 2, i8 0, !171}
!171 = !{i32 3, i32 3}
!172 = !{!173, !174, !175}
!173 = !{i32 0, !"POSITION", i8 9, i8 0, !167, i8 2, i32 1, i8 3, i32 0, i8 0, !168}
!174 = !{i32 1, !"NORMAL", i8 9, i8 0, !167, i8 2, i32 1, i8 3, i32 1, i8 0, !168}
!175 = !{i32 2, !"TEXCOORD", i8 9, i8 0, !167, i8 2, i32 1, i8 2, i32 2, i8 0, !171}
!176 = !{i32 0, i64 1}
!177 = !DILocation(line: 113, column: 22, scope: !17)
!178 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "vin", arg: 1, scope: !17, file: !1, line: 113, type: !20)
!179 = !DIExpression(DW_OP_bit_piece, 192, 32)
!180 = !DIExpression(DW_OP_bit_piece, 224, 32)
!181 = !DIExpression(DW_OP_bit_piece, 96, 32)
!182 = !DIExpression(DW_OP_bit_piece, 128, 32)
!183 = !DIExpression(DW_OP_bit_piece, 160, 32)
!184 = !DIExpression(DW_OP_bit_piece, 0, 32)
!185 = !DIExpression(DW_OP_bit_piece, 32, 32)
!186 = !DIExpression(DW_OP_bit_piece, 64, 32)
!187 = !DILocation(line: 115, column: 12, scope: !17)
!188 = !DILocation(line: 115, column: 5, scope: !17)
