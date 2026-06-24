;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   xyz 
; SIZE                     0   xy          1     NONE   float   xy  
;
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; POSITION                 0   xyz         0     NONE   float   xyz 
; SIZE                     0   xy          1     NONE   float   xy  
;
; shader debug name: 3b6192565245f0fa359a10c9ce9da22c.pdb
; shader hash: 3b6192565245f0fa359a10c9ce9da22c
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Vertex Shader
; OutputPositionPresent=0
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 2
; SigOutputElements: 2
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 2
; SigOutputVectors[0]: 2
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
; SIZE                     0                              
;
; Output signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; POSITION                 0                 linear       
; SIZE                     0                 linear       
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
; Number of inputs: 6, outputs: 6
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;   output 0 depends on inputs: { 0 }
;   output 1 depends on inputs: { 1 }
;   output 2 depends on inputs: { 2 }
;   output 4 depends on inputs: { 4 }
;   output 5 depends on inputs: { 5 }
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

define void @VS() {
  %1 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 0, i32 undef), !dbg !146 ; line:86 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !147, metadata !148), !dbg !149 ; var:"vout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  %2 = call float @dx.op.loadInput.f32(i32 4, i32 1, i32 0, i8 1, i32 undef), !dbg !146 ; line:86 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !147, metadata !150), !dbg !149 ; var:"vout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  %3 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 0, i32 undef), !dbg !146 ; line:86 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !151, metadata !152), !dbg !146 ; var:"vin" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  %4 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 1, i32 undef), !dbg !146 ; line:86 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !151, metadata !153), !dbg !146 ; var:"vin" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  %5 = call float @dx.op.loadInput.f32(i32 4, i32 0, i32 0, i8 2, i32 undef), !dbg !146 ; line:86 col:23  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !151, metadata !148), !dbg !146 ; var:"vin" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !151, metadata !150), !dbg !146 ; var:"vin" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !151, metadata !152), !dbg !146 ; var:"vin" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !151, metadata !153), !dbg !146 ; var:"vin" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !151, metadata !154), !dbg !146 ; var:"vin" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  %6 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !155 ; line:90 col:18
  call void @llvm.dbg.value(metadata float %3, i64 0, metadata !147, metadata !152), !dbg !149 ; var:"vout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %4, i64 0, metadata !147, metadata !153), !dbg !149 ; var:"vout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %5, i64 0, metadata !147, metadata !154), !dbg !149 ; var:"vout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"VS"
  %7 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !156 ; line:91 col:16
  call void @llvm.dbg.value(metadata float %1, i64 0, metadata !147, metadata !148), !dbg !149 ; var:"vout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"VS"
  call void @llvm.dbg.value(metadata float %2, i64 0, metadata !147, metadata !150), !dbg !149 ; var:"vout" !DIExpression(DW_OP_bit_piece, 128, 32) func:"VS"
  %8 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !157 ; line:93 col:12
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %3), !dbg !157 ; line:93 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %4), !dbg !157 ; line:93 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float %5), !dbg !157 ; line:93 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 0, float %1), !dbg !157 ; line:93 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 1, i32 0, i8 1, float %2), !dbg !157 ; line:93 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  %9 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !158 ; line:93 col:5
  ret void, !dbg !158 ; line:93 col:5
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
!llvm.module.flags = !{!120, !121}
!llvm.ident = !{!122}
!dx.source.contents = !{!123, !124}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!125}
!dx.source.args = !{!126}
!dx.version = !{!127}
!dx.valver = !{!128}
!dx.shaderModel = !{!129}
!dx.typeAnnotations = !{!130}
!dx.viewIdState = !{!133}
!dx.entryPoints = !{!134}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, subprograms: !3, globals: !33)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTreeBillboard.hlsl", directory: "")
!2 = !{}
!3 = !{!4}
!4 = !DISubprogram(name: "VS", scope: !1, file: !1, line: 86, type: !5, isLocal: false, isDefinition: true, scopeLine: 87, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @VS)
!5 = !DISubroutineType(types: !6)
!6 = !{!7, !29}
!7 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexOut", file: !1, line: 70, size: 160, align: 32, elements: !8)
!8 = !{!9, !21}
!9 = !DIDerivedType(tag: DW_TAG_member, name: "CenterW", scope: !7, file: !1, line: 72, baseType: !10, size: 96, align: 32)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "float3", file: !1, line: 33, baseType: !11)
!11 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 3>", file: !1, line: 33, size: 96, align: 32, elements: !12, templateParams: !17)
!12 = !{!13, !15, !16}
!13 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !11, file: !1, line: 33, baseType: !14, size: 32, align: 32, flags: DIFlagPublic)
!14 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !11, file: !1, line: 33, baseType: !14, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !11, file: !1, line: 33, baseType: !14, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!17 = !{!18, !19}
!18 = !DITemplateTypeParameter(name: "element", type: !14)
!19 = !DITemplateValueParameter(name: "element_count", type: !20, value: i32 3)
!20 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "SizeW", scope: !7, file: !1, line: 73, baseType: !22, size: 64, align: 32, offset: 96)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 48, baseType: !23)
!23 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 48, size: 64, align: 32, elements: !24, templateParams: !27)
!24 = !{!25, !26}
!25 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !23, file: !1, line: 48, baseType: !14, size: 32, align: 32, flags: DIFlagPublic)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !23, file: !1, line: 48, baseType: !14, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!27 = !{!18, !28}
!28 = !DITemplateValueParameter(name: "element_count", type: !20, value: i32 2)
!29 = !DICompositeType(tag: DW_TAG_structure_type, name: "VertexIn", file: !1, line: 64, size: 160, align: 32, elements: !30)
!30 = !{!31, !32}
!31 = !DIDerivedType(tag: DW_TAG_member, name: "PosW", scope: !29, file: !1, line: 66, baseType: !10, size: 96, align: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "SizeW", scope: !29, file: !1, line: 67, baseType: !22, size: 64, align: 32, offset: 96)
!33 = !{!34, !58, !59, !70, !72, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !85, !86, !87, !88, !89, !90, !91, !105, !106, !107, !108, !109, !113, !115, !116, !117, !118, !119}
!34 = !DIGlobalVariable(name: "gWorld", linkageName: "\01?gWorld@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 26, type: !35, isLocal: false, isDefinition: true)
!35 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !36)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4x4", file: !1, line: 26, baseType: !37)
!37 = !DICompositeType(tag: DW_TAG_class_type, name: "matrix<float, 4, 4>", file: !1, line: 26, size: 512, align: 32, elements: !38, templateParams: !55)
!38 = !{!39, !40, !41, !42, !43, !44, !45, !46, !47, !48, !49, !50, !51, !52, !53, !54}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "_11", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, flags: DIFlagPublic)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "_12", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "_13", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "_14", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "_21", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 128, flags: DIFlagPublic)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "_22", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 160, flags: DIFlagPublic)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "_23", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 192, flags: DIFlagPublic)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "_24", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 224, flags: DIFlagPublic)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "_31", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 256, flags: DIFlagPublic)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "_32", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 288, flags: DIFlagPublic)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "_33", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 320, flags: DIFlagPublic)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "_34", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 352, flags: DIFlagPublic)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "_41", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 384, flags: DIFlagPublic)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "_42", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 416, flags: DIFlagPublic)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "_43", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 448, flags: DIFlagPublic)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "_44", scope: !37, file: !1, line: 26, baseType: !14, size: 32, align: 32, offset: 480, flags: DIFlagPublic)
!55 = !{!18, !56, !57}
!56 = !DITemplateValueParameter(name: "row_count", type: !20, value: i32 4)
!57 = !DITemplateValueParameter(name: "col_count", type: !20, value: i32 4)
!58 = !DIGlobalVariable(name: "gTexTransform", linkageName: "\01?gTexTransform@cbPerObject@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 27, type: !35, isLocal: false, isDefinition: true)
!59 = !DIGlobalVariable(name: "gDiffuseAlbedo", linkageName: "\01?gDiffuseAlbedo@cbMaterial@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 32, type: !60, isLocal: false, isDefinition: true)
!60 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !61)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 32, baseType: !62)
!62 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 32, size: 128, align: 32, elements: !63, templateParams: !68)
!63 = !{!64, !65, !66, !67}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !62, file: !1, line: 32, baseType: !14, size: 32, align: 32, flags: DIFlagPublic)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !62, file: !1, line: 32, baseType: !14, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !62, file: !1, line: 32, baseType: !14, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !62, file: !1, line: 32, baseType: !14, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!68 = !{!18, !69}
!69 = !DITemplateValueParameter(name: "element_count", type: !20, value: i32 4)
!70 = !DIGlobalVariable(name: "gFresnelR0", linkageName: "\01?gFresnelR0@cbMaterial@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 33, type: !71, isLocal: false, isDefinition: true)
!71 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!72 = !DIGlobalVariable(name: "gRoughness", linkageName: "\01?gRoughness@cbMaterial@@3MB", scope: !0, file: !1, line: 34, type: !73, isLocal: false, isDefinition: true)
!73 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !14)
!74 = !DIGlobalVariable(name: "gMatTransform", linkageName: "\01?gMatTransform@cbMaterial@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 35, type: !35, isLocal: false, isDefinition: true)
!75 = !DIGlobalVariable(name: "gView", linkageName: "\01?gView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 40, type: !35, isLocal: false, isDefinition: true)
!76 = !DIGlobalVariable(name: "gInvView", linkageName: "\01?gInvView@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 41, type: !35, isLocal: false, isDefinition: true)
!77 = !DIGlobalVariable(name: "gProj", linkageName: "\01?gProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 42, type: !35, isLocal: false, isDefinition: true)
!78 = !DIGlobalVariable(name: "gInvProj", linkageName: "\01?gInvProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 43, type: !35, isLocal: false, isDefinition: true)
!79 = !DIGlobalVariable(name: "gViewProj", linkageName: "\01?gViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 44, type: !35, isLocal: false, isDefinition: true)
!80 = !DIGlobalVariable(name: "gInvViewProj", linkageName: "\01?gInvViewProj@cbPass@@3V?$matrix@M$03$03@@B", scope: !0, file: !1, line: 45, type: !35, isLocal: false, isDefinition: true)
!81 = !DIGlobalVariable(name: "gEyePosW", linkageName: "\01?gEyePosW@cbPass@@3V?$vector@M$02@@B", scope: !0, file: !1, line: 46, type: !71, isLocal: false, isDefinition: true)
!82 = !DIGlobalVariable(name: "cbPerObjectPad1", linkageName: "\01?cbPerObjectPad1@cbPass@@3MB", scope: !0, file: !1, line: 47, type: !73, isLocal: false, isDefinition: true)
!83 = !DIGlobalVariable(name: "gRenderTargetSize", linkageName: "\01?gRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 48, type: !84, isLocal: false, isDefinition: true)
!84 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !22)
!85 = !DIGlobalVariable(name: "gInvRenderTargetSize", linkageName: "\01?gInvRenderTargetSize@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 49, type: !84, isLocal: false, isDefinition: true)
!86 = !DIGlobalVariable(name: "gNearZ", linkageName: "\01?gNearZ@cbPass@@3MB", scope: !0, file: !1, line: 50, type: !73, isLocal: false, isDefinition: true)
!87 = !DIGlobalVariable(name: "gFarZ", linkageName: "\01?gFarZ@cbPass@@3MB", scope: !0, file: !1, line: 51, type: !73, isLocal: false, isDefinition: true)
!88 = !DIGlobalVariable(name: "gTotalTime", linkageName: "\01?gTotalTime@cbPass@@3MB", scope: !0, file: !1, line: 52, type: !73, isLocal: false, isDefinition: true)
!89 = !DIGlobalVariable(name: "gDeltaTime", linkageName: "\01?gDeltaTime@cbPass@@3MB", scope: !0, file: !1, line: 53, type: !73, isLocal: false, isDefinition: true)
!90 = !DIGlobalVariable(name: "gAmbientLight", linkageName: "\01?gAmbientLight@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 54, type: !60, isLocal: false, isDefinition: true)
!91 = !DIGlobalVariable(name: "gLights", linkageName: "\01?gLights@cbPass@@3QBULight@@B", scope: !0, file: !1, line: 56, type: !92, isLocal: false, isDefinition: true)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !93, size: 6144, align: 32, elements: !103)
!93 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !94)
!94 = !DICompositeType(tag: DW_TAG_structure_type, name: "Light", file: !95, line: 3, size: 384, align: 32, elements: !96)
!95 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders/LightingUtil.hlsli", directory: "")
!96 = !{!97, !98, !99, !100, !101, !102}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "Strength", scope: !94, file: !95, line: 5, baseType: !10, size: 96, align: 32)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffStart", scope: !94, file: !95, line: 6, baseType: !14, size: 32, align: 32, offset: 96)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "Direction", scope: !94, file: !95, line: 7, baseType: !10, size: 96, align: 32, offset: 128)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "FalloffEnd", scope: !94, file: !95, line: 8, baseType: !14, size: 32, align: 32, offset: 224)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "Position", scope: !94, file: !95, line: 9, baseType: !10, size: 96, align: 32, offset: 256)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "SpotPower", scope: !94, file: !95, line: 10, baseType: !14, size: 32, align: 32, offset: 352)
!103 = !{!104}
!104 = !DISubrange(count: 16)
!105 = !DIGlobalVariable(name: "gFogColor", linkageName: "\01?gFogColor@cbPass@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 58, type: !60, isLocal: false, isDefinition: true)
!106 = !DIGlobalVariable(name: "gFogStart", linkageName: "\01?gFogStart@cbPass@@3MB", scope: !0, file: !1, line: 59, type: !73, isLocal: false, isDefinition: true)
!107 = !DIGlobalVariable(name: "gFogRange", linkageName: "\01?gFogRange@cbPass@@3MB", scope: !0, file: !1, line: 60, type: !73, isLocal: false, isDefinition: true)
!108 = !DIGlobalVariable(name: "cbPerObjectPad2", linkageName: "\01?cbPerObjectPad2@cbPass@@3V?$vector@M$01@@B", scope: !0, file: !1, line: 61, type: !84, isLocal: false, isDefinition: true)
!109 = !DIGlobalVariable(name: "gTreeMapArray", linkageName: "\01?gTreeMapArray@@3V?$Texture2DArray@V?$vector@M$03@@@@A", scope: !0, file: !1, line: 15, type: !110, isLocal: false, isDefinition: true)
!110 = !DICompositeType(tag: DW_TAG_class_type, name: "Texture2DArray<vector<float, 4> >", file: !1, line: 15, size: 160, align: 32, elements: !2, templateParams: !111)
!111 = !{!112}
!112 = !DITemplateTypeParameter(name: "element", type: !62)
!113 = !DIGlobalVariable(name: "gsamPointWrap", linkageName: "\01?gsamPointWrap@@3USamplerState@@A", scope: !0, file: !1, line: 17, type: !114, isLocal: false, isDefinition: true)
!114 = !DICompositeType(tag: DW_TAG_structure_type, name: "SamplerState", file: !1, line: 17, size: 32, align: 32, elements: !2)
!115 = !DIGlobalVariable(name: "gsamPointClamp", linkageName: "\01?gsamPointClamp@@3USamplerState@@A", scope: !0, file: !1, line: 18, type: !114, isLocal: false, isDefinition: true)
!116 = !DIGlobalVariable(name: "gsamLinearWrap", linkageName: "\01?gsamLinearWrap@@3USamplerState@@A", scope: !0, file: !1, line: 19, type: !114, isLocal: false, isDefinition: true)
!117 = !DIGlobalVariable(name: "gsamLinearClamp", linkageName: "\01?gsamLinearClamp@@3USamplerState@@A", scope: !0, file: !1, line: 20, type: !114, isLocal: false, isDefinition: true)
!118 = !DIGlobalVariable(name: "gsamAnisotropicWrap", linkageName: "\01?gsamAnisotropicWrap@@3USamplerState@@A", scope: !0, file: !1, line: 21, type: !114, isLocal: false, isDefinition: true)
!119 = !DIGlobalVariable(name: "gsamAnisotropicClamp", linkageName: "\01?gsamAnisotropicClamp@@3USamplerState@@A", scope: !0, file: !1, line: 22, type: !114, isLocal: false, isDefinition: true)
!120 = !{i32 2, !"Dwarf Version", i32 4}
!121 = !{i32 2, !"Debug Info Version", i32 3}
!122 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!123 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTreeBillboard.hlsl", !"#ifndef NUM_DIR_LIGHTS\0D\0A    #define NUM_DIR_LIGHTS 3\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_POINT_LIGHTS\0D\0A    #define NUM_POINT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#ifndef NUM_SPOT_LIGHTS\0D\0A    #define NUM_SPOT_LIGHTS 0\0D\0A#endif\0D\0A\0D\0A#include \22LightingUtil.hlsli\22\0D\0A\0D\0ATexture2DArray gTreeMapArray : register(t0);\0D\0A\0D\0ASamplerState gsamPointWrap : register(s0);\0D\0ASamplerState gsamPointClamp : register(s1);\0D\0ASamplerState gsamLinearWrap : register(s2);\0D\0ASamplerState gsamLinearClamp : register(s3);\0D\0ASamplerState gsamAnisotropicWrap : register(s4);\0D\0ASamplerState gsamAnisotropicClamp : register(s5);\0D\0A\0D\0Acbuffer cbPerObject : register(b0)\0D\0A{\0D\0A    float4x4 gWorld; //16DWARD\0D\0A    float4x4 gTexTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbMaterial : register(b1)\0D\0A{\0D\0A    float4 gDiffuseAlbedo;\0D\0A    float3 gFresnelR0;\0D\0A    float gRoughness;\0D\0A    float4x4 gMatTransform;\0D\0A};\0D\0A\0D\0Acbuffer cbPass : register(b2)\0D\0A{\0D\0A    float4x4 gView;\0D\0A    float4x4 gInvView;\0D\0A    float4x4 gProj;\0D\0A    float4x4 gInvProj;\0D\0A    float4x4 gViewProj;\0D\0A    float4x4 gInvViewProj;\0D\0A    float3 gEyePosW;\0D\0A    float cbPerObjectPad1;\0D\0A    float2 gRenderTargetSize;\0D\0A    float2 gInvRenderTargetSize;\0D\0A    float gNearZ;\0D\0A    float gFarZ;\0D\0A    float gTotalTime;\0D\0A    float gDeltaTime;\0D\0A    float4 gAmbientLight;\0D\0A    \0D\0A    Light gLights[MaxLights];\0D\0A    \0D\0A    float4 gFogColor;\0D\0A    float gFogStart;\0D\0A    float gFogRange;\0D\0A    float2 cbPerObjectPad2;\0D\0A};\0D\0A\0D\0Astruct VertexIn\0D\0A{\0D\0A    float3 PosW : POSITION;\0D\0A    float2 SizeW : SIZE;\0D\0A};\0D\0A\0D\0Astruct VertexOut\0D\0A{\0D\0A    float3 CenterW : POSITION;\0D\0A    float2 SizeW : SIZE;\0D\0A};\0D\0A\0D\0Astruct GeoOut\0D\0A{\0D\0A    float4 PosH : SV_POSITION;\0D\0A    float3 PosW : POSITION;\0D\0A    float3 NormalW : NORMAL;\0D\0A    float2 TexC : TEXCOORD;\0D\0A    uint PrimID : SV_PrimitiveID;\0D\0A};\0D\0A\0D\0A//\B1\D7\B3\C9 \C6\D0\BD\BA\BD\BA\B7\E7 \BC\CE\C0\CC\B4\F5.\0D\0AVertexOut VS(VertexIn vin)\0D\0A{\0D\0A    VertexOut vout;\0D\0A    \0D\0A    vout.CenterW = vin.PosW;\0D\0A    vout.SizeW = vin.SizeW;\0D\0A\0D\0A    return vout;\0D\0A}\0D\0A \0D\0A//\C1\A1(CenterW)\B8\A6 \BB\E7\B0\A2\C7\FC(\C1\A1 4\B0\B3)\C0\B8\B7\CE \C8\AE\C0\E5.\0D\0A[maxvertexcount(4)]\0D\0Avoid GS(point VertexOut gin[1],\0D\0A        uint primID : SV_PrimitiveID,\0D\0A        inout TriangleStream<GeoOut> triStream)\0D\0A{\0D\0A\09//\C0\D3\BD\C3 \B7\CE\C4\C3 \C1\C2\C7\A5\B0\E8 -> \BF\F9\B5\E5 \C1\C2\C7\A5\B0\E8\0D\0A    //\BA\F4\BA\B8\B5\E5\B4\C2 y\C3\E0\BF\A1 \C1\A4\B7\C4\B5\C7\B0\ED \BD\C3\BC\B1\C0\BB \C7\E2\C7\D4\0D\0A    float3 up = float3(0.0f, 1.0f, 0.0f);\0D\0A    float3 look = gEyePosW - gin[0].CenterW;\0D\0A    look.y = 0.0f; //project to xz-plane\0D\0A    look = normalize(look);\0D\0A    float3 right = cross(up, look);\0D\0A\0D\0A    float halfWidth = 0.5f * gin[0].SizeW.x;\0D\0A    float halfHeight = 0.5f * gin[0].SizeW.y;\0D\0A\09\0D\0A    float4 v[4];\0D\0A    v[0] = float4(gin[0].CenterW + halfWidth * right - halfHeight * up, 1.0f);\0D\0A    v[1] = float4(gin[0].CenterW + halfWidth * right + halfHeight * up, 1.0f);\0D\0A    v[2] = float4(gin[0].CenterW - halfWidth * right - halfHeight * up, 1.0f);\0D\0A    v[3] = float4(gin[0].CenterW - halfWidth * right + halfHeight * up, 1.0f);\0D\0A    \0D\0A    float2 texC[4] =\0D\0A    {\0D\0A        float2(0.0f, 1.0f),\0D\0A\09\09float2(0.0f, 0.0f),\0D\0A\09\09float2(1.0f, 1.0f),\0D\0A\09\09float2(1.0f, 0.0f)\0D\0A    };\0D\0A\09\0D\0A    GeoOut gout;\0D\0A\09[unroll]\0D\0A    for (int i = 0; i < 4; ++i)\0D\0A    {\0D\0A        gout.PosH = mul(v[i], gViewProj);\0D\0A        gout.PosW = v[i].xyz;\0D\0A        gout.NormalW = look;\0D\0A        gout.TexC = texC[i];\0D\0A        gout.PrimID = primID;\0D\0A\09\09\0D\0A        triStream.Append(gout);\0D\0A    }\0D\0A}\0D\0A\0D\0Afloat4 PS(GeoOut pin) : SV_Target\0D\0A{\0D\0A    float3 uvw = float3(pin.TexC, pin.PrimID % 3);\0D\0A    float4 diffuseAlbedo = gTreeMapArray.Sample(gsamAnisotropicWrap, uvw) * gDiffuseAlbedo;\0D\0A\09\0D\0A#ifdef ALPHA_TEST\0D\0A\09clip(diffuseAlbedo.a - 0.1f);\0D\0A#endif\0D\0A    \0D\0A    pin.NormalW = normalize(pin.NormalW);\0D\0A    \0D\0A    float3 toEyeW = gEyePosW - pin.PosW;\0D\0A    float distToEye = length(toEyeW);\0D\0A    toEyeW /= distToEye; // normalize\0D\0A    \0D\0A    float4 ambient = gAmbientLight * diffuseAlbedo;\0D\0A\0D\0A    const float shininess = 1.0f - gRoughness;\0D\0A    Material mat = { diffuseAlbedo, gFresnelR0, shininess };\0D\0A    float3 shadowFactor = 1.0f;\0D\0A    float4 directLight = ComputeLighting(gLights, mat, pin.PosW,\0D\0A        pin.NormalW, toEyeW, shadowFactor);\0D\0A\0D\0A    float4 litColor = ambient + directLight;\0D\0A\0D\0A#ifdef FOG\0D\0A\09float fogAmount = saturate((distToEye - gFogStart) / gFogRange);\0D\0A\09litColor = lerp(litColor, gFogColor, fogAmount);\0D\0A#endif\0D\0A    \0D\0A    litColor.a = diffuseAlbedo.a;\0D\0A\0D\0A    return litColor;\0D\0A}\0D\0A\0D\0Afloat4 PS_Wireframe(GeoOut pin) : SV_Target\0D\0A{\0D\0A    return float4(1.0f, 1.0f, 1.0f, 1.0f);\0D\0A}"}
!124 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CLightingUtil.hlsli", !"#define MaxLights 16\0D\0A\0D\0Astruct Light\0D\0A{\0D\0A    float3 Strength;\0D\0A    float FalloffStart;     //point, spot\0D\0A    float3 Direction;       //directional, spot\0D\0A    float FalloffEnd;       //point, spot\0D\0A    float3 Position;        //point\0D\0A    float SpotPower;        //spot\0D\0A};\0D\0A\0D\0Astruct Material\0D\0A{\0D\0A    float4 DiffuseAlbedo;\0D\0A    float3 FresnelR0;\0D\0A    float Shininess;\0D\0A};\0D\0A\0D\0A//\EC\B9\B4\ED\88\B0\ED\99\94\0D\0Afloat QuantizeKd(float kd)\0D\0A{\0D\0A    if (kd <= 0.0f)\0D\0A        return 0.2f;\0D\0A    else if (kd <= 0.3f)\0D\0A        return 0.4f;\0D\0A    else if (kd <= 0.6f)\0D\0A        return 0.6f;\0D\0A    else if (kd <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.0f;\0D\0A}\0D\0A\0D\0Afloat QuantizeKs(float ks)\0D\0A{\0D\0A    if (ks <= 0.1f)\0D\0A        return 0.0f;\0D\0A    else if (ks <= 0.3f)\0D\0A        return 0.2f;\0D\0A    else if (ks <= 0.5f)\0D\0A        return 0.4f;\0D\0A    else if (ks <= 0.7f)\0D\0A        return 0.6f;\0D\0A    else if (ks <= 0.9f)\0D\0A        return 0.8f;\0D\0A    else\0D\0A        return 1.f;\0D\0A}\0D\0A\0D\0Afloat CalcAttenuation(float d, float falloffStart, float falloffEnd)\0D\0A{\0D\0A    //\EC\84\A0\ED\98\95 \EA\B0\90\EC\87\A0\0D\0A    return saturate((falloffEnd - d) / (falloffEnd - falloffStart));\0D\0A}\0D\0A\0D\0A//Schlick\EC\9D\80 \ED\94\84\EB\A0\88\EB\84\AC \EB\B0\98\EC\82\AC\EC\9C\A8\EC\97\90 \EB\8C\80\ED\95\9C \EA\B7\BC\EC\82\AC\EC\B9\98(233\ED\8E\98\EC\9D\B4\EC\A7\80 \22\EC\8B\A4\EC\8B\9C\EA\B0\84 \EB\A0\8C\EB\8D\94\EB\A7\81 3\ED\8C\90\22 \EC\B0\B8\EC\A1\B0)\0D\0A//R0 = ((n-1)/(n+1))^2, \EC\97\AC\EA\B8\B0\EC\84\9C n\EC\9D\80 \EA\B5\B4\EC\A0\88\EB\A5\A0\0D\0Afloat3 SchlickFresnel(float3 R0, float3 normal, float3 lightVec)\0D\0A{\0D\0A    float cosIncidentAngle = saturate(dot(normal, lightVec));\0D\0A    float f0 = 1.0f - cosIncidentAngle;\0D\0A    float3 reflectPercent = R0 + (1.0f - R0) * pow(f0, 5.0f);\0D\0A    \0D\0A    return reflectPercent;\0D\0A}\0D\0A\0D\0Afloat3 BlinnPhong(float3 lightStrength, float3 lightVec, float3 normal, float3 toEye, Material mat)\0D\0A{\0D\0A    const float m = mat.Shininess * 256.0f;\0D\0A    float3 halfVec = normalize(toEye + lightVec);\0D\0A    \0D\0A    float roughnessFactor = (m + 8.0f) * pow(max(dot(halfVec, normal), 0.0f), m) / 8.0f;\0D\0A    float3 fresnelFactor = SchlickFresnel(mat.FresnelR0, halfVec, lightVec);\0D\0A    \0D\0A    float3 specAlbedo = fresnelFactor * roughnessFactor;\0D\0A\0D\0A    //Blinn-Phong \EB\AA\A8\EB\8D\B8\EC\97\90\EC\84\A0\EB\8A\94 speccAlbedo\EA\B0\80 1\EB\B3\B4\EB\8B\A4 \ED\81\B4 \EC\88\98 \EC\9E\88\EB\8B\A4.\0D\0A    //LDR\EB\A0\8C\EB\8D\94\EB\A7\81\EC\9D\84 \EC\88\98\ED\96\89\ED\95\98\EA\B3\A0 \EC\9E\88\EC\9C\BC\EB\AF\80\EB\A1\9C \EB\B2\94\EC\9C\84\EB\A5\BC \EC\95\BD\EA\B0\84 \EC\B6\95\EC\86\8C\ED\95\9C\EB\8B\A4.\0D\0A    specAlbedo = specAlbedo / (specAlbedo + 1.0f);\0D\0A    \0D\0A    return (mat.DiffuseAlbedo.rgb + specAlbedo) * lightStrength;\0D\0A}\0D\0A\0D\0Afloat3 ComputeDirectionalLight(Light L, Material mat, float3 normal, float3 toEye)\0D\0A{\0D\0A    //\EA\B4\91 \EB\B2\A1\ED\84\B0\EB\8A\94 \EB\B9\9B\EC\9D\B4 \EC\A7\84\ED\96\89\ED\95\9C\EB\8A\94 \EB\B0\A9\ED\96\A5\EA\B3\BC \EB\B0\98\EB\8C\80 \EB\B0\A9\ED\96\A5.\0D\0A    float3 lightVec = -L.Direction;\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0\E3\84\B4.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrenght = L.Strength * ndotl;\0D\0A    \0D\0A    return BlinnPhong(lightStrenght, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputePointLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat3 ComputeSpotLight(Light L, Material mat, float3 pos, float3 normal, float3 toEye)\0D\0A{\0D\0A    float3 lightVec = L.Position - pos;\0D\0A    float d = length(lightVec);\0D\0A    \0D\0A    if (d > L.FalloffEnd)\0D\0A        return 0;\0D\0A    \0D\0A    lightVec /= d; //\EC\A0\95\EA\B7\9C\ED\99\94\0D\0A    \0D\0A    //\EB\9E\8C\EB\B2\A0\EB\A5\B4\ED\8A\B8 \EC\BD\94\EC\82\AC\EC\9D\B8 \EB\B2\95\EC\B9\99\EC\97\90 \EB\94\B0\EB\9D\BC \EB\B9\9B \EA\B0\95\EB\8F\84 \EA\B3\84\EC\82\B0.\0D\0A    float ndotl = max(dot(lightVec, normal), 0.0f);\0D\0A    float3 lightStrength = L.Strength * ndotl;\0D\0A    \0D\0A    //\EA\B1\B0\EB\A6\AC\EC\97\90 \EB\94\B0\EB\A5\B8 \EB\B9\9B \EA\B0\90\EC\87\A0 \EA\B3\84\EC\82\B0.\0D\0A    float att = CalcAttenuation(d, L.FalloffStart, L.FalloffEnd);\0D\0A    lightStrength *= att;\0D\0A    \0D\0A    //\EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EA\B2\BD\EC\9A\B0, \EB\B9\9B\EC\9D\B4 \EC\8A\A4\ED\8F\AC\ED\8A\B8\EB\9D\BC\EC\9D\B4\ED\8A\B8\EC\9D\98 \EC\A4\91\EC\8B\AC\EC\97\90\EC\84\9C \EB\A9\80\EC\96\B4\EC\A7\88\EC\88\98\EB\A1\9D \EB\B9\9B\EC\9D\B4 \EC\95\BD\ED\95\B4\EC\A7\84\EB\8B\A4.\0D\0A    float spotFactor = pow(max(dot(-lightVec, L.Direction), 0.0f), L.SpotPower);\0D\0A    lightStrength *= spotFactor;\0D\0A    \0D\0A    return BlinnPhong(lightStrength, lightVec, normal, toEye, mat);\0D\0A}\0D\0A\0D\0Afloat4 ComputeLighting(Light gLights[MaxLights], Material mat, float3 pos, float3 normal, float3 toEye, float3 shadowFactor)\0D\0A{\0D\0A    float3 result = 0;\0D\0A    int i = 0;\0D\0A    \0D\0A#if (NUM_DIR_LIGHTS > 0)\0D\0A    for(i = 0; i < NUM_DIR_LIGHTS; ++i)\0D\0A    {\0D\0A        result += shadowFactor[i] * ComputeDirectionalLight(gLights[i], mat, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_POINT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS; i < NUM_DIR_LIGHTS+NUM_POINT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputePointLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif\0D\0A\0D\0A#if (NUM_SPOT_LIGHTS > 0)\0D\0A    for(i = NUM_DIR_LIGHTS + NUM_POINT_LIGHTS; i < NUM_DIR_LIGHTS + NUM_POINT_LIGHTS + NUM_SPOT_LIGHTS; ++i)\0D\0A    {\0D\0A        result += ComputeSpotLight(gLights[i], mat, pos, normal, toEye);\0D\0A    }\0D\0A#endif \0D\0A    \0D\0A    return float4(result, 0.0f);\0D\0A}"}
!125 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CTreeBillboard.hlsl"}
!126 = !{!"-E", !"VS", !"-T", !"vs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CTreeBillboardVS.cso"}
!127 = !{i32 1, i32 0}
!128 = !{i32 1, i32 8}
!129 = !{!"vs", i32 6, i32 0}
!130 = !{i32 1, void ()* @VS, !131}
!131 = !{!132}
!132 = !{i32 0, !2, !2}
!133 = !{[8 x i32] [i32 6, i32 6, i32 1, i32 2, i32 4, i32 0, i32 16, i32 32]}
!134 = !{void ()* @VS, !"VS", !135, null, !145}
!135 = !{!136, !142, null}
!136 = !{!137, !140}
!137 = !{i32 0, !"POSITION", i8 9, i8 0, !138, i8 0, i32 1, i8 3, i32 0, i8 0, !139}
!138 = !{i32 0}
!139 = !{i32 3, i32 7}
!140 = !{i32 1, !"SIZE", i8 9, i8 0, !138, i8 0, i32 1, i8 2, i32 1, i8 0, !141}
!141 = !{i32 3, i32 3}
!142 = !{!143, !144}
!143 = !{i32 0, !"POSITION", i8 9, i8 0, !138, i8 2, i32 1, i8 3, i32 0, i8 0, !139}
!144 = !{i32 1, !"SIZE", i8 9, i8 0, !138, i8 2, i32 1, i8 2, i32 1, i8 0, !141}
!145 = !{i32 0, i64 1}
!146 = !DILocation(line: 86, column: 23, scope: !4)
!147 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "vout", scope: !4, file: !1, line: 88, type: !7)
!148 = !DIExpression(DW_OP_bit_piece, 96, 32)
!149 = !DILocation(line: 88, column: 15, scope: !4)
!150 = !DIExpression(DW_OP_bit_piece, 128, 32)
!151 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "vin", arg: 1, scope: !4, file: !1, line: 86, type: !29)
!152 = !DIExpression(DW_OP_bit_piece, 0, 32)
!153 = !DIExpression(DW_OP_bit_piece, 32, 32)
!154 = !DIExpression(DW_OP_bit_piece, 64, 32)
!155 = !DILocation(line: 90, column: 18, scope: !4)
!156 = !DILocation(line: 91, column: 16, scope: !4)
!157 = !DILocation(line: 93, column: 12, scope: !4)
!158 = !DILocation(line: 93, column: 5, scope: !4)
