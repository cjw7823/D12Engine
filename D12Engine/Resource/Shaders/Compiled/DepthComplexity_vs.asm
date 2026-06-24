;
; Input signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_VertexID              0   x           0   VERTID    uint   x   
;
;
; Output signature:
;
; Name                 Index   Mask Register SysValue  Format   Used
; -------------------- ----- ------ -------- -------- ------- ------
; SV_Position              0   xyzw        0      POS   float   xyzw
;
; shader debug name: 8ec6383e5d83de251731c198e9e31cbc.pdb
; shader hash: 8ec6383e5d83de251731c198e9e31cbc
;
; Pipeline Runtime Information: 
;
;PSVRuntimeInfo:
; Vertex Shader
; OutputPositionPresent=1
; MinimumExpectedWaveLaneCount: 0
; MaximumExpectedWaveLaneCount: 4294967295
; UsesViewID: false
; SigInputElements: 1
; SigOutputElements: 1
; SigPatchConstOrPrimElements: 0
; SigInputVectors: 1
; SigOutputVectors[0]: 1
; SigOutputVectors[1]: 0
; SigOutputVectors[2]: 0
; SigOutputVectors[3]: 0
; EntryFunctionName: FullscreenVS
;
;
; Input signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_VertexID              0                              
;
; Output signature:
;
; Name                 Index             InterpMode DynIdx
; -------------------- ----- ---------------------- ------
; SV_Position              0          noperspective       
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
; Number of inputs: 1, outputs: 4
; Outputs dependent on ViewId: {  }
; Inputs contributing to computation of Outputs:
;   output 0 depends on inputs: { 0 }
;   output 1 depends on inputs: { 0 }
;
target datalayout = "e-m:e-p:32:32-i1:32-i8:32-i16:32-i32:32-i64:64-f16:32-f32:32-f64:64-n8:16:32:64"
target triple = "dxil-ms-dx"

@dx.nothing.a = internal constant [1 x i32] zeroinitializer

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

define void @FullscreenVS() {
  %1 = call i32 @dx.op.loadInput.i32(i32 4, i32 0, i32 0, i8 0, i32 undef)  ; LoadInput(inputSigId,rowIndex,colIndex,gsVertexAxis)
  %pos.0 = alloca [3 x float]
  %pos.1 = alloca [3 x float]
  call void @llvm.dbg.value(metadata i32 %1, i64 0, metadata !58, metadata !59), !dbg !60 ; var:"vid" !DIExpression() func:"FullscreenVS"
  call void @llvm.dbg.declare(metadata [3 x float]* %pos.0, metadata !61, metadata !65), !dbg !66, !dx.dbg.varlayout !67 ; var:"pos" !DIExpression(DW_OP_bit_piece, 0, 32) func:"FullscreenVS"
  call void @llvm.dbg.declare(metadata [3 x float]* %pos.1, metadata !61, metadata !68), !dbg !66, !dx.dbg.varlayout !69 ; var:"pos" !DIExpression(DW_OP_bit_piece, 32, 32) func:"FullscreenVS"
  %2 = getelementptr [3 x float], [3 x float]* %pos.0, i32 0, i32 0, !dbg !70 ; line:16 col:5
  %3 = getelementptr [3 x float], [3 x float]* %pos.1, i32 0, i32 0, !dbg !70 ; line:16 col:5
  %4 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !70 ; line:16 col:5
  store float -1.000000e+00, float* %2, !dbg !70 ; line:16 col:5
  store float -1.000000e+00, float* %3, !dbg !70 ; line:16 col:5
  %5 = getelementptr [3 x float], [3 x float]* %pos.0, i32 0, i32 1, !dbg !70 ; line:16 col:5
  %6 = getelementptr [3 x float], [3 x float]* %pos.1, i32 0, i32 1, !dbg !70 ; line:16 col:5
  %7 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !70 ; line:16 col:5
  store float -1.000000e+00, float* %5, !dbg !70 ; line:16 col:5
  store float 3.000000e+00, float* %6, !dbg !70 ; line:16 col:5
  %8 = getelementptr [3 x float], [3 x float]* %pos.0, i32 0, i32 2, !dbg !70 ; line:16 col:5
  %9 = getelementptr [3 x float], [3 x float]* %pos.1, i32 0, i32 2, !dbg !70 ; line:16 col:5
  %10 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !70 ; line:16 col:5
  store float 3.000000e+00, float* %8, !dbg !70 ; line:16 col:5
  store float -1.000000e+00, float* %9, !dbg !70 ; line:16 col:5
  %11 = getelementptr [3 x float], [3 x float]* %pos.0, i32 0, i32 %1, !dbg !71 ; line:22 col:24
  %12 = getelementptr [3 x float], [3 x float]* %pos.1, i32 0, i32 %1, !dbg !71 ; line:22 col:24
  %load = load float, float* %11, !dbg !71 ; line:22 col:24
  %load1 = load float, float* %12, !dbg !71 ; line:22 col:24
  %13 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !72 ; line:22 col:15
  call void @llvm.dbg.value(metadata float %load, i64 0, metadata !73, metadata !65), !dbg !74 ; var:"vout" !DIExpression(DW_OP_bit_piece, 0, 32) func:"FullscreenVS"
  call void @llvm.dbg.value(metadata float %load1, i64 0, metadata !73, metadata !68), !dbg !74 ; var:"vout" !DIExpression(DW_OP_bit_piece, 32, 32) func:"FullscreenVS"
  call void @llvm.dbg.value(metadata float 0.000000e+00, i64 0, metadata !73, metadata !75), !dbg !74 ; var:"vout" !DIExpression(DW_OP_bit_piece, 64, 32) func:"FullscreenVS"
  call void @llvm.dbg.value(metadata float 1.000000e+00, i64 0, metadata !73, metadata !76), !dbg !74 ; var:"vout" !DIExpression(DW_OP_bit_piece, 96, 32) func:"FullscreenVS"
  %14 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !77 ; line:23 col:12
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 0, float %load), !dbg !77 ; line:23 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 1, float %load1), !dbg !77 ; line:23 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 2, float 0.000000e+00), !dbg !77 ; line:23 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  call void @dx.op.storeOutput.f32(i32 5, i32 0, i32 0, i8 3, float 1.000000e+00), !dbg !77 ; line:23 col:12  ; StoreOutput(outputSigId,rowIndex,colIndex,value)
  %15 = load i32, i32* getelementptr inbounds ([1 x i32], [1 x i32]* @dx.nothing.a, i32 0, i32 0), !dbg !78 ; line:23 col:5
  ret void, !dbg !78 ; line:23 col:5
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #0

; Function Attrs: nounwind readnone
declare i32 @dx.op.loadInput.i32(i32, i32, i32, i8, i32) #0

; Function Attrs: nounwind
declare void @dx.op.storeOutput.f32(i32, i32, i32, i8, float) #1

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!35, !36}
!llvm.ident = !{!37}
!dx.source.contents = !{!38}
!dx.source.defines = !{!2}
!dx.source.mainFileName = !{!39}
!dx.source.args = !{!40}
!dx.version = !{!41}
!dx.valver = !{!42}
!dx.shaderModel = !{!43}
!dx.typeAnnotations = !{!44}
!dx.viewIdState = !{!47}
!dx.entryPoints = !{!48}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "dxcoob 1.8.2502.11 (239921522)", isOptimized: false, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !23, globals: !32)
!1 = !DIFile(filename: "C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDepthComplexity.hlsl", directory: "")
!2 = !{}
!3 = !{!4, !14}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "float2", file: !1, line: 15, baseType: !5)
!5 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 2>", file: !1, line: 15, size: 64, align: 32, elements: !6, templateParams: !10)
!6 = !{!7, !9}
!7 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !5, file: !1, line: 15, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!8 = !DIBasicType(name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!9 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !5, file: !1, line: 15, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!10 = !{!11, !12}
!11 = !DITemplateTypeParameter(name: "element", type: !8)
!12 = !DITemplateValueParameter(name: "element_count", type: !13, value: i32 2)
!13 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "float4", file: !1, line: 3, baseType: !15)
!15 = !DICompositeType(tag: DW_TAG_class_type, name: "vector<float, 4>", file: !1, line: 3, size: 128, align: 32, elements: !16, templateParams: !21)
!16 = !{!17, !18, !19, !20}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !15, file: !1, line: 3, baseType: !8, size: 32, align: 32, flags: DIFlagPublic)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !15, file: !1, line: 3, baseType: !8, size: 32, align: 32, offset: 32, flags: DIFlagPublic)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !15, file: !1, line: 3, baseType: !8, size: 32, align: 32, offset: 64, flags: DIFlagPublic)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "w", scope: !15, file: !1, line: 3, baseType: !8, size: 32, align: 32, offset: 96, flags: DIFlagPublic)
!21 = !{!11, !22}
!22 = !DITemplateValueParameter(name: "element_count", type: !13, value: i32 4)
!23 = !{!24}
!24 = !DISubprogram(name: "FullscreenVS", scope: !1, file: !1, line: 11, type: !25, isLocal: false, isDefinition: true, scopeLine: 12, flags: DIFlagPrototyped, isOptimized: false, function: void ()* @FullscreenVS)
!25 = !DISubroutineType(types: !26)
!26 = !{!27, !30}
!27 = !DICompositeType(tag: DW_TAG_structure_type, name: "VOut", file: !1, line: 6, size: 128, align: 32, elements: !28)
!28 = !{!29}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "PosH", scope: !27, file: !1, line: 8, baseType: !14, size: 128, align: 32)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint", file: !1, line: 3, baseType: !31)
!31 = !DIBasicType(name: "unsigned int", size: 32, align: 32, encoding: DW_ATE_unsigned)
!32 = !{!33}
!33 = !DIGlobalVariable(name: "gDebugColor", linkageName: "\01?gDebugColor@DebugColorCB@@3V?$vector@M$03@@B", scope: !0, file: !1, line: 3, type: !34, isLocal: false, isDefinition: true)
!34 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !14)
!35 = !{i32 2, !"Dwarf Version", i32 4}
!36 = !{i32 2, !"Debug Info Version", i32 3}
!37 = !{!"dxcoob 1.8.2502.11 (239921522)"}
!38 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDepthComplexity.hlsl", !"cbuffer DebugColorCB : register(b0)\0D\0A{\0D\0A    float4 gDebugColor;\0D\0A};\0D\0A\0D\0Astruct VOut\0D\0A{\0D\0A    float4 PosH : SV_Position;\0D\0A};\0D\0A\0D\0AVOut FullscreenVS(uint vid : SV_VertexID)\0D\0A{\0D\0A    VOut vout;\0D\0A    \0D\0A    float2 pos[3] =\0D\0A    {\0D\0A        float2(-1.0f, -1.0f),\0D\0A        float2(-1.0f, 3.0f),\0D\0A        float2(3.0f, -1.0f),\0D\0A    };\0D\0A\0D\0A    vout.PosH = float4(pos[vid], 0.0f, 1.0f);\0D\0A    return vout;\0D\0A}\0D\0A\0D\0Afloat4 FullscreenPS(VOut pin) : SV_Target\0D\0A{\0D\0A    return gDebugColor;\0D\0A}"}
!39 = !{!"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CDepthComplexity.hlsl"}
!40 = !{!"-E", !"FullscreenVS", !"-T", !"vs_6_0", !"-Zi", !"-Qembed_debug", !"-Od", !"-Fo", !"C:\5CUsers\5Ccjw78\5CDesktop\5CD12Engine\5CD12Engine\5CResource\5CShaders\5CCompiled\5CDepthComplexity_vs.cso"}
!41 = !{i32 1, i32 0}
!42 = !{i32 1, i32 8}
!43 = !{!"vs", i32 6, i32 0}
!44 = !{i32 1, void ()* @FullscreenVS, !45}
!45 = !{!46}
!46 = !{i32 0, !2, !2}
!47 = !{[3 x i32] [i32 1, i32 4, i32 3]}
!48 = !{void ()* @FullscreenVS, !"FullscreenVS", !49, null, !57}
!49 = !{!50, !54, null}
!50 = !{!51}
!51 = !{i32 0, !"SV_VertexID", i8 5, i8 1, !52, i8 0, i32 1, i8 1, i32 0, i8 0, !53}
!52 = !{i32 0}
!53 = !{i32 3, i32 1}
!54 = !{!55}
!55 = !{i32 0, !"SV_Position", i8 9, i8 3, !52, i8 4, i32 1, i8 4, i32 0, i8 0, !56}
!56 = !{i32 3, i32 15}
!57 = !{i32 0, i64 1}
!58 = !DILocalVariable(tag: DW_TAG_arg_variable, name: "vid", arg: 1, scope: !24, file: !1, line: 11, type: !30)
!59 = !DIExpression()
!60 = !DILocation(line: 11, column: 24, scope: !24)
!61 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "pos", scope: !24, file: !1, line: 15, type: !62)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !4, size: 192, align: 32, elements: !63)
!63 = !{!64}
!64 = !DISubrange(count: 3)
!65 = !DIExpression(DW_OP_bit_piece, 0, 32)
!66 = !DILocation(line: 15, column: 12, scope: !24)
!67 = !{i32 0, i32 64, i32 3}
!68 = !DIExpression(DW_OP_bit_piece, 32, 32)
!69 = !{i32 32, i32 64, i32 3}
!70 = !DILocation(line: 16, column: 5, scope: !24)
!71 = !DILocation(line: 22, column: 24, scope: !24)
!72 = !DILocation(line: 22, column: 15, scope: !24)
!73 = !DILocalVariable(tag: DW_TAG_auto_variable, name: "vout", scope: !24, file: !1, line: 13, type: !27)
!74 = !DILocation(line: 13, column: 10, scope: !24)
!75 = !DIExpression(DW_OP_bit_piece, 64, 32)
!76 = !DIExpression(DW_OP_bit_piece, 96, 32)
!77 = !DILocation(line: 23, column: 12, scope: !24)
!78 = !DILocation(line: 23, column: 5, scope: !24)
